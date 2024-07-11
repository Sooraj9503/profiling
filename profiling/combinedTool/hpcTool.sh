#!/bin/bash

source /home/hpcap/sooraj/spack/share/spack/setup-env.sh
spack load hpctoolkit@2023.08.1%gcc@12.2.0

while true; do
    echo "Enter file to execute: "
    read -r file

    if [[ $file == *.c ]] || [[ $file == *.cpp ]]; then
        if [ -e "$file" ]; then
            echo "Enter the executable file name: "
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

#!/bin/bash

arr=("REALTIME" "CPUTIME" "perf::CACHE-MISSES" "MEMLEAK" "IO")
chosen_options=()

while true; do
    echo "Choose one or more of the following options (separated by space):"
    for i in "${arr[@]}"; do
        echo "  * $i"
    done
    read -r -p "Enter your choices: " options
    for option in $options; do
        if [[ " ${arr[*]} " =~ " $option " ]]; then
            chosen_options+=(" -e $option")
        else
            echo "Invalid option: $option"
        fi
    done
    read -r -p "Do you want to choose more options? (y/n): " response
    case $response in
        [yY][eE][sS]|[yY])
            continue
            ;;
        [nN][oO]|[nN])
            break
            ;;
        *)
            echo "Invalid response. Please enter y or n."
            ;;
    esac
done

echo "You chose the following options:"
for option in "${chosen_options[@]}"; do
    echo "$option"
done



while true; do
    echo "Report with/without trace view Press [y/n]"
    read -r report
    if [[ $report == y ]]; then
        cmd="hpcrun"
        for option in "${chosen_options[@]}"; do
            cmd+="$option"
        done
        cmd+=" -t ./$output_file"

        echo "Running command: $cmd"
        eval $cmd
        hpcstruct hpctoolkit-$output_file-measurements
        hpcprof hpctoolkit-$output_file-measurements
        hpcviewer hpctoolkit-$output_file-database
        break
    elif [ $report == n ]; then
        cmd="hpcrun"
        for option in "${chosen_options[@]}"; do
            cmd+=" $option"
        done
        cmd+=" ./$output_file"

        echo "Running command: $cmd"
        eval $cmd
        hpcstruct hpctoolkit-$output_file-measurements
        hpcprof hpctoolkit-$output_file-measurements
        hpcviewer hpctoolkit-$output_file-database
        break
    else
        echo "wrong option"
    fi
done