#!/bin/bash

# Set variables
INPUT_DIR="input.txt"
OUTPUT_DIR="/output/indexing"
JAVA_FILE="Indexing.java"
CLASS_DIR="classes"
JAR_DIR="jar"
JAR_FILE="$JAR_DIR/Indexing.jar"
CLASS_NAME="Indexing"

# Clean previous output
if hadoop fs -test -d $OUTPUT_DIR; then
    echo "Cleaning up previous output..."
    hadoop fs -rm -r $OUTPUT_DIR
else
    echo "Output directory does not exist, skipping cleanup."
fi

# Put new input file into HDFS
echo "Uploading new input file to HDFS..."
hadoop fs -put -f $INPUT_DIR /input/indexing.txt

# Create directories for class and jar files
mkdir -p $CLASS_DIR
mkdir -p $JAR_DIR

# Compile the Java code
echo "Compiling Java code..."
javac -classpath `hadoop classpath` $JAVA_FILE -d $CLASS_DIR

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Compilation failed. Please check your Java code."
    exit 1
fi

# Create a JAR file
echo "Creating JAR file..."
jar cf $JAR_FILE -C $CLASS_DIR .

# Run the Hadoop job
echo "Running Hadoop job..."
hadoop jar $JAR_FILE $CLASS_NAME /input/indexing.txt $OUTPUT_DIR

# Check if the job ran successfully
if [ $? -ne 0 ]; then
    echo "Hadoop job failed. Please check for errors."
    exit 1
fi

# Display the output
echo "Output:"
hadoop fs -cat $OUTPUT_DIR/part-r-00000
