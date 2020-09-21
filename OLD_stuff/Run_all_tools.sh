#!/bin/bash


RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="Updated on $RIGHT_NOW by $USER"

##### Functions

help()
{
    echo "-A | --ASV_table -> A tsv file where each column represents a different ASV and each row represents a different samples"
    echo "-G | --Groupings -> A tsv file with two columns. One columns represents the sample names while the other column represents the group for that sample"
    echo "-O | --output_path -> the path to the directory that the output of each test should be placed into"
    echo "-F | --Filt -> The precentage of samples required for a feature to be present in so that it will not be filtered out"
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
    Rscript Tool_scripts/Run_Aldex2.R $ASV_table_Path $Groupings_Path $out_file
    
}

Run_DeSeq2()
{
#A simple Rscript that takes in two TSV files (one ASV table) and (one Grouping table) and runs DeSeq2 differential abundance

    echo "Running DeSeq2"

    mkdir $Output_Path/Deseq2_out
    out_file_deseq=$Output_Path/Deseq2_out/Deseq2_results.tsv
    Rscript Tool_scripts/Run_DESeq2.R $ASV_table_Path $Groupings_Path $out_file_deseq
}

Run_Ancom2()
{

    echo "Running ANCOM"
    mkdir $Output_Path/ANCOM_out
    out_file_ancom=$Output_Path/ANCOM_out/Ancom_res.tsv
    Rscript Tool_scripts/Run_ANCOM.R $ASV_table_Path $Groupings_Path $out_file_ancom $PWD/Ancom2_Script/ancom_v2.1.R
}


Run_Lefse()
{
    ## Would like to find a way around activiating this environment to run this as it does take some time to run...
    source activate hackathon
    echo "Running Lefse on rarified input table"
    mkdir $Output_Path/Lefse_out
    out_file_lefse=$Output_Path/Lefse_out/lefse_format_file.tsv
     
    Rscript Tool_scripts/Format_lefse.R $Rar_ASV_table_PATH $Groupings_Path $out_file_lefse
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
    Rscript Tool_scripts/Run_Corncob.R $ASV_table_Path $Groupings_Path $out_file_corncob

}

Run_Wilcoxin_rare()
{

    mkdir $Output_Path/Wilcoxon_rare_out
    out_file_wil_rare=$Output_Path/Wilcoxon_rare_out/Wil_rare_results.tsv
    Rscript Tool_scripts/Run_Wilcox_rare.R $Rar_ASV_table_PATH $Groupings_Path $out_file_wil_rare

}

Run_Wilcoxin_CLR()
{
    mkdir $Output_Path/Wilcoxon_CLR_out
    out_file_wil_CLR=$Output_Path/Wilcoxon_CLR_out/Wil_CLR_results.tsv
    Rscript Tool_scripts/Run_Wilcox_CLR.R $ASV_table_Path $Groupings_Path $out_file_wil_CLR

    
}

Run_Maaslin2_rare()
{
    echo "Running Maaslin2 with rarified table"
    mkdir $Output_Path/Maaslin2_rare_out
    out_file_maas_rare=$Output_Path/Maaslin2_rare_out
    Rscript Tool_scripts/Run_Maaslin2.R $Rar_ASV_table_PATH $Groupings_Path $out_file_maas_rare
}

Run_Maaslin2()
{
    echo "Running Maaslin2 on non-rarified table"
    mkdir $Output_Path/Maaslin2_out
    out_file_maas=$Output_Path/Maaslin2_out
    Rscript Tool_scripts/Run_Maaslin2.R $ASV_table_Path $Groupings_Path $out_file_maas
}

Run_metagenomeSeq()
{

    echo "Running metagenomeSeq using fitFeatureModel"
    mkdir $Output_Path/metagenomeSeq_out
    out_file_mgSeq=$Output_Path/metagenomeSeq_out/mgSeq_res.tsv
    Rscript Tool_scripts/Run_metagenomeSeq.R $ASV_table_Path $Groupings_Path $out_file_mgSeq
}

Run_edgeR()
{
    echo "Running edgeR"
    mkdir $Output_Path/edgeR_out
    out_file_edgeR=$Output_Path/edgeR_out/edgeR_res.tsv
    Rscript Tool_scripts/Run_edgeR.R $ASV_table_Path $Groupings_Path $out_file_edgeR
    
}

Run_t_test_rare()

{
    echo "Running T test"
    mkdir $Output_Path/t_test_rare_out
    out_file_t_rare=$Output_Path/t_test_rare_out/t_test_res.tsv
    Rscript Tool_scripts/Run_t_test_rare.R $Rar_ASV_table_PATH $Groupings_Path $out_file_t_rare
    
}

Filter_non_rare_table()
{

    echo "Ensuring samples are the same between tables"
    table_name="${ASV_table_Path##*/}"
    rare_table_name="${Rar_ASV_table_PATH##*/}"
    mkdir $Output_Path/fixed_non_rare_tables/
    mkdir $Output_Path/fixed_rare_tables/
    out_file_new_tab_ASV=$Output_Path/fixed_non_rare_tables/$table_name
    out_file_new_tab_rar_ASV=$Output_Path/fixed_rare_tables/$rare_table_name
	## set up filtering code
    if [ $Filt_level != 0 ]; then
	## script that both filters ASVs at filter level and then also at the filter level presence
	Rscript Tool_scripts/Filter_samples_and_features.R $ASV_table_Path $Rar_ASV_table_PATH $Filt_level $out_file_new_tab_ASV $out_file_new_tab_rar_ASV
	ASV_table_Path=$out_file_new_tab_ASV
	Rar_ASV_table_PATH=$out_file_new_tab_rar_ASV
    else
	### If filtering is not required we run the script that doesn't use filtering...
	Rscript Tool_scripts/Filter_samples_of_non_rare_table.R $ASV_table_Path $Rar_ASV_table_PATH $out_file_new_tab_ASV
    ### check if it made a new table and if so update ASV_table_Path
	if [ -f "$out_file_new_tab" ]; then
	    ASV_table_Path=$out_file_new_tab_ASV
	else
	    echo "Sample filtering not required"
	fi
    fi
    
    
    
}

Groupings_Path=
ASV_table_Path=
Output_Path=
Rar_ASV_table_Path=
Filt_level=0

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
	-F | --Filt ) 	shift
			Filt_level=$1
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
#Ancom2 (:
#Ancom ... need a scipy script.
#Corncob (:
#Maaslin2 (:
#Wilcoxin rarified (:
#Wilcoxin CLR (:
#edgeR (:
#metagenomeSeq (:
#t test 



# Test code to verify command line processing

time_file=$Output_Path/time_file.txt
touch $time_file

current=$SECONDS
Filter_non_rare_table
duration=$(( SECONDS - current))
echo "Filtering took "$duration" seconds" >> $time_file

current=$SECONDS
Run_ALDEX2
duration=$(( SECONDS - current))
echo "Aldex2 took "$duration" seconds" >> $time_file

current=$SECONDS
Run_DeSeq2
duration=$(( SECONDS - current))
echo "Deseq2 took " $duration" seconds" >> $time_file

current=$SECONDS
Run_Lefse		       	
duration=$(( SECONDS - current))
echo "Lefse took "$duration" seconds" >> $time_file

current=$SECONDS
Run_Corncob
duration=$(( SECONDS - current))
echo "Corncob took "$duration" seconds" >> $time_file

current=$SECONDS
Run_Wilcoxin_rare
duration=$(( SECONDS - current))
echo "Wilcoxon rare took "$duration" seconds" >> $time_file

current=$SECONDS
Run_Wilcoxin_CLR
duration=$(( SECONDS - current))
echo "Wilcoxon CLR took "$duration" seconds" >> $time_file

current=$SECONDS
Run_Maaslin2_rare
duration=$(( SECONDS - current))
echo "Maaslin2 rare took "$duration" seconds" >> $time_file

current=$SECONDS
Run_Maaslin2
duration=$(( SECONDS - current))
echo "Maaslin2 took "$duration" seconds" >> $time_file

current=$SECONDS
Run_Ancom2
duration=$(( SECONDS - current))
echo "Ancom2 took "$duration" seconds" >> $time_file

current=$SECONDS
Run_metagenomeSeq
duration=$(( SECONDS - current))
echo "metagenomeSeq took "$duration" seconds" >> $time_file

current=$SECONDS
Run_edgeR
duration=$(( SECONDS - current))
echo "edgeR took "$duration" seconds" >> $time_file

current=$SECONDS
Run_t_test_rare
duration=$(( SECONDS - current))
echo "t test rare took "$duration" seconds" >> $time_file
