/*
USANDO EL PRIMER MODELO 

Construir un blpoque anonimo que permita imprimir el nombre del personaje
que registra menos poderes.

El nombre se debe imprimir en mayusculas
*/

DECLARE
  --Variable que almacena el nombre del personaje
    nombre_pers   personaje.nombre%TYPE;
  --Variable que almacena el id del personaje
    id_pers    NUMBER;
  --Variable que almacena el id de poderes
    power_pers personajepoder.poderid%TYPE;
  --ALMACENA EL TOTAL de poderes
    total NUMBER;
BEGIN
    --OBTENER EL NOMBRE DEL PERSONAJE
    SELECT
        nombre
    INTO nombre_pers
    FROM
        personaje
    WHERE
        personajeid = id_pers;
        
    --OBTENEMOS CANTIDAD DE PODERES
    SELECT
        MIN(poderid)
    INTO total
    FROM
        personajepoder
    WHERE
        poderid = power_pers; 

    --VERIFICAMOS PODERES
    IF total = (>1)
    then
        dbms_output.put_line ( nombre_pers || ' es el personaje con menos poderes ' );
    end
        if;
        end;