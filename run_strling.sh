#!/bin/bash

crams=$1
fasta=$2
cramsidx=$3
fastaidx=$4


# faidx to same folder as fasta
fname=$(basename "$fasta")
directory=$(dirname "$fasta")
ln -s "$fastaidx" "${directory}/${fname}.fai"

process_cram_file() {
    cram_file=$1
    cramidx_file=$2

    # copy crais to same folder as crams (tibanna puts in own folder)
    sname=$(basename "$cram_file" .cram)
    directory=$(dirname "$cram_file")
    ln -s "$cramidx_file" "${directory}/${sname}.cram.crai"

    mkdir -p str-bins/
    /usr/local/bin/strling extract -f "$fasta" "$cram_file" "str-bins/${sname}.bin"
    mkdir -p str-results/
    mkdir -p "str-results/${sname}/"
    mkdir -p "str-logs/${sname}/"

    /usr/local/bin/strling call --output-prefix "str-results/${sname}/${sname}" -f "$fasta" "$cram_file" "str-bins/${sname}.bin" > "str-logs/${sname}.log"
}

export -f process_cram_file

# Run the process_cram_file function in parallel for each CRAM file
parallel --jobs 2 process_cram_file ::: $crams $cramsidx

# Ensure all parallel jobs are completed before proceeding
wait


