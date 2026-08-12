# Fundamentos del análisis de datos

## Tipos de datos

### Datos estructurados

Información que es altamente organizada, ejemplo un archivo de Excel.

- Puede mostrarse a través de filas y columnas, bases de datos relacionales.
- Números, fechas y cadenas de texto.

### Datos semi estructurados

Archivos tipo JSON

### Datos desestructurados

No tienen una estructura predefinada y puede venir en distintas formas, por ejemplo archivos de audio o imagenes.

## KPI's y metricas

### Metricas

Cualquier medición que provee información usando datos.

Ejemplo de un sitio web:

- __Visitantes:__ 15000 visitantes mensuales.
- __Ventas:__ 500 unidades vendidas.

Las metricas ayudan a entender que esta suceciendo con los datos.

### KPI _(Key Performance Indicator)_

Metrica especifica que directamente mide el progreso hacia un objetivo.

Ejemplo de un sitio web:

- __Visitantes:__ 15000 visitantes mensuales (KPI objetivo - 20000 visitantes mensuales).
- __Ventas:__ 500 unidades vendidas (KPI de ventas - Incrementar las ventas en un 2% al mes).

Los KPI's muestran si se esta alcanzando un objetivo.

## Tipos de datos

Atributo asociado a los datos que le dice a un sistema computarizado como interpretar su valor.

### Tipos de datos principales

- Cadenas de texto
- Números
- Fechas

## Tipos de archivos

Formato en el cual los datos son almacenados en un archivo.

- Archivos de texto, por ejemplo .txt o .csv.
- Archivos estructurados, por ejemplo .xlsx o .db.
- Archivos semi-estructurados, por ejemplo .json o .xml.
- Archivos desestructurados, por ejemplo .png o .mp4.
- Archivos especializados y Big Data, por ejemplo .parquet.

## Recopilación de datos

Proceso de reunir datos de diferentes fuentes para usar en el análisis, toma de decisiones y resolución de problemas.

### Data pipelines

Sistema que automatiza el movimiento de los datos desde un lugar a otro.

#### ETL Pipeline (_Extract, Transform, Load_)

    [Fuentes] -> Extraer (datos sin procesar) -> [Transformar] -> Preparar los datos (cargar) -> Almacenar -> Analizar