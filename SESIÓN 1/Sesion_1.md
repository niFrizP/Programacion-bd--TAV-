# Sesión 1

# 

mar 2 de ene

## Experiencias:

- Experiencia 1: Bloques anónimos simples.
- Experiencia 2: Bloques anónimos complejos.
- Experiencia 3: Funciones, procedimientos, packages y trigger.

## Evaluaciones:

- Jueves 4 : Primera Evaluación Exp 1. 20%
- Martes 9 : Segunda Evaluación Exp 2 parte 1. 15%
- Jueves 11 : Tercera Evaluación Exp 2 parte 2. 20%
- Miércoles 17 : Cuarta Evaluación Exp 3 parte 1. 20%
- Miércoles 24 : Quinta Evaluación Exp 3 parte 2. 25%
- Lunes 29 : Examen Transversal.

## EXPLICACIÓN INICIAL DE BLOQUES ANÓNIMOS

**¿Que es un bloque anónimo?**

Una unidad de programación que se ejecuta sobre una base de datos, se caracteriza porque NO TIENE NOMBRE.


Modelo Relacional Inicial

**¿Como se crea un bloque anónimo?**

```sql
--EJERCICIO 1
SET SERVEROUTPUT ON;
DECLARE
  --Variable que almacena el total de universos
  total NUMBER;  
BEGIN
  --OBTENER EL TOTAL DE UNIVERSOS REGISTRADOS
  SELECT COUNT(universoid)
  INTO total --el into se encarga de almacenar la instruccion (SELECT) dentro de la variable
  FROM universo;  
  --IMPRIMIR EN PANTALLA
  DBMS_OUTPUT.PUT_LINE('El total de universos es ' || total);
END;

--El select de la linea 6 es un cursor implicito.
```

```sql
--EJERCICIO 2
SET SERVEROUTPUT ON;
DECLARE
  --Variable que almacena el id del personaje
  identi NUMBER :=&id_personaje;   --& varible bind que lee desde lo que uno escribe en el teclado
  --Almacena el nombre del personaje
  nombre_pers personaje.nombre%TYPE;
  --Almacena el total de poderes que tiene un personaje
  total NUMBER;       
BEGIN
  --OBTENER EL NOMBRE DEL PERSONAJE
  SELECT nombre
  INTO nombre_pers  
  FROM personaje
  WHERE personajeid = identi;    
  --OBTENER EL TOTAL DE PODERES QUE TIENE UN PERSONAJE
  SELECT COUNT(poderid)
  INTO total
  FROM personajepoder
  WHERE personajeid = identi;  
  --IMPRIMIR EN PANTALLA
  DBMS_OUTPUT.PUT_LINE(nombre_pers || ' tiene ' || total || ' poder/es');
END;
```

```sql
--EJERCICIO 3
SET SERVEROUTPUT ON;
DECLARE
  --Variable que almacena el id del personaje
  identi NUMBER :=&id_personaje;   --& varible bind que lee desde lo que uno escribe en el teclado
  --Almacena el nombre del personaje
  nombre_pers personaje.nombre%TYPE;
  --Almacena el total de poderes que tiene un personaje
  total NUMBER;       
BEGIN
  --OBTENER EL NOMBRE DEL PERSONAJE
  SELECT nombre
  INTO nombre_pers  
  FROM personaje
  WHERE personajeid = identi;    
  --OBTENER EL TOTAL DE PODERES QUE TIENE UN PERSONAJE
  SELECT COUNT(poderid)
  INTO total
  FROM personajepoder
  WHERE personajeid = identi; 
  --VERIFICA SI TIENE PODERES
  IF total = 0 THEN
    DBMS_OUTPUT.PUT_LINE(nombre_pers || ' no tiene poderes ');
    ELSE 
      --IMPRIMIR EN PANTALLA
    DBMS_OUTPUT.PUT_LINE(nombre_pers || ' tiene ' || total || ' poder/es');
  END IF;
END;
```

### AVANZANDO EN LA CONSTRUCCIÓN DE BLOQUES ANÓNIMOS

Usando el modelo disponible en el archivo Modelo_TAVl.PDF se pide construir bloques anónimos que permitan cumplir con los requerimientos que se indican en cada ejercicio:

```sql
SET SERVEROUTPUT ON;
DECLARE
  --Almacena el puntaje promedio de poder de SH
  promedio_sh NUMBER;
  --Almacena el ID del sh buscado
  buscado NUMBER := &cod_heroe;
  --Almacena el promedio general de poder de SH
  promedio_sh_gen NUMBER;      
BEGIN
  --OBTENER EL PUNTAJE PROMEDIO DE PODERES DEL SUPERHEROE
  SELECT AVG(puntaje)
  INTO  promedio_sh
  FROM poder p JOIN heroe_poder b ON(p.cod_poder = b.cod_poder)
  WHERE cod_heroe = buscado;
  --OBTENER EL PROMEDIO PUNTAJE GENERAL
  SELECT AVG(puntaje)
  INTO  promedio_sh_gen
  FROM poder;
  --COMPARAR PROMEDIO GENERAL CON PROMEDIO DEL SH
    IF promedio_sh < promedio_sh_gen THEN
      DBMS_OUTPUT.PUT_LINE('Promedio SH es MENOR que el promedio general');
    ELSIF promedio_sh > promedio_sh_gen THEN
      DBMS_OUTPUT.PUT_LINE('Promedio SH es MAYOR que el promedio general');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Promedio SH es IGUAL que el promedio general');
  END IF;
END;
```

```sql
--Ejercicio 2
--¿Que tablas necesito? VILLANO 
DECLARE
  --Almacena el mayor nivel de maldad
  max_lvl NUMBER;
  --Almacena a los mas malos
  mas_malos NUMBER;    
BEGIN
  --OBTENER EL MAXIMO NIVEL DE MALDAD
  SELECT MAX(nivel_maldad)
  INTO max_lvl   
  FROM villano;
  --OBTENER LA CANTIDAD DE VILLANOS QUE CUENTAN CON ESE NIVEL MAXIMO.
  SELECT COUNT(cod_villano)
  INTO mas_malos  
  FROM villano
  WHERE max_lvl = mas_malos;
  --Imprimimos
  DBMS_OUTPUT.PUT_LINE('Hay ' || mas_malos || ' villanosque tienen el mayor nivel de maldad');    
END;
```

# Desafíos

## Desafío 1:

USANDO EL PRIMER MODELO

Construir un bloque anónimo que permita imprimir el nombre del personaje
que registra menos poderes.

El nombre se debe imprimir en mayúsculas

```sql
DECLARE
--Variable que almacena el nombre del personaje
nombre_pers   personaje.nombre%TYPE;
--Variable que almacena el id del personaje
id_pers    NUMBER;
--Variable que almacena el id de poderes
power_pers personajepoder.poderid%TYPE;
--ALMACENA EL TOTAL de poderes
total NUMBER;
BEGIN
--OBTENER EL NOMBRE DEL PERSONAJE
SELECT
nombre
INTO nombre_pers
FROM
personaje
WHERE
personajeid = id_pers;
--OBTENEMOS CANTIDAD DE PODERES
SELECT
    MIN(poderid)
INTO total
FROM
    personajepoder
WHERE
    poderid = power_pers;

--VERIFICAMOS PODERES
IF total = (>1)
then
    dbms_output.put_line ( nombre_pers || ' es el personaje con menos poderes ' );
end
    if;
    end;

```

## Desafío 2:

USANDO EL SEGUNDO MODELO

Construir un bloque anónimo que permita, dado un año de aparición indicar la cantidad de películas que fueron estrenadas ese año (campo year_aparicion)

En caso de que para el año ingresado no existan películas debe imprimir un mensaje descriptivo de la situación.

```sql
--Desafio 2
SET SERVEROUTPUT ON;

DECLARE
  --Almacena el año a consultar por teclado
  busqueda=: & year_aparicion;
 --Almacena el año de las peliculas
  peli_total NUMBER;
  --Almacena el año con el estreno mas reciente
  reciente NUMBER;       
BEGIN
  --Calcula la cantidad de peliculas y las compara con la busqueda
  SELECT COUNT(id_pelicula)
  INTO peli_total
  FROM pelicula
  WHERE year_aparicion = busqueda;
  --Buscamos el año mas reciente y lo comparamos con el buscado
  SELECT MAX(year_aparicion)
  INTO reciente
  FROM year_aparicion = busqueda;    
 
  --COMPROBAMOS SI EXISTE O NO UNA PELICULA EN EL AÑO DADO
    IF peli_total = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay estrenos en el año ' || busqueda);
          ELSE
        DBMS_OUTPUT.PUT_LINE('Hay ' || peli_total || ' peliculas estrenadas en ' || reciente );
  END IF;  
END;
```
