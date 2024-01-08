/*
IMPRIMIR INFORME  DE TODOS LOS VILLANOS REGISTRADOS INDICANDO:
- NOMBRE DEL VILLANO
- NOMBRE DEL UNIVERSO AL QUE PERTENCE
- CANTIDAD DE PODERES QUE TIENE

TABLAS A USAR; VILLANO, UNIVERSO, VILLANO_PODER
TABLA A RECORRER; VILLANO
*/

SET SERVEROUTPUT ON;
DECLARE
    --ALMACENA LOS REGISTROS A PROCESAR 
    CURSOR c_villanos IS           
    SELECT
        nomb_villano,
        cod_universo,
        cod_villano
    FROM
        villano;
        
    --ALMACENA EL NOMBRE DEL UNIVERSO
    nom_uni       universo.nomb_universo%TYPE;
    --ALMACENA LOS PODERES DEL VILLANO
    total_poderes NUMBER;
BEGIN
    --RECORRE EL CURSOR VILLANO
    FOR reg_villano IN c_villanos LOOP
        --OBTENER EL NOMBRE DEL UNIVERSO
        SELECT
            nomb_universo
        INTO nom_uni
        FROM
            universo
        WHERE
            cod_universo = reg_villano.cod_universo;
        --OBTENER CANTIDAD DE PODERES
        SELECT
            COUNT(cod_poder)
        INTO total_poderes
        FROM
            villano_poder
        WHERE
            cod_villano = reg_villano.cod_villano;
        --IMPRIMIR DATOS DEL VILLANO
        dbms_output.put_line(reg_villano.nomb_villano
                             || ' '
                             || nom_uni
                             || ' '
                             || total_poderes);

    END LOOP;
END;


/*
REPETIR EL EJERCICIO ANTERIOR CONSIDERANDO SOLO LOS VILLANOS CUYO
NIVEL DE MALDAD SEA MENOR O IGUAL A 4
*/

DECLARE
    --ALMACENA LOS REGISTROS A PROCESAR 
    CURSOR c_villanos IS           -- <---- CURSOR EXPLICITO, NO NECESITA INTO.
    SELECT
        nomb_villano,
        cod_universo,
        cod_villano
    FROM
        villano
    WHERE 
        nivel_maldad <= 4;
    --ALMACENA EL NOMBRE DEL UNIVERSO
    nom_uni       universo.nomb_universo%TYPE;
    --ALMACENA LOS PODERES DEL VILLANO
    total_poderes NUMBER;
BEGIN
    --RECORRE EL CURSOR VILLANO
    FOR reg_villano IN c_villanos LOOP
        --OBTENER EL NOMBRE DEL UNIVERSO
        SELECT
            nomb_universo
        INTO nom_uni
        FROM
            universo
        WHERE
            cod_universo = reg_villano.cod_universo;
        --OBTENER CANTIDAD DE PODERES
        SELECT
            COUNT(cod_poder)
        INTO total_poderes
        FROM
            villano_poder
        WHERE
            cod_villano = reg_villano.cod_villano;
        --IMPRIMIR DATOS DEL VILLANO
        dbms_output.put_line(reg_villano.nomb_villano
                             || ' '
                             || nom_uni
                             || ' '
                             || total_poderes);

    END LOOP;
END;