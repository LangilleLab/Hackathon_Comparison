
parallel -j 39 'run_lefse.py {1} {1//}/Lefse_results.tsv' ::: ~/projects/Hackathon/Studies/*/Fix_Results_0.1/Lefse_out/lefse_formatted.lefse

