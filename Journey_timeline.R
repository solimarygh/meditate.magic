suppressPackageStartupMessages({
  library(plotly)
  library(dplyr)
  library(tibble)
})

# Datos (horas desde la ingestión)
time_h    <- c(0.0, 0.5, 1, 2, 3, 4, 6, 8, 9, 10, 11, 12)
intensity <- c(0,   2.0, 5, 9, 9, 7, 6, 2, 0.5, 0,  0,  0)

df <- tibble(
  time_h = time_h,
  intensity = intensity
)

# Colores
line_color         <- "rgb(90,120,230)"
fill_color         <- "rgba(90,120,230,0.15)"

first_band_color <- "rgba(120,120,120,0.18)"  # gris medio, suave
# más clarito
#first_band_color <- "rgba(160,160,160,0.18)"

# más oscuro
#first_band_color <- "rgba(90,90,90,0.18)"
peak_band_color    <- "rgba(255,191,0,0.12)"    # banda pico (ámbar)
integration_color  <- "rgba(90,200,120,0.12)"   # banda integración (verde)


font_family <- "'Nunito', 'Avenir', 'Helvetica', 'Arial', sans-serif"

# Trazado principal
p <- plot_ly(
  df,
  x = ~time_h, y = ~intensity,
  type = "scatter", mode = "lines+markers",
  line = list(color = line_color, width = 5, shape = "spline", smoothing = 1.2),
  marker = list(size = 10, symbol = "circle", line = list(width = 0)),
  fill = "tozeroy", fillcolor = fill_color,
  hovertemplate = "%{x:.1f} h<br><b>%{y:.1f}</b><extra></extra>"
)

# BANDAS: primeros efectos (0.5–1 h), pico (1.5–4 h), integración (8–12 h)
shapes_list <- list(
  list(type = "rect", xref = "x", x0 = 0.5, x1 = 1.0,
       yref = "paper", y0 = 0, y1 = 1,
       fillcolor = first_band_color, line = list(width = 0)),
  list(type = "rect", xref = "x", x0 = 1.5, x1 = 4.0,
       yref = "paper", y0 = 0, y1 = 1,
       fillcolor = peak_band_color, line = list(width = 0)),
  list(type = "rect", xref = "x", x0 = 8.0, x1 = 12.0,
       yref = "paper", y0 = 0, y1 = 1,
       fillcolor = integration_color, line = list(width = 0))
  
)

# Flecha de INTEGRACIÓN hacia la derecha (continúa 12+ h)
p <- add_trace(
  p,
  x = c(8.0, 12.2), y = c(1.0, 1.0),
  type = "scatter", mode = "lines+markers",
  line = list(width = 4, dash = "dot", color = "rgba(90,200,120,0.8)"),
  marker = list(symbol = "triangle-right", size = 16,
                color = "rgba(90,200,120,0.95)", line = list(width = 0)),
  hoverinfo = "skip", showlegend = FALSE, inherit = FALSE
)

# ANOTACIONES:
# - Ingestion: flecha que apunta EXACTO a (0, 0). El texto se coloca con offset (ax, ay).
ann <- list(
  list(
    x = 0, y = 0,                 # la punta de la flecha apunta EXACTO a (0,0)
    xref = "x", yref = "y",       # <- asegura coordenadas en el sistema de datos
    text = "🍄 Ingestion",
    showarrow = TRUE,
    # Coloca el texto un poco arriba y a la derecha del (0,0):
    ax = 30, ay = -30,             # desplazamiento en píxeles desde (x,y) hacia el texto
    axref = "pixel", ayref = "pixel",
    xshift = 6, yshift = 6,       # pequeño ajuste adicional para evitar bordes
    arrowhead = 3, arrowsize = 1, arrowwidth = 1.7,
    arrowcolor = "rgba(0,0,0,0.55)",
    xanchor = "left", yanchor = "bottom",
    font = list(size = 14, color = "rgba(0,0,0,0.85)")
  ),
  
  

  list( x = 0.75, y = 8.0, text = "🌊<br> First <br>effects ", showarrow = FALSE, xanchor = "center", yanchor = "bottom", font = list(size = 14, color = "rgba(0,0,0,0.7)") ),
 
  
  list(
    x = 2.7, y = 9.2, text = "⭐ Peak (1.5–4 h)", showarrow = FALSE,
    xanchor = "center", yanchor = "bottom",
    font = list(size = 14, color = "rgba(0,0,0,0.7)")
  ),
  
  
  list(
    x = 6, y = 7, text = "🌬️💨<br> Come down", showarrow = FALSE,
    xanchor = "center", yanchor = "bottom",
    font = list(size = 14, color = "rgba(0,0,0,0.7)")
  ),
  list(
    x = 9.8, y = 2, text = "💚🌱 Integration (8–12+ h)", showarrow = FALSE,
    xanchor = "center", yanchor = "bottom",
    font = list(size = 14, color = "rgba(0,0,0,0.7)")
  )
)

# LAYOUT
p <- layout(
  p,
  title = list(text = "<b>Typical Psilocybin Mushroom Journey Timeline</b>",
               x = 0.5, font = list(family = font_family, size = 18)),
  xaxis = list(
    title = "Hours since ingestion",
    range = c(-0.2, 12.5),  # un pelín a la izquierda y derecha para respirar y ver la punta
    tickvals = c(0, 0.5, 1, 2, 3, 4, 6, 8, 10, 12),
    ticktext = c("0", "0.5", "1", "2", "3", "4", "6", "8", "10", "12"),
    tickfont = list(size = 12, family = font_family),
    showgrid = FALSE, zeroline = FALSE
  ),
  yaxis = list(
    title = "Intensity (0–10)", range = c(0, 10), dtick = 2,
    showgrid = TRUE, gridcolor = "rgba(0,0,0,0.06)", zeroline = FALSE,
    tickfont = list(size = 12, family = font_family),
    titlefont = list(size = 14, family = font_family)
  ),
  shapes = I(shapes_list),
  annotations = I(ann),
  paper_bgcolor = "white", plot_bgcolor = "white",
  margin = list(l = 60, r = 30, b = 60, t = 70),
  font = list(family = font_family)
) %>%
  config(displayModeBar = TRUE, toImageButtonOptions = list(format = "png"))



p <- p %>% config(toImageButtonOptions = list(format = "png",
                                              width = 2400, height = 1350,
                                              scale = 2))
p




