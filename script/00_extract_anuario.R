
# Extrae las tablas del Anuario Estadístico de la Policía Nacional a data/raw/.
# Correr desde la raíz del repositorio: Rscript script/00_extract_anuario.R

# 1. Paquetes -------------------------------------------------------------

library(tidyverse)
library(pdftools)

# 2. Anuario --------------------------------------------------------------

anuario_year <- 2021
anuario_url <- "https://www.policia.gob.ni/wp-content/uploads/2022/07/Anuario-Estad%C3%ADstico-Policial-2021.pdf"
anuario_pdf <- file.path("data", "raw", "anuarios", str_glue("anuario_{anuario_year}.pdf"))

if (!file.exists(anuario_pdf)) {
  dir.create(dirname(anuario_pdf), recursive = TRUE, showWarnings = FALSE)
  options(timeout = 3600)
  download.file(anuario_url, anuario_pdf, mode = "wb")
}

pages <- pdf_text(anuario_pdf) %>% map(~ str_split_1(.x, "\n"))

departamentos <- c(
  "Nacional", "Boaco", "Carazo", "Chinandega", "Chontales", "Estelí", "Granada",
  "Jinotega", "León", "Madriz", "Managua", "Masaya", "Matagalpa", "Nueva Segovia",
  "RACCN", "RACCS", "Rivas", "Río San Juan", "Triángulo Minero", "Zelaya Central"
)

tablas_departamento <- tribble(
  ~tabla, ~variable,
  "1.20", "Denuncias",
  "1.21", "Homicidios",
  "1.22", "Robos",
  "1.23", "Hurtos",
  "1.24", "Delitos sexuales",
  "1.25", "Lesiones"
)

vida <- "Delitos y faltas contra la vida"
patrimonio <- "Delitos y faltas contra el patrimonio y el orden socioeconómico"
estupefacientes <- "Delitos relacionados con estupefacientes psicotrópicos y otras"
otras <- "Otras familias y otras faltas"

# Filas de las tablas 1.1 y 1.2, en el orden en que aparecen en el anuario.
filas_nacional <- tribble(
  ~nivel, ~tipologia, ~delito,
  "total", "Total general", "Total general",
  "tipologia", vida, vida,
  "delito", vida, "Asesinatos",
  "delito", vida, "Homicidios",
  "delito", vida, "Lesiones",
  "delito", vida, "Violaciones",
  "delito", vida, "Otros delitos contra la vida",
  "tipologia", patrimonio, patrimonio,
  "delito", patrimonio, "Robo con fuerza",
  "delito", patrimonio, "Robo con violencia",
  "delito", patrimonio, "Robo con intimidación",
  "delito", patrimonio, "Hurtos",
  "delito", patrimonio, "Estafas",
  "delito", patrimonio, "Abigeatos",
  "delito", patrimonio, "Otros contra el patrimonio",
  "delito", estupefacientes, estupefacientes,
  "delito", otras, otras
)

indicadores_transito <- c(
  "Total Accidentes", "Total Fallecidos", "Total Lesionados",
  "Accidentes por cada 100 mil habitantes", "Fallecidos por cada 100 mil habitantes",
  "Lesionados por cada 100 mil habitantes"
)

# Columnas de la tabla 1.19, en orden.
columnas_drogas <- tribble(
  ~droga, ~unidad,
  "Cocaína", "Kilogramos",
  "Crack", "Piedras",
  "Crack", "Kilogramos",
  "Marihuana", "Plantas",
  "Marihuana", "Kilogramos",
  "Marihuana", "Kilogramos de semilla",
  "Heroína", "Kilogramos",
  "Éxtasis", "Pastillas"
)

# 3. Funciones ------------------------------------------------------------

header_pattern <- "^\\s*(Departamentos|Tipología)((\\s+(19|20)\\d{2})+)\\s*$"
values_pattern <- "(\\s+(\\d[\\d,]*|ND))+\\s*$"
years_pattern <- "^\\s*((19|20)\\d{2}\\s*)+$"

# Separa una línea en etiqueta y valores numéricos finales ("ND" es NA).
# Algunas líneas empiezan con el número de página, que no es parte de la etiqueta.
parse_line <- function(line) {
  tail <- str_extract(line, values_pattern)
  if (is.na(tail)) {
    return(list(label = str_squish(line), values = numeric()))
  }
  tokens <- str_split_1(str_squish(tail), " ")
  list(
    label = str_remove(str_squish(str_remove(line, fixed(tail))), "^\\d+ "),
    values = suppressWarnings(as.numeric(str_remove_all(tokens, ",")))
  )
}

# La página de una tabla es la que tiene su título y un encabezado de años.
find_table <- function(tabla, header = header_pattern) {
  title <- str_glue("^\\s*{str_replace(tabla, fixed('.'), '\\\\.')}\\s")
  hits <- which(map_lgl(pages, ~ any(str_detect(.x, title)) && any(str_detect(.x, header))))
  stopifnot(length(hits) == 1)
  pages[[hits]]
}

# Divide la página en paneles (uno por encabezado de años) con sus filas completas.
parse_panels <- function(lines) {
  panel <- cumsum(str_detect(lines, header_pattern))
  split(lines, panel)[-1] %>%
    map(function(panel_lines) {
      years <- as.integer(str_extract_all(str_extract(panel_lines[1], header_pattern), "(19|20)\\d{2}")[[1]])
      rows <- map(panel_lines[-1], parse_line) %>% keep(~ length(.x$values) == length(years))
      list(years = years, rows = rows)
    })
}

parse_departamento <- function(tabla) {
  panels <- parse_panels(find_table(tabla))
  stopifnot(length(panels) == 1)
  rows <- keep(panels[[1]]$rows, ~ .x$label %in% departamentos)
  stopifnot(setequal(map_chr(rows, "label"), departamentos), length(rows) == length(departamentos))
  map_dfr(rows, ~ tibble(Departamentos = .x$label, year = panels[[1]]$years, value = .x$values))
}

parse_nacional <- function(tabla) {
  map_dfr(parse_panels(find_table(tabla)), function(panel) {
    stopifnot(length(panel$rows) == nrow(filas_nacional))
    labels <- map_chr(panel$rows, "label")
    # Las etiquetas largas ocupan varias líneas; la parte en la fila de valores debe coincidir.
    stopifnot(all(map2_lgl(labels, filas_nacional$delito, ~ .x == "" || str_detect(.y, fixed(.x)))))
    map2_dfr(panel$rows, seq_along(panel$rows), ~ tibble(
      nivel = filas_nacional$nivel[.y],
      tipologia = filas_nacional$tipologia[.y],
      delito = filas_nacional$delito[.y],
      year = panel$years,
      value = .x$values
    ))
  })
}

page_years <- function(lines) {
  as.integer(str_extract_all(str_subset(lines, years_pattern)[1], "(19|20)\\d{2}")[[1]])
}

parse_transito <- function() {
  lines <- find_table("1.37", years_pattern)
  years <- page_years(lines)
  rows <- map(lines, parse_line) %>%
    keep(~ .x$label %in% indicadores_transito && length(.x$values) == length(years))
  stopifnot(setequal(map_chr(rows, "label"), indicadores_transito), length(rows) == length(indicadores_transito))
  map_dfr(rows, ~ tibble(Indicador = .x$label, year = years, value = .x$values))
}

# Distritos 9 y 10 solo tienen datos desde 2011; sus filas son más cortas.
parse_managua <- function() {
  lines <- find_table("4.8", years_pattern)
  years <- page_years(lines)
  rows <- map(lines, parse_line) %>% keep(~ .x$label %in% c("Total general", "Distrito #"))
  stopifnot(length(rows) == 11)
  map_dfr(rows, function(row) {
    total <- row$label == "Total general"
    values <- if (total) row$values else row$values[-1]
    n <- length(values) / 2
    stopifnot(n == round(n), n <= length(years))
    tibble(
      distrito = if (total) "Total general" else str_glue("Distrito {row$values[1]}"),
      year = years[seq_len(n)],
      denuncias = values[c(TRUE, FALSE)],
      resueltos = values[c(FALSE, TRUE)]
    )
  })
}

# Las columnas de conteo son enteras. En 2006 el anuario usa punto como separador
# de miles en dos de ellas (2.780 piedras, 136.964 plantas), así que ahí se quita el punto.
parse_drogas <- function() {
  lines <- find_table("1.19", "^\\s*Años\\s+Kilogramos")
  rows <- str_subset(lines, "^\\s*(19|20)\\d{2}\\s") %>% str_squish() %>% str_split(" ")
  stopifnot(all(lengths(rows) == 1 + nrow(columnas_drogas)))
  drogas <- map_dfr(rows, ~ mutate(columnas_drogas, year = as.integer(.x[1]), raw = .x[-1]))
  conteo <- drogas$unidad %in% c("Piedras", "Plantas", "Pastillas")
  puntos <- drogas %>% filter(conteo, str_detect(raw, fixed(".")))
  if (nrow(puntos) > 0) {
    message("Conteos con punto como separador de miles:")
    print(puntos)
  }
  drogas %>%
    mutate(value = as.numeric(str_remove_all(raw, if_else(conteo, "[,.]", ",")))) %>%
    select(-raw)
}

# 4. Extracción -----------------------------------------------------------

nacional <- bind_rows(
  parse_nacional("1.1") %>% mutate(medida = "denuncias"),
  parse_nacional("1.2") %>% mutate(medida = "resueltos")
)

# Las tipologías y el total publicados deben ser la suma de sus delitos.
check_tipologia <- nacional %>%
  filter(nivel != "total") %>%
  group_by(medida, year, tipologia) %>%
  filter(any(nivel == "tipologia")) %>%
  summarise(publicado = sum(value[nivel == "tipologia"]), suma = sum(value[nivel == "delito"], na.rm = TRUE), .groups = "drop")

check_total <- nacional %>%
  group_by(medida, year) %>%
  summarise(publicado = sum(value[nivel == "total"]), suma = sum(value[nivel == "delito"], na.rm = TRUE), .groups = "drop")

descuadres <- bind_rows(check_tipologia, check_total) %>% filter(publicado != suma)
if (nrow(descuadres) > 0) {
  message("Sumas que no cuadran en el anuario:")
  print(descuadres, n = Inf)
}

departamento <- tablas_departamento %>%
  mutate(data = map(tabla, parse_departamento)) %>%
  unnest(data) %>%
  select(Variable = variable, Departamentos, year, value)

policias <- parse_departamento("1.35")
policias_km2 <- parse_departamento("1.33")
riesgo <- parse_departamento("1.26")
transito <- parse_transito()
drogas <- parse_drogas()
managua <- parse_managua()

stopifnot(setequal(drogas$year, 1990:anuario_year), !anyNA(drogas$value))

# Los distritos de Managua deben sumar el total general publicado.
check_managua <- managua %>%
  pivot_longer(c(denuncias, resueltos), names_to = "medida") %>%
  group_by(medida, year) %>%
  summarise(publicado = sum(value[distrito == "Total general"]), suma = sum(value[distrito != "Total general"]), .groups = "drop")
stopifnot(nrow(check_managua) == 2 * 15)
if (any(check_managua$publicado != check_managua$suma)) {
  message("Distritos de Managua que no suman el total:")
  print(filter(check_managua, publicado != suma), n = Inf)
}

# 5. Exportar -------------------------------------------------------------

nacional %>%
  filter(nivel == "delito") %>%
  select(-nivel) %>%
  arrange(desc(year)) %>%
  pivot_wider(names_from = year, values_from = value) %>%
  select(medida, tipologia, delito, everything()) %>%
  write_csv(file.path("data", "raw", "raw_nacional.csv"), na = "NA")

departamento %>%
  arrange(desc(year)) %>%
  pivot_wider(names_from = year, values_from = value) %>%
  write_csv(file.path("data", "raw", "raw_departamentos.csv"))

policias %>%
  arrange(desc(year)) %>%
  pivot_wider(names_from = year, values_from = value) %>%
  write_csv(file.path("data", "raw", "policias.csv"))

write_wide <- function(df, file) {
  df %>%
    arrange(desc(year)) %>%
    pivot_wider(names_from = year, values_from = value) %>%
    write_csv(file.path("data", "raw", file), na = "NA")
}

write_wide(policias_km2, "policias_km2.csv")
write_wide(riesgo, "riesgo.csv")
write_wide(transito, "transito.csv")
write_wide(drogas, "drogas.csv")

managua %>%
  filter(distrito != "Total general") %>%
  pivot_longer(c(denuncias, resueltos), names_to = "medida") %>%
  write_wide("managua_distritos.csv")
