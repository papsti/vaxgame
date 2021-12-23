source("../model_funs.R")
source("../plot_params.R")

data <- (readRDS("../suppfig1/data/plot_data.RDS")
  %>% filter(R0 == 1.4)
)

regions <- tibble(
  r = c(0.28, 0.92),
  s = c(0.4, 0.87),
  label = c("I. No lasting\nherd immunity",
            "II. Herd immunity\nevery other year"),
  colour = c("a", "b"),
  hjust = c(0,1)
)

(ggplot(data = data, 
        mapping = 
          aes(x = r, y = s))
  + geom_tile(mapping = aes(fill = cut(period, c(-Inf,1,2,3)),
              colour = cut(period, c(-Inf,1,2,3))))
  + geom_text(data = regions,
              mapping = aes(label = label),
              colour = palette1_labels,
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
    values = palette1)
  + scale_colour_manual(
    values = palette1
  )
  + labs(x = "Vaccine morbidity, r",
         y = "Vaccine efficacy, s")
  + guides(fill = FALSE,
           colour = FALSE)
)

ggsave("fig2.pdf", width = fig_width, height = fig_width)
