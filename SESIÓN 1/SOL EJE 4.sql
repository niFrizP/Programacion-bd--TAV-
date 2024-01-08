--VER RELACION ENTRE CANTIDAD DE HEROE Y VILLANO
        CLASIFICACION := CASE
            WHEN TOTAL_HEROES > TOTAL_VILLANOS THEN 'En el Universo ' || NOMBRE_UNIVERSO || ' hay mas heroes que villanos '
            WHEN TOTAL_HEROES < TOTAL_VILLANOS THEN 'En el Universo ' || NOMBRE_UNIVERSO || ' hay mas villanos que heroes '
            ELSE 'En el Universo ' || NOMBRE_UNIVERSO || ' hay la misma cantidad de heroes y villanos '
        END;
