from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Covid-19 Data Pipeline") \
    .enableHiveSupport() \
    .getOrCreate()

# Load data from Hive and process it
# Example: df = spark.sql("SELECT * FROM covid_data")
# df.show()

spark.stop()
