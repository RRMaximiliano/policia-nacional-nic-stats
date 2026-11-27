
# Convierte los archivos de data/raw/ a los archivos finales en data/.
# Correr desde la raíz del repositorio después de script/00_extract_anuario.R

# 1. Paquetes -------------------------------------------------------------

library(tidyverse)

# 2. Funciones ------------------------------------------------------------

read_raw <- function(file) {
  read_csv(file.path("data", "raw", file), show_col_types = FALSE)
}

longer_years <- function(df, values_to) {
  df %>%
    pivot_longer(
      matches("^\\d{4}$"),
      names_to = "year",
      values_to = values_to,
      names_transform = as.numeric
    )
}

write_data <- function(df, file) {
  write_csv(df, file.path("data", file))
}

# 3. Nivel nacional -------------------------------------------------------

read_raw("raw_nacional.csv") %>%
  longer_years("cantidad") %>%
  pivot_wider(names_from = medida, values_from = cantidad) %>%
  select(year, tipologia, delito, denuncias, resueltos) %>%
  write_data("stats.csv")

# 4. Nivel departamental --------------------------------------------------

read_raw("raw_departamentos.csv") %>%
  longer_years("cantidad") %>%
  rename(departamento = Departamentos, variable = Variable) %>%
  arrange(departamento, year, .locale = "es") %>%
  select(departamento, year, variable, cantidad) %>%
  write_data("stats_departamento.csv")

# 5. Policías por cada 100 mil habitantes y por cada 100 km² --------------

policias_km2 <- read_raw("policias_km2.csv") %>%
  longer_years("policias_100km2") %>%
  rename(departamento = Departamentos)

read_raw("policias.csv") %>%
  longer_years("policias") %>%
  rename(departamento = Departamentos) %>%
  arrange(departamento, year, .locale = "es") %>%
  left_join(policias_km2, by = c("departamento", "year")) %>%
  write_data("policias.csv")

# 6. Riesgo de ser víctima: un delito por cada X personas -----------------

read_raw("riesgo.csv") %>%
  longer_years("personas_por_delito") %>%
  rename(departamento = Departamentos) %>%
  arrange(departamento, year, .locale = "es") %>%
  write_data("riesgo_departamento.csv")

# 7. Accidentes de tránsito -----------------------------------------------

read_raw("transito.csv") %>%
  longer_years("cantidad") %>%
  select(year, indicador = Indicador, cantidad) %>%
  write_data("transito.csv")

# 8. Incautaciones de drogas ----------------------------------------------

read_raw("drogas.csv") %>%
  longer_years("cantidad") %>%
  select(year, droga, unidad, cantidad) %>%
  write_data("drogas.csv")

# 9. Distritos de Managua -------------------------------------------------
# Los distritos 9 y 10 aparecen en el anuario desde 2011; sus años anteriores
# vienen vacíos y no se incluyen.

read_raw("managua_distritos.csv") %>%
  longer_years("cantidad") %>%
  filter(!is.na(cantidad)) %>%
  pivot_wider(names_from = medida, values_from = cantidad) %>%
  arrange(parse_number(distrito), year) %>%
  select(distrito, year, denuncias, resueltos) %>%
  write_data("managua_distritos.csv")
