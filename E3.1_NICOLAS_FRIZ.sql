

--ENCABEZADO DEL PACKAGE
CREATE OR REPLACE PACKAGE pkg_peliculas IS
    --FUNCION PUBLICA
    FUNCTION fn_nom_universo(p_cod_universo NUMBER)
    RETURN NUMBER;
    --PROCEDIMIENTO PUBLICO
    PROCEDURE sp_cant_hyv(p_id_peli NUMBER, p_cant_h OUT NUMBER, p_cant_v OUT NUMBER);
END;
-----------------------------------------------------------------------

--CUERPO DEL PACKAGE
CREATE OR REPLACE PACKAGE BODY pkg_peliculas IS
    --FUNCION DADO EL COD_UNIVERSO RETORNE NOMB_UNIVERSO
    FUNCTION fn_nom_universo(p_cod_universo NUMBER)
    RETURN NUMBER
    IS
    --ALMACENA EL NOMBRE DE LOS UNIVERSOS
    uni_nom info_pelicula.universo%TYPE;
    BEGIN
        --OBTENEMOS EL NOMBRE DEL UNIVERSO SEGUN SU CODIGO
        SELECT nomb_universo
        INTO uni_nom
        FROM UNIVERSO
        WHERE cod_universo = p_cod_universo;
        --RETORNAMOS EL RESULTADO
        RETURN uni_nom;
    END;
    --PROCEDIMIENTO DADO EL ID DE UNA PELICULA RETORNE LA CANT. DE H Y V.
    PROCEDURE sp_cant_hyv(p_id_peli NUMBER, p_cant_h OUT NUMBER, p_cant_v OUT NUMBER)
    IS
    BEGIN
        --OBTENEMOS DADO EL ID DE PELICULA ME DEVUELVA LA CANTIDAD DE HEROES
        SELECT COUNT(cod_heroe)
        INTO p_cant_h
        FROM elenco_heroes
        WHERE id_pelicula = p_id_peli;
        
        --OBTENEMOS DADO EL ID DE PELICULA ME DEVUELVA LA CANTIDAD DE VILLANOS
        SELECT COUNT(cod_villano)
        INTO p_cant_v
        FROM elenco_villanos
        WHERE id_pelicula = p_id_peli;
    END;
END;

-- FUNCION ALMACENADA 
CREATE OR REPLACE FUNCTION fn_aparicion_heroes(p_cod_peli NUMBER, p_limite NUMBER)
RETURN NUMBER
IS
    --OBTENEMOS CANTIDAD DE PELICULAS
    CURSOR c_cant_peli IS
        SELECT COUNT(id_pelicula)
        FROM elenco_heroes;
    
    --ALMACENA EL ANNIO DE APARICION
    anno_ap NUMBER;
    --ALMACENA EL TOTAL DE HEROES
    total_hero NUMBER;
    
    BEGIN
    --OBTENEMOS EL ANNIO DE APARICION
        SELECT year_aparicion
        INTO anno_ap
        FROM pelicula
        WHERE id_pelicula = p_cod_peli;
        
    
END;
    
-- PROCEDIMIENTO QUE ALMACENA EXCEPCIONES
CREATE OR REPLACE PROCEDURE SP_INSERTAR(p_id_peli NUMBER, p_nomb_peli VARCHAR2, p_universo VARCHAR2, p_cant_heroes NUMBER, p_cant_villanos NUMBER, p_cant_old NUMBER, p_detalle VARCHAR2)
IS
    --ALMACENA EL ERROR DE ORACLE
    msg_oracle error_proceso.error_oracle%TYPE;
BEGIN
    INSERT INTO info_pelicula
    VALUES(p_id_peli,  p_nomb_peli, p_universo, p_cant_heroes, p_cant_villanos, p_cant_old, p_detalle);
EXCEPTION WHEN DUP_VAL_ON_INDEX THEN 
    --ALMACENA EL ERROR DE ORACLE
    msg_oracle := SQLERRM;
    --INSERTA EL ERROR EN LA TABLA CORRESPONDIENTE
    INSERT INTO ERROR_PROCESO
    VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, msg_oracle, 'REGISTRO DUPLICADO');
END;

--PROCEDIMIENTO ALMACENADO QUE GENERA EL INFORME
CREATE OR REPLACE PROCEDURE SP_INFORME IS
    --ALMACENA EL NOMBRE DEL UNIVERSO
    uni_nom universo.nomb_universo%TYPE;
    --ALMACENA LOS HEROES
    p_cant_h NUMBER;
    --ALMACENA LOS VILLANOS
    p_cant_v NUMBER;
    --ALMACENA LOS ANTIGUOS
    p_antiguo NUMBER;
BEGIN
    --PROCESA A LAS PELICULAS
    FOR reg_peli IN c_peliculas LOOP
        --OBTIENE EL NOMBRE DEL UNIVERSO
        uni_nom := fn_nom_universo(reg_peli.cod_universo);
        --OBTIENE LOS HEROES Y VILLANOS
        sp_cant_hyv(reg_peli.id_pelicula, p_cant_h, p_cant_v);
        --OBTIENE CANTIDAD ANTIGUOS
        p_antiguo := fn_aparicion_heroes;
        --INSERTAR RESULTADOS
        SP_INSERTAR(reg_peli.id_pelicula, reg_peli.nombre_pelicula, uni_nom, p_cant_h, p_cant_v, p_antiguo);
    END LOOP;
END;















