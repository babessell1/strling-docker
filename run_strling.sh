#!/bin/bash

cram=$1
fasta=$2
md5=$3

MD_OUT=($(md5sum $cram))
if [[ $MD_OUT != $md5]]; then
    echo "MD5 sum does not match expected value!" 1>&2
    exit 1
fi

sname=$(basename "$cram" .cram)

mkdir -p str-bins/
strling extract -f $fasta $cram ${sname}.bin
mkdir -p str-results/
strling call --output-prefix {output} -f {input.ref} {input.cram} {wildcards.sample}.bin