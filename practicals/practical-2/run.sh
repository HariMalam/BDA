#!/bin/bash

# Set variables
INPUT_DIR="input.txt"
OUTPUT_DIR="output/wordcount"
SCALA_FILE="WordCount.scala"

# Run the Spark job
spark-submit --class WordCount $SCALA_FILE $INPUT_DIR $OUTPUT_DIR
# Check if the Scala file exists
if [ ! -f "$SCALA_FILE" ]; then
    echo "Error: $SCALA_FILE not found!"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$INPUT_DIR" ]; then
    echo "Error: $INPUT_DIR not found!"
    exit 1
fi

# Check if the output directory exists, if not create it
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi