#!/bin/bash

cram=$1
fasta=$2
md5file=$3

md5sum=$(echo $md5file)

MD_OUT=($($MD5SUM $cram))
if [[ $MD_OUT != $md5]]
then
    echo "MD5 sum does not match expected value!" 1>&2
    exit 1
fi
echo $MD_OUT

sname=$(basename "$cram" .cram)

mkdir -p str-bins/
strling extract -f $fasta $cram ${sname}.bin
mkdir -p str-results/
/home/ubuntu/strling call --output-prefix ${sname}/ -f $fasta $cram ${sname}.bin