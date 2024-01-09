--TABLAS A USAR: VILLANO, PELICULA
--TABLA A RECORRER: VILLANO
DECLARE
    --ALMACENAMOS LOS VILLANOS A PROCESAR Y LO ORDENAMOS POR NOMBRE
    CURSOR c_villanos (
        lvl_maldad NUMBER
    ) IS
    SELECT
        cod_villano,
        nomb_villano
    FROM
        villano
    WHERE
        nivel_maldad <= lvl_maldad
    ORDER BY
        villano.nomb_villano;

    --ALMACENA EL NIVEL DE MALDAD LEIDO DESDE TECLADO.
    lvl_maldad        NUMBER := &lvl_maldad;
    --ALMACENAMOS LA CANTIDAD DE PELICULAS EN LA QUE ES PARTICIPE
    cant_peli         NUMBER;
    --ALMACENA EL ANNIO DE LA PELICULA MAS ANTIGUA.
    anio_antiguo      NUMBER;
    --ALMACENA LA ANTIGUEDAD
    antiguedad        NUMBER;
    --ALMACENAMOS LA CATEGORIA
    categoria_villano resumen_villano.categoria%TYPE;
BEGIN
    --BORRAMOS LOS REGISTROS DE LA TABLA A INSERTAR
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_VILLANO';
    
    --RECORRER LOS VILLANOS
    FOR reg_villano IN c_villanos(lvl_maldad) LOOP
        --OBTENEMOS LA CANTIDAD DE PELICULAS EN LAS QUE APARECE
        SELECT
            COUNT(a.id_pelicula)
        INTO cant_peli
        FROM
                 pelicula a
            JOIN elenco_villanos b ON ( a.id_pelicula = b.id_pelicula )
        WHERE
            b.cod_villano = reg_villano.cod_villano;
        
        --OBTENEMOS EL ANIO DE PELICULA MAS ANTIGUA EN LA QUE APARECE
        SELECT
            nvl(MIN(a.year_aparicion),
                0)
        INTO anio_antiguo
        FROM
                 pelicula a
            JOIN elenco_villanos b ON ( a.id_pelicula = b.id_pelicula )
        WHERE
            b.cod_villano = reg_villano.cod_villano;
        
        --OBTENEMOS LA ANTIGUEDAD
        antiguedad := extract(YEAR FROM sysdate) - anio_antiguo;
        
        --VERIFICAMOS SI NO TIENE ANTIGUEDAD
        antiguedad :=
            CASE
                WHEN antiguedad = extract(YEAR FROM sysdate) THEN
                    0
                ELSE antiguedad
            END;
        
        --OBTENEMOS LA CATEGORIA EN BASE A LA REGLA DE NEGOCIO
        categoria_villano :=
            CASE
                WHEN cant_peli = 0 THEN
                    'SIN PARTICIPACION'
                WHEN antiguedad < 10 THEN
                    'RECIENTE'
                WHEN antiguedad > 10 THEN
                    'CONTEMPORANEO'
                WHEN antiguedad > 20 THEN
                    'ANTIGUO'
            END;
            
        --INSERTAMOS EL REGISTRO EN LA TABLA INFORME_VILLANOS
        INSERT INTO resumen_villano VALUES (
            reg_villano.cod_villano,
            reg_villano.nomb_villano,
            cant_peli,
            anio_antiguo,
            antiguedad,
            categoria_villano
        );

    END LOOP;

END;