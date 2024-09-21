import org.apache.spark.sql.SparkSession

object WordCount {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder.appName("Word Count").getOrCreate()
    val input = spark.read.textFile(args(0))
    
    val counts = input.flatMap(line => line.split(" "))
                      .groupByKey(identity)
                      .count()

    counts.write.csv(args(1))
    spark.stop()
  }
}
