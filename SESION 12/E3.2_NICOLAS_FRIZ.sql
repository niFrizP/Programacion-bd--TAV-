--FUNCION ALMACENADA
CREATE OR REPLACE FUNCTION fn_total_hero (p_origen NUMBER)
RETURN NUMBER
IS
--ALMACENA EL TOTAL DE HEROES CON PODERES DEL ORIGEN
total_heroes info_origen.cantidad_heroes%TYPE;
BEGIN
--OBTENEMOS EL TOTAL DE HEROES CON PODERES DEL ORIGEN INDICADO
    SELECT COUNT(cod_heroe)
    INTO total_heroes
    FROM HEROE_PODER
    WHERE cod_origen = p_origen;
    RETURN total_heroes;
END;

--ENCABEZADO PACKAGE CON PROCEDIMIENTO Y FUNCION PUBLICA
CREATE OR REPLACE PACKAGE pkg_heroes IS
    -- VARIABLE QUE ALMACENA EL PORCENTAJE MINIMO
    PORCENTAJE_MIN  NUMBER := 0.3;
    -- PROCEDIMIENTO PUBLICO
    PROCEDURE sp_insertar(p_origen NUMBER, p_nombre VARCHAR2,
    p_cant_hero NUMBER, p_prop NUMBER);
    --FUNCION PUBLICA
    FUNCTION fn_proporcion(p_origen NUMBER) RETURN NUMBER;
END;

--CUERPO PACKAGE CON PROCEDIMIENTO Y FUNCION PUBLICA
CREATE OR REPLACE PACKAGE BODY pkg_heroes IS
    --PROCEDIMIENTO PUBLICO
    PROCEDURE sp_insertar(p_origen NUMBER, p_nombre VARCHAR2,
    p_cant_hero NUMBER, p_prop NUMBER)
    IS
        msg_oracle errores_proceso.descripcion%TYPE;
    BEGIN
        INSERT INTO INFO_ORIGEN
        VALUES(p_origen , p_nombre ,
    p_cant_hero , p_prop );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
        msg_oracle := SQLERRM;
        INSERT INTO errores_proceso
        VALUES(SEQ_ERROR.NEXTVAL, 'EJECUCION',
        msg_oracle);
    END;
    --FUNCION PUBLICA
    FUNCTION fn_proporcion(p_origen NUMBER) RETURN NUMBER
    IS
        --ALMACENA EL TOTAL DE PODERES DE ORIGEN
        total_origen   NUMBER;
        --ALMACENA EL TOTAL DE PODERES REGISTRADOS
        total_poderes  NUMBER;
        --ALMACENA LA PROPORCION
        proporcion     NUMBER;
        --DECLARA LA EXCEPCION
        error_negocio EXCEPTION;

    BEGIN  
        --OBTENEMOS EL TOTAL DE PODERES REGISTRADOS
        SELECT COUNT(*) 
        INTO total_poderes 
        FROM PODER;
            
        --OBTENEMOS EL TOTAL DE PODERES DE ORIGEN
        total_origen := fn_total_hero(p_origen);


        --CALCULAMOS LA PROPORCION
        IF total_poderes > 0 THEN
            proporcion := total_origen / total_poderes;
        ELSE
            proporcion := 0;
        END IF;
                
        IF proporcion < porcentaje_min THEN
            RAISE error_negocio;
        END IF;
        RETURN proporcion;
        EXCEPTION WHEN error_negocio THEN
        INSERT INTO errores_proceso
        VALUES(seq_error.NEXTVAL, 'NEGOCIO', 'ORIGEN' || p_origen || 'CUENTA CON -% DE HEROES QUE EL LIMITE IGUAL A ' || PORCENTAJE_MIN);
        RETURN proporcion;
    END;
END;

--PROCEDIMIENTO ALMACENADO
CREATE OR REPLACE PROCEDURE sp_informe(p_min_heroes NUMBER) 
IS
    CURSOR c_origen IS
    SELECT a.cod_origen, a.nomb_origen
    FROM origen a JOIN heroe_poder b ON(a.cod_origen = b.cod_origen)
    GROUP BY a.cod_origen, a.nomb_origen
    HAVING COUNT(cod_heroe) > p_min_heroes;
    --FUNCION TOTAL_HERO
    cant_hero NUMBER;
    --FUNCION PROPORCION
    prop NUMBER;
BEGIN
    FOR reg_info IN c_origen LOOP
        prop := pkg_heroes.fn_proporcion(reg_info.cod_origen);
        cant_hero := fn_total_hero(reg_info.cod_origen);
        --INSERTA EL INFORME
        pkg_heroes.sp_insertar(reg_info.cod_origen,
        reg_info.nomB_origen, cant_hero, prop);
    END LOOP;
END;

-- Llamar al procedimiento
EXEC sp_informe (0);

--TRIGGER
   CREATE OR REPLACE TRIGGER trg_insert_info_origen
   AFTER INSERT ON INFO_ORIGEN
   FOR EACH ROW
   DECLARE
    observacion resumen_origen.observacion%TYPE;
   BEGIN
   observacion:=
        CASE WHEN :NEW.proporcion < 0.3 THEN 'BASICO'
        WHEN :NEW.proporcion BETWEEN 0.3 AND 0.5 THEN 'NORMAL'
        WHEN :NEW.proporcion BETWEEN 0.5 AND 0.9 THEN 'ALTO'
        ELSE 'EXCELENCIA' END;
      INSERT INTO RESUMEN_ORIGEN (id_origen, proporcion, observacion)
      VALUES (:NEW.id_origen,:NEW.proporcion,observacion);
   END;

   




