#!/bin/bash

# Set variables
INPUT_DIR="input.txt"
OUTPUT_DIR="/output"
JAVA_FILE="MatrixMultiplication.java"
CLASS_DIR="classes"
JAR_DIR="jar"
JAR_FILE="$JAR_DIR/MatrixMultiplication.jar"
CLASS_NAME="MatrixMultiplication"

# Clean previous output
echo "Cleaning up previous output..."
hadoop fs -rm -r $OUTPUT_DIR

# Put new input file into HDFS
echo "Uploading new input file to HDFS..."
hadoop fs -put -f $INPUT_DIR /input/matrix.txt

# Create directories for class and jar files
mkdir -p $CLASS_DIR
mkdir -p $JAR_DIR

# Compile the Java code
echo "Compiling Java code..."
javac -classpath `hadoop classpath` $JAVA_FILE -d $CLASS_DIR

# Create a JAR file
echo "Creating JAR file..."
jar cf $JAR_FILE -C $CLASS_DIR .

# Run the Hadoop job
echo "Running Hadoop job..."
hadoop jar $JAR_FILE $CLASS_NAME /input/matrix.txt $OUTPUT_DIR

# Display the output
echo "Output:"
hadoop fs -cat $OUTPUT_DIR/part-r-00000

echo "Job completed."
