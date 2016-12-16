#!/bin/bash

#PBS -N OrthomclWorkflow_12_16
#PBS -k o
#PBS -q cpu
#PBS -l nodes=1:ppn=16,vmem=50gb
#PBS -l walltime=8:00:00
#PBS -q shared
#BS -m abe
#PBS -M rtraborn@indiana.edu

ulimit -s unlimited
module load orthomcl

orthoWD=/N/u/rtraborn/Mason/PristOrthoMCL
blastOut=ppa_cel_all_v_all_1215.tsv
fastaDir=input_fasta

cd $orthoWD

echo "Starting the workflow"

#blastp -query goodProteins_p_pa_c_el.fasta -db goodProteins_ppa_cel -evalue 1e-3 -outfmt 6 -num_threads 6 -out ppa_cel_all_v_all_1215.tsv ##this was run on gnomic

#echo "Parsing the BLAST output with orthocmcl"

#orthomclBlastParser ppa_cel_all_v_all_1215.tsv input_fasta > ppa_cel_out.bpo #this was run on gnomic

echo "Loading the BLAST data into the orthmcl database on RDC"

orthomclLoadBlast orthomcl.config ppa_cel_out.bpo

echo "Computing the pairs on the orthmcl database on RDC"

orthomclPairs orthomcl.config Prist_orthomclPairs_1216.log cleanup=no

echo "Running orthomclDumpPairsFiles on orthmcl database on RDC"

orthomclDumpPairsFiles orthomcl.config

#echo "Running mcl for clustering"

#mcl mclInput --abc -I 2.0 -analyze y -o mclOutput.1216_I20.out

#echo "Converting the MCL clusters into OrthoMCL groups"

#orthomclMclToGroups OG 1 < mclOutput.1216_I20.out > mclGroups.1216_I20.table

echo "Job Complete!"
