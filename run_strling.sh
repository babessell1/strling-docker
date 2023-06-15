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
    
    cp "${ro_cramidx_dir}/${sname}.cram.crai" "${ro_cram_dir}/${sname}.cram.crai"

    /usr/local/bin/strling extract -f "$fasta" "$cram" "output/${sname}.bin"
    /usr/local/bin/strling call --output-prefix "output/${sname}" -f "$fasta" "$cram" "output/${sname}.bin"

}

# Assign the command-line arguments to variables
cram1="$1"
cram2="$2"
fasta="$3"
cramidx1="$4"
cramidx2="$5"
fastaidx="$6"

mkdir -p output
mkdir -p out

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
name2=$(basename "$cram2" .cram)
tar cf ${name1}_${name2}.tar output
mv ${name1}_${name2}.tar out/${name1}_${name2}.tar

echo "$(ls out)"
echo "$(ls output)"
