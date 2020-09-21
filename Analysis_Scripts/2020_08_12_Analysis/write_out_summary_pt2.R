# Write out heatmap code for making them as tabs for each dataset.

hackathon_study_ids <- c("ArcticFireSoils",
                         "ArcticFreshwaters",
                         "ArcticTransects",
                         "art_scher",
                         "asd_son",
                         "BISCUIT",
                         "Blueberry",
                         "cdi_schubert",
                         "cdi_vincent",
                         "Chemerin",
                         "crc_baxter",
                         "crc_zeller",
                         "edd_singh",
                         "Exercise",
                         "glass_plastic_oberbeckmann",
                         "GWMC_ASIA_NA",
                         "GWMC_HOT_COLD",
                         "hiv_dinh",
                         "hiv_lozupone",
                         "hiv_noguerajulian",
                         "ibd_gevers",
                         "ibd_papa",
                         "Ji_WTP_DS",
                         "MALL",
                         "ob_goodrich",
                         "ob_ross",
                         "ob_turnbaugh",
                         "ob_zhu",
                         ###"ob_zupancic",
                         "Office",
                         "par_scheperjans",
                         "sed_plastic_hoellein",
                         "sed_plastic_rosato",
                         "seston_plastic_mccormick",
                         "sw_plastic_frere",
                         "sw_sed_detender",
                         "t1d_alkanani",
                         "t1d_mejialeon",
                         "wood_plastic_kesy")

outfile <- "/home/gavin/gavin_backup/misc/hackathon/2020_08_12_summary/2020_08_12_summary_part2.Rmd"

cat("\n\n## Filtered data {.tabset}\n", sep="", append = FALSE, file = outfile)

for(study in hackathon_study_ids) {
  cat("\n\n### ", study, "\n",
      "```{r ", study, "_heatmap_filt, cache=TRUE}\n",
      "     ", study, "_P_filt <- filt_results[[\"", study, "\"]]$adjP_table\n",
      "     ", study, "_P_filt[", study, "_P_filt >= 0.05] <- 1\n",
      "     ", study, "_P_filt[", study, "_P_filt < 0.05] <- 0\n",
  
      "     # Remove features that are all NA in at least 8 columns (which corresponds to ASV only in the rarified data)\n",
      "     ", "features2remove <- which(rowSums(is.na(", study, "_P_filt)) >= 8)\n",
      "     ", "if(length(features2remove) > 0) {\n",
      "         ", study, "_P_filt <- ", study, "_P_filt[-features2remove, ]\n",
      "      }\n",
      
      "     all_P_tables_filt[[\"", study, "\"]] <- ", study,"_P_filt\n\n",
      
      "     table2plot <- ", study, "_P_filt\n",
      
      "     if(nrow(table2plot) > 10000) {\n",
      "         table2plot <- table2plot[sample(rownames(table2plot), 10000), ]\n",
      "     }\n\n",
    
      "     heatmaps_filt[[\"", study, "\"]] <- pheatmap(t(table2plot),\n",
      "                                                  color=c(\"cornflowerblue\", \"black\"),\n",
      "                                                  clustering_distance_cols = \"binary\",\n",
      "                                                  clustering_distance_rows = \"binary\",\n",
      "                                                  clustering_method = \"complete\",\n",
      "                                                  show_colnames = FALSE,\n",
      "                                                  legend=FALSE)\n\n\n",
      "     heatmaps_filt[[\"", study, "\"]]\n",
      "```\n",
      sep = "",
      file = outfile, append = TRUE)
}

cat("\n\n## Unfiltered data {.tabset}\n", sep="", append = TRUE, file = outfile)

for(study in hackathon_study_ids) {
  cat("\n\n### ", study, "\n",
      "```{r ", study, "_heatmap_unfilt, cache=TRUE}\n",
      "     ", study, "_P_unfilt <- unfilt_results[[\"", study, "\"]]$adjP_table\n",
      "     ", study, "_P_unfilt[", study, "_P_unfilt >= 0.05] <- 1\n",
      "     ", study, "_P_unfilt[", study, "_P_unfilt < 0.05] <- 0\n",
      
      "     # Remove features that are all NA in at least 8 columns (which corresponds to ASV only in the rarified data)\n",
      "     ", "features2remove <- which(rowSums(is.na(", study, "_P_unfilt)) >= 8)\n",
      "     ", "if(length(features2remove) > 0) {\n",
      "         ", study, "_P_unfilt <- ", study, "_P_unfilt[-features2remove, ]\n",
      "      }\n",
      
      "     all_P_tables_unfilt[[\"", study, "\"]] <- ", study,"_P_unfilt\n\n",
      
      "     table2plot <- ", study, "_P_unfilt\n",
      
      "     if(nrow(table2plot) > 10000) {\n",
      "         table2plot <- table2plot[sample(rownames(table2plot), 10000), ]\n",
      "     }\n\n",
      
      "     heatmaps_unfilt[[\"", study, "\"]] <- pheatmap(t(table2plot),\n",
      "                                                  color=c(\"cornflowerblue\", \"black\"),\n",
      "                                                  clustering_distance_cols = \"binary\",\n",
      "                                                  clustering_distance_rows = \"binary\",\n",
      "                                                  clustering_method = \"complete\",\n",
      "                                                  show_colnames = FALSE,\n",
      "                                                  legend=FALSE)\n\n\n",
      "     heatmaps_unfilt[[\"", study, "\"]]\n",
      "```\n",
      sep = "",
      file = outfile, append = TRUE)
}

