SET SERVEROUTPUT ON;
DECLARE
  --Almacena el puntaje promedio de poder de SH
  promedio_sh NUMBER;
  --Almacena el ID del sh buscado
  buscado NUMBER := &cod_heroe;
  --Almacena el promedio general de poder de SH
  promedio_sh_gen NUMBER;      
BEGIN
  --OBTENER EL PUNTAJE PROMEDIO DE PODERES DEL SUPERHEROE
  SELECT AVG(puntaje)
  INTO  promedio_sh
  FROM poder p JOIN heroe_poder b ON(p.cod_poder = b.cod_poder)
  WHERE cod_heroe = buscado;
  --OBTENER EL PROMEDIO PUNTAJE GENERAL
  SELECT AVG(puntaje)
  INTO  promedio_sh_gen
  FROM poder;
  --COMPARAR PROMEDIO GENERAL CON PROMEDIO DEL SH
    IF promedio_sh < promedio_sh_gen THEN
      DBMS_OUTPUT.PUT_LINE('Promedio SH es MENOR que el promedio general');
    ELSIF promedio_sh > promedio_sh_gen THEN
      DBMS_OUTPUT.PUT_LINE('Promedio SH es MAYOR que el promedio general');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Promedio SH es IGUAL que el promedio general');
  END IF;
END;

