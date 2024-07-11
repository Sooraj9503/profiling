#!/bin/bash

while true; do
    echo "Choose from below:"
    echo "1. advisorTool"
    echo "2. gprofTool"
    echo "3. hpcTool"
    echo "4. vtuneTool"
    echo "Enter your choice: "
    read choice

    case $choice in
        1) source advisorTool.sh; break;;
        2) source gprofTool.sh; break;;
        3) source hpcTool.sh; break;;
        4) source vtuneTool.sh; break;;
        *) echo "Invalid choice!";;
    esac
done