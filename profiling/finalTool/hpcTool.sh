#!/bin/bash

source /home/hpcap/sooraj/spack/share/spack/setup-env.sh
spack load hpctoolkit@2023.08.1%gcc@12.2.0
while true; do
    echo "Enter file name to compile"
    read -r filename
    echo "Enter name for executable file"
    read -r exe_name

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

while true; do
    echo "Do you want to generate a report? (y/n)"
    read -r report

    if [[ $report == y ]]; then
        options=()
        realtime_or_cputime=0
        while true; do
            echo "Select one or more options (separated by spaces):"
            echo "1. REALTIME"
            echo "2. CPUTIME"
            echo "3. perf::CACHE-MISSES"
            echo "4. MEMLEAK"
            echo "5. IO"
            echo "6. ALL (selects all options except REALTIME and CPUTIME)"

            read -r choices

            for choice in $choices; do
                case $choice in
                    1|2) if ((realtime_or_cputime)); then
                             echo "Error: Cannot choose REALTIME and CPUTIME at the same time."
                             exit 1
                         fi
                         ((realtime_or_cputime++))
                         if [[ $options[*] == *${choice==1?"REALTIME":"CPUTIME"}* ]]; then
                             echo "Error: You have already chosen ${choice==1?"REALTIME":"CPUTIME"}."
                             exit 1
                         fi
                         options+=(-e ${choice==1?"REALTIME":"CPUTIME"}) ;;
                    3) if [[ $options[*] == *perf::CACHE-MISSES* ]]; then
                             echo "Error: You have already chosen perf::CACHE-MISSES."
                             exit 1
                         fi
                         options+=(-e perf::CACHE-MISSES) ;;
                    4) if [[ $options[*] == *MEMLEAK* ]]; then
                             echo "Error: You have already chosen MEMLEAK."
                             exit 1
                         fi
                         options+=(-e MEMLEAK) ;;
                    5) if [[ $options[*] == *IO* ]]; then
                             echo "Error: You have already chosen IO."
                             exit 1
                         fi
                         options+=(-e IO) ;;
                    6) if [[ $options[*] == *perf::CACHE-MISSES* || $options[*] == *MEMLEAK* || $options[*] == *IO* ]]; then
                             echo "Error: You have already chosen one of the options in ALL."
                             exit 1
                         fi
                         options+=(-e perf::CACHE-MISSES -e MEMLEAK -e IO) ;;
                    *) echo "Invalid choice. Please choose a valid option." ;;
                esac
            done

            echo "Enter the file name with .txt extension in which output will be redirected"
            read -r file
            hpcrun "${options[@]}" ./$exe_name
            hpcstruct hpctoolkit-$exe_name-measurements
            hpcprof hpctoolkit-$exe_name-measurements
            hpcviewer hpctoolkit-$exe_name-database > $file
            break
        done
        break
    elif [[ $report == n ]]; then
        echo "Enter the file name with .txt extension in which output will be redirected"
        read -r file
        gprof $exe_name gmon.out > $file
        break
    else
        echo "Invalid choice. Please enter y or n."
    fi
done