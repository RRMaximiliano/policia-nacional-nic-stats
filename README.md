
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Estadísticas de la Policia Nacional de Nicaragua

## A nivel nacional

Este repositorio contiene datos extraídos de los reportes de los
Anuarios Estadísticos de la Policía Nacional de Nicaragua. Los anuarios
desde 1998 al 2018 se pueden encontrar
[aquí](https://drive.google.com/file/d/1cndR83OTomj41gkOsre_57P9Hy8V3X6v/view?usp=sharing).
El [Anuario Estadístico
2021](https://www.policia.gob.ni/wp-content/uploads/2022/07/Anuario-Estad%C3%ADstico-Policial-2021.pdf)
es el más reciente publicado por la Policía Nacional y contiene las
series completas que usa este repositorio.

## Información en la base de datos

Actualmente, este repositorio contiene siete bases de datos.

1.  Nivel nacional con información desde el año 1980 al 2021.
2.  Nivel departamental con información desde el año 2007 al 2021.
3.  Policias por cada 100 mil habitantes y por cada 100 km² desde el año
    2007 al 2021.
4.  Riesgo de ser víctima de delito por departamento desde el año 2007
    al 2021.
5.  Accidentes de tránsito a nivel nacional desde el año 2007 al 2021.
6.  Incautaciones de drogas a nivel nacional desde el año 1990 al 2021.
7.  Denuncias y casos resueltos por distrito de Managua desde el año
    2007 al 2021.

### A nivel Nacional

Las siguientes variables se encuentran en este base de datos:

- `year`: Año.
- `tipología`: Tipología del crimer cometido.
  - e.g., Delitos y faltas contra la vida, Delitos y faltas contra el
    patrimonio y el orden socioeconómico.
- `delito`: Tipo del crimer comedito.
  - e.g., Asesinatos, Homicidios, etc.
- `denuncias`: Denuncias.
- `resueltos`: Casos resueltos.

``` r
data
#> # A tibble: 588 × 5
#>     year tipologia                       delito     denuncias resueltos
#>    <int> <chr>                           <chr>          <int>     <int>
#>  1  2021 Delitos y faltas contra la vida Asesinatos       121        86
#>  2  2020 Delitos y faltas contra la vida Asesinatos       151       115
#>  3  2019 Delitos y faltas contra la vida Asesinatos       152       116
#>  4  2018 Delitos y faltas contra la vida Asesinatos       303       105
#>  5  2017 Delitos y faltas contra la vida Asesinatos       114        91
#>  6  2016 Delitos y faltas contra la vida Asesinatos       145        98
#>  7  2015 Delitos y faltas contra la vida Asesinatos       162       130
#>  8  2014 Delitos y faltas contra la vida Asesinatos       182       148
#>  9  2013 Delitos y faltas contra la vida Asesinatos       191       151
#> 10  2012 Delitos y faltas contra la vida Asesinatos       232       174
#> # ℹ 578 more rows
```

### A nivel departamental

A nivel departamental, las estadísticas se encuentra desde el año 2007
al 2021, y las siguientes variables:

- `year`: Año.
- `departamento`: Departamento
- `variable`: Tipología del crimer cometido.
- `cantidad`: Número por cada 100 mil habitantes.
  - e.g., Denuncias, Homicidios, etc.

``` r
data_dep
#> # A tibble: 1,800 × 4
#>    departamento  year variable         cantidad
#>    <chr>        <dbl> <chr>               <dbl>
#>  1 Boaco         2007 Denuncias            1062
#>  2 Boaco         2007 Homicidios             12
#>  3 Boaco         2007 Robos                 121
#>  4 Boaco         2007 Hurtos                197
#>  5 Boaco         2007 Delitos sexuales       76
#>  6 Boaco         2007 Lesiones              233
#>  7 Boaco         2008 Denuncias            1272
#>  8 Boaco         2008 Homicidios              4
#>  9 Boaco         2008 Robos                 214
#> 10 Boaco         2008 Hurtos                167
#> # ℹ 1,790 more rows
```

### Número de policias por cada cien mil habitantes

También es a nivel departamental y se encuentra información desde el año
2007 al 2021 con las siguientes variables:

- `year`: Año
- `departamento`: Departamento
- `policias`: Número de policias por cada cien mil habitantes (tabla
  1.35 del anuario).
- `policias_100km2`: Número de policias por cada 100 km² (tabla 1.33).

``` r
data_pol
#> # A tibble: 300 × 4
#>    departamento  year policias policias_100km2
#>    <chr>        <dbl>    <dbl>           <dbl>
#>  1 Boaco         2007       83               3
#>  2 Boaco         2008       95               4
#>  3 Boaco         2009       95               4
#>  4 Boaco         2010       94               4
#>  5 Boaco         2011      112               4
#>  6 Boaco         2012      100               4
#>  7 Boaco         2013       99               4
#>  8 Boaco         2014       98               4
#>  9 Boaco         2015      102               4
#> 10 Boaco         2016      119               5
#> # ℹ 290 more rows
```

### Riesgo de ser víctima de delito

Por departamento, desde el año 2007 al 2021 (tabla 1.26). Según el
anuario, se lee como un delito por cada “X” cantidad de personas, así
que un número más bajo indica más riesgo.

- `departamento`: Departamento
- `year`: Año
- `personas_por_delito`: Número de personas por cada delito.

### Accidentes de tránsito

A nivel nacional, desde el año 2007 al 2021 (tabla 1.37).

- `year`: Año
- `indicador`: Total de accidentes, fallecidos y lesionados, y cada uno
  por cada 100 mil habitantes.
- `cantidad`: Valor del indicador.

### Incautaciones de drogas

A nivel nacional, desde el año 1990 al 2021 (tabla 1.19).

- `year`: Año
- `droga`: Cocaína, Crack, Marihuana, Heroína o Éxtasis.
- `unidad`: Kilogramos, Piedras, Plantas, Kilogramos de semilla o
  Pastillas.
- `cantidad`: Cantidad incautada.

### Distritos de Managua

Denuncias y casos resueltos por distrito policial de Managua, desde el
año 2007 al 2021 (tabla 4.8). Los distritos 9 y 10 aparecen desde el año
2011.

- `distrito`: Distrito policial.
- `year`: Año
- `denuncias`: Denuncias.
- `resueltos`: Casos resueltos.

## Descargar los datos

Los datos se encuentran en la carpeta `/data` en formato
[CSV](https://github.com/RRMaximiliano/policia-nacional-nic-stats/tree/master/data).
Al acceder el link, deberán darle click derecho “guardar como / save
as”.

1.  [Nivel
    nacional](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/stats.csv)
2.  [Nivel
    departamental](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/stats_departamento.csv)
3.  [Policias](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/policias.csv)
4.  [Riesgo de ser
    víctima](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/riesgo_departamento.csv)
5.  [Accidentes de
    tránsito](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/transito.csv)
6.  [Incautaciones de
    drogas](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/drogas.csv)
7.  [Distritos de
    Managua](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/managua_distritos.csv)

## Caveats

Los datos presentados en este repositorio son datos oficiales de la
Policía Nacional de Nicaragua. La función de este repositorio es tener
disponible los datos en un formato `tidy`.

> Notas:
>
> - Para el caso de Robo con violencia, no se presentan casos resueltos
>   de 1980 a 1989.
> - En la tabla de drogas de 2006, el anuario usa punto como separador
>   de miles en las piedras de crack (2.780) y las plantas de marihuana
>   (136.964). Aquí aparecen como 2,780 y 136,964.
> - Para Río San Juan, el anuario indica que las tasas son por cada 100
>   mil habitantes a partir de 2013. Las cifras de 2007 a 2012 no son
>   comparables con los años siguientes.

## Actualizar los datos

Los datos se generan a partir del PDF del anuario más reciente:

1.  `script/00_extract_anuario.R` descarga el anuario a
    `data/raw/anuarios/` y extrae las tablas 1.1, 1.2, 1.19, 1.20 a
    1.26, 1.33, 1.35, 1.37 y 4.8 a `data/raw/`. También verifica que
    cada tipología y el total general sumen sus delitos, y que los
    distritos de Managua sumen el total del departamento.
2.  `script/01_cleaning.R` convierte los archivos de `data/raw/` a los
    archivos finales en `data/`.

Ambos scripts se corren desde la raíz del repositorio. Para un anuario
nuevo, se cambian `anuario_year` y `anuario_url` en el primer script.

## Comentarios y sugerencias

Para realizar comentarios o sugerencias sobre la base de datos puedes
abrir un issue en este repositorio:
<https://github.com/rrmaximiliano/policia-nacional-nic-stats/issues>
