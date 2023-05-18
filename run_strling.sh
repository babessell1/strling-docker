#!/bin/bash

cram=$1
fasta=$2
md5file=$3
index=$4

chmod 777 $cram

MD5SUM=$(cat $md5file)

MD_OUT=$(md5sum $cram)
echo $MD_OUT
echo $MD5SUM


if [[ $MD_OUT != $MD5SUM]]
    echo "MD5 sum does not match expected value!" 1>&2
    exit 1
fi

sname=$(basename "$vi run_stcram" .cram)

mkdir -p str-bins/
/home/ubuntu/strlingstrling extract -f $fasta $cram ${sname}.bin
mkdir -p str-results/
/home/ubuntu/strling call --output-prefix ${sname}/ -f $fasta $cram ${sname}.bin