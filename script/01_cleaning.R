
# 1. Paquetes -------------------------------------------------------------

library(tidyverse)
library(janitor)

# 2. Load Data ------------------------------------------------------------
raw <- read_csv("data/raw/raw_departamentos.csv")

# 3. Cleaning -------------------------------------------------------------

data <- raw %>% 
  pivot_longer(
    3:15, 
    names_to = "year",
    values_to = "cantidad"
  ) %>% 
  clean_names() %>% 
  rename(departamento = departamentos) %>% 
  filter(!departamento %in% c("Triángulo Minero", "Zelaya Central")) %>% 
  group_by(departamento) %>%
  mutate(
    year = as.numeric(year)
  ) %>% 
  arrange(departamento, year) %>% 
  select(departamento, year, variable, cantidad) 
  
data %>%
  as_tibble() %>% 
  write_csv("data/stats_departamento.csv")

