drop table if exists expedientes;

create table expedientes(
	nombre     varchar(40),
	asignatura varchar(40),
	nota       numeric(3,1),
	primary key ( nombre, asignatura)
);

insert into expedientes values ( 'Pepe',  'FISICA',  6), ('Pepe',  'CALCULO', 5),					
			       ( 'Juan',  'CALCULO', 4), ('Juan',  'FISICA',  4),
			       ( 'Maria', 'CALCULO', 4), ('Maria', 'FISICA',  7),
				('Ana',   'FISICA',  5), ('Julio', 'INGLES',  9);

--1 asignatura, nombre, nota de los alumnos ordenados por asignatura, nota descendente y nombre
select asignatura, nombre, nota
from expedientes
order by asignatura, nota DESC, nombre;

/*Solución:
"CALCULO";	"Pepe";		5.0
"CALCULO";	"Juan";		4.0
"CALCULO";	"Maria";	4.0
"FISICA";	"Maria";	7.0
"FISICA";	"Pepe";		6.0
"FISICA";	"Ana";		5.0
"FISICA";	"Juan";		4.0
"INGLES";	"Julio";	9.0
*/

--2 asignatura, nombre, nota de los  alumnos que han aprobado cada asignatura ordenados por asignatura, nota descendente y nombre
select asignatura, nombre, nota
from expedientes
where nota>=5
order by asignatura, nota DESC, nombre;

/*Solución:
"CALCULO";	"Pepe";		5.0
"FISICA";	"Maria";	7.0
"FISICA";	"Pepe";		6.0
"FISICA";	"Ana";		5.0
"INGLES";	"Julio";	9.0
*/


--3 Alumnos matriculados en fisica o en calculo ordenados por nombre
--Repetirla en RelaX sin ordenaciones
select distinct nombre
from expedientes
where asignatura='CALCULO' OR asignatura='FISICA'
order by nombre;
/*Solución:
"Ana"
"Juan"
"Maria"
"Pepe"
*/


-- 4 Alumnos matriculados en Fisica y Calculo ordenados por nombre
--Repetirla en RelaX sin ordenaciones
select nombre
from expedientes
where asignatura='FISICA'
intersect
select nombre
from expedientes
where asignatura='CALCULO'
order by nombre;
/*Solución:
"Juan"
"Maria"
"Pepe"
*/


-- 5 Alumnos matriculados en Fisica pero no en Calculo ordenados por nombre
--Repetirla en RelaX sin ordenaciones
select nombre
from expedientes
where asignatura='FISICA'
except
select nombre
from expedientes
where asignatura='CALCULO'
order by nombre;
--Solución: Ana


-- 6 Alumnos que han aprobado Fisica y suspendido Calculo ordenados por nombre
--Repetirla en RelaX sin ordenaciones
select nombre
from expedientes
where asignatura='FISICA' AND nota>=5
intersect
select nombre
from expedientes
where asignatura='CALCULO' AND nota<5
order by nombre;
--Solución: Maria


-- 7 Alumnos que han aprobado Fisica y no han suspendido Calculo (Que pasa con Ana?) ordenados por nombre
--Repetirla en RelaX sin ordenaciones
select nombre
from expedientes
where asignatura='FISICA' AND nota>=5
except
select nombre
from expedientes
where asignatura='CALCULO' AND nota<5
order by nombre;
/*Solución:
"Ana"
"Pepe"
*/

