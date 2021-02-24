
# 1. Paquetes -------------------------------------------------------------

library(tidyverse)
library(janitor)

# 2. Load Data ------------------------------------------------------------
project <- file.path("D:/Documents/GitHub/policia-nacional-nic-stats")

raw <- read_csv(file.path(project, "data", "raw", "raw_departamentos.csv"))
policias <- read_csv(file.path(project, "data", "raw", "policias.csv"))
  
# 3. Cleaning -------------------------------------------------------------

#-- Stats de los departamentos
data <- raw %>% 
  pivot_longer(
    3:15, 
    names_to = "year",
    values_to = "cantidad"
  ) %>% 
  clean_names() %>% 
  rename(departamento = departamentos) %>% 
  group_by(departamento) %>%
  mutate(
    year = as.numeric(year)
  ) %>% 
  arrange(departamento, year) %>% 
  select(departamento, year, variable, cantidad) 
  
data %>%
  as_tibble() %>% 
  write_csv(file.path(project, "data", "stats_departamento.csv"))

#-- Stats de policias por cada 100 mil habitantes

policias %>% 
  pivot_longer(
    2:14, 
    names_to = "year",
    values_to = "policias"
  ) %>% 
  clean_names() %>% 
  rename(departamento = departamentos) %>% 
  group_by(departamento) %>%
  mutate(
    year = as.numeric(year)
  ) %>% 
  arrange(departamento, year) %>% 
  select(departamento, year, policias) %>% 
  as_tibble() %>% 
  write_csv(file.path(project, "data", "policias.csv"))
