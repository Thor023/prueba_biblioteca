--Crear base de datos llamada biblioteca
CREATE DATABASE biblioteca;
-- PASAR A LA DATABASE CON comando \c NombreBase
\c biblioteca
--Crear tablas correspondientes a la base de datos
--SOCIO
CREATE TABLE socio(
    rut VARCHAR (12),
    nombre VARCHAR (30),
    apellido VARCHAR (30),
    direccion VARCHAR (255),
    telefono VARCHAR (15),
    PRIMARY KEY (rut)
);
--LIBRO
CREATE TABLE libro(
    ISBN VARCHAR (20),
    titulo VARCHAR(250),
    paginas INT,
    PRIMARY KEY (ISBN)
);
--AUTOR   
CREATE TABLE autor(
    codigo_autor VARCHAR (20),
    nombre_autor VARCHAR (50),
    apellido_autor VARCHAR (50),
    ano_nacimiento int null,
    ano_muerte int null,
    PRIMARY KEY (codigo_autor)
);
--LIBRO_AUTOR 
CREATE TABLE libro_autor(
    ISBN VARCHAR (20),
    codigo_autor VARCHAR (20),
    tipo_autor VARCHAR(50),
    FOREIGN KEY (ISBN) REFERENCES libro(ISBN),
    FOREIGN KEY (codigo_autor) REFERENCES autor (codigo_autor)
);
--PRESTAMO
CREATE TABLE prestamo(
    prestamo_id SERIAL,
    rut_socio VARCHAR (12),
    ISBN_libro VARCHAR (20),
    fecha_inicio DATE,
    fecha_devolucion DATE,
    PRIMARY KEY (prestamo_id),
    FOREIGN KEY (rut_socio) REFERENCES socio (rut),
    FOREIGN KEY (ISBN_libro) REFERENCES libro (ISBN)
);

--INSERTAR LOS REGISTROS SEGUN CORRESPONDA.-

--TABLA SOCIO
INSERT INTO socio (rut, nombre, apellido, direccion, telefono) values
    (1111111-1, 'JUAN', 'SOTO','AVENIDA 1 SANTIAGO', 91111111),
    (2222222-2, 'ANA', 'PEREZ','PASAJE 2 SANTIAGO', 92222222),
    (3333333-3, 'SANDRA', 'AGUILAR','AVENIDA 2 SANTIAGO', 93333333),
    (4444444-4, 'ESTEBAN', 'JEREZ','AVENIDA 3 SANTIAGO', 94444444),
    (5555555-5, 'SILVANA', 'MUÑOZ','PASAJE 3 SANTIAGO', 95555555);

--TABLA LIBRO
INSERT INTO libro (ISBN, titulo, paginas) values
    (111-111-1111-111, 'CUENTOS DE TERROR', 344),
    (222-222-2222-222, 'POESIAS CONTEMPORANEAS', 167),
    (333-333-3333-333, 'HISTORIA DE ASIA', 511),
    (444-444-4444-444, 'MANUAL DE MECANICA', 298);

--TABLA AUTOR
INSERT INTO autor (codigo_autor, nombre_autor, apellido_autor, ano_nacimiento, ano_muerte) values
    (1,'ANDRES','ULLOA',1982,null),
    (2,'SERGIO','MARDONES',1950,2012),
    (3,'JOSE','SALGADO',1968,2020),
    (4,'ANA','SALGADO',1972,null),
    (5,'MARTIN','PORTA',1976,null);    

--TABLA LIBRO_AUTOR
INSERT INTO libro_autor( ISBN, codigo_autor, tipo_autor) values
    (111-111-1111-111, 3, 'PRINCIPAL'),
    (111-111-1111-111, 4, 'COAUTOR'),
    (222-222-2222-222, 1, 'PRINCIPAL'),
    (333-333-3333-333, 2, 'PRINCIPAL'),
    (444-444-4444-444, 5, 'PRINCIPAL');

--TABLA PRESTAMO
INSERT INTO prestamo( rut_socio, ISBN_libro, fecha_inicio, fecha_devolucion) values
    (1111111-1, 111-111-1111-111, '20-01-2020', '27-01-2020' ),
    (5555555-5, 222-222-2222-222, '20-01-2020', '30-01-2020' ),
    (3333333-3, 333-333-3333-333, '22-01-2020', '30-01-2020' ),
    (4444444-4, 444-444-4444-444, '23-01-2020', '30-01-2020' ),
    (2222222-2, 111-111-1111-111, '27-01-2020', '04-02-2020' ),
    (1111111-1, 444-444-4444-444, '31-01-2020', '12-02-2020' ),
    (3333333-3, 222-222-2222-222, '31-01-2020', '12-02-2020' );


--Realizar las consultas:

--a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)

SELECT isbn, titulo, paginas
FROM libro
WHERE paginas < 300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970.(0.5 puntos)

SELECT codigo_autor, nombre_autor, apellido_autor, ano_nacimiento
FROM autor
WHERE ano_nacimiento > 1970;

--c. ¿Cuál es el libro más solicitado? (0.5 puntos).

SELECT  ISBN_libro, libro.titulo, count(ISBN_libro) as total
FROM prestamo
INNER JOIN libro ON prestamo.ISBN_libro = ISBN
group by ISBN_libro, libro.titulo
order by 3 desc;

--d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días.(0.5 puntos)

select rut_socio, socio.nombre, socio.apellido,((fecha_devolucion-fecha_inicio)-7) as dias_retraso,((fecha_devolucion - fecha_inicio)-7)*100 as multa_total
from prestamo
INNER JOIN socio ON prestamo.rut_socio = rut
where (fecha_devolucion-fecha_inicio) > 7;