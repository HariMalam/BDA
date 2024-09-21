#!/bin/bash

# Set variables
INPUT_DIR="input.csv"  # Adjust this path
OUTPUT_DIR="output/matrix_operations"
SCALA_FILE="MatrixOperations.scala"

# Run the Spark job
spark-submit --class MatrixOperations $SCALA_FILE $INPUT_DIR $OUTPUT_DIR
