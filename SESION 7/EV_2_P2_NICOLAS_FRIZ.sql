DECLARE
    --ALMACENAMOS LAS PELICULAS
    CURSOR C_PELICULAS IS 
        SELECT id_pelicula,nombre_pelicula,year_aparicion
        FROM pelicula
        ORDER BY year_aparicion ASC;
        
    --ALMACENAMOS LOS HEROES
    CURSOR C_HEROES(P_PELICULA NUMBER) IS
        SELECT a.cod_heroe, a.nomb_heroe, a.fecha_aparicion, b.id_pelicula
        FROM SUPERHEROE a JOIN elenco_heroes b ON(a.cod_heroe = b.cod_heroe)
        WHERE b.id_pelicula = P_PELICULA;
    
    --ALMACENAMOS EL PUNTAJE DEL HEROE
    PTJE_PODER NUMBER;
    --ALMACENAMOS LA ANTIGUEDAD DE LA PELICULA
    ANTIGUEDAD NUMBER;
    --ALMACENAMOS LA EDAD DEL HEROE AL MOMENTO DE ESTRENO DE PELICULA
    ANT_HEROE NUMBER;
    --ALMACENAMOS EL TOTAL DE HEROES QUE PARTICIPARON EN LA PELICULA
    TOTAL_HEROES NUMBER;
    --ALMACENAMOS EL PUNTAJE TOTAL DE LOS HEROES
    PTJE_TOTAL NUMBER;
    --ALMACENAMOS LA CLASIFICACION SEGUN LA REGLA DE NEGOCIO
    CLASIFICACION DETALLE_PELICULA.CLASIFICACION%TYPE;
    
BEGIN
    --BORRAR LOS REGISTROS DE LAS TABLAS
    EXECUTE IMMEDIATE 'TRUNCATE TABLE INFO_PELICULA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_PELICULA';
        --RECORREMOS LAS PELICULAS
        FOR reg_peli IN C_PELICULAS LOOP
        
        --OBTENEMOS LA ANTIGUEDAD DE LA PELICULA
        ANTIGUEDAD :=  EXTRACT(YEAR FROM SYSDATE)-reg_peli.year_aparicion;
    
        --RECORREMOS LOS HEROES DE LAS PELICULAS
        FOR reg_heroe IN C_HEROES(reg_peli.id_pelicula) LOOP
        
        --PUNTAJE TOTAL DEL HEROES QUE PARTICIPARON EN LA PELICULA
        SELECT NVL(SUM(a.puntaje),0)
        INTO PTJE_PODER
        FROM poder a JOIN heroe_poder b ON(a.cod_poder = b.cod_poder) JOIN superheroe c ON(b.cod_heroe = c.cod_heroe)
        JOIN elenco_heroes d ON(c.cod_heroe = d.cod_heroe)
        WHERE b.cod_heroe = reg_heroe.cod_heroe AND d.id_pelicula = reg_heroe.id_pelicula;
        
        --CANTIDAD DE AÑOS DEL HEROE AL MOMENTO DEL ESTRENO DE LA PELICULA.
        ANT_HEROE :=  reg_peli.year_aparicion - EXTRACT(YEAR FROM reg_heroe.fecha_aparicion);
        
        --TOTAL DE HEROES QUE APARECIERON EN LA PELICULA
        SELECT NVL(COUNT(cod_heroe), 0)
        INTO TOTAL_HEROES
        FROM ELENCO_HEROES
        WHERE id_pelicula = reg_heroe.id_pelicula;
        
        --PUNTAJE TOTAL DE TODOS LOS PODERES DE LOS HEROES
        SELECT NVL(SUM(PUNTAJE), 0)
        INTO PTJE_TOTAL
        FROM PODER a JOIN heroe_poder b ON(a.cod_poder = b.cod_poder)
        WHERE b.cod_heroe = reg_heroe.cod_heroe;
        
        --OBTENEMOS LA CATEGORIA EN BASE A LA REGLA DE NEGOCIO
        CLASIFICACION :=
            CASE
                WHEN ANT_HEROE < 10 THEN
                'RECIENTE'
                WHEN ANT_HEROE BETWEEN 11 AND 60 THEN
                'ANTIGUO'
                WHEN ANT_HEROE > 60 THEN
                'ICONICO'
            END;
            
        
        --INSERTAMOS EL DETALLE
        INSERT INTO DETALLE_PELICULA VALUES(reg_heroe.id_pelicula, reg_heroe.cod_heroe, reg_heroe.nomb_heroe, ant_heroe, clasificacion, PTJE_TOTAL);
        END LOOP;
        
        --INSERTAMOS EL INFORME
        INSERT INTO INFO_PELICULA VALUES(reg_peli.id_pelicula, reg_peli.nombre_pelicula, reg_peli.year_aparicion, antiguedad, ptje_poder, total_heroes);
    END LOOP;
END;