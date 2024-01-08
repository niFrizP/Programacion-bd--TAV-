-- Tablas extra de la semana 2
/*
Estas tablas deben ser agregadas a las tablas incluidas 
en el archivo DDL-DML-TAV.sql
*/
-- Ejercicio 1
DROP TABLE informe_pelicula;
CREATE TABLE informe_pelicula
(
    id_pelicula NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    aparicion NUMBER NOT NULL,
    universo VARCHAR2(100) NOT NULL,
    total_personajes NUMBER NOT NULL,
    nivel_maldad_total NUMBER NOT NULL,
    puntaje_total_heroes NUMBER NOT NULL,
    puntaje_total_villanos NUMBER NOT NULL,
    observacion VARCHAR2(100) NOT NULL
);

-- Ejercicio 2
DROP TABLE resumen_poder;
CREATE TABLE resumen_poder
(
    id_poder NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    puntaje NUMBER NOT NULL,
    cantidad_heroes NUMBER NOT NULL,
    cantidad_villanos NUMBER NOT NULL,
    origen_poder VARCHAR2(100) NOT NULL
);

-- Desafio
DROP TABLE informe_villanos;
CREATE TABLE informe_villanos
(
    id_villano NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    nivel_maldad NUMBER NOT NULL,
    puntaje_total NUMBER NOT NULL,
    observacion VARCHAR2(100) NOT NULL,
    es_nemesis_de VARCHAR2(100) NOT NULL
);