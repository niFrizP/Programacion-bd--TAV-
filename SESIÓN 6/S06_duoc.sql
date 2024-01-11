/*
--TABLAS A USAR:
--SUPERHEROE, UNIVERSO, HEROE_PODER, PODER, ORIGEN, ELENCO_HEROE, PELICULA.
--TABLA A RECORRER PARA RESUMEN:
--SUPERHEROE  
--TABLA A RECORRER PARA EL DETALLE:
--HEROE_PODER
*/

DECLARE
--ALMACENAMOS LAS HEROES CON SU UNIVERSO A PROCESAR
CURSOR C_HEROES IS SELECT
    a.cod_heroe,
    a.nomb_heroe,
    b.nomb_universo,
    b.cod_universo
FROM
    superheroe a
    JOIN universo b
    ON(a.cod_universo = b.cod_universo);

--ALMACENAMOS LOS PODERES DEL HEROE
CURSOR C_PODERES (P_HEROE NUMBER) IS SELECT
    a.cod_poder,
    b.nomb_poder,
    b.puntaje
FROM
    heroe_poder a
    JOIN poder b
    ON(a.cod_poder = b.cod_poder)
WHERE
    a.cod_heroe = P_HEROE;

--ALMACENAMOS LAS PELICULAS DEL HEROE ANTES DE 2010
CANT_PELIS_ANTES NUMBER;

--ALMACENAMOS LAS PELICULAS DEL HEROE DESPUES DE 2010
CANT_PELIS_DESPUES NUMBER;

--ALMACENAMOS EL ORIGEN DEL PODER
DETAIL_ORIGEN DETALLE_PODERES.ORIGEN_PODER%TYPE;

--ALMACENAMOS LA CANTIDAD DE OTROS HEROES CON EL MISMO PODER
OTROS_IGUALES NUMBER;

--ALMACENAMOS LA CATEGORIA
CATEGORIA_HEROE DETALLE_PODERES.CATEGORIA%TYPE;

BEGIN
    --BORRAR LOS REGISTROS DE LAS TABLAS
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFO_HEROE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PODERES';


 --RECORRE LOS HEROES
    FOR reg_heroe IN c_heroes LOOP
 --OBTENEMOS LAS PELICULAS EN LAS QUE APARECE EL HEROE ANTES DE 2010
        SELECT
            COUNT(a.id_pelicula)
        INTO CANT_PELIS_ANTES
        FROM
                 pelicula a
            JOIN elenco_heroes b ON ( a.id_pelicula = b.id_pelicula )
        WHERE
                b.cod_heroe = reg_heroe.cod_heroe
            AND a.year_aparicion < '2010';
 --OBTENEMOS LAS PELICULAS EN LAS QUE APARECE EL HEROE DESPUES DE 2010
        SELECT
            COUNT(a.id_pelicula)
        INTO CANT_PELIS_DESPUES
        FROM
                 pelicula a
            JOIN elenco_heroes b ON ( a.id_pelicula = b.id_pelicula )
        WHERE
                b.cod_heroe = reg_heroe.cod_heroe
            AND a.year_aparicion >= '2010';
 --RECORRE LOS PODERES DEL HEROE
        FOR reg_poder IN c_poderes(reg_heroe.cod_heroe) LOOP
--OBTENEMOS EL ORIGEN PODER
            SELECT
                a.nomb_origen
            INTO DETAIL_ORIGEN
            FROM
                origen a JOIN heroe_poder b ON(a.cod_origen = b.cod_origen)
            WHERE
                cod_heroe = reg_heroe.cod_heroe;
                
--OBTENEMOS LA CANTIDAD DE HEROES QUE TIENEN EL MISMO PODER PERTENECIENTES DEL MISMO UNIVERSO
        SELECT COUNT(a.cod_heroe)
        INTO OTROS_IGUALES
        FROM superheroe a JOIN heroe_poder b ON (a.cod_heroe = b.cod_heroe)
        WHERE a.cod_universo = reg_heroe.cod_universo AND b.cod_poder = reg_poder.cod_poder AND a.cod_heroe != reg_heroe.cod_heroe;
        

--OBTENEMOS LA CATEGORIA EN BASE A LA REGLA DE NEGOCIO

CATEGORIA_HEROE :=
    CASE 
        WHEN OTROS_IGUALES = 0 THEN
            'UNICO'
        WHEN OTROS_IGUALES <= 3 THEN
            'NORMAL'
        WHEN OTROS_IGUALES >= 4 THEN
            'POPULAR'
    END;


        END LOOP;
 -- INSERTAR EN DETALLE_PODERES
    INSERT INTO DETALLE_PODERES
    VALUES(
        reg_heroe.cod_heroe,
        reg_poder.cod_poder,
        reg_poder.nomb_poder,
        reg_poder.puntaje,
        DETAIL_ORIGEN,
        OTROS_IGUALES,
        CATEGORIA_HEROE
    );

    END LOOP;
 --OBTENER EL TOTAL DE PODERES UNICOS
    
 --CUANTOS OTROS HEROES TIENEN EL MISMO PODER QUE PERTENESCA AL MISMO UNIVERSO
 --INSERTAR EN INFO_HEROE
END;