--SEMANA 3
--FUNCION ALMACENADA

CREATE OR REPLACE 
FUNCTION fn_obtener_universo(p_universo NUMBER)
RETURN VARCHAR2
IS 
    --ALMACENA EL NOMBRE DEL UNIVERSO
    N_universo universo.nomb_universo%TYPE;
BEGIN 
    --OBTENER EL NOMBRE DEL UNIVERSO
    SELECT nomb_universo
    INTO N_universo
    FROM universo
    WHERE cod_universo = p_universo;
    --RETORNA EL RESULTADO
    RETURN N_universo;
    --CREAMOS LA EXCEPCION EN CASO NO HAYA REGISTROS.
EXCEPTION WHEN NO_DATA_FOUND THEN
    --RETORNA EL RESULTADO EN CASO QUE NO HAYA REGISTROS.
    RETURN 'NO REGISTRADO';
END;

--FUNCION ALMACENADA 2
-- Tablas necesarias:
/*
    SUPERHEROE, HEROE_PODER
*/
CREATE OR REPLACE 
FUNCTION fn_poderes_unicos(p_heroe NUMBER, p_universo NUMBER)
RETURN NUMBER
IS
-- Almacena el total de poderes unicos
    total_poderes_unicos NUMBER;
BEGIN
    -- Obtener el total de poderes unicos
    SELECT COUNT(1) INTO total_poderes_unicos
    FROM (
        SELECT a.cod_poder--, COUNT(b.cod_heroe) 
        FROM heroe_poder a JOIN heroe_poder b
        ON(a.cod_poder = b.cod_poder)
        WHERE a.cod_heroe = p_heroe AND b.cod_heroe IN(SELECT cod_heroe FROM superheroe
                    WHERE cod_universo = p_universo)
        GROUP BY a.cod_poder
        HAVING COUNT(b.cod_heroe) = 1);
    RETURN total_poderes_unicos;
END;

--PROCEDIMIENTO ALMACENADO 1
CREATE OR REPLACE PROCEDURE
sp_totales(p_heroe NUMBER, p_total_antes OUT NUMBER, p_total_despues OUT NUMBER) -- OUT, ES PARA ESPECIFICAR QUE ES UN PARAMETRO DE SALIDA Y PUEDE MODIFICAR COSAS...
--Y ESA ES SU FORMA DE RETORNAR.
IS 
BEGIN
    --CALCULAR EL TOTAL ANTES DE 2010
    SELECT COUNT(a.id_pelicula)
    INTO p_total_antes
    FROM pelicula a JOIN elenco_heroes b 
    ON(a.id_pelicula = b.id_pelicula)
    WHERE year_aparicion < 2010 AND cod_heroe = p_heroe;
    
    --CALCULAR EL TOTAL DESPUES DE 2010
    SELECT COUNT(a.id_pelicula)
    INTO p_total_despues
    FROM pelicula a JOIN elenco_heroes b 
    ON(a.id_pelicula = b.id_pelicula)
    WHERE year_aparicion >= 2010 AND cod_heroe = p_heroe;
END;

--PROCEDIMIENTO 2
CREATE OR REPLACE PROCEDURE SP_INSERTAR(p_heroe NUMBER, p_nombre VARCHAR2, p_universo VARCHAR2, p_ANTES NUMBER, p_despues NUMBER, p_poderes_unicos NUMBER)
-- 6 parametros de entrada, no los modifica el procedimiento.
IS
    --ALMACENA EL ERROR DE ORACLE
    msg_oracle error_proceso.error_oracle%TYPE;
BEGIN
    INSERT INTO info_heroe
    VALUES(p_heroe, p_nombre, p_universo, p_antes, p_despues, p_poderes_unicos);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN 
    --ALMACENA EL ERROR DE ORACLE
    msg_oracle := SQLERRM;
    --INSERTA EL ERROR EN LA TABLA CORRESPONDIENTE
    INSERT INTO ERROR_PROCESO
    VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, msg_oracle, 'REGISTRO DUPLICADO');
END;


--PROCEDIMIENTO FINAL
CREATE OR REPLACE PROCEDURE SP_INFORME
IS
    --ALMACENA LOS HEROES A PROCESAR
    CURSOR c_heroes IS
        SELECT cod_heroe, nomb_heroe, cod_universo
        FROM superheroe;
    --ALMACENA EL NOMBRE DEL UNIVERSO
    n_uni universo.nomb_universo%TYPE;
    --ALMACENA EL ANTES
    TOTAL_ANT NUMBER;
    --ALMACENA EL DESPUES
    TOTAL_DES NUMBER;
    --ALMACENA TOTAL DE LOS PODERES UNICOS
    p_uni NUMBER;
BEGIN
    --PROCESA A LOS HEROES
    FOR reg_heroe IN c_heroes LOOP
        --OBTIENE EL NOMBRE DEL UNIVERSO
        n_uni := fn_obtener_universo(reg_heroe.cod_universo);
        --OBTIENE LOS TOTALES DEL ANTES Y DESPUES DEL 2010
        sp_totales(reg_heroe.cod_heroe, total_ant, total_des);
        --OBTIENE EL TOTAL DE PODERES UNICOS
        p_uni := fn_poderes_unicos(reg_heroe.cod_heroe, reg_heroe.cod_universo);
        --INSERTAR RESULTADOS
        SP_INSERTAR(reg_heroe.cod_heroe, reg_heroe.nomb_heroe, n_uni, total_ant, total_des, p_uni);
    END LOOP;
END;
--LLAMAMOS EL PROCEDIMIENTO
EXEC sp_informe;
