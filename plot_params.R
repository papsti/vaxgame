library(latex2exp)
library(patchwork)
library(colorspace)

R0 <- 1 + 2^{1:8}/10
step <- 0.01
r <- seq(0, 1, by = step)
s <- seq(0, 1, by = step)
p0 <- seq(0, 1, by = step)

palette1 <- c("#cbe4f6", "#ffe5ce", "#FFFFFF")
palette1_labels <- c("#12476b", "#a14b00")
colour_pcrit <- "#B31B1B"
palette2 <- c("#cbe4f6", "#cef1ce", "#b7ebb7", "#9fe49f", "#FFFFFF")
palette2_labels <- c("#12476b", rep("#1a601a", 3))
palette3 <- c("#32bb32", "#1a601a", "#268E26")
palette4 <- c("#000000",
              palette1_labels[1],
              lighten(palette1_labels[1], 
                      amount = c(0.2, 0.4,
                                 0.6, 0.8)))

shape_palette <- c(19, 17)

size_label <- 4

scale_x <- scale_x_continuous(expand = expansion(mult = 0.01))
scale_y <- scale_y_continuous(expand = expansion(mult = 0.01))

theme_set(theme_bw())
theme_update(
  panel.grid = element_blank()
)

fig_width <- 5.5
fig_height <- 3.5

panel_label <- function(p, letter, size = 5,
                        pos = c("topright", "topleft"),
                        x = NULL,
                        y = NULL,
                        pct = 0.05,
                        vjust = 0.5){
  
  pos <- match.arg(pos)
  
  xind <- switch(pos,
                 "topright" = 2,
                 "topleft" = 1)
  
  hjust <- switch(pos,
                  "topright" = 1,
                  "topleft" = 0)
  
  if(pos == "topright") pct <- -pct
  
  ## default: top-right placement based on plot limits
  if(is.null(x)) x <- (1 + pct)*layer_scales(p)$x$get_limits()[xind]
  if(is.null(y)) y <- (1 - pct)*layer_scales(p)$y$get_limits()[xind]
  
  p <- p + annotate("text",
                    x = x, y = y,
                    label = letter,
                    hjust = hjust,
                    vjust = vjust,
                    size = size)
  return(p)
}
