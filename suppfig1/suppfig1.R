source("../model_funs.R")
source("../plot_params.R")

generate_data <- FALSE

if(generate_data){
  inputs <- expand_grid(R0, r, s)
  
  data <- (inputs 
           %>% rowwise()
           %>% mutate(period = get_period(R0, r, s))
  )
  
  saveRDS(data, "data/plot_data.RDS")
} else {
  data <- readRDS("data/plot_data.RDS")
}

data <- (data
  %>% filter(period < 3,
             R0 < 10)
  %>% mutate(R0 = as_factor(paste0("R[0] == ", R0)))
)

cut_vec <- c(-Inf,1,2,3)

(ggplot(data,
        aes(x = r, y = s, 
            fill = cut(period, cut_vec),
            colour = cut(period, cut_vec)))
  + geom_tile()
  + facet_wrap(facets = vars(R0),
               labeller = label_parsed,
               ncol = 2)
  + scale_x_continuous(
    labels = c(0, 0.25, 0.5, 0.75, 1),
    expand = expansion(mult = 0)
  )
  + scale_y_continuous(
    labels = c(0, 0.25, 0.5, 0.75, 1),
    expand = expansion(mult = 0)
  )
  + scale_fill_manual(
    values = palette1,
    labels = c("I. No lasting HI",
               "II. HI every other year",
               "Slow convergence"))
  + scale_colour_manual(
    values = palette1
  )
  + labs(x = "Vaccine morbidity, r",
         y = "Vaccine efficacy, s",
         fill = "Region")
  + guides(fill = guide_legend(ncol = 2),
           colour = FALSE)
  + theme_bw()
  + theme(legend.position = "bottom")
)

ggsave("suppfig1.pdf", width = fig_width, height = 1.5*fig_width)
