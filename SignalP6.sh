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
#or
awk 'NR==FNR{a[NR]=$0;next}{print a[FNR],$0}' new.ids.txt coordinates_BSE_SP.txt | sed 's/ /\t/g' > new_coordinates.bed

## Rename Fasta header##
awk 'NR%2==0' SP_BSF.fasta | paste -d'\n' new.ids.txt - > new_fasta.fasta
## Add '>' to Fasta #
sed 's/^tr|/\>tr|/g' new_fasta.fasta

#Match IDs of SP to fasta #
grep -w -A 1 -f  IDs_SP.txt processed_entries.fasta --no-group-separator > SP_protein.fasta
# inser > at the header #
awk '{ if ($0 ~ /_/) { printf ">"; } print $0; }' SP_protein.fasta > SP_BSF.fasta 
#convert txt to bed format#
sed 's/,/\t/g' SP_BSF.txt > SP_BSF.bed
#remove coordinates less than 5#
awk -F '\t' '$3 >= 5 { print }' SP_BSF.bed > filtered_SP_BSF.bed ## 2897 

## change FASTA header##
awk 'NR%2==0' SP_BSF.fasta | paste -d'\n' IDs_SP.txt - > new_fasta.fasta 

### validate the two lines ##
diff <(head -n1 fasta.txt) <( head -n1 bed.txt) 

######################################################################

                        ## Drosophila Signal peptides ###
## manipulate the gff3 file #
grep "sp|" output.gff3 | awk -F '|' '{print $1, $2}' | sed 's/ /|/g' > prot_ids.txt
awk '$1=$1' FS=" " OFS="," output.gff3 >comma_sp.gff3
cat comma_sp.gff3 | rev | cut -d, -f5,6 | rev > coordinates_Dro_SP.txt
## Delete the first row inplace #
sed -i '1d' coordinates_Dro_SP.txt

paste -d, prot_ids.txt coordinates_Dro_SP.txt | sed 's/,/\t/g' > SP_coordinates.bed
awk -F '\t' '$3 >= 5 { print }' SP_coordinates.bed > filtered_coordinates.bed

## Manipulate in Fasta file ##
grep -w -A1 -f prot_ids.txt processed_entries.fasta --no-group-separator > SP_Dro.fasta 
awk '{ if ($0 ~ /_/) { printf ">"; } print $0; }' SP_Dro.fasta | awk 'NR%2==0'| paste -d'\n' prot_ids.txt - | awk '{ if ($0 ~ /_/) { printf ">"; } print $0; }' > matching.fasta
sed 's/^sp|/\>sp|/g' matching.fasta > filt.Dro.fasta 
bedtools getfasta -fi filt.Dro.fasta -bed filtered_coordinates.bed > Dro.SP.fasta

### filtering the signal peptides have <25 bases ###
awk -F '\t' '$3 <= 25 { print }' filtered_coordinates.bed > test.bed
bedtools getfasta -fi filt.Dro.fasta -bed test.bed > Short_25_seq.fasta





