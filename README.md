
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Estadísticas de la Policia Nacional de Nicaragua

## A nivel nacional

Este repositorio contiene datos extraídos de los reportes de los
Anuarios Estadísticos de la Policía Nacional de Nicaragua. Los anuario
desde 1998 al 2019 se pueden encontrar
[aquí](https://drive.google.com/file/d/1cndR83OTomj41gkOsre_57P9Hy8V3X6v/view?usp=sharing).

## Información en la base de datos

Actualmente, este repositorio contiene tres bases de datos.

1.  Nivel nacional con información desde el año 1980 al 2019.
2.  Nivel departamental con información desde el año 2007 al 2019.
3.  Policias por cada 100 mil habitantes desde el año 2007 al 2019.

### A nivel Nacional

Las siguientes variables se encuentran en este base de datos:

-   `year`: Año.
-   `tipología`: Tipología del crimer cometido.
    -   e.g., Delitos y faltas contra la vida, Delitos y faltas contra
        el patrimonio y el orden socioeconómico.
-   `delito`: Tipo del crimer comedito.
    -   e.g., Asesinatos, Homicidios, etc.
-   `denuncias`: Denuncias.
-   `resueltos`: Casos resueltos.

``` r
data
#> # A tibble: 560 x 5
#>     year tipologia                       delito     denuncias resueltos
#>    <int> <chr>                           <chr>          <int>     <int>
#>  1  2019 Delitos y faltas contra la vida Asesinatos       152       116
#>  2  2018 Delitos y faltas contra la vida Asesinatos       303       105
#>  3  2017 Delitos y faltas contra la vida Asesinatos       114        91
#>  4  2016 Delitos y faltas contra la vida Asesinatos       145        98
#>  5  2015 Delitos y faltas contra la vida Asesinatos       162       130
#>  6  2014 Delitos y faltas contra la vida Asesinatos       182       148
#>  7  2013 Delitos y faltas contra la vida Asesinatos       191       151
#>  8  2012 Delitos y faltas contra la vida Asesinatos       232       174
#>  9  2011 Delitos y faltas contra la vida Asesinatos       226       148
#> 10  2010 Delitos y faltas contra la vida Asesinatos       259       154
#> # ... with 550 more rows
```

### A nivel departamental

A nivel departamental, las estadísticas se encuentra desde el año 2007
al 2019, y las siguientes variables:

-   `year`: Año.
-   `departamento`: Departamento
-   `variable`: Tipología del crimer cometido.
-   `cantidad`: Número por cada 100 mil habitantes.
    -   e.g., Denuncias, Homicidios, etc.

``` r
data_dep
#> # A tibble: 1,560 x 4
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
#> # ... with 1,550 more rows
```

### Número de policias por cada cien mil habitantes

También es a nivel departamental y se encuentra información desde el año
2007 al 2019 con las siguientes variables:

-   `year`: Año
-   `departamento`: Departamento
-   `policias`: Número de policias por cada cien mil habitantes.

``` r
data_pol
#> # A tibble: 260 x 3
#>    departamento  year policias
#>    <chr>        <dbl>    <dbl>
#>  1 Boaco         2007       83
#>  2 Boaco         2008       95
#>  3 Boaco         2009       95
#>  4 Boaco         2010       94
#>  5 Boaco         2011      112
#>  6 Boaco         2012      100
#>  7 Boaco         2013       99
#>  8 Boaco         2014       98
#>  9 Boaco         2015      102
#> 10 Boaco         2016      119
#> # ... with 250 more rows
```

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

## Caveats

Los datos presentados en este repositorio son datos oficiales de la
Policía Nacional de Nicaragua. La función de este repositorio es tener
disponible los datos en un formato `tidy`.

> Notas: Para el caso de Robo con violencia, no se presentan datos de
> 1980 a 1989.

## Comentarios y sugerencias

Para realizar comentarios o sugerencias sobre la base de datos puedes
abrir un issue en este repositorio:
<https://github.com/rrmaximiliano/policia-nacional-nic-stats/issues>
