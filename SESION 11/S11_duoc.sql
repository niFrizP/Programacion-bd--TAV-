--CREAMOS LA TABLA
CREATE TABLE resumen_cliente
(
    periodo VARCHAR2(7) PRIMARY KEY,
    cantidad NUMBER NOT NULL
);
--PROCEDIMIENTO PARA LLENAR LA TABLA
DROP PROCEDURE sp_resumen;

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
        INSERT INTO resumen_cliente
        VALUES(reg_resumen.periodo, reg_resumen.total);
    END LOOP;
END;

EXEC sp_resumen;

--AHORA CONSTRUIMOS EL TRIGGER
CREATE OR REPLACE TRIGGER trg_resumen
AFTER INSERT OR UPDATE OF birthday OR DELETE ON cliente
FOR EACH ROW
BEGIN
    --VERIFICA SI SE TRATA DE UNA ELIMINACION
    IF DELETING THEN
        --RESTA UNA UNIDAD EN LA CANTIDAD DEL PERIODO DEL REGISTRO ELIMINADO
        UPDATE resumen_cliente
        SET cantidad = cantidad - 1
        WHERE periodo = TO_CHAR(:OLD.birthday, 'MM-YYYY');
    END IF;
    --VERIFICA SI SE TRATA DE UNA INSERCION
    IF INSERTING THEN
        --AUMENTA EN UNA CANTIDAD EL PERIODO DEL NUEVO CLIENTE
        UPDATE resumen_cliente
        SET cantidad = cantidad + 1
        WHERE periodo = TO_CHAR(:NEW.birthday, 'MM-YYYY');
        IF SQL%ROWCOUNT = 0 THEN
            --EN CASO QUE NO EXISTA SE INSERTA NADA MAS
            INSERT INTO resumen_cliente
            VALUES(TO_CHAR(:NEW.birthday, 'MM-YYYY'),1);
        END IF;
    END IF;
    --VERIFICA SI SE TRATA DE UNA ACTUALIZACION
    IF UPDATING THEN
        --RESTA UNA UNIDAD EN EL PERIODO
        UPDATE resumen_cliente
        SET cantidad = cantidad - 1
        WHERE periodo = TO_CHAR(:OLD.birthday, 'MM-YYYY');
        --AUMENTA UNA UNIDAD EN EL PERIODO
        UPDATE resumen_cliente
        SET cantidad = cantidad + 1
        WHERE periodo = TO_CHAR(:NEW.birthday, 'MM-YYYY');
        --VERIFICA SI HAY EXISTENCIAS
        IF SQL%ROWCOUNT = 0 THEN
            --EN CASO QUE NO EXISTA SE INSERTA NADA MAS
            INSERT INTO resumen_cliente
            VALUES(TO_CHAR(:NEW.birthday, 'MM-YYYY'),1);
        END IF;
    END IF;
END;

insert into Cliente (id, first_name, last_name, birthday) values (1231, 'Juan', 'Veloz', '30/12/1931');

delete from cliente WHERE id = 279;

 update cliente set cliente.birthday='01/01/1932'
  where id='592';

 update cliente set cliente.birthday='01/01/1931'
  where id='592';
  
  SELECT EXTRACT(MONTH FROM birthday)
  FROM cliente
where id='592';