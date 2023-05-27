#!/bin/bash

crams=($1 $2)
fasta=$3
cramsidx=($4 $5)
fastaidx=$6

echo "$crams"
echo "$fasta"
echo "$cramsidx"
echo "$fastaidx"

ref_dir="/data1/input/references/"
cram_dir="/data1/input/crams/"

echo "$ref_dir"
echo "$cram_dir"


# faidx to same folder as fasta
fname=$(basename "$fasta")
ro_ref_dir=$(dirname "$fasta")
#ln -s "$fastaidx" "${directory}/${fname}.fai"

samtools faidx "${ref_dir}/${fname}"

process_cram_file() {
    cram_file=$1

    echo "function"
    echo "$fa"

    echo "$cram_file"

    # copy crais to same folder as crams (tibanna puts in own folder)
    sname=$(basename "$cram_file" .cram)
    ro_cram_dir=$(dirname "$cram_file")
    #ln -s "$cramsidx_file" "${directory}/${sname}.cram.crai"

    echo "$sname"

    ref_dir="/data1/input/references/"
    cram_dir="/data1/input/crams/"


    #cramidx_file=$2
    samtools index "${cram_dir}/${sname}.cram"

    mkdir -p str-bins/
    /usr/local/bin/strling extract -f "$fa" "${cram_dir}/${sname}.cram" "str-bins/${sname}.bin"
    mkdir -p str-results/
    mkdir -p "str-results/${sname}/"
    mkdir -p "str-logs/${sname}/"

    /usr/local/bin/strling call --output-prefix "str-results/${sname}/${sname}" -f "$fa" "${cram_dir}/${sname}.cram" "str-bins/${sname}.bin" > "str-logs/${cname}.log"
}

export -f process_cram_file

# Run the process_cram_file function in parallel for each CRAM file
parallel --env fa --jobs 2 process_cram_file "${ref_dir}/${fname}" ::: $crams #$cramsidx

# Ensure all parallel jobs are completed before proceeding
wait


