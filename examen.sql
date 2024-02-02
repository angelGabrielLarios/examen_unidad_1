-- Active: 1702943187359@@127.0.0.1@3306@exa_biblioteca
CREATE DATABASE exa_biblioteca;

USE exa_biblioteca;

CREATE TABLE colegios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);



CREATE TABLE  asignaturas(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE aulas(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE profesores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    apellido VARCHAR(120) NOT NULL,
    id_colegio INT NOT NULL,
    id_aula INT NOT NULL,
    id_curso INT NOT NULL,
    FOREIGN KEY(id_colegio) REFERENCES colegios(id),
    FOREIGN KEY(id_aula) REFERENCES aulas(id),
    FOREIGN KEY(id_curso) REFERENCES cursos(id)
);

CREATE TABLE editoriales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    id_editorial INT,
    FOREIGN KEY (id_editorial) REFERENCES editoriales(id)
);




CREATE TABLE profesores_asignaturas(
    id_profesor INT NOT NULL,
    id_asignatura INT NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES profesores(id),
    FOREIGN KEY (id_asignatura) REFERENCES asignaturas(id) 
);



INSERT INTO colegios
(nombre)
VALUES 
('C.P Cervantes'),
('C.P Quevedo');


CREATE TABLE prestamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_profesor INT NOT NULL,
    id_libro INT NOT NULL,
    fecha_prestamo DATE,
    FOREIGN KEY (id_profesor) REFERENCES profesores(id),
    FOREIGN KEY (id_libro) REFERENCES libros(id)
);




INSERT INTO asignaturas
(nombre)
VALUES 
('Pensamiento Lógico'),
('Escritura'),
('Pensamiento Numerico'),
('Pensamiento Espacial'),
('Temporal y Causal'),
('Ingles');

INSERT INTO aulas
(nombre)
VALUES 
('1.A01'),
('1.B01'),
('2.B01');

INSERT INTO cursos
(nombre)
VALUES 
('1er Grado'),
('2do Grado');

INSERT INTO profesores
(nombre, apellido,id_colegio,id_curso, id_aula)
VALUES 
('Juan', 'Pérez', 1, 1, 1),
('Alicia', 'García', 1, 1,2),
('Andrés', 'Fernández', 1, 2, 1),
('Juan', 'Méndez',2 ,1, 3);

INSERT INTO profesores_asignaturas
(id_profesor, id_asignatura)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 3),
(3, 2),
(3, 6),
(4, 1),
(4, 3);




INSERT INTO editoriales
(nombre)
VALUES 
('Graó'),
('Técnicas Rubio'),
('Prentice Hall'),
('Temas de Hoy');


INSERT INTO libros
(nombre, id_editorial)
VALUES 
('Aprender y enseñar en educación infantil',1),
('Preescolar Rubio, N56',2),
('Educación Infantil N9',3),
('Sabes educar: guía para Padres y Profesores', 4);


INSERT INTO prestamos
(id_profesor, id_libro, fecha_prestamo)
VALUES 
(1, 1, STR_TO_DATE('09/09/2010', '%d/%m/%Y')),
(1, 2, STR_TO_DATE('05/05/2010', '%d/%m/%Y')),
(1, 1, STR_TO_DATE('05/05/2010', '%d/%m/%Y')),
(2, 3, STR_TO_DATE('06/05/2010', '%d/%m/%Y')),
(2, 1, STR_TO_DATE('06/05/2010', '%d/%m/%Y')),
(3, 1, STR_TO_DATE('09/09/2010', '%d/%m/%Y')),
(3, 4, STR_TO_DATE('05/05/2010', '%d/%m/%Y')),
(4, 4, STR_TO_DATE('18/12/2010', '%d/%m/%Y')),
(4, 1, STR_TO_DATE('06/05/2010', '%d/%m/%Y'));



/* mi consulta general */
SELECT 
prestamos.id as id_prestamos,
profesores.nombre as nombre_profesor,
profesores.apellido as apellido_profesor,
libros.nombre as nombre_libro,
DATE_FORMAT(prestamos.fecha_prestamo, '%d/%m/%Y') as fecha_prestamo
FROM
prestamos
INNER JOIN profesores
ON profesores.id = prestamos.id_profesor
INNER JOIN libros
ON libros.id = prestamos.id_libro
ORDER BY profesores.nombre, profesores.apellido,libros.nombre ASC;


/* 
1) Los libros que se han prestado 06/05/2010 al 09/09/2010. 
*/
SELECT 
    DISTINCT libros.nombre as nombre_libro
FROM
prestamos
INNER JOIN profesores
ON profesores.id = prestamos.id_profesor
INNER JOIN libros
ON libros.id = prestamos.id_libro
WHERE prestamos.fecha_prestamo BETWEEN STR_TO_DATE('06/05/2010', '%d/%m/%Y') AND STR_TO_DATE('09/09/2010', '%d/%m/%Y');



/* 
2) Qué libros ha solicitado el profesor Juan Pérez 
*/
SELECT 
DISTINCT
libros.nombre as nombre_libro
FROM
prestamos
INNER JOIN profesores
ON profesores.id = prestamos.id_profesor
INNER JOIN libros
ON libros.id = prestamos.id_libro
WHERE profesores.nombre = "Juan" and profesores.apellido = "Pérez";


/*
3) agregar la editorial 
*/
INSERT INTO editoriales
(nombre)
VALUES ('UTSH');


SELECT 

/* 
4) - Listar que profesores hacen uso del Aula 1.A01 
*/

SELECT 
profesores.nombre as nombre_profesor,
profesores.apellido as apellido_profesor
FROM 
profesores 
INNER JOIN aulas 
ON profesores.id_aula = aulas.id
WHERE aulas.nombre = '1.A01';




/* 
5) Listar los libros que se han empleado para el curso de 1er. Grado 
*/
SELECT 
DISTINCT libros.nombre as nombre_libro
FROM
prestamos
INNER JOIN profesores
ON profesores.id = prestamos.id_profesor
INNER JOIN cursos 
on cursos.nombre = profesores.id_curso
INNER JOIN libros
ON libros.id = prestamos.id_libro
WHERE cursos.nombre = '1er Grado';


/* 
6) Listar El nombre del profesor y la fecha que solicitaron el libro “Aprender y Enseñar en la Educación
Infantil” 
*/

SELECT 
DISTINCT profesores.nombre as nombre_profesor,
profesores.apellido as apellido_profesor,
DATE_FORMAT(prestamos.fecha_prestamo, '%d/%m/%Y') as fecha_prestamo
FROM
prestamos
INNER JOIN profesores
ON profesores.id = prestamos.id_profesor
INNER JOIN libros
ON libros.id = prestamos.id_libro
WHERE libros.id = 1
ORDER BY fecha_prestamo ASC;


/* 
7) Diseñar una consulta que pueda indicar que libro es el que se ha solicitado más. 
*/
SELECT 
libros.nombre as nombre_libro,
COUNT(libros.id) as num_veces_solicitado
FROM
prestamos
INNER JOIN profesores
ON profesores.id = prestamos.id_profesor
INNER JOIN libros
ON libros.id = prestamos.id_libro
GROUP BY libros.id 
ORDER BY num_veces_solicitado DESC
LIMIT 1;













