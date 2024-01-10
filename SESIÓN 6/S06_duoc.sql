/*
--TABLAS A USAR:
--SUPERHEROE, UNIVERSO, HEROE_PODER, PODER, ORIGEN, ELENCO_HEROE, PELICULA.
--TABLA A RECORRER PARA RESUMEN:
--SUPERHEROE  
--TABLA A RECORRER PARA EL DETALLE:
--HEROE_PODER
*/

CREATE

--ALMACENAMOS LAS HEROES CON SU UNIVERSO A PROCESAR
CURSOR C_HEROES IS

SELECT
    a.cod_heroe,
    a.nomb_heroe,
    b.nomb_universo,
    b.cod_universo
FROM
    superheroe a
    JOIN universo b
    ON(a.cod_universo = b.cod_universo);

--ALMACENAMOS LOS PODERES DEL HEROE
CURSOR C_PODERES (P_HEROE NUMBER) IS

SELECT
    cod_poder,
    b.cod_poder,
    b.nomb_poder,
    b.puntaje
FROM
    heroe_poder a
    JOIN poder b
    ON(a.cod_poder = b.cod_poder)
WHERE
    cod_heroe = p_heroe;

--ALMACENAMOS LAS PELICULAS DEL HEROE ANTES DE 2010
CANT_PELIS_ANTES NUMBER;

--ALMACENAMOS LAS PELICULAS DEL HEROE DESPUES DE 2010
CANT_PELIS_DESPUES
number;

BEGIN
    --BORRAR LOS REGISTROS DE LAS TABLAS
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFO_HEROE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PODERES';

 --RECORRE LOS HEROES
    FOR reg_heroe IN c_heroes LOOP
 --OBTENEMOS LAS PELICULAS EN LAS QUE APARECE EL HEROE ANTES DE 2010
        SELECT
            COUNT(a.id_pelicula)
        INTO cant_pelis_antes
        FROM
                 pelicula a
            JOIN elenco_heroes b ON ( a.id_pelicula = b.id_pelicula )
        WHERE
                b.cod_heroe = reg_heroe.cod_heroe
            AND a.year_aparicion < '2010';
 --OBTENEMOS LAS PELICULAS EN LAS QUE APARECE EL HEROE DESPUES DE 2010
        SELECT
            COUNT(a.id_pelicula)
        INTO cant_pelis_despues
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
                nomb_origen
            FROM
                origen
            WHERE
                cod_heroe = reg_heroe.cod_heroe;
--OBTENEMOS LA CANTIDAD DE HEROES QUE TIENEN EL MISMO PODER PERTENECIENTES DEL MISMO UNIVERSO


        END LOOP;
 -- INSERTAR EN DETALLE_PODERES
    END LOOP;
 --OBTENER EL TOTAL DE PODERES UNICOS
 --CUANTOS OTROS HEROES TIENEN EL MISMO PODER QUE PERTENESCA AL MISMO UNIVERSO
 --INSERTAR EN INFO_HEROE
END;