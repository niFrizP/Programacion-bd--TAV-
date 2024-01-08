DECLARE
    --SE ALMACENA EL ID DE SUPERHEROE
    id_sh NUMBER;
    --SE ALMACENA EL NOMBRE DE SH
    nom_sh resumen_heroe.nombre_heroe%TYPE;
    --SE ALMACENA EL PUNTAJE TOTAL
    ptje_total NUMBER;
    --SE ALMACENA CANTIDAD DE PELICULAS
    pelis NUMBER;
    --SE ALMACENA LA CATEGORIA
    categoria resumen_heroe.categoria%TYPE;
    --SE ALMACENA ID MIN
    min_sh NUMBER;
    --SE ALMACENA ID MAX 
    max_sh NUMBER;

BEGIN
    --TRUNCAR EL CONTENIDO DE LA TABLA
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_heroe';
    
    --MIN Y MAX HEROE
    SELECT
        MIN(cod_heroe),
        MAX(cod_heroe)
    INTO
        min_sh,
        max_sh
    FROM
        superheroe;
        
    -- SE RECORRE SUPERHEROE
    id_sh := min_sh;
    WHILE id_sh <= max_sh LOOP

        
    --SE OBTIENEN NOMBRE DE SH
    SELECT
        nomb_heroe
    INTO
        nom_sh
    FROM
        superheroe
    WHERE 
        cod_heroe = id_sh;
    
    --SE OBTIENE LA CANTIDAD DE PELICULAS POR SH
    SELECT
        COUNT(id_pelicula)
    INTO pelis
    FROM
        elenco_heroes
    WHERE
        cod_heroe = id_sh;
    
    --SUMA DE PUNTAJE
    SELECT
        NVL(SUM(puntaje),0)
    INTO ptje_total
    FROM
        poder a JOIN heroe_poder b ON(a.cod_poder=b.cod_poder)
    WHERE 
        b.cod_heroe = id_sh;
    
    --CATEGORIZACION
    categoria :=
            CASE
                WHEN ptje_total = 0 THEN
                    'SIN PODERES '
                WHEN ptje_total BETWEEN 1 AND 5 THEN
                    'NORMAL'
                WHEN ptje_total BETWEEN 6 AND 10 THEN
                     'PODEROSO'
                ELSE 'SUPER PODEROSO'
            END;
                     
    --SE INSERTA EN LA TABLA REQUERIDA
        INSERT INTO resumen_heroe VALUES (
            id_sh,
            nom_sh,
            pelis,
            ptje_total,
            categoria
        );
        
 --AUMENTA EN 10
        id_sh := id_sh + 10;

    END LOOP;
END ;