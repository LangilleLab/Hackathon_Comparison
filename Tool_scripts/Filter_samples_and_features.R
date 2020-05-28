#### Check if rarified and non-rarified tables contain the same samples and if they don't create a table that does
remove_rare_features <- function( table , cutoff_pro) {
  if(cutoff_pro==0){
    message("No filtering will be done due to cutoff_pro set to 0")
    return(table)
  }
  row2keep <- c()
  cutoff <- ceiling( cutoff_pro * ncol(table) )
  for ( i in 1:nrow(table) ) {
    row_nonzero <- length( which( table[ i , ]  > 0 ) )
    if ( row_nonzero > cutoff ) {
      row2keep <- c( row2keep , i)
    }
  }
  return( table [ row2keep , , drop=F ])
}


args <- commandArgs(trailingOnly = TRUE)
#test if there is an argument supply
if (length(args) <= 4) {
  stop("At least five arguments must be supplied", call.=FALSE)
}

### check if we need to skip first line of file
con <- file(args[1])
file_1_line1 <- readLines(con,n=1)
close(con)

if(grepl("Constructed from biom file", file_1_line1)){
  ASV_table_1 <- read.table(args[1], sep="\t", skip=1, header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}else{
  ASV_table_1 <- read.table(args[1], sep="\t", header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}

con2 <- file(args[[2]])
file_2_line1 <- readLines(con2, n=1)
close(con2)

if(grepl("Constructed from biom file", file_2_line1)){
  ASV_table_2 <- read.table(args[2], sep="\t", skip=1, header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}else{
  ASV_table_2 <- read.table(args[2], sep="\t", header=T, row.names = 1, 
                            comment.char = "", quote="", check.names = F)
}


### loaded in the tables now we need to filter the ASVS that are found in less than X filter level

message(as.numeric(args[[3]]))
ASV_table_1 <- remove_rare_features(ASV_table_1, as.numeric(args[[3]]))
ASV_table_2 <- remove_rare_features(ASV_table_2, as.numeric(args[[3]]))


if(!identical(colnames(ASV_table_1), colnames(ASV_table_2))){
  
  if(length(colnames(ASV_table_1)) > length(colnames(ASV_table_2))){
    
    message("There are more samples in the non-rarified table. These samples will be fitlered out before running differential abundance calculations")
    ASV_table_1 <- ASV_table_1[, colnames(ASV_table_2)]
    write.table(ASV_table_1, sep="\t", quote=F, file=args[[4]])
    write.table(ASV_table_2, sep="\t", quote=F, file=args[[5]])
  }
  else{
    
    "The samples do not match in the rarified and non-rarified tables please check the input files"
  }
}else{
  "Samples  between tables agree, no sample filter required, returning feature filtered tables"
  write.table(ASV_table_1, sep="\t", quote=F, file=args[[4]])
  write.table(ASV_table_2, sep="\t", quote=F, file=args[[5]])
}
### filer ASV_table_1 to be the same

