/*
         1  N     N    1          N      1
Actores<-----Rueda------>Peliculas-------->Estudios

*/


DROP TABLE IF EXISTS Actores CASCADE;
DROP TABLE IF EXISTS Estudios CASCADE;
DROP TABLE IF EXISTS Peliculas CASCADE;
DROP TABLE IF EXISTS Rueda CASCADE;

CREATE TABLE Actores(
	nombre	char(20) primary key
);

CREATE TABLE Estudios(
	nombre	char(20) primary key,
	sede    char(20)
);

CREATE TABLE Peliculas(
	titulo		char(20) primary key,
	presupuesto	numeric(10),
	nombreEstudio	char(20) references estudios not null
);

CREATE TABLE Rueda(
	nombreActor 	char(20) references actores,	
	titulo		char(29) references peliculas,
	primary key ( nombreActor, titulo )	
);


insert into actores values ('Actor1'),('Actor2'),('Actor3');

insert into estudios values ('Warner', 'Hollywood'), ('Pixar', 'Miami'), ('Metro', 'Hollywood');

insert into peliculas values ('Peli1', 100, 'Warner'), ('Peli2', 200, 'Warner'), ('Peli3', 50, 'Metro'), ('Peli4', 100, 'Metro');

insert into rueda values  ('Actor1', 'Peli1'),
			  ('Actor2', 'Peli1'),
			  ('Actor1', 'Peli2'),
			  ('Actor1', 'Peli3');

select count (nombreActor) from peliculas join rueda using (titulo) where nombreEstudio='Warner';


--1. Películas en las que intervinieron más (estrictamente) del 50% de los actores de la Warner
--Solucion: Peli1
select titulo
from peliculas natural join rueda
where nombreEstudio='Warner'
group by titulo
having count(distinct nombreActor) >0.5*(select count(distinct nombreActor)
		from rueda join peliculas using (titulo)
		where nombreEstudio='Warner');

--2. Número promedio de películas hecho por un estudio	
--Solucion 2			  

--3. Listado en el que salgan todos los actores con el número de películas que han hecho. Si no han hecho ninguna que salga cero. 	
/*Solucion
"Actor1              ";3
"Actor2              ";1
"Actor3              ";0
*/

--4. Actores que no han hecho ninguna pelicula con presupuesto inferior a 200
--Solucion 3

