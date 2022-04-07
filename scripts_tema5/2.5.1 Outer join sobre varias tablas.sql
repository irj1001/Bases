drop table if exists alquila, inmuebles, inquilinos cascade;

create table inquilinos(
	dni numeric(8) primary key,
	nombre varchar(15),
	tfno numeric(9) );

insert into inquilinos values
	( 1, 'Pepe',   123456789),
	( 2, 'Maria',  123456789),
	( 3, 'Enrique',333333333);

create table inmuebles(
	planta	numeric(2),
	letra	char(1),	
	alquiler numeric(6,2),
	primary key ( planta, letra )
);

insert into inmuebles values
	( 1, 'A', 400),
	( 1, 'B', 500),
	( 2, 'A', 300),
	( 2, 'B', 400);

create table alquila (
	dni numeric(8) references inquilinos,
	planta	numeric(2),
	letra	char(1),	
	foreign key ( planta, letra ) references inmuebles,
	primary key ( dni, planta, letra )
);

insert into alquila values
	( 1, 1, 'B'), (2, 1, 'B'), --Maria y Pepe viven en el 1-B
	( 1, 2, 'A');              --Pepe tiene el 2A como despacho

/*
IMPORTANTE: pgAdmin sólo te muestra el resultado del último comando SQL ejecutado, 
	asi que para ver lo que hacen las selects anteriores a la última tienes 2 posibilidades:
	
--Pon marcas de comentario en las sentencias que no quieras que se ejecuten
--Otra posibilidad es que selecciones la(s) sentencia(s) que quieras probar, y des al boton de ejecutar				
*/		
	
--1er intento => no sale el 1A y 2B
SELECT planta, letra, alquiler, dni, nombre, tfno
FROM ( Inmuebles NATURAL LEFT JOIN Alquila)
		NATURAL JOIN Inquilinos;

--Estudio del primer join: El campo DNI vale nulo para el 1A => ya no puede hacer join con DNI de inquilinos
SELECT planta, letra, alquiler, dni
FROM ( Inmuebles NATURAL LEFT JOIN Alquila);

--Arreglo 1: Arrastrar el join externo al siguiente join
SELECT planta, letra, alquiler, dni, nombre, tfno
FROM ( Inmuebles NATURAL LEFT JOIN Alquila)
		NATURAL LEFT JOIN Inquilinos;

--Arreglo 2: Cambiar el orden en el que se ejecutan los joins 
--mediante los parentesis
SELECT planta, letra, alquiler, dni, nombre, tfno
FROM  Inmuebles NATURAL LEFT JOIN (Alquila
		NATURAL JOIN Inquilinos);

--cambiando la posición de las tablas en el from
SELECT planta, letra, alquiler, dni, nombre, tfno
FROM  Alquila NATURAL JOIN Inquilinos
 NATURAL RIGHT JOIN Inmuebles;