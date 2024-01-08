--EJERCICIO 3
--TABLAS A USAR: ORIGEN, PODER, HEROE_PODER
--TABLA A RECORRER: ORIGEN
DECLARE
 --SE ALMACENA EL CODIGO MINIMO DE ORIGEN
    min_cod       NUMBER;
 --SE ALMACENA EL CODIGO MAXIMO DE ORIGEN
    max_cod       NUMBER;
 --SE ALMACENA EL NOMBRE
    nombre        origen.nomb_origen%type;
 --SE ALMACENA LA CANTIDAD TOTAL DE PODERES
    total_poderes NUMBER;
 --SE ALMACENA EL PROMEDIO DE PUNTAJE DE LOS PODERES
    prom_puntaje  NUMBER;
BEGIN
 --SE OBTIENE EL CODIGO MINIMO Y MAXIMO DE ORIGEN
    SELECT
        MIN(cod_origen),
        MAX(cod_origen) INTO min_cod,
        max_cod
    FROM
        origen;
 --SE RECORRE LA TABLA ORIGEN
    FOR id_origen IN min_cod .. max_cod LOOP --ID_ORIGEN ALMACENA LOS ID DE ORIGEN
 --OBTENER EL NOMBRE DEL ORIGEN
        SELECT
            nomb_origen INTO nombre
        FROM
            origen
        WHERE
            cod_origen = id_origen;
 --OBTENER LA CANTIDAD DE PODERES
        SELECT
            COUNT(cod_poder) INTO total_poderes
        FROM
            heroe_poder
        WHERE
            cod_origen = id_origen;
 --OBTENER EL PUNTAJE PROMEDIO DE LOS PODERES
        SELECT
            AVG(puntaje) INTO prom_puntaje
        FROM
            poder       a
            JOIN heroe_poder b
            ON(a.cod_poder = b.cod_poder)
        WHERE
            cod_origen = id_origen;
 --IMPRIMIR LOS DATOS
        dbms_output.put_line(nombre
                             || ' TIENE '
                             || total_poderes
                             ||' PODERES CON UN PUNTAJE PROMEDIO DE '
                             || prom_puntaje);
    END LOOP;
END;