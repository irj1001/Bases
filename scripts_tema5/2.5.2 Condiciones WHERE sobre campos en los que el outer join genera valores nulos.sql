drop table if exists equipos, jugadoresInternacionales cascade;

create table equipos(
	nombre		varchar(30) primary key,
	ciudad		varchar(15)
);

insert into equipos values
	( 'Real Madrid', 'Madrid'),
	( 'F.C. Barcelona', 'Barcelona'),
	( 'Atleti', 'Madrid'),
	( 'CD Universidad de Burgos', 'Burgos');

create table jugadoresInternacionales(
	nombre		varchar(40) primary key,
	nombre_equipo	varchar(30) references equipos,
	nacionalidad	varchar(20)
);

insert into jugadoresInternacionales values
	('Leo Messi', 		'F.C. Barcelona', 	'Argentino'),
	('Cristiano Ronaldo', 	'Real Madrid', 		'Portuges'),
	('Sergio Ramos', 	'Real Madrid', 		'Español'),
	('Isco',		'Real Madrid', 		'Español'),
	('Andrés Iniesta', 	'F.C. Barcelona', 	'Español'),
	('Antoine Griezmann',	'Atleti',		'Frances');

select * from jugadoresInternacionales;

select *
from equipos left join jugadoresInternacionales on (equipos.nombre = nombre_equipo)
where nacionalidad = 'Español';

select *
from equipos left join jugadoresInternacionales on (equipos.nombre = nombre_equipo);

select *
from equipos left join jugadoresInternacionales
 on (equipos.nombre = nombre_equipo and nacionalidad = 'Español');