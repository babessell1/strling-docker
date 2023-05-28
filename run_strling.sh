#!/bin/bash

cram=$1
fasta=$3
cramidx=$4
fastaidx=$6

echo "Start"
echo "$cram"
echo "$fasta"
echo "$cramidx"
echo "$fastaidx"

fname=$(basename "$fasta")
ro_ref_dir=$(dirname "$fasta")

sname=$(basename "$cram" .cram)
ro_cram_dir=$(dirname "$cram")

#ls /mnt/data1/input | echo
echo "ls: $(ls)"
echo "pwd: $(pwd)"
echo "sname: $sname"
echo "fname: $fname"
echo "sub ls: $(ls /mnt)"
echo "sub pwd: $(pwd /mnt)"

#ln -s "$fastaidx" "${ro_ref_dir}/${fname}.fai"

mv "/data1/input/cramsidx/${sname}.cram.crai" "data1/input/crams/${sname}.cram.crai"

cram="/data1/input/crams/${sname}.cram"
fasta="/data1/input/references/${fname}"

mkdir -p str-bins/
/usr/local/bin/strling extract -f "$fasta" "$cram" "str-bins/${sname}.bin"
mkdir -p str-results/
mkdir -p "str-results/${sname}/"
mkdir -p "str-logs/${sname}/"

/usr/local/bin/strling call --output-prefix "str-results/${sname}/${sname}" -f "$fasta" "$cram" "str-bins/${sname}.bin" > "str-logs/${sname}.log"
