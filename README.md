# README

This repository contains all of the code required to reproduce the figures in Papst, O'Keeffe, Strogatz (2022).

To generate a figure, navigate to the directory corresponding to the figure number (*e.g.* `fig2/` for Figure 2 or `suppfig1/` for Supplementary Figure 1), then execute the `R` script of the same name. For instance, in an R session, simply execute `source("fig3.R")` in the `fig3/` subdirectory to generate `fig3.pdf` (in that same subdirectory).

Supporting files include `model_funs.R`, where model functions are defined, and `plot_params.R`, where plot settings are stipulated.

The supplementary figures require time-consuming simulations to generate. The data for these figures has been precomputed and saved to `data/plot_data.RDS` within each supplementary figure's subdirectory. The scripts generating the supplementary figures have a logical variable named `generate_data` defined at the beginning, which is set to `FALSE` to skip the simulation and simply import the pre-computed data to make the figure. If you so desire, you can set `generate_data <- TRUE` to perform the simulation yourself.

## Paper citations

TBD

## Session information

The code in this repository was most recently run using the following specifications:

```
R version 4.0.3 (2020-10-10)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS Big Sur 10.16

Matrix products: default
LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib

locale:
[1] en_CA.UTF-8/en_CA.UTF-8/en_CA.UTF-8/C/en_CA.UTF-8/en_CA.UTF-8

attached base packages:
[1] stats     graphics  grDevices
[4] utils     datasets  methods  
[7] base     

other attached packages:
 [1] colorspace_2.0-0
 [2] patchwork_1.1.1
 [3] latex2exp_0.4.0
 [4] bazar_1.0.11    
 [5] lamW_2.1.0      
 [6] forcats_0.5.1   
 [7] stringr_1.4.0   
 [8] dplyr_1.0.5     
 [9] purrr_0.3.4     
[10] readr_1.4.0     
[11] tidyr_1.1.3     
[12] tibble_3.1.1    
[13] ggplot2_3.3.3   
[14] tidyverse_1.3.0

loaded via a namespace (and not attached):
 [1] kimisc_0.4        
 [2] tidyselect_1.1.0  
 [3] haven_2.3.1       
 [4] vctrs_0.3.8       
 [5] generics_0.1.0    
 [6] utf8_1.2.1        
 [7] rlang_0.4.11      
 [8] pillar_1.6.0      
 [9] glue_1.4.2        
[10] withr_2.4.1       
[11] DBI_1.1.1         
[12] dbplyr_2.1.0      
[13] modelr_0.1.8      
[14] readxl_1.3.1      
[15] lifecycle_1.0.0   
[16] munsell_0.5.0     
[17] gtable_0.3.0      
[18] cellranger_1.1.0  
[19] rvest_0.3.6       
[20] memoise_2.0.0.9000
[21] labeling_0.4.2    
[22] fastmap_1.1.0     
[23] fansi_0.4.2       
[24] broom_0.7.4       
[25] Rcpp_1.0.6        
[26] scales_1.1.1      
[27] backports_1.2.1   
[28] cachem_1.0.4      
[29] RcppParallel_5.1.4
[30] jsonlite_1.7.2    
[31] farver_2.1.0      
[32] fs_1.5.0          
[33] digest_0.6.27     
[34] hms_1.0.0         
[35] stringi_1.5.3     
[36] grid_4.0.3        
[37] cli_2.5.0         
[38] tools_4.0.3       
[39] magrittr_2.0.1    
[40] crayon_1.4.1      
[41] pkgconfig_2.0.3   
[42] ellipsis_0.3.2    
[43] xml2_1.3.2        
[44] reprex_1.0.0      
[45] lubridate_1.7.10  
[46] assertthat_0.2.1  
[47] httr_1.4.2        
[48] rstudioapi_0.13   
[49] R6_2.5.0          
[50] compiler_4.0.3  
```
