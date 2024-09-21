package Sorting;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

public class Sorting {

    public static class SortMapper extends Mapper<LongWritable, LongWritable, LongWritable, LongWritable> {
        @Override
        protected void map(LongWritable key, LongWritable value, Context context) throws IOException, InterruptedException {
            // number sotring
            LongWritable number = new LongWritable(Long.parseLong(value.toString()));
            context.write(number, number);

            // string sorting
            // context.write(value, key);
        }
    }

    public static class SortReducer extends Reducer<LongWritable, LongWritable, LongWritable, LongWritable> {
        @Override
        protected void reduce(LongWritable key, Iterable<LongWritable> values, Context context) throws IOException, InterruptedException {
            for (LongWritable val : values) {
                context.write(key, val);
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Sorting");

        job.setJarByClass(Sorting.class);
        job.setMapperClass(SortMapper.class);
        job.setReducerClass(SortReducer.class);

        job.setOutputKeyClass(LongWritable.class);
        job.setOutputValueClass(LongWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
