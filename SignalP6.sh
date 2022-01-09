#Running the Signalp6 for BSF###
signalp6 -ff uniprot-compressed_true_download_true_format_fasta_query_proteome_3A-2022.01.03-07.35.10.32.fasta -od out_BSF/ -org eukarya -fmt all
-fmt for formating
-org for organism
-ff for Fasta file

#Change teh delimiter of the gff3 file##
awk '$1=$1' FS=" " OFS="," output.gff3 > output.test.gff3 
#awk -F "|" '{print $2}' comma_updated.gff3 > BSF_SP_ids.txt ## protein IDs
grep -w -f  IDs_SP.txt processed_entries.fasta > BSF_SP_ids.txt 
cat comma_updated.gff3 | rev | cut -d, -f5,6 | rev > coordinates_BSE_SP.txt ## coordinates
paste -d, BSF_SP_ids.txt coordinates_BSE_SP.txt > SP_BSF.txt ## merging 2966 signal peptide for BSF

#Match IDs of SP to fasta #
grep -w -A 1 -f  IDs_SP.txt processed_entries.fasta --no-group-separator > SP_protein.fasta
# inser > at the header #
awk '{ if ($0 ~ /_/) { printf ">"; } print $0; }' SP_protein.fasta > SP_BSF.fasta 
#convert txt to bed format#
sed 's/,/\t/g' SP_BSF.txt > SP_BSF.bed
#remove coordinates less than 5#
awk -F '\t' '$3 >= 5 { print }' SP_BSF.bed > filtered_SP_BSF.bed
