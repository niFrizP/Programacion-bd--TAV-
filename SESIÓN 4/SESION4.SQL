--Ejercicio 1
/*Se requiere generar un resumen de las peliculas cuyo anno de aparicion sea superior a un
determinado limite. El resumen debe contener:
*Identificador de la pelicula
* Nombre de la pelicula
* Anno de aparicion
* Nombre del universo al que pertenece
* Cantidad total de personajes (heroes y villanos)
* Nivel de maldad total de todos los villanos que aparecen en la pelicula
* Puntaje total de los poderes de todos los heroes que aparecen en la pelicula
* Puntaje total de poderes de todos los villanos que aparecen en la pelicula
* Observacion de acuerdo con lo que indica la regla de negocio.*/

--Tablas necesarias: PELICULA, UNIVERSO, ELENCO_HEROES, ELENCO_VILLANOS, PODER, VILLANO, HEROE_PODER, VILLANO_PODER.
--Tabla a recorrer: PELICULA.


DECLARE
    --ALMACENA LAS PELICULAS A PROCESAR.
    CURSOR c_peliculas(
        p_limite NUMBER
    ) IS
    SELECT
        id_pelicula,
        nombre_pelicula,
        year_aparicion,
        cod_universo
    FROM
        pelicula
    WHERE
        year_aparicion > p_limite;
    --ALMACENA EL LIMITE LEIDO DESDE TECLADO.
    limite                 NUMBER:= &limite_annio;
    --ALMACENA EL NOMBRE DEL UNIVERSO DE LA PELICULA.
    nombre_universo        universo.nomb_universo%type;
    --ALMACENA EL TOTAL DE HEROES DE LA PELICULA.
    total_heroes           NUMBER;
    --ALMACENA EL TOTAL DE VILLANOS DE LA PELICULA.
    total_villanos         NUMBER;
    --ALMACENA EL NIVEL DE MALDAD TOTAL DE LOS VILLANOS DE LA PELICULA.
    nivel_maldad_total     NUMBER;
    --ALMACENA EL PUNTAJE TOTAL DE LOS PODERES DE LOS HEROES DE LA PELICULA.
    puntaje_total_heroes   NUMBER;
    --ALMACENA EL PUNTAJE TOTAL DE LOS PODERES DE LOS VILLANOS DE LA PELICULA.
    puntaje_total_villanos NUMBER;
    --ALMACENA LA OBSERVACION DE LA PELICULA DE ACUERDO AL PUNTAJE.
    observacion_pelicula   informe_pelicula.observacion%type;
BEGIN
    --BORRA LOS REGISTROS DE LA TABLA INFORME_PELICULA.
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFORME_PELICULA';
    
    --RECORREMOS LAS PELICULAS
    FOR reg_pelicula IN c_peliculas(limite) LOOP
        --OBTENEMOS EL NOMBRE DEL UNIVERSO DE LA PELICULA.
        SELECT
            nomb_universo INTO nombre_universo
        FROM
            universo
        WHERE
            cod_universo = reg_pelicula.cod_universo;
        
        --OBTENEMOS EL TOTAL DE HEROES DE LA PELICULA.
        SELECT
            COUNT(cod_heroe) INTO total_heroes
        FROM
            elenco_heroes
        WHERE
            id_pelicula = reg_pelicula.id_pelicula;
        
        --OBTENEMOS EL TOTAL DE VILLANOS DE LA PELICULA.
        SELECT
            COUNT(cod_villano) INTO total_villanos
        FROM
            elenco_villanos
        WHERE
            id_pelicula = reg_pelicula.id_pelicula;
        
        --OBTENEMOS EL NIVEL DE MALDAD TOTAL DE LOS VILLANOS DE LA PELICULA.
        SELECT
            nvl(SUM(nivel_maldad),
            0) INTO nivel_maldad_total
        FROM
            villano a
            JOIN elenco_villanos b
            ON(a.cod_villano = b.cod_villano)
        WHERE
            id_pelicula = reg_pelicula.id_pelicula;
        
        --OBTIENE EL PUNTAJE TOTAL DE LOS PODERES DE LOS HEROES DE LA PELICULA.
        SELECT
            nvl(SUM(puntaje),
            0) INTO puntaje_total_heroes
        FROM
            poder a
            JOIN heroe_poder b
            ON(a.cod_poder = b.cod_poder) JOIN elenco_heroes c
            ON(b.cod_heroe = c.cod_heroe)
        WHERE
            id_pelicula = reg_pelicula.id_pelicula;
        
        --OBTIENE EL PUNTAJE TOTAL DE LOS PODERES DE LOS VILLANOS DE LA PELICULA.
        SELECT
            nvl(SUM(puntaje),
            0) INTO puntaje_total_villanos
        FROM
            poder a
            JOIN villano_poder b
            ON(a.cod_poder = b.cod_poder) JOIN elenco_villanos c
            ON(b.cod_villano = c.cod_villano)
        WHERE
            id_pelicula = reg_pelicula.id_pelicula;
        
        --DETERMINA LA OBSERVACION DE LA PELICULA DE ACUERDO AL PUNTAJE.
        observacion_pelicula := CASE
            WHEN puntaje_total_heroes > puntaje_total_villanos THEN
                'HEROES MAS PODEROSOS QUE LOS VILLANOS'
            WHEN puntaje_total_heroes < puntaje_total_villanos THEN
                'VILLANOS MAS PODEROSOS QUE LOS HEROES'
            ELSE
                'HEROES Y VILLANOS IGUAL DE PODEROSOS'
        END;
        
        --INSERTA EL REGISTRO EN LA TABLA INFORME_PELICULA.
        INSERT INTO informe_pelicula VALUES(
            reg_pelicula.id_pelicula,
            reg_pelicula.nombre_pelicula,
            reg_pelicula.year_aparicion,
            nombre_universo,
            (total_heroes + total_villanos),
            nivel_maldad_total,
            puntaje_total_heroes,
            puntaje_total_villanos,
            observacion_pelicula
        );
    END LOOP;
END;

-- Ejercicio 2
/*
Tablas necesarias:
PODER, HEROE_PODER, VILLANO_PODER, ORIGEN
Tabla a recorrer:
PODER
*/
DECLARE
    -- Almacena los poderes a procesar
    CURSOR c_poderes(p_limite NUMBER) IS
        SELECT cod_poder, nomb_poder, puntaje
        FROM poder
        WHERE puntaje > p_limite;
    -- Almacena el limite de puntaje leido desde teclado
    limite_puntaje NUMBER := &LIMITE_PUNTAJE;
    -- Almacena el total de heroes
    total_heroes NUMBER;
    -- Almacena el total de villanos
    total_villanos NUMBER;
    -- Almacena el origen del poder
    origen_poder resumen_poder.origen_poder%TYPE;
    -- Almacena el total de origenes dl poder
    total_origenes NUMBER;
BEGIN
    -- Trunca la tabla de acuerdo con requerimiento
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_poder';
    -- Recorre los poderes a procesar
    FOR reg_poder IN c_poderes(limite_puntaje) LOOP
        -- Obtener el total de heroes que poseen el poder
        SELECT COUNT(cod_heroe) INTO total_heroes
        FROM heroe_poder
        WHERE cod_poder = reg_poder.cod_poder;
        -- Obtiene el total de villanos que poseen el poder
        SELECT COUNT(cod_villano) INTO total_villanos
        FROM villano_poder
        WHERE cod_poder = reg_poder.cod_poder;
        -- Analiza la cantidad de heroes que poseen el poder
        IF total_heroes = 0  THEN
            origen_poder := 'DESCONOCIDO';
        ELSE
            -- Obtiene el total de origenes
            SELECT COUNT(cod_origen)
            INTO total_origenes
            FROM heroe_poder
            WHERE cod_poder = reg_poder.cod_poder;
            -- Verifica si son varios origenes
            IF total_origenes >= 2 THEN
                origen_poder := 'VARIOS ORIGENES';
            ELSE
                -- Busco el nombre del UNICO ORIGEN
                SELECT nomb_origen INTO origen_poder
                FROM origen a JOIN heroe_poder b 
                    ON(a.cod_origen = b.cod_origen)
                WHERE cod_poder = reg_poder.cod_poder;
            END IF;
        END IF;
        -- Inserto resultados
        INSERT INTO resumen_poder
        VALUES(reg_poder.cod_poder,
        reg_poder.nomb_poder, reg_poder.puntaje,
        total_heroes, total_villanos,
        origen_poder);
    END LOOP;
END;












