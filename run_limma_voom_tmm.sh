#!/bin/bash

Run_limma_voom_TMM()
{

    echo "Running Limma_voom_TMM"
    mkdir $Output_Path/Limma_voom_TMM
    outfile_voom=$Output_Path/Limma_voom_TMM/limma_voom_tmm_res.tsv
    Rscript Tool_scripts/Run_Limma_Voom_TMM.R $ASV_table_Path $Groupings_Path $outfile_voom

}


ASV_table_Path=""
Groupings_Path=""
Output_Path=""

if [ "$1" = "" ]; then
    echo "no input please add input"
    exit 1
fi
    
while [ "$1" != "" ]; do
    case $1 in
	-A | --ASV_table )
	    shift
	    ASV_table_Path=$1
	    ;;
	-G | --Groupings )
	    shift
	    Groupings_Path=$1
	    ;;
	-O | --out )
	    shift
	    Output_Path=$1
	    ;;
	* )
	    echo "Input command not recognized"
	    exit 1
    esac
    shift
done

time_file=$Output_Path/time_file.txt
current=$SECONDS
Run_limma_voom_TMM
duration=$(( SECONDS - current))
echo "limma_voom_tmm took " $duration" seconds" >> $time_file
