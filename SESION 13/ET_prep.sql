
-- ENCABEZADO PACKAGE
CREATE OR REPLACE PACKAGE pkg_postulante IS
    -- VARIABLE QUE ALMACENA LA FECHA DE EJECUCION DEL PROCESO
        FEC_EXEC DATE;
    -- VARIABLE QUE ALMACENA EL TOTAL DE POSTULANTES
        TOTAL_POST NUMBER;
    -- FUNCION PUBLICA QUE RETORNA EL TOTAL DE TRABAJOS DEL POSTULANTE
    FUNCTION fn_trabajos_total(p_postulante NUMBER) RETURN NUMBER;
    -- FUNCION PUBLICA QUE RETORNA LA ANTIGUEDAD DEL POSTULANTE
    FUNCTION fn_antiguedad(p_postulante NUMBER) RETURN NUMBER;
END;

--CUERPO DEL PACKAGE
CREATE OR REPLACE PACKAGE BODY pkg_postulante IS
    -- FUNCION PUBLICA QUE RETORNA EL TOTAL DE TRABAJOS DEL POSTULANTE
        CREATE OR REPLACE FUNCTION fn_trabajos_total(p_postulante NUMBER) RETURN NUMBER
        IS
        --ALMACENA EL TOTAL DE TRABAJOS
        TOTAL NUMBER;
        BEGIN
            --OBTENEMOS LA CANTIDAD TOTAL DE TRABAJOS EN LOS QUE HA TENIDO EL POSTULANTE
            SELECT COUNT(1)
            INTO TOTAL
            FROM antecedentes_laborales 
            WHERE a.numrun = p_postulante;   
        END;
    
    -- FUNCION PUBLICA QUE RETORNA LA ANTIGUEDAD DEL POSTULANTE
        CREATE OR REPLACE FUNCTION fn_antiguedad(p_postulante NUMBER) RETURN NUMBER
        IS
            --ALMACENAMOS LA ANTIGUEDAD
            antiguedad NUMBER;
        BEGIN
            --OBTENEMOS LA ANTIGUEDAD DEL POSTULANTE
            SELECT TRUNC(MONTH BETWEEN(SYSDATE, fecha_contrato)/12);
            INTO antiguedad
            FROM antecedentes_laborares
            WHERE numrun = p_postulante;
        END;
END;

--FUNCION ALMACENADA
CREATE OR REPLACE FUNCTION fn_ultima_region (p_postulante)IS
IS
    --ALMACENAMOS LA ULTIMA REGION
    ultima info_postulante.ultima_region_trabajo%TYPE;
BEGIN
    --OBTENEMOS LA ULTIMA REGION DONDE LABURO EL POSTULANTE
    SELECT a.nombre_region
    INTO ultima
    FROM region a JOIN servicio_local_educp b ON(a.cod_region = b.cod_region)
    JOIN antecedentes_laborales c ON(b.cod_serv_educp = c.cod_serv_educp)
    WHERE numrun = p_postulante AND (SELECT MAX(fecha_contrato) FROM antecedentes_laborales WHERE numrun = p_postulante;);
END;
--TRIGGER
CREATE OR REPLACE TRIGGER trg_registro
AFTER INSERT ON info_postulante
FOR EACH ROW
DECLARE
BEGIN
    tiempo_antiguedad := TRUNC(MONTH BETWEEN(SYSDATE, fecha_contrato)/12)
END;
--PROCEDIMIENTO ALMACENADO
CREATE OR REPLACE PROCEDURE IS
CURSOR;
BEGIN

END;
--EJECUCION DEL PROCEDIMIENTO
--02-01-2024    