DECLARE
 --Almacena el a�o a consultar por teclado
    busqueda NUMBER := &anio_buscar;
 --Almacena el a�o de las peliculas
    peli_total NUMBER;
 --Almacena el a�o con el estreno mas reciente
    reciente   NUMBER;
BEGIN
 --Calcula la cantidad de peliculas en el a�o buscado
    SELECT
        COUNT(ID_PELICULA) INTO PELI_TOTAL
    FROM
        PELICULA
    WHERE
        YEAR_APARICION = busqueda;
 --Buscamos el a�o mas reciente de estreno y lo comparamos con el a�o buscado
    SELECT
        MAX(YEAR_APARICION) INTO RECIENTE
    FROM
        PELICULA
    WHERE
        YEAR_APARICION = busqueda;
 --COMPROBAMOS SI EXISTEN PELICULAS EN EL A�O DADO
    IF PELI_TOTAL = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No hay estrenos en el a�o '
                             || busqueda);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Hay '
                             || PELI_TOTAL
                             || ' pelicula/s estrenada/s en '
                             || RECIENTE );
    END IF;
END;