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
    HERO_COUNT  NUMBER;
    --ALMACENA LA CANTIDAD DE VILLANOS QUE APARECEN EN LA PELICULA
    EVIL_COUNT  NUMBER;
BEGIN
 --OBTENEMOS LOS DATOS DE PELICULA
    SELECT
        id_pelicula,
        nombre_pelicula,
        year_aparicion,
        EXTRACT(YEAR FROM sysdate) - year_aparicion INTO peli_id,
        peli_nom,
        estreno,
        annios_pass
    FROM
        pelicula;

 --OBTENEMOS LA CANTIDAD DE VILLANOS SEGUN LA PELICULA
    SELECT
        COUNT(*)
    INTO EVIL_COUNT
    FROM
        elenco_villanos
    WHERE
        id_pelicula = peli_id;
 --OBTENEMOS LA CANTIDAD DE HEROES SEGUN LA PELICULA
    SELECT
        COUNT(*)
    INTO HERO_COUNT
    FROM
        elenco_heroes
    WHERE
        id_pelicula = peli_id;
 --OBTENEMOS LA CATEGORIA
    FOR 
        i IN 1..peli_id
    LOOP
        IF
            HERO_COUNT >= EVIL_COUNT
        THEN
            INSERT INTO resumen_pelicula VALUES (
                peli_id,
                peli_nom,
                annios_pass,
                HERO_COUNT,
                EVIL_COUNT,
                'A'
            );
        ELSE
            INSERT INTO resumen_pelicula VALUES (
                peli_id,
                peli_nom,
                annios_pass,
                HERO_COUNT,
                EVIL_COUNT,
                'B'
            );
        END IF;
    END LOOP;
END;