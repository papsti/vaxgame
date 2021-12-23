source("../model_funs.R")

generate_data <- FALSE

if(generate_data){
  source("../plot_params.R")
  
  inputs <- expand_grid(R0, s, p0)
  
  data <- (inputs 
           %>% rowwise()
           %>% mutate(SOHI_check = SOHI_check(R0, s, p0))
  )
  
  saveRDS(data, "data/plot_data.RDS")
} else {
  data <- readRDS("data/plot_data.RDS")
}

data <- (data
         %>% filter(R0 < 10)
         %>% mutate(R0 = as_factor(paste0("R[0] == ", R0)))
)

palette <- c("#cbe4f6", "#cef1ce", "#b7ebb7", "#9fe49f")
cut_vec <- c(-Inf,0,1/3,2/3,1)

(ggplot(data, aes(x = p0, y = s, 
                  fill = cut(SOHI_check, cut_vec),
                  colour = cut(SOHI_check, cut_vec)))
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
      values = palette,
      labels = c("I. No lasting HI",
                 "II. Lasting HI from start",
                 "III. Converge to inefficient, lasting HI",
                 "IV. Converge to optimal, lasting HI"))
  + scale_colour_manual(
    values = palette
  )
  + labs(x = TeX("Initial vaccination proportion, $p_0$"),
         y = "Vaccine efficacy, s",
         fill = "Region")
  + guides(fill = guide_legend(ncol = 2),
           colour = FALSE)
  + theme_bw()
  + theme(legend.position = "bottom",
          legend.direction = "horizontal")
)

ggsave("suppfig2.pdf", width = fig_width, height = 1.5*fig_width)