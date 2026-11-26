
# Correr desde la raíz del repositorio después de script/00_extract_anuario.R

# 1. Paquetes -------------------------------------------------------------

library(tidyverse)
library(janitor)

# 2. Load Data ------------------------------------------------------------

raw_nacional <- read_csv(file.path("data", "raw", "raw_nacional.csv"))
raw <- read_csv(file.path("data", "raw", "raw_departamentos.csv"))
policias <- read_csv(file.path("data", "raw", "policias.csv"))
policias_km2 <- read_csv(file.path("data", "raw", "policias_km2.csv"))
riesgo <- read_csv(file.path("data", "raw", "riesgo.csv"))
transito <- read_csv(file.path("data", "raw", "transito.csv"))
drogas <- read_csv(file.path("data", "raw", "drogas.csv"))
managua <- read_csv(file.path("data", "raw", "managua_distritos.csv"))

longer_years <- function(df, values_to) {
  df %>%
    pivot_longer(
      matches("^\\d{4}$"),
      names_to = "year",
      values_to = values_to,
      names_transform = as.numeric
    )
}

# 3. Cleaning -------------------------------------------------------------

#-- Stats a nivel nacional

raw_nacional %>%
  pivot_longer(
    matches("^\\d{4}$"),
    names_to = "year",
    values_to = "cantidad"
  ) %>%
  pivot_wider(names_from = medida, values_from = cantidad) %>%
  mutate(year = as.numeric(year)) %>%
  select(year, tipologia, delito, denuncias, resueltos) %>%
  write_csv(file.path("data", "stats.csv"))

#-- Stats de los departamentos
data <- raw %>%
  pivot_longer(
    matches("^\\d{4}$"),
    names_to = "year",
    values_to = "cantidad"
  ) %>%
  clean_names() %>%
  rename(departamento = departamentos) %>%
  group_by(departamento) %>%
  mutate(
    year = as.numeric(year)
  ) %>%
  arrange(departamento, year, .locale = "es") %>%
  select(departamento, year, variable, cantidad)

data %>%
  as_tibble() %>%
  write_csv(file.path("data", "stats_departamento.csv"))

#-- Policias por cada 100 mil habitantes y por cada 100 km²

policias %>%
  pivot_longer(
    matches("^\\d{4}$"),
    names_to = "year",
    values_to = "policias"
  ) %>%
  clean_names() %>%
  rename(departamento = departamentos) %>%
  group_by(departamento) %>%
  mutate(
    year = as.numeric(year)
  ) %>%
  arrange(departamento, year, .locale = "es") %>%
  select(departamento, year, policias) %>%
  as_tibble() %>%
  left_join(
    policias_km2 %>%
      longer_years("policias_100km2") %>%
      rename(departamento = Departamentos),
    by = c("departamento", "year")
  ) %>%
  write_csv(file.path("data", "policias.csv"))

#-- Riesgo de ser víctima: un delito por cada X personas

riesgo %>%
  longer_years("personas_por_delito") %>%
  rename(departamento = Departamentos) %>%
  arrange(departamento, year, .locale = "es") %>%
  write_csv(file.path("data", "riesgo_departamento.csv"))

#-- Accidentes de tránsito

transito %>%
  longer_years("cantidad") %>%
  rename(indicador = Indicador) %>%
  select(year, indicador, cantidad) %>%
  write_csv(file.path("data", "transito.csv"))

#-- Incautaciones de drogas

drogas %>%
  longer_years("cantidad") %>%
  select(year, droga, unidad, cantidad) %>%
  write_csv(file.path("data", "drogas.csv"))

#-- Denuncias y casos resueltos por distrito de Managua
# Los distritos 9 y 10 aparecen en el anuario desde 2011; sus años anteriores
# vienen vacíos y no se incluyen.

managua %>%
  longer_years("cantidad") %>%
  filter(!is.na(cantidad)) %>%
  pivot_wider(names_from = medida, values_from = cantidad) %>%
  arrange(parse_number(distrito), year) %>%
  select(distrito, year, denuncias, resueltos) %>%
  write_csv(file.path("data", "managua_distritos.csv"))
