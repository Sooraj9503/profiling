#!/bin/bash

advisor(){

    source /home/hpcap/sooraj/spack/share/spack/setup-env.sh
    spack load intel-oneapi-advisor@2024.1.0

    while true; do
        echo "Enter file to execute: "
        read -r file

        if [[ $file == *.c || $file == *.cpp ]]; then
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

    advisor --collect=offload --config=$target_device --project-dir=./$directory_name -- ./$output_file && echo "Command executed successfully" || echo "Wrong command"
    echo "Running advisor command..."
}

hpc(){

    source /home/hpcap/sooraj/spack/share/spack/setup-env.sh
    spack load hpctoolkit@2023.08.1%gcc@12.2.0

    while true; do
        echo "Enter file to execute: "
        read -r file

        if [[ $file == *.c || $file == *.cpp ]]; then
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
        elif [[ $report == n ]]; then
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
            echo "Wrong option"
        fi
    done
}

vtune(){

    echo "source started"

    source ~/sooraj/spack/share/spack/setup-env.sh
    source /opt/intel/oneapi/setvars.sh
    sudo sysctl -w kernel.yama.ptrace_scope=0

    echo "source ended"

    while true; do
        ls
        echo "Enter file to execute: "
        read -r file

        if [[ $file == *.c || $file == *.cpp ]]; then
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
}

echo "Press 1: for Advisor tool"
echo "Press 2: for Hpc tool"
echo "Press 3: for Vtune tool"
echo "Enter your choice:"
read choice

case $choice in
    "1")
        echo "Executing Advisor tool........"
        advisor
        ;;
    "2")
        echo "Executing hpc tool........"
        hpc
        ;;
    "3")
        echo "Executing vtune tool........"
        vtune
        ;;
    *)
        echo "Invalid option"
        ;;
esac