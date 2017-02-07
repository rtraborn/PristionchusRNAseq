#!/bin/bash

myfasta=c_elegans.PRJNA13758.WS255.protein.fa

echo "Beginning script."

echo "Selecting longest isoforms"

awk '{print $1}' $myfasta > fasta.out
cat fasta.out | awk '/^>/ {if(N>0) printf("\n"); printf("%s\t",$0);N++;next;} {printf("%s",$0);} END {if(N>0) printf("\n");}' | sed -n '/[a-z]/p' | sed 's|[a-z]|.&|g' | sed -e 's/\.//1' | tr "." "\t" | awk -F '	'  '{printf("%s\t%d\n",$0,length($3));}' | sort -t '	' -k1,1 -k4,4nr | sort -t '	' -k1,1 -u -s | sed 's/	/./' | cut -f 1,2 | tr "\t" "\n"  | fold -w 60 | perl -e 'while (<>) {if (/(>\w*)(\w)\.([a-z])/) {print "$1.$2$3\n";} else {print $_;}}' > isoforms.out

echo "Selecting only single isoform genes."

cat fasta.out | awk '/^>/ {if(N>0) printf("\n"); printf("%s\t",$0);N++;next;} {printf("%s",$0);} END {if(N>0) printf("\n");}' | awk '!/^>\w+\.[0-9][a-z]/' | tr "\t" "\n" | fold -w 60 > non_isoforms.out

cat non_isoforms.out isoforms.out > c_elegans.PRJNA13758.single.isoform.fa

rm fasta.out

echo "Job complete"
