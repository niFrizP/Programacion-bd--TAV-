CREATE OR REPLACE PACKAGE pkg_heroes IS
    --VARIABLE PARA ALMACENAR EL TOTAL DE HEROES
    TOTAL_HEROES_PROCESADOS NUMBER;
    --FUNCION PUBLICA
    FUNCTION FN_PUNTAJE_PODERES(p_heroe NUMBER)
    RETURN NUMBER;
    --PROCEDIMIENTO PUBLICO
    PROCEDURE SP_INSERTAR(p_heroe NUMBER, p_nombre VARCHAR2, p_universo VARCHAR2, p_nemesis VARCHAR2,
    p_cantidad_poderes NUMBER, p_puntaje NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY pkg_heroes IS
    FUNCTION fn_puntaje(p_heroe NUMBER) RETURN NUMBER
    IS
        TOTAL NUMBER;
    BEGIN
        SELECT NVL(SUM(puntaje),0)
        INTO TOTAL
        FROM poder a JOIN heroe_poder b ON(a.cod_poder = b.cod_poder)
        WHERE cod_heroe = p_heroe;
        RETURN TOTAL;
    END;
    PROCEDURE sp_insertar(p_heroe NUMBER, p_nombre VARCHAR2, p_universo VARCHAR2, p_nemesis VARCHAR2, 
    p_cantidad_poderes NUMBER, p_puntaje NUMBER)
    IS
        msg_oracle error_proceso.descripcion%TYPE;
    BEGIN
        INSERT INTO info_heroe
        VALUES(p_hero, p_nombre, p_universo, p_nemesis, p_cantidad_poderes, p_puntaje);
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        msg_oracle := SQLERRM;
        INSERT INTO error_proceso
        VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, 'EJECUCION', msg_oracle, USER);
    END;
END;

--FUNCION ALMACENADA
CREATE OR REPLACE FUNCTION fn_nemesis(p_cod_heroe NUMBER)
RETURN VARCHAR2
IS
    nombre_nemesis info_heroe.nombre_nemesis%TYPE;
    msg_oracle error_proceso.descripcion%TYPE;
BEGIN
    SELECT b.nomb_villano
    INTO nombre_nemesis
    FROM heroe_villano a JOIN villano b ON(a.cod_villano = b.cod_villano)
    WHERE a.cod_heroe = p_cod_heroe AND LOWER(esnemesis) = 'si';
    RETURN nombre_nemesis;
EXCEPTION WHEN NO_DATA_FOUND THEN
    msg_oracle := SQLERRM;
    INSERT INTO error_proceso
    VALUES(SEQ_ERROR.NEXTVAL, SYSDATE, 'EJECUCION', msg_oracle, USER);
    RETURN 'SIN NEMESIS';
END;


CREATE OR REPLACE PROCEDURE sp_informe(p_limite NUMBER)
IS
    CURSOR c_heroes(p_limite_antiguedad NUMBER) IS
        SELECT cod_heroe, nomb_heroe, nomb_universo
        FROM superheroe a JOIN universo b
            ON(a.cod_universo = b.cod_universo)
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_aparicion)/12)>p_limite_antiguedad;
    nom_nemesis info_heroe.nombre_nemesis%TYPE;
    --ALMACENA EL TOTAL DE PODER
    TOTAL_PODER NUMBER;
BEGIN
    FOR reg_heroe IN c_heroes(p_limite) LOOP
        --OBTIENE EL NOMBRE DEL NEMESIS
        nom_nemesis := fn_nemesis(reg_heroe.cod_heroe);
        --OBTIENE LA CANTIDAD DE PODERES
        SELECT COUNT(cod_poder)
        INTO TOTAL_PODER
        FROM heroe_poder
        WHERE cod_heroe = reg_heroe.cod_poder;
        --OBTIENE EL PUNTAJE
        puntaje_total := pkg_heroes.fn_puntaje_poderes
    END LOOP;
END;


--TRIGGER
CREATE OR REPLACE TRIGGER trg_heroe
AFTER INSERT ON heroe_poder
FOR EACH ROW
DECLARE
puntaje_new NUMBER;
nom_heroe info_heroe.nombre%TYPE;
nom_univ info_heroe.universo%TYPE;
n_nemesis info_heroe.nombre_nemesis%TYPE;
BEGIN
    --BUSCAR EL PUNTAJE DEL NUEVO PODER
    SELECT puntaje INTO puntaje_new
    FROM poder
    WHERE cod_poder = :NEW.cod_poder;
    --ACTUALIZA LA TABLA INFO_HEROE
    UPDATE info_heroe
    SET cantidad_poderes = cantidad_poderes + 1,
        puntaje_poderes = puntaje_poderes + puntaje_new
    WHERE id_heroe = :NEW.cod_heroe;
    
    IF SQL%ROWCOUNT = 0 THEN
        --RESCATA EL NOMBRE Y UNIVERSO DEL HEROE
        SELECT NOMB_HEROE, nomb_universo  INTO nom_heroe, nom_univ
        FROM SUPERHEROE a JOIN UNIVERSO b ON(a.cod_universo = b.cod_universo)
        WHERE cod_heroe = :NEW.cod_heroe;
        --RESCATA EL NOMBRE DEL NEMESIS
        n_nemesis := fn_nemesis(:NEW.cod_heroe);
        
        INSERT INTO info_heroe
        VALUES(:NEW.cod_heroe, nombre_heroe, nombre_universo, n_nemesis, 1, puntaje_new)
    END IF;

