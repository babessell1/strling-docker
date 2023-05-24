#!/bin/bash

cram=$1
fasta=$2
cramidx=$3
fastaidx=$4


chmod 777 $cram

#MD5SUM=$(cat $md5file)

#MD_OUT=$(md5sum $cram)
#echo $MD_OUT
#echo $MD5SUM


#if [ $MD_OUT != $MD5SUM]; then
#    echo "MD5 sum does not match expected value!"
#    exit 1
#fi

sname=$(basename "$cram" .cram)

mkdir -p str-bins/
/home/ubuntu/strling extract -f $fasta $cram "str-bins/${sname}.bin"
mkdir -p str-results/
mkdir -p str-results/${sname}/
mkdir -p str-logs/${sname}/

/home/ubuntu/strling call --output-prefix str-results/${sname}/${sname} -f $fasta $cram str-bins/${sname}.bin > str-logs/${sname}.log