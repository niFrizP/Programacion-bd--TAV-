-- Primero creamos la tabla
CREATE TABLE resumen_clientes
(
    periodo VARCHAR2(7) PRIMARY KEY,
    cantidad NUMBER NOT NULL
);
-- Ahora creamos el procedimiento almacenado 
-- para llenar la tabla resumen
CREATE OR REPLACE PROCEDURE sp_resumen
IS
    CURSOR c_periodos IS
        SELECT TO_CHAR(birthday,'MM-YYYY') periodo, 
            COUNT(id) total
        FROM cliente
        GROUP BY TO_CHAR(birthday,'MM-YYYY')
        ORDER BY 1;
BEGIN
    FOR reg_resumen IN c_periodos LOOP
        INSERT INTO resumen_clientes
        VALUES(reg_resumen.periodo, reg_resumen.total);
    END LOOP;
END;

EXEC sp_resumen;

-- Ahora construimos el TRIGGER
CREATE OR REPLACE TRIGGER trg_resumen
AFTER INSERT OR UPDATE OF birthday OR DELETE ON cliente
FOR EACH ROW
BEGIN
    -- Verifica si se trata de una eliminacion
    IF DELETING THEN
        -- Resta UNA unidad a la cantidad del periodo
        -- del regitro que FUE ELIMINADO.
        UPDATE resumen_clientes
        SET cantidad = cantidad - 1
        WHERE periodo = TO_CHAR(:OLD.birthday,'MM-YYYY');
    END IF;
    -- Verifica si se trata de una insercion
    IF INSERTING THEN
        -- Aumenta en una unidad el total del periodo
        -- del nuevo cliente
        UPDATE resumen_clientes
        SET cantidad = cantidad + 1
        WHERE periodo = TO_CHAR(:NEW.birthday,'MM-YYYY');
        -- Verifica si ese periodo existia en la tabla
        IF SQL%ROWCOUNT = 0 THEN
            -- Sabemos que no existia por tanto
            -- corresponde INSERTAR
            INSERT INTO resumen_clientes
            VALUES(TO_CHAR(:NEW.birthday,'MM-YYYY'), 1);
        END IF;
    END IF;
END;
