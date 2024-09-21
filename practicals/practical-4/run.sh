#!/bin/bash

# Set variables
INPUT_DIR="input.libsvm"  # Adjust this path
OUTPUT_DIR="output/kmeans_clustering"
SCALA_FILE="KMeansClustering.scala"

# Run the Spark job
spark-submit --class KMeansClustering $SCALA_FILE $INPUT_DIR $OUTPUT_DIR
