import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

public class MatrixMultiplication {

    public static class MatrixMapper extends Mapper<LongWritable, Text, Text, Text> {
        @Override
        protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            // Input format: A,i,j,value or B,j,k,value
            String[] elements = value.toString().split(",");
            if (elements[0].equals("A")) {
                String i = elements[1]; // Row index for A
                String j = elements[2]; // Column index for A
                String v = elements[3]; // Value in A
                // Emit A's row and its column index for all possible columns of B
                for (int k = 0; k < 5; k++) { // Adjust size as necessary
                    context.write(new Text(i + "," + k), new Text("A," + j + "," + v));
                }
            } else if (elements[0].equals("B")) {
                String j = elements[1]; // Row index for B
                String k = elements[2]; // Column index for B
                String v = elements[3]; // Value in B
                // Emit B's column and its row index for all possible rows of A
                for (int i = 0; i < 5; i++) { // Adjust size as necessary
                    context.write(new Text(i + "," + k), new Text("B," + j + "," + v));
                }
            }
        }
    }

    public static class MatrixReducer extends Reducer<Text, Text, Text, FloatWritable> {
        @Override
        protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            // Key format: i,k
            // Value format: A,j,value or B,j,value
            float[] A = new float[5];
            float[] B = new float[5];

            for (Text val : values) {
                String[] elements = val.toString().split(",");
                if (elements[0].equals("A")) {
                    A[Integer.parseInt(elements[1])] = Float.parseFloat(elements[2]);
                } else if (elements[0].equals("B")) {
                    B[Integer.parseInt(elements[1])] = Float.parseFloat(elements[2]);
                }
            }

            float sum = 0;
            // Calculate the dot product for the resulting matrix entry
            for (int j = 0; j < 5; j++) {
                sum += A[j] * B[j];
            }

            // Only write output if sum is not zero
            if (sum != 0) {
                context.write(key, new FloatWritable(sum));
            }
        }
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: MatrixMultiplication <input path> <output path>");
            System.exit(-1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Matrix Multiplication");

        job.setJarByClass(MatrixMultiplication.class);
        job.setMapperClass(MatrixMapper.class);
        job.setReducerClass(MatrixReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
