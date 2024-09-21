#!/bin/bash

# Ensure required environment variables are set
: "${HADOOP_HOME:?Need to set HADOOP_HOME}"
: "${SPARK_HOME:?Need to set SPARK_HOME}"

# Format HDFS if it's the first time
if [ ! -d "/root/hadoop-data" ]; then
    hdfs namenode -format || { echo "HDFS format failed"; exit 1; }
fi

# Start Hadoop services (HDFS + YARN)
$HADOOP_HOME/sbin/start-dfs.sh || { echo "Failed to start HDFS"; exit 1; }
$HADOOP_HOME/sbin/start-yarn.sh || { echo "Failed to start YARN"; exit 1; }

# Start Spark master and worker
$SPARK_HOME/sbin/start-master.sh || { echo "Failed to start Spark master"; exit 1; }
$SPARK_HOME/sbin/start-worker.sh spark://localhost:7077 || { echo "Failed to start Spark worker"; exit 1; }

# Optional: Start Hive Metastore if required
# Uncomment if using Hive
# $HIVE_HOME/bin/hive --service metastore &

# Keep the container running
exec tail -f /dev/null
