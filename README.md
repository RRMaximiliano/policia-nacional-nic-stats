
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Estadísticas de la Policia Nacional de Nicaragua

Este repositorio contiene datos extraídos de los reportes de los
Anuarios Estadísticos de la Policía Nacional de Nicaragua.

## Información en la base de datos

Actualmente, los datos en este repositorio contienen información desde
el año 1980 al año 2019.

## Variables incluídas en la base de datos

Las siguientes variables se encuentran en este base de datos:

  - `year`: Año.
  - `tipología`: Tipología del crimer cometido.
      - e.g., Delitos y faltas contra la vida, Delitos y faltas contra
        el patrimonio y el orden socioeconómico.
  - `delito`: Tipo del crimer comedito.
      - e.g., Asesinatos, Homicidios, etc.
  - `denuncias`: Denuncias.
  - `resueltos`: Casos resueltos.

<!-- end list -->

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

## Descargar los datos

Los datos se encuentran en la carpeta `/data` en formato
[CSV](https://raw.githubusercontent.com/RRMaximiliano/policia-nacional-nic-stats/master/data/data.csv).
Al acceder el link, deberán darle click derecho “guardar como / save
as”.

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
