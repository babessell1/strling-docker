#!/bin/bash

crams=$1
fasta=$2
cramsidx=$3
fastaidx=$4

echo "$crams"
chmod 777 "$crams"
chmod 777 "$fasta"
chmod 777 "$cramsidx"
chmod 777 "$fastaidx"

# faidx to same folder as fasta
fname=$(basename "$fasta")
directory=$(dirname "$fasta")
echo "$directory"
echo "$fname"
echo "$fastaidx"
cp "$fastaidx" "${directory}/${fname}.fai"


# copy crais to same folder as crams (tibanna puts in own folder)
sname=$(basename "$crams" .cram)
directory=$(dirname "$crams")
cp "$cramidx_file" "${directory}/${sname}.cram.crai"

mkdir -p str-bins/
/usr/local/bin/strling extract -f "$fasta" "$crams" "str-bins/${sname}.bin"
mkdir -p str-results/
mkdir -p "str-results/${sname}/"
mkdir -p "str-logs/${sname}/"

/usr/local/bin/strling call --output-prefix "str-results/${sname}/${sname}" -f "$fasta" "$crams" "str-bins/${sname}.bin" > "str-logs/${sname}.log"


