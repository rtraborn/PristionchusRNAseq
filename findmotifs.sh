#!/bin/bash

#PBS -N HOMER
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=16,vmem=48gb
#PBS -l walltime=4:00:00
#PBS -q shared
#BS -m abe
#PBS -M lbui@indiana.edu


ulimit -s unlimited
module load gcc
module load bedtools
module load findmotifs

GENOME=/N/dc2/projects/Pristionchus/LBUI/RNA_seq_2016/Database/pacificus_Hybrid2.fa
ChrLength=/N/dc2/projects/Pristionchus/LBUI/PristionchusRNAseq/annotation_files/pp_hybrid2_chrlengths.txt
WD=/N/dc2/projects/Pristionchus/LBUI/PristionchusRNAseq/annotation_files

cd $WD

echo "Creating fasta files for promoter regions"

for GL in *.bed
do

bedtools flank -i $(basename $GL .bed).bed $GL -g $ChrLength -l 1000 -r 0 -s 
bedtools getfasta -fi $GENOME -bed $(basename $GL .bed).bed $GL |
findmotifs.pl    

done

echo "Alignment Complete"

