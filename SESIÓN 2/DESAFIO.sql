/*Desafío Sesión 2
Crear una tabla llamada RESUMEN_PELICULA que tenga los siguientes campos
id_pelicula
nombre de la pelicula
cantidad de años pasados desde que se estrenó
cantidad de heroes que aparecen en la película
cantidad de villanos que aparece en la pelicula
categoria
Se requiere emitir un resumen de las peliculas que obtenga los datos que contiene la tabla RESUMEN_PELICULA y los
inserte en la tabla.
La categoria se obtiene de acuerdo con la regla;
Categoria A si heroes >= villanos (Si aparecen mas o la misma cantidad de heroes que de villanos en la pelicula)
Categoria B en otro caso
*/


--TABLAS A USAR: PELICULA, ELENCO_HEROES, ELENCO_VILLANOS
--CONSTRUIR UN BLOQUE ANONIMO
DECLARE
 --ALMACENA EL ID DE PELICULA
    peli_id     NUMBER;
 --ALMACENA EL NOMBRE DE LA PELICULA
    peli_nom    pelicula.nombre_pelicula%type;
 --ALMACENA EL AÑO DE ESTRENO DE LA PELICULA
    estreno     pelicula.year_aparicion%type;
 --ALMACENA LA CANTIDAD DE AÑOS PASADOS DESDE QUE SE ESTRENO LA PELICULA
    annios_pass NUMBER;
 --ALMACENA LA CANTIDAD DE HEROES QUE APARECEN EN LA PELICULA
    hero_count  NUMBER;
 --ALMACENA LA CANTIDAD DE VILLANOS QUE APARECEN EN LA PELICULA
    evil_count  NUMBER;
BEGIN
 --OBTENEMOS LOS DATOS DE PELICULA
    SELECT
        id_pelicula,
        year_aparicion INTO peli_id,
        estreno,
        annios_pass
    FROM
        pelicula;

 --OBTENEMOS LOS AÑOS PASADOS DESDE EL ESTRENO DE LA PELICULA
    SELECT EXTRACT(YEAR FROM sysdate) - year_aparicion
    INTO annios_pass
    FROM pelicula
    WHERE id_pelicula = peli_id;
    
 --OBTENEMOS NOMBRE DE PELICULAS
    SELECT
        nombre_pelicula INTO peli_nom
    FROM
        pelicula
    WHERE
        id_pelicula = peli_id;

 --OBTENEMOS LA CANTIDAD DE VILLANOS SEGUN LA PELICULA
    SELECT
        COUNT(*) INTO evil_count
    FROM
        elenco_villanos
    WHERE
        id_pelicula = peli_id;

 --OBTENEMOS LA CANTIDAD DE HEROES SEGUN LA PELICULA
    SELECT
        COUNT(*) INTO hero_count
    FROM
        elenco_heroes
    WHERE
        id_pelicula = peli_id;

 --OBTENEMOS LA CATEGORIA
    FOR i IN 1..peli_id LOOP
        IF hero_count >= evil_count THEN
            INSERT INTO resumen_pelicula VALUES (
                peli_id,
                peli_nom,
                annios_pass,
                hero_count,
                evil_count,
                'A'
            );
        ELSE
            INSERT INTO resumen_pelicula VALUES (
                peli_id,
                peli_nom,
                annios_pass,
                hero_count,
                evil_count,
                'B'
            );
        END IF;
    END LOOP;
END;