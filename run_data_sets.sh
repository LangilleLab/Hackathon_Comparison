#!/bin/bash



parallel -j 40 --link --dry './Run_all_tools.sh -A {1} -R {2} -G {3} -O {4}' :::: <(cat ASV_table_list.txt) :::: <(cat ASV_table_rare_list.txt) :::: <(cat metadata_list.txt) :::: <(cat output_list.txt) 
#parallel -j 40 --link --dry './Run_all_tools.sh -A {1} -R {2} -G {3} -O {4}' ::: ~/projects/Hackathon/Results/* ~/projects/Hackathon/Results/* ~/projects/Hackathon/Results/* ~/projects/Hackathon/Results/*
