#!/bin/bash

while true; do
    echo "Enter file name to compile"
    read -r filename
    echo "Enter name for executable file"
    read -r exe_name
    echo "Enter the file name with .txt extention in which output will be redirected"
    read -r file

    if [[ $filename == *.c ]]; then
        if gcc -pg -o $exe_name $filename && ./$exe_name; then
            break
        else
            echo "Error: Compilation failed."
        fi
    elif [[ $filename == *.cpp ]]; then
        if g++ -pg -o $exe_name $filename && ./$exe_name; then
            break
        else
            echo "Error: Compilation failed."
        fi
    else
        echo "Invalid file name"
    fi
done

gprof $exe_name gmon.out > $file && cat $file