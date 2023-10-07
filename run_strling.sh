#!/bin/bash

extract_subject_name() {
    # get sample name from cram/bam filename
    local string="$1"
    local delimiter="_vcpa"
    local subject_name=""

    # Use the delimiter "_vcpa" to split the string and extract the subject name
    subject_name="${string%%$delimiter*}"

    echo "$subject_name"
}


# Function to clean up files associated with a CRAM
cleanup() {
    local cram="$1"
    local bname=$(basename "$cram" .cram)
    
    # Remove CRAM files and associated output
    rm -f "output/${bname}*"
}


task1_status=0
task2_status=0

process_file() {
    local cram="$1"
    local fasta="$2"

    local fname=$(basename "$fasta")
    local bname=$(basename "$cram" .cram)

    # read only input directories cram/bam, index
    local ro_cram_dir=$(dirname "$cram")

    samtools index -@ 2 "$cram"

    # extract repetitive region binaries
    /usr/local/bin/strling extract -f "$fasta" "$cram" "output/${bname}.bin"
    # call strs
    /usr/local/bin/strling call --output-prefix "output/${bname}" -f "$fasta" "$cram" "output/${bname}.bin"

    # If the process fails, set the failed CRAM variable
    if [ $? -ne 0 ]; then
        # Trigger the cleanup function here to ensure it has a valid failed_cram value
        cleanup "$cram"
        # set task_status to failed depending on which task failed
        if [ "$cram" == "$cram1" ]; then
            task1_status=1
        elif [ "$cram" == "$cram2" ]; then
            task2_status=1
        fi
    fi

    # extra double check to make sure file exists
    if [ ! -f "output/${bname}-genotype.txt" ] 
        # Trigger the cleanup function here to ensure it has a valid failed_cram value
        cleanup "$cram"
        # set task_status to failed depending on which task failed
        if [ "$cram" == "$cram1" ]; then
            task1_status=1
        elif [ "$cram" == "$cram2" ]; then
            task2_status=1
        fi
    fi
}

# command-line (cwl file) arguments
cram1="$1"
cram2="$2"
fasta="$3"
fastaidx="$4"

# out = dir to export to
mkdir -p output
mkdir -p out

# Run the script in parallel for both cram1 and cram2
(
    process_file "$cram1" "$fasta"
) &
(
    process_file "$cram2" "$fasta"
) &

# Wait for all parallel processes to finish
wait

# Check if either of the tasks were killed (exit code is non-zero)
if [ "$task1_status" -ne 0 ] || [ "$task2_status" -ne 0 ]; then
    echo "One or more tasks were killed. Cleaning up..."

    # Determine which task failed and create a TAR for the successful task
    if [ "$task1_status" -eq 0 ]; then  # task 1 succeeded, only create a TAR for task 1
        name1=$(extract_subject_name "$(basename "$cram1" .cram)")
        echo "Task 1 failed. Creating TAR for $name1 only..."
        tar cf "out/${name1}.tar" "output"
        # exit with a pass to ensure tibanna will take what it can get
        exit 0
    elif [ "$task2_status" -eq 0 ]; then  # task 2 succeeded, only create a TAR for task 2
        name2=$(extract_subject_name "$(basename "$cram2" .cram)")
        echo "Task 2 failed. Creating TAR for $name2 only..."
        tar cf "out/${name2}.tar" "output"
        # exit with a pass to ensure tibanna will take what it can get
        exit 0
    else
        echo "Both tasks failed. No TAR files will be created."
        # exit with a failure code
        exit 1
    fi
fi

name1=$(extract_subject_name "$(basename "$cram1" .cram)")
name2=$(extract_subject_name "$(basename "$cram2" .cram)")

echo "${name1}___${name2}.tar"

tar cf "out/${name1}___${name2}.tar" "output"
