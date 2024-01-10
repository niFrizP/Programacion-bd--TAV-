DECLARE
    --SE ALMACENA EL ID DE SUPERHEROE
    id_sh NUMBER;
    --SE ALMACENA EL NOMBRE DE SH
    nom_sh NUMBER;
    --SE ALMACENA EL PUNTAJE TOTAL
    ptje_total NUMBER;
    --SE ALMACENA CANTIDAD DE PELICULAS
    pelis NUMBER;
    --SE ALMACENA LA CATEGORIA
    categorizacion resumen_heroe.categoria%TYPE;

BEGIN
    --SE OBTIENEN ID Y NOMBRE DE SH
    SELECT
        cod_heroe,
        nomb_heroe
    INTO
        id_sh,
        nom_sh
    FROM
        superheroe;
    
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
        SUM(puntaje)
    INTO ptje_total
    FROM
        poder a JOIN heroe_poder b ON(a.cod_poder=b.cod_poder)
    WHERE 
        b.cod_heroe = id_sh;
    
    --CATEGORIZACION
    categorizacion :=
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
            cod_heroe,
            nom_sh,
            pelis,
            ptje_total,
            categorizacion
        );
END ;