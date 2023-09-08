#!/bin/bash

#Adapted from the 1000G script submit. These are simply to iterate through subddirectories. Adapting to a more parallele pipeline structure will be necessary in the future.

script=$1
sample_processed=$2
INPUT_DIR=$3

readarray -t sample_done < "$sample_processed"

cd $INPUT_DIR


# Match the basename for each modkit processed directory with the list of ones that had already been processed
for subdir in "$INPUT_DIR"/*; do
    if [ -d "$subdir" ]; then
        dirname=$(basename "$subdir")

          # Only run intersect script on directories not previously processed
            if [[ ! " ${sample_done[@]} " =~ " $dirname " ]]; then
            cd "$subdir"
            sh "$script" $subdir
            echo "Script executed for directory: $subdir"
            
        fi
    fi
done

