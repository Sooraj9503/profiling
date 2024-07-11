#!/bin/bash

source ~/sooraj/spack/share/spack/./setup-env.sh
source /opt/intel/oneapi/setvars.sh
sudo sysctl -w kernel.yama.ptrace_scope=0

while true; do
    ls
    echo "Enter file to execute: "
    read -r file

    if [[ $file == *.c ]] || [[ $file == *.cpp ]]; then
        if [ -e "$file" ]; then
            echo "Enter the executable file name: "
            read -r output_file
            echo "Enter the directory name you want to store report file in: "
            read -r dir_name
            gcc -o $output_file $file -lstdc++ || g++ -o $output_file $file -lstdc++
            break
        else
            echo "File does not exist"
        fi
    else
        echo "Invalid file type (only .c and .cpp files are supported)"
    fi
done

vtune --collect=hotspot --result-dir=./$dir_name -- ./$output_file

cd $dir_name

vtune-gui $dir_name.vtune