DECLARE
    --ALMACENAMOS LOS VILLANOS A PROCESAR
    CURSOR c_villanos (
        p_min_mal NUMBER,
        p_max_mal NUMBER
    ) IS
    SELECT
        cod_villano,
        nomb_villano,
        nivel_maldad
    FROM
        villano
    WHERE
        nivel_maldad >= p_min_mal AND nivel_maldad <= p_max_mal;
        
    --ALMACENA EL MINIMO NIVEL DE MALDAD LEIDO DESDE TECLADO.
    min_mal             NUMBER := &min_mal;
    --ALMACENA EL MAXIMO NIVEL DE MALDAD LEIDO DESDE TECLADO.
    max_mal             NUMBER := &max_mal;
    --ALMACENA EL PUNTAJE TOTAL DE PODERES DE UN VILLANO.
    puntaje_total       NUMBER;
    --ALMACENA LA OBSERVACION DE UN VILLANO.
    observacion_villano informe_villanos.observacion%TYPE;
    --ALMACENA EL DETALLE DE NEMESIS DE UN VILLANO.
    detalle_nemesis     informe_villanos.es_nemesis_de%TYPE;
    --ALMACENA EL NOMBRE DEL SUPERHEROE NEMESIS DE UN VILLANO.
    heroe_nom           informe_villanos.es_nemesis_de%TYPE;
BEGIN
    --SE ELIMINAN LOS REGISTROS DE LA TABLA INFORME_VILLANOS
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFORME_VILLANOS';
    
    --SE RECORREN LOS VILLANOS A PROCESSAR
    FOR reg_evil IN c_villanos(min_mal, max_mal) LOOP 
        --OBTENEMOS EL PUNTAJE TOTAL DE PODERES
        SELECT
            nvl(SUM(puntaje),
                0)
        INTO puntaje_total
        FROM
                 villano_poder a
            JOIN poder b ON ( a.cod_poder = b.cod_poder )
        WHERE
            a.cod_villano = reg_evil.cod_villano;

    --DETERMINAMOS LA OBSERVACION DE ACUERDO A LA REGLA DE NEGOCIO.
        observacion_villano :=
            CASE
                WHEN puntaje_total = 0 THEN
                    'SIN PODERES'
                WHEN puntaje_total > reg_evil.nivel_maldad THEN
                    'PUNTAJE TOTAL DE PODERES SUPERIOR A SU NIVEL DE MALDAD'
                WHEN puntaje_total <= reg_evil.nivel_maldad THEN
                    'PUNTAJE TOTAL DE PODERES ES IGUAL O INFERIOR A SU NIVEL DE MALDAD'

            END;
    
    --BUSCAMOS INFORMACION PARA REALIZAR LA REGLA DE NEGOCIO.
        SELECT
            b.nomb_heroe, a.esnemesis
        INTO  heroe_nom, detalle_nemesis
        FROM
            heroe_villano a
            JOIN superheroe b ON (a.cod_heroe = b.cod_heroe)
        WHERE
            a.cod_villano = reg_evil.cod_villano;

        
    
    --DETERMINAMOS SI EL VILLANO ES NEMESIS DE ALGUN SUPERHEROE
        IF detalle_nemesis = 'NO' THEN
            detalle_nemesis := 'NO ES NEMESIS DE NINGUN SUPERHEROE';
        ELSE
            detalle_nemesis := 'ES NEMESIS DE ' || UPPER(heroe_nom);
        END IF;
    
    --INSERTAMOS EL REGISTRO EN LA TABLA INFORME_VILLANOS
        INSERT INTO informe_villanos VALUES (
            reg_evil.cod_villano,
            reg_evil.nomb_villano,
            reg_evil.nivel_maldad,
            puntaje_total,
            observacion_villano,
            detalle_nemesis
        );

    END LOOP;
END;