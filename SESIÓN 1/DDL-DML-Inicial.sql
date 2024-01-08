-- Borrado de tablas
DROP TABLE PeliculaPersonaje;
DROP TABLE PersonajePoder;
DROP TABLE Personaje;
DROP TABLE Poder;
DROP TABLE Pelicula;
DROP TABLE Universo;

-- Tabla para universos
CREATE TABLE Universo (
    UniversoID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL
);

-- Tabla para películas
CREATE TABLE Pelicula (
    PeliculaID NUMBER PRIMARY KEY,
    Titulo VARCHAR2(255) NOT NULL,
    AnioLanzamiento NUMBER,
    UniversoID NUMBER,
    FOREIGN KEY (UniversoID) REFERENCES Universo(UniversoID)
);

-- Tabla para personajes
CREATE TABLE Personaje (
    PersonajeID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100) NOT NULL,
    UniversoID NUMBER,
    FOREIGN KEY (UniversoID) REFERENCES Universo(UniversoID)
);

-- Tabla para poderes
CREATE TABLE Poder (
    PoderID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(100) NOT NULL
);

-- Relación entre películas y personajes (muchos a muchos)
CREATE TABLE PeliculaPersonaje (
    PeliculaID NUMBER,
    PersonajeID NUMBER,
    PRIMARY KEY (PeliculaID, PersonajeID),
    FOREIGN KEY (PeliculaID) REFERENCES Pelicula(PeliculaID),
    FOREIGN KEY (PersonajeID) REFERENCES Personaje(PersonajeID)
);

-- Relación entre personajes y poderes (muchos a muchos)
CREATE TABLE PersonajePoder (
    PersonajeID NUMBER,
    PoderID NUMBER,
    PRIMARY KEY (PersonajeID, PoderID),
    FOREIGN KEY (PersonajeID) REFERENCES Personaje(PersonajeID),
    FOREIGN KEY (PoderID) REFERENCES Poder(PoderID)
);

-- Insertar datos en la tabla de universos
-- Insertar datos en la tabla de universos
INSERT INTO Universo (UniversoID, Nombre)
VALUES
    (1, 'Marvel');
INSERT INTO Universo (UniversoID, Nombre)
VALUES	
    (2, 'DC');
-- Insertar datos en la tabla de películas
INSERT INTO Pelicula VALUES(1, 'Avengers: Endgame', 2019, 1);
INSERT INTO Pelicula VALUES(2, 'The Dark Knight', 2008, 2);

-- Insertar datos en la tabla de personajes
INSERT INTO Personaje VALUES(1, 'Iron Man',1);
INSERT INTO Personaje VALUES(2, 'Batman', 2);
INSERT INTO Personaje VALUES(3, 'Thanos', 1);

-- Insertar datos en la tabla de poderes
INSERT INTO Poder (PoderID, Nombre) VALUES(1, 'Vuelo');
INSERT INTO Poder (PoderID, Nombre) VALUES(2, 'Fuerza sobrehumana');

-- Asociar personajes con películas y poderes
INSERT INTO PeliculaPersonaje (PeliculaID, PersonajeID)
VALUES(1, 1);	-- Iron Man en Avengers: Endgame
INSERT INTO PeliculaPersonaje (PeliculaID, PersonajeID)
VALUES(2, 2); -- Batman en The Dark Knight

INSERT INTO PeliculaPersonaje (PeliculaID, PersonajeID)
VALUES(1, 3); -- Thanos en Avengers: endgame

INSERT INTO PersonajePoder (PersonajeID, PoderID)
VALUES(1, 1); -- Iron Man tiene el poder de vuelo
INSERT INTO PersonajePoder (PersonajeID, PoderID)
VALUES(2, 2); -- Batman tiene el poder de fuerza sobrehumana


-- Resto de inserciones...


