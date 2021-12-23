source("../model_funs.R")
source("../plot_params.R")

R0 <- 1.4
r <- 0.8
s <- 0.7
p0 <- 0
N <- 20

data <- tibble(
  n = 0:N,
  p_n = iterate_f(R0, r, s, p0, N+1)
)

colour_main <- "#EF8636"
the_pcrit <- pcrit(R0, s)
nudge_pcrit <- 0.02

p1 <- ((ggplot(data,
       aes(x = n, y = p_n))
  + geom_hline(aes(yintercept = the_pcrit),
               linetype = "dashed",
               colour = colour_pcrit)
  + annotate("text", x = 2.2, y = (1+nudge_pcrit)*the_pcrit,
             vjust = 0,
             label = TeX("$p_{crit}$"),
             colour = colour_pcrit)
  + geom_line(colour = colour_main)
  + geom_point(colour = colour_main)
  + scale_x
  + coord_cartesian(ylim = c(0, 0.6))
  + labs(x = "Year, n",
         y = TeX("Proportion of the population vaccinated, $p_n$"))
  )
  %>% panel_label("A",
                  x = 18.9,
                  y = 0.57)
)

data2 <- (tibble(
  p_n = seq(0, 1, step)
  )
  %>% rowwise()
  %>% mutate(`p_(n+1)` = iterate_f(R0, r, s, p_n, N = 2)[2])
)

p2 <- ((ggplot(data2,
              aes(x = p_n, y = `p_(n+1)`))
        + geom_vline(aes(xintercept = the_pcrit),
                     linetype = "dashed",
                     colour = colour_pcrit)
        + geom_hline(aes(yintercept = the_pcrit),
                     linetype = "dashed",
                     colour = colour_pcrit)
        + annotate("text", x = 0.85, y = (1 + 1.5*nudge_pcrit)*the_pcrit,
                   vjust = 0,
                   label = TeX("$p_{crit}$"),
                   colour = colour_pcrit)
  + geom_line(colour = colour_main) 
  + scale_x_continuous(expand = expansion(mult = 0))
  + scale_y_continuous(expand = expansion(mult = 0))
  + coord_cartesian(ylim = c(0, 1))
  + labs(x = TeX("$p_n$"),
         y = TeX("$p_{n+1}$"))
  )
  %>% panel_label("B", 
                  x = 0.94,
                  y = 0.91)
)

p1 + p2

ggsave("fig3.pdf", width = 1.5*fig_width, height = fig_height)
