source("../model_funs.R")
source("../plot_params.R")

generate_data <- FALSE

if(generate_data){
  R0 <- 1.4 ## fix R0
  p0 <- seq(0, 1, length.out = 4)
  inputs <- expand_grid(R0, r, s, p0)
  
  data <- (inputs
   %>% rowwise()
   ## first, iterate map to get period
   %>% mutate(period = get_period(R0, r, s, p0)))
  
  saveRDS(data, "data/checkpoint.RDS")
  
  data <- (data 
   ## only take parameters that converge to a period 1 solution
   %>% filter(period == 1, r != 0, s != 1)
   ## calculate time in HI interval
   %>% rowwise()
   %>% mutate(time_in_HI = time_in_HI(
     R0 = R0,
     r = r,
     s = s,
     p0 = p0
     ))
  )
  
  saveRDS(data, "data/plot_data.RDS")
} else {
  data <- readRDS("data/plot_data.RDS")
}

data <- (data 
  %>% mutate(p0 = case_when(
    p0 == 0 ~ "0",
    p0 == 1 ~ "1",
    T ~ paste0(3*p0 %% 3, '/3'))
    )
  %>% mutate(p0 = as_factor(paste0("p[0] == ", p0)))
)

cut_vec <- c(0, 1, 5, 10, 50, 100, Inf)
labels <- character(length(cut_vec)-1)
for(i in 1:(length(cut_vec)-1)){
  if(i == 1){
    labels[i] <- as.character(cut_vec[i])
  } else if (i == length(cut_vec)-1){
    labels[i] <- paste0(cut_vec[i], "+")
  } else {
    labels[i] <- paste0(cut_vec[i], "-", cut_vec[i+1]-1)
  }
}

(ggplot(data
        %>% drop_na()
        , aes(x = r, y = s,
              # fill = time_in_HI,
              # colour = time_in_HI
        fill = cut(time_in_HI, cut_vec, right = FALSE),
        colour = cut(time_in_HI, cut_vec, right = FALSE)
        ))
  + geom_tile()
  + facet_wrap(facets = vars(p0),
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
    values = palette4,
    labels = labels
  )
  + scale_colour_manual(
    values = palette4
  )
  + labs(x = "Vaccine morbidity, r",
         y = "Vaccine efficacy, s",
         fill = "Number of years spent\nin herd immunity interval"
         )
  + guides(
    colour = FALSE
    )
  + theme(legend.position = "bottom",
          legend.direction = "horizontal")
)

ggsave("suppfig3.pdf", width = fig_width, height = fig_width)



