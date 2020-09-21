#!/bin/bash

parallel --eta -j 20 -N3 '~/GitHub_Repos/Hackathon_testing/run_limma_voom_tmm.sh -G {1} -O {2} -A {3}' ::: <(cat ~/GitHub_Repos/Hackathon_testing/parallel_run_scripts/No_filt_input_limma/sort_combined_input.txt)
