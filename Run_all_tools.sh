#!/bin/bash

# sysinfo_page - A script to produce a system information HTML file

##### Constants

RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="Updated on $RIGHT_NOW by $USER"

##### Functions

help()
{
    echo "-A | --ASV_table -> A tsv file where each column represents a different ASV and each row represents a different samples"
    echo "-G | --Groupings -> A tsv file with two columns. One columns represents the sample names while the other column represents the group for that sample"
    echo "-O | --output_path -> the path to the directory that the output of each test should be placed into"
    echo "-h | --help -> The output of this command!"

}

usage()
{
    echo "usage: Run_all_tools -A [PATH_TO_ASV_TABLE] -G [PATH_TO_GROUPING_TABLE] -O [PATH_TO_OUTPUT_DIRECTORY] -R [PATH_TO_RARIFIED_TABLE]"
}

Run_ALDEX2()
{
#A simple Rscript that takes in two TSV files (one ASV table) and (one Grouping table) and runs ALDEX2 differential abundance
    echo "Running ALDEx2"
    
    mkdir $Output_Path/Aldex_out
    out_file=$Output_Path/Aldex_out/Aldex_res.tsv
    Rscript Run_Aldex2.R $ASV_table_Path $Groupings_Path $out_file
    
}

Run_DeSeq2()
{
#A simple Rscript that takes in two TSV files (one ASV table) and (one Grouping table) and runs DeSeq2 differential abundance

    echo "Running DeSeq2"

    mkdir $Output_Path/Deseq2_out
    out_file_deseq=$Output_Path/Deseq2_out/Deseq2_results.tsv
    Rscript Run_DESeq2.R $ASV_table_Path $Groupings_Path $out_file_deseq
}

Run_Ancom()
{

    echo "Running ANCOM"
}


Run_Lefse()
{
    ## Would like to find a way around activiating this environment to run this as it does take some time to run...
    source activate hackathon
    echo "Running Lefse on rarified input table"
    mkdir $Output_Path/Lefse_out
    out_file_lefse=$Output_Path/Lefse_out/lefse_format_file.tsv
     
    Rscript Format_lefse.R $Rar_ASV_table_PATH $Groupings_Path $out_file_lefse
    formated_out_file_lefse=$Output_Path/Lefse_out/lefse_formatted.lefse

    
    format_input.py $out_file_lefse $formated_out_file_lefse -c 2 -u 1 -o 1000000
    lefse_results=$Output_Path/Lefse_out/Lefse_results.tsv
    run_lefse.py $formated_out_file_lefse $lefse_results
    echo "Done running Lefse"
    
    source deactivate hackathon
}
##### Main

Run_Corncob()
{

    mkdir $Output_Path/Corncob_out
    out_file_corncob=$Output_Path/Corncob_out/Corncob_results.tsv
    Rscript Run_Corncob.R $ASV_table_Path $Groupings_Path $out_file_corncob

}

Run_Wilcoxin_rare()
{

    mkdir $Output_Path/Wilcoxin_rare_out
    out_file_wil_rare=$Output_Path/Wilcoxin_rare_out/Wil_rare_results.tsv
    Rscript Run_Wilcox_rare.R $Rar_ASV_table_PATH $Groupings_Path $out_file_wil_rare

}

Groupings_Path=
ASV_table_Path=
Output_Path=
Rar_ASV_table_Path=

Run_Wilcoxin_CLR()
{
    mkdir $Output_Path/Wilcoxin_CLR_out
    out_file_wil_CLR=$Output_Path/Wilcoxin_CLR_out/Wil_CLR_results.tsv
    Rscript Run_Wilcox_CLR.R $ASV_table_Path $Groupings_Path $out_file_wil_CLR

    
}


while [ "$1" != "" ]; do
    case $1 in
        -A | --ASV_table )           shift
                                ASV_table_Path=$1
                                ;;
	-R | --rar_ASV_table ) shift
			       Rar_ASV_table_PATH=$1
			       ;;
        -G | --Groupings ) shift
	    Groupings_Path=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
	-O | --outputh_path) shift
			     Output_Path=$1
			     ;;
			    
        * )                     usage
                                exit 1
    esac
    shift
done

### Tools to implement
#Aldex (:
#Deseq2 (:
#Lefse (:
#Ancom 
#Corncob (:
#Maaslin2 
#Wilcoxin rarified (:
#Wilcoxin CLR (:


# Test code to verify command line processing

echo $ASV_table_Path
echo $Groupings_Path
echo $Output_Path

#Run_ALDEX2
#Run_DeSeq2
#Run_Lefse		       	
#Run_Corncob
#Run_Wilcoxin_rare
Run_Wilcoxin_CLR
