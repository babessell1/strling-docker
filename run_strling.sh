#!/bin/bash

process_file() {
    local cram="$1"
    local fasta="$2"
    local cramidx="$3"

    local fname=$(basename "$fasta")
    local ro_ref_dir=$(dirname "$fasta")

    local sname=$(basename "$cram" .cram)
    local ro_cram_dir=$(dirname "$cram")
    local ro_cramidx_dir=$(dirname "$cramidx")

    echo "--------------------------"
    echo "sname: ${sname}"
    echo "fname: ${fname}"
    echo "cram: ${cram}"
    echo "cramidx: ${cramidx}"
    echo "ro_ref_dir: ${ro_ref_dir}"
    echo "ro_cram_dir: ${ro_cram_dir}"
    echo "ro_cramidx_dir: ${ro_cramidx_dir}"
    echo "============================"
    
    cp "${ro_cramidx_dir}/${sname}.cram.crai" "${ro_cram_dir}/${sname}.cram.crai"

    #/usr/local/bin/strling extract -f "$fasta" "$cram" "${sname}.bin"
    touch output/${sname}.dummy.bin
    #mkdir -p ${sname}
    #mkdir -p "str-results/${sname}/"
    #mkdir -p "str-logs/${sname}/"

    #/usr/local/bin/strling call --output-prefix "${sname}" -f "$fasta" "$cram" "${sname}/${sname}.bin"
    touch output/${sname}-bounds.txt
    touch output/${sname}-genotype.txt
    touch output/${sname}-unplaced.txt


    #tar -zcvf ${sname}.tar.gz ${sname}

}

# Assign the command-line arguments to variables
cram1="$1"
cram2="$2"
fasta="$3"
cramidx1="$4"
cramidx2="$5"
fastaidx="$6"

echo "$(pwd)"

echo "${cram1}"
echo "${cram2}"
echo "${fasta}"
echo "${cramidx1}"
echo "${cramidx2}"
echo "${fastaidx}"

# Run the script in parallel for both cram1 and cram2
(
    process_file "$cram1" "$fasta" "$cramidx1"
) &

(
    process_file "$cram2" "$fasta" "$cramidx2"
) &

# Wait for all parallel processes to finish
wait
name1=$(basename "$cram1" .cram)
name1=$(basename "$cram2" .cram)
tar cf ${name1}_${name2}.tar output
mv ${name1}_${name2}.tar out/${name1}_${name2}.tar

echo "$(ls)"
