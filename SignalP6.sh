#Running the Signalp6 for BSF###
signalp6 -ff uniprot-compressed_true_download_true_format_fasta_query_proteome_3A-2022.01.03-07.35.10.32.fasta -od out_BSF/ -org eukarya -fmt all
-fmt for formating
-org for organism
-ff for Fasta file

#Change teh delimiter of the gff3 file##
awk '$1=$1' FS=" " OFS="," output.gff3 > output.test.gff3 
awk -F "|" '{print $2}' comma_updated.gff3 > BSF_SP_ids.txt ## protein IDs
cat comma_updated.gff3 | rev | cut -d, -f5,6 | rev > coordinates_BSE_SP.txt ## coordinates
paste -d, BSF_SP_ids.txt coordinates_BSE_SP.txt > SP_BSF.txt ## merging

