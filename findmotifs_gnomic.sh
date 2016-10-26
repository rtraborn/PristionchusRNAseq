#!/bin/bash

#PBS -N HOMER
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=16,vmem=24gb
#PBS -l walltime=12:00:00
#PBS -q shared
#BS -m abe
#PBS -M lbui@indiana.edu


ulimit -s unlimited
module load gcc
module load bedtools

GENOME=/N/dc2/projects/Pristionchus/LBUI/RNA_seq_2016/Database/pacificus_Hybrid2.fa
ChrLength=/N/dc2/projects/Pristionchus/LBUI/PristionchusRNAseq/annotation_files/pp_hybrid2_chrlengths.txt
WD=/N/dc2/projects/Pristionchus/LBUI/PristionchusRNAseq/annotation_files
BG=/N/dc2/projects/Pristionchus/LBUI/PritionchusRNAseq/annotation_files/background.fa
myLen=1000


cd $WD

echo "Creating fasta files for promoter regions and running findMotifs"

for BD in *.up.bed
do

bedtools flank -i $BD -g $ChrLength -l $myLen -r 0 -s > $(basename $BD .bed)_1kb.bed
bedtools getfasta -s -fi $GENOME -bed $(basename $BD .bed)_1kb.bed -fo $(basename $BD .bed).fa 
findMotifs.pl  $(basename $BD .bed).fa fasta $(basename $BD .bed)_1kb -fasta $GENOME -len 8,10,12 -norevopp -p 16    

done

echo "Alignment Complete"

