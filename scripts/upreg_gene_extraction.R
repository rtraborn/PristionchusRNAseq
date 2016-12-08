### subsetting the RNA-seq results file to extract genes upregulated by a factor of 5
library(rtracklayer)

PP.results <- read.table(file="GSF1137.summary_LB.txt", header=TRUE, fill=TRUE)

cutoff.up <- log2(5) #setting the cutoffs at 5 and -5, respectively 
cutoff.down <- -(log2(5))

S6.ind <- which(PP.results$log2FC <= cutoff.down)
S6.upreg <- PP.results[S6.ind,]
S4.ind <- which(PP.results$log2FC >= cutoff.up)
S4.upreg <- PP.results[S4.ind, ]

write.table(S6.upreg, file="S6_upreg_genes.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
write.table(S4.upreg, file="S4_upreg_genes.txt", sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)

PP.gff3 <- readGFF("../annotation_files/Hybrid2_AUGUSTUS2014.gff3")
PP.mRNA <- PP.gff3[PP.gff3$type %in% "mRNA",]
PP.mRNA.df <- as.data.frame(PP.mRNA)
dim(PP.mRNA)

match(S6.upreg$V2_Gene, PP.mRNA.df$ID) -> S6.match.ind
match(S4.upreg$V2_Gene, PP.mRNA.df$ID) -> S4.match.ind

PP.mRNA.df[S6.match.ind, ] -> PP.mRNA.S6
PP.mRNA.df[S4.match.ind, ] -> PP.mRNA.S4

dim(PP.mRNA.S6)
dim(PP.mRNA.S4)

PP_S6.bed <- cbind(PP.mRNA.S6$seqid, PP.mRNA.S6$start, PP.mRNA.S6$end, PP.mRNA.S6$ID, c("."), PP.S6$score, PP.mRNA.S6$strand)
PP_S4.bed <- cbind(PP.mRNA.S4$seqid, PP.mRNA.S4$start, PP.mRNA.S4$end, PP.mRNA.S4$ID, c("."), PP.S4$score, PP.mRNA.S4$strand)

colnames(PP_S6.bed) <- c("chr", "start", "end", "ID", "score", "strand")
colnames(PP_S4.bed) <- c("chr", "start", "end", "ID", "score", "strand")

write.table(PP_S6.bed, file="PP_S6_upreg_genes.bed", quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)
write.table(PP_S6.bed, file="PP_S4_upreg_genes.bed", quote=FALSE, sep="\t", row.names=FALSE, col.names=TRUE)


