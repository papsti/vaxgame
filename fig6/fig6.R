source("../model_funs.R")
source("../plot_params.R")

R0 <- 1.4
r <- 0
s <- 0.6
p0 <- c(0, 0.2)
N <- 5

data <- (tibble(
  p0 = p0
)
  %>% rowwise()
  %>% mutate(p_n = list(iterate_f(R0, r, s, p0, N+1)))
  %>% unnest(cols = p_n)
  %>% mutate(n = rep(0:N, 2),
             p0 = as_factor(p0))
)

the_pcrit <- pcrit(R0, s)
nudge_pcrit <- 0.02

p1 <- ((ggplot(data,
       aes(x = n, y = p_n,
           group = p0, colour = p0))
  + geom_hline(aes(yintercept = the_pcrit),
               linetype = "dashed",
               colour = colour_pcrit)
  + annotate("text", x = 0.4, y = (1 + nudge_pcrit)*the_pcrit,
             vjust = 0,
             label = TeX("$p_{crit}$"),
             colour = colour_pcrit)
  + geom_line()
  + geom_point(aes(shape = p0))
  + scale_x
  + scale_y_continuous(expand = expansion(mult = c(0.05, 0.1)))
  + scale_colour_manual(
    expression("Initial vaccination level, p"['0']),
    values = palette3
  )
  + scale_shape_manual(
    expression("Initial vaccination level, p"['0']),
    values = shape_palette
  )
  + labs(x = "Year, n",
         y = TeX("Proportion of the population vaccinated, $p_n$")
  )
  + theme(
    legend.position = c(0.7, 0.17)
  ))
  %>% panel_label("A", y  = 0.58)
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
        + geom_line(colour = palette3[3]) 
        + scale_x_continuous(expand = expansion(mult = 0))
        + scale_y_continuous(expand = expansion(mult = 0))
        + coord_cartesian(ylim = c(0, 1))
        + labs(x = TeX("$p_n$"),
               y = TeX("$p_{n+1}$"))
)
%>% panel_label("B", 
                x = 0.095,
                y = 0.91)
)

p1 + p2

ggsave("fig6.pdf", width = 1.5*fig_width, height = fig_height)
