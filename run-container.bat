@echo off
REM Set the current directory
setlocal

REM Get the current directory where the batch script is running
for %%i in ("%~dp0.") do set "BDA_DIR=%%~fi"

REM Run Docker and mount the 'practicals' folder from Windows into the container
docker run -it --name harimalam/bda-container ^
    -p 8088:8088 -p 8042:8042 -p 50070:50070 -p 8080:8080 ^
    -v %BDA_DIR%\practicals:/root/practicals ^
    bda-image

endlocal
