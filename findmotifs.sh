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

GENOME=/N/dc2/projects/Pristionchus/LBUI/RNA_seq_2016/Database/pacificus_Hybrid2.fa
ChrLength=/N/dc2/projects/Pristionchus/LBUI/PristionchusRNAseq/annotation_files/pp_hybrid2_chrlengths.txt
WD=/N/dc2/projects/Pristionchus/LBUI/PristionchusRNAseq/annotation_files
BG={to be entered by LBR}
myLen=1000


cd $WD

echo "Creating fasta files for promoter regions"

for BD in *.bed
do

bedtools flank -i $BD -g $ChrLength -l $myLen -r 0 -s |
bedtools getfasta -s -fi $GENOME > $(basename $BD .bed).fa 
findmotifs.pl  $BD.fa fasta $(basename $BD .bed) -fasta $BG -len 8,10,12 -norevopp    

done

echo "Alignment Complete"

