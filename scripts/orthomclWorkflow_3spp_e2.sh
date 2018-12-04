#!/bin/bash

orthoWD=/scratch/rtraborn/archive/Ppa_orthomcl
blastOut=blastp_goodProteins_e2_1203.tab
similarSeq=3spp_e2_out_1203.bpo
fastaDir=blastp_e2
configFile=/scratch/rtraborn/archive/Ppa_orthomcl/orthomcl_3e2_0718.config

cd $orthoWD

echo "Starting the workflow"

orthomclInstallSchema $configFile

echo "Parsing the BLAST output with orthocmcl"

orthomclBlastParser $blastOut $fastaDir > $similarSeq

echo "Loading the BLAST data into the orthmcl database on RDC"

orthomclLoadBlast $configFile $similarSeq

echo "Computing the pairs on the orthmcl database on RDC"

orthomclPairs $configFile Prist_orthomclPairs_3spp_e2.log cleanup=no

echo "Running orthomclDumpPairsFiles on orthmcl database on RDC"

orthomclDumpPairsFiles $configFile

echo "Running mcl for clustering"

mcl mclInput --abc -I 2.0 -analyze y -o mclOutput_3spp_e2.out

echo "Converting the MCL clusters into OrthoMCL groups"

orthomclMclToGroups OG 1 < mclOutput_3spp_e2.out > mclOutput_3spp_e2.table

echo "Converting the orthologous groups into a table of counts per species"

CopyNumberGen.sh mclOutput_3spp_e2.table > 3spp_e2_CopyNum.txt

echo "Identifying single-copy orthologs (SCOs)"

ExtractSCOs.sh 3spp_e2_CopyNum.txt > 3spp_e2_SCOs.txt

echo "Job Complete!"
