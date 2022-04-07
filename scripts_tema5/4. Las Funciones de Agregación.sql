drop table if exists empleados cascade;
create table empleados (
	nombre		char(20) primary key,
	salario	   	numeric(4),
	nHorasExtras	integer,
	provincia	char(15)
);


insert into empleados values 	('Pepe', 100, 0,  'BURGOS'),
				('Juan', 200, 10, 'BURGOS'),
				('Ana',  200, 20, 'LEON');

				
SELECT MAX(salario) FROM empleados;

SELECT MAX(0.8*salario) FROM empleados;
SELECT 0.8*MAX(salario) FROM empleados;

SELECT AVG(salario+60*nHorasExtras)
FROM empleados;

/* No funciona porque al condensar el resultado en una fila, que nombre elije y con que criterio
SELECT AVG(salario+60*nHorasExtras), nombre
FROM empleados;
*/

--si que puede ir una cte en la select u otra f. sumaria, pero no una referencia directa a un campo
--en el where no hay esa restriccion
SELECT 'El promedio es: ', AVG(salario+60*nHorasExtras)
FROM empleados
WHERE provincia='BURGOS';

/*no puede haber f. sumarias en la clausuala where
SELECT AVG(salario+60*nHorasExtras)
FROM empleados
WHERE MIN(salario)<100;
*/
------------------------------COUNT---------------------------------------------
SELECT COUNT(*)
FROM empleados
WHERE salario>100;

SELECT COUNT(*)
FROM empleados;

drop table if exists alumnos;
create table alumnos(
	nombre	char(20),
	altura	numeric(3,2),
	nota	numeric(4,2)
);

insert into alumnos values 	('Pepe', 1.70, 2.3),
				('Ana',  1.72, 5.4),
				('Pablo',1.70, null),
				('Pedro',null, 8);

--count y los nulls
SELECT COUNT(*), COUNT(nota)
FROM alumnos WHERE nombre >= 'Pablo';

--count que no cumple ninguna fila  o tabla vacia
SELECT COUNT(*), COUNT(nota)
FROM alumnos
WHERE nombre = 'David';

SELECT COUNT(*), COUNT(nota)
FROM alumnos
WHERE nombre = 'Pablo';

--distinct/all
SELECT COUNT(*), COUNT(DISTINCT altura),
	COUNT(ALL altura), COUNT(altura)
FROM alumnos;

----------------------------MAX y MIN

drop table if exists alumnos;
create table alumnos(
	nombre	char(20),	
	nota	numeric(4,2),
	fechaNac	date
);


insert into alumnos (nombre, fechaNac, nota) values ('Pedro', date '01-10-1983', 2.3),
						    ('Ana',   date '15-12-1980', 10),
						    ('Pablo', date '05-12-1984', null),
						    ('Pepe',  null,		 8),
						    ( null,   null, 		 1),
						    ('Zacarias', null, 		 1);
SELECT MAX( nombre), MIN( FechaNac), MAX(Nota)
FROM alumnos WHERE nombre >= 'Pablo';

--MAX/MIN cuando where no se verifica por ninguna fila o tabla vacia
SELECT MAX( nombre), MIN( FechaNac), MAX(Nota)
FROM alumnos WHERE nombre < 'Ana';

--MAX/MIN cuando where se verifica solo en filas en las q la expresion evaluada es siempre nulo
SELECT MAX( nombre), MIN( FechaNac), MAX(Nota)
FROM alumnos WHERE nombre >= 'Pepe';

---------------------------SUM y AVG

SELECT SUM( nota), SUM( ALL nota), SUM(DISTINCT Nota)
FROM alumnos;

SELECT AVG( nota), AVG( ALL nota), AVG(DISTINCT Nota)
FROM alumnos;