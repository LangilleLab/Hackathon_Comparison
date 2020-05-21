#### Check if rarified and non-rarified tables contain the same samples and if they don't create a table that does



args <- commandArgs(trailingOnly = TRUE)
#test if there is an argument supply
if (length(args) <= 2) {
  stop("At least three arguments must be supplied", call.=FALSE)
}

## table 1 == non-rare
ASV_table_1 <- read.table(args[1], sep="\t", skip=1, header=T, row.names = 1, comment.char = "", quote="", check.names = F)
## table 2 == rare
ASV_table_2 <- read.table(args[2], sep="\t", skip=1, header=T, row.names = 1, comment.char = "", quote="", check.names = F)

if(!identical(colnames(ASV_table_1), colnames(ASV_table_2))){
  
  if(length(colnames(ASV_table_1)) > length(colnames(ASV_table_2))){
    
    message("There are more samples in the non-rarified table. These samples will be fitlered out before running differential abundance calculations")
    ASV_table_1 <- ASV_table_1[, colnames(ASV_table_2)]
    write.table(ASV_table_1, sep="\t", quote=F, file=args[[3]])
  }
  else{
    
    "The samples do not match in the rarified and non-rarified tables please check the input files"
  }
}else{
  "Samples betweent ables agree, no filtering required"
}
### filer ASV_table_1 to be the same

