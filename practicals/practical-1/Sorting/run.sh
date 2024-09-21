#!/bin/bash

# Set variables
INPUT_DIR="input.txt"
OUTPUT_DIR="/output/sorting"
JAVA_FILE="Sorting.java"
CLASS_DIR="classes"
JAR_DIR="jar"
JAR_FILE="$JAR_DIR/Sorting.jar"
CLASS_NAME="Sorting"

# Clean previous output
hadoop fs -rm -r $OUTPUT_DIR

# Put new input file into HDFS
hadoop fs -put -f $INPUT_DIR /input/sorting.txt

# Create directories for class and jar files
mkdir -p $CLASS_DIR
mkdir -p $JAR_DIR

# Compile the Java code
javac -classpath `hadoop classpath` $JAVA_FILE -d $CLASS_DIR

# Create a JAR file
jar cf $JAR_FILE -C $CLASS_DIR .

# Run the Hadoop job
hadoop jar $JAR_FILE $CLASS_NAME /input/sorting.txt $OUTPUT_DIR

# Display the output
hadoop fs -cat $OUTPUT_DIR/part-r-00000
