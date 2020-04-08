#### Run Corncob

library(corncob)
library(phyloseq)


args <- commandArgs(trailingOnly = TRUE)


ASV_table <- read.table(args[1], sep="\t", skip=1, header=T, row.names = 1, comment.char = "", quote="", check.names = F)
groupings <- read.table(args[2], sep="\t", row.names = 1, header=T, comment.char = "", quote="", check.names = F)

#number of samples
sample_num <- length(colnames(ASV_table))
grouping_num <- length(rownames(groupings))

#check if the same number of samples are being input.
if(sample_num != grouping_num){
  message("The number of samples in the ASV table and the groupings table are unequal")
  message("Will remove any samples that are not found in either the ASV table or the groupings table")
}

#check if order of samples match up.
if(identical(colnames(ASV_table), rownames(groupings))==T){
  message("Groupings and ASV table are in the same order")
}else{
  rows_to_keep <- intersect(colnames(ASV_table), rownames(groupings))
  groupings <- groupings[rows_to_keep,,drop=F]
  ASV_table <- ASV_table[,rows_to_keep]
  if(identical(colnames(ASV_table), rownames(groupings))==T){
    message("Groupings table was re-arrange to be in the same order as the ASV table")
    message("A total of ", sample_num-length(colnames(ASV_table)), " from the ASV_table")
    message("A total of ", grouping_num-length(rownames(groupings)), " from the groupings table")
  }else{
    stop("Unable to match samples between the ASV table and groupings table")
  }
}

#run corncob
#put data into phyloseq object.
colnames(groupings)
colnames(groupings)[1] <- "places"

OTU <- phyloseq::otu_table(ASV_table, taxa_are_rows = T)
sampledata <- phyloseq::sample_data(groupings, errorIfNULL = T)
phylo <- phyloseq::merge_phyloseq(OTU, sampledata)

my_formula <- as.formula(paste("~","places",sep=" ", collapse = ""))
my_formula
results <- corncob::differentialTest(formula= my_formula,
                                     phi.formula = my_formula,
                                     phi.formula_null = my_formula,
                                     formula_null = ~ 1,
                                     test="Wald", data=phylo,
                                     boot=F,
                                     fdr_cutoff = 0.05)


results$p_fdr
write.table(results$p_fdr, file=args[[3]], sep="\t", col.names = NA)
