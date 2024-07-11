#!/bin/bash

source /home/hpcap/sooraj/spack/share/spack/setup-env.sh
spack load intel-oneapi-advisor@2024.1.0

while true; do
    echo "Enter file to execute: "
    read -r file

    if [[ $file == *.c ]] || [[ $file == *.cpp ]]; then
        if [ -e "$file" ]; then
            echo "Enter the output file name: "
            read -r output_file
            gcc -o $output_file $file -lstdc++ || g++ -o $output_file $file -lstdc++
            break
        else
            echo "File does not exist"
        fi
    else
        echo "Invalid file type (only .c and .cpp files are supported)"
    fi
done

arr=("xehpg_256xve" "xehpg_512xve" "gen12_tgl" "gen12_tg1" "gen11_icl" "gen9_gt2" "gen9_gt3" "gen9_gt4")

while true; do
    echo "Choose one of the following target devices:"
    for i in "${arr[@]}"; do
        echo "$i"
    done
    read -r target_device
    if [[ " ${arr[*]} " =~ " $target_device " ]]; then
        break
    else
        echo "Invalid target device. Please try again."
    fi
done

echo "Target device is $target_device"

echo "Enter the directory name"
read -r directory_name

echo "Running advisor command..."
advisor --collect=offload --config=$target_device --project-dir=./$directory_name -- ./$output_file && echo "Command executed succesfully" || echo "Wrong command"
echo "opening report in the browser........"
firefox /home/hpcap/sooraj/profiling/advisor/$directory_name/e000/report/report.html