source("../model_funs.R")
source("../plot_params.R")

R0 <- 1.4
rmin <- 0.005
rmax <- 0.3
npoints <- 26
r <- 10^{seq(log(rmin, base = 10), log(rmax, base = 10),
         length.out = npoints)}
s <- c(0.6, 0.7)
p0 <- 0

inputs <- expand_grid(
  R0 = R0,
  r = r,
  s = s,
  p0 = p0
)

data <- (inputs
  %>% rowwise()
  %>% mutate(time_in_HI = time_in_HI(R0, r, s, p0, N = 100))
  %>% mutate(s = as_factor(s))
)

(ggplot(data,
        aes(x = r,
            y = time_in_HI,
            group = s,
            colour = s))
  + geom_line()
  + geom_point(aes(shape = s))
  + scale_x
  + scale_colour_manual(
    "Vaccine efficacy, s",
    values = palette4[c(2,4)]
  )
  + scale_shape_manual(
    "Vaccine efficacy, s",
    values = shape_palette
  )
  + labs(x = "Vaccine morbidity, r",
         y = "Years")
  + theme(legend.position = c(0.83,0.8))
)

ggsave("fig4.pdf", width = fig_width, height = fig_height)

