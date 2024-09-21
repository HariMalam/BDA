#!/bin/bash

# Run Docker container and mount the 'practicals' folder
docker run -it --name bda-container \
    -p 8088:8088 -p 8042:8042 -p 50070:50070 -p 8080:8080 \
    -v $(pwd)/practicals:/root/practicals \
    harimalam/bda-image
