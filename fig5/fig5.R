source("../model_funs.R")
source("../plot_params.R")

data <- (readRDS("../suppfig2/data/plot_data.RDS")
         %>% filter(R0 == 1.4)
)

regions <- tibble(
  p0 = c(0.35, 0.85, 0.05, 0.21),
  s = c(0.22, 0.73, 0.8, 0.55),
  label = c("I. No lasting\nherd immunity",
            "II. Lasting\nherd immunity\nfrom start",
            "III. Converge to\ninefficient, lasting\nherd immunity",
            "IV. Converge to\noptimal, lasting\n herd immunity"),
  colour = c("a", "b", "c", "d"),
  hjust = c(0,1, 0, 0)
)

(ggplot(data = data, 
        mapping = 
          aes(x = p0, y = s))
  + geom_tile(mapping = aes(
    fill = cut(SOHI_check, c(-Inf,0,1/3,2/3,1)),
    colour = cut(SOHI_check, c(-Inf,0,1/3,2/3,1))
    ))
  + geom_text(data = regions,
              mapping = aes(label = label),
              colour = palette2_labels,
              hjust = regions$hjust,
              size = size_label)
  + scale_x_continuous(
    labels = c(0, 0.25, 0.5, 0.75, 1),
    expand = expansion(mult = 0)
  )
  + scale_y_continuous(
    labels = c(0, 0.25, 0.5, 0.75, 1),
    expand = expansion(mult = 0)
  )
  + scale_fill_manual(
    values = palette2
    )
  + scale_colour_manual(
    values = palette2
  )
  + labs(x = TeX("Initial vaccination proportion, $p_0$"),
         y = "Vaccine efficacy, s")
  + guides(fill = FALSE,
           colour = FALSE)
)

ggsave("fig5.pdf", width = fig_width, height = fig_width)
