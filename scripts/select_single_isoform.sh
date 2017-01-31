#!/bin/bash

myfasta=c_elegans.PRJNA13758.WS255.protein.fa

echo "Beginning script."

awk '{print $1}' $myfasta > fasta.out
cat fasta.out | awk '/^>/ {if(N>0) printf("\n"); printf("%s\t",$0);N++;next;} {printf("%s",$0);} END {if(N>0) printf("\n");}' | tr "." "\t" | awk -F '	'  '{printf("%s\t%d\n",$0,length($3));}' | sort -t '	' -k1,1 -k4,4nr | sort -t '	' -k1,1 -u -s | sed 's/	/./' | cut -f 1,2 | tr "\t" "\n"  | fold -w 60 > c_elegans.PRJNA13758.single_isoform.fa
rm fasta.out

echo "Job complete"
