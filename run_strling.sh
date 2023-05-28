#!/bin/bash

call_strling() {
    cram="$1"
    fasta="$2"
    cramidx="$3"

    fname=$(basename "$fasta")
    ro_ref_dir=$(dirname "$fasta")

    sname=$(basename "$cram" .cram)
    ro_cram_dir=$(dirname "$cram")
    ro_cramidx_dir=$(dirname "$cramidx")

    cp "${ro_cramidx_dir}/${sname}.cram.crai" "${ro_cram_dir}/${sname}.cram.crai"

    mkdir -p str-bins/
    /usr/local/bin/strling extract -f "$fasta" "$cram" "str-bins/${sname}.bin"
    mkdir -p str-results/
    mkdir -p "str-results/${sname}/"
    mkdir -p "str-logs/${sname}/"

    /usr/local/bin/strling call --output-prefix "str-results/${sname}/${sname}" -f "$fasta" "$cram" "str-bins/${sname}.bin"
    echo "done"
}

# Assign the command-line arguments to variables
cram1="$1"
cram2="$2"
fasta="$3"
cramidx1="$4"
cramidx2="$5"
fastaidx="$6"

# Define the function to be executed in parallel
export -f call_strling

# Run the script in parallel for both cram1 and cram2
parallel call_strling ::: "$cram1" "$cram2" ::: "$fasta" "$fasta" ::: "$cramidx1" "$cramidx2"
