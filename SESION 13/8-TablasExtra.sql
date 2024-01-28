CREATE TABLE info_postulante
(
    run_postulante NUMBER PRIMARY KEY,
    nombre_postulante VARCHAR2(100) NOT NULL,
    antiguedad NUMBER NOT NULL,
    fecha_ultimo_contrato DATE NOT NULL,
    cantidad_trabajos NUMBER NOT NULL,
    ultima_region_trabajo VARCHAR2(100) NOT NULL
);

CREATE TABLE clasificacion_postulante
(
    run_postulante NUMBER PRIMARY KEY,
    fecha_ultimo_contrato DATE NOT NULL,
    clasificacion VARCHAR2(100) NOT NULL
);
