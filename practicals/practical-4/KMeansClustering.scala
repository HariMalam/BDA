import org.apache.spark.ml.clustering.KMeans
import org.apache.spark.sql.SparkSession

object KMeansClustering {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder.appName("K-Means Clustering").getOrCreate()

    val data = spark.read.format("libsvm").load(args(0))
    val kmeans = new KMeans().setK(2).setSeed(1L)
    val model = kmeans.fit(data)

    model.transform(data).show()
    spark.stop()
  }
}
