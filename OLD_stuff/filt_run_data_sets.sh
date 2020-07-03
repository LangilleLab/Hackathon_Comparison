#!/bin/bash



parallel --eta -j 39 -N4 './Run_all_tools.sh -A {2} -R {1} -G {3} -O {4} -F 0.1' :::: <(cat filt_sorted_all_input.txt)  
#parallel -j 40 --link --dry './Run_all_tools.sh -A {1} -R {2} -G {3} -O {4}' ::: ~/projects/Hackathon/Results/* ~/projects/Hackathon/Results/* ~/projects/Hackathon/Results/* ~/projects/Hackathon/Results/*
