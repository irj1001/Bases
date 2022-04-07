drop table if exists alumnos;

create table alumnos(
	nombre varchar(20)  	
);

insert into alumnos values ('ANA'),(null),('PEDRO'),('ALBERTO'),('ALBERTA'),('MARIA'), ('PEPE'), ('PABLO');

select * from alumnos;

SELECT nombre FROM alumnos
WHERE nombre LIKE 'P%O';

SELECT nombre FROM alumnos
WHERE nombre LIKE 'A_A';

SELECT nombre FROM alumnos
WHERE nombre LIKE '%';

SELECT nombre FROM alumnos
WHERE nombre LIKE 'PEDRO';

------------------------------------------------------
drop table if exists alumnos;
create table alumnos(
	nombre char(20)  /*Cuidado!! con CHAR tiene en cuenta espacios finales, se arregla con TRIM q quita los espacios finales*/	
);

insert into alumnos values ('ANA'),(null),('PEDRO'),('ALBERTO'),('ALBERTA'),('MARIA'), ('PEPE'), ('PABLO');

select * from alumnos;

SELECT nombre FROM alumnos
WHERE nombre LIKE 'P%O';  /*Cuidado!! con CHAR tiene en cuenta espacios finales, se arregla con TRIM q quita los espacios finales*/

SELECT nombre FROM alumnos
WHERE trim(nombre) LIKE 'P%O';

---------------------------------------------------------------------------------------------------------
drop table if exists peliculas;
create table peliculas(
   titulo varchar(40) primary key
);

insert into peliculas values ('The ten % solution'), ('Casablanca');

SELECT titulo FROM peliculas
WHERE titulo LIKE '%%%';

SELECT titulo FROM peliculas
WHERE titulo LIKE '%#%%' ESCAPE '#';

SELECT titulo FROM peliculas
WHERE titulo LIKE '%$%%' ESCAPE '$';

drop table if exists usuarios;
create table usuarios(
   login 	varchar(10) primary key,
   password	varchar(10))
;

insert into usuarios values ('Pepe', '12345'), ('Juan', '12%34'), ('Luis', '12$34'), ('Ana', '12%$34'), ('Maria', '123%%'), ('Raro', '123\\45') ;

select * from usuarios;

SELECT * FROM usuarios
WHERE password LIKE '%2$%%' ESCAPE '$';

SELECT * FROM usuarios
WHERE password LIKE '%$%$%' ESCAPE '$';

SELECT * FROM usuarios
WHERE password LIKE '%^%$%' ESCAPE '^';

--------SIMILAR TO----------------------------------------------
select * from alumnos
where nombre similar to 'P%O';

drop table if exists ordenadores;

create table ordenadores(
	ip char(15) check( ip similar to '[0-2][0-9]{2}.[0-2][0-9]{2}.[0-2][0-9]{2}.[0-2][0-9]{2}'),
	nombre char(40));

insert into ordenadores values
	('125.125.125.125', 'ordenador de Pepe'),
	('125.295.125.125', 'ordenador de Maria');

drop table if exists ordenadores;
create table ordenadores(
	ip char(15) check( ip similar to '(([0-1][0-9]{2})|(2[0-4][0-9])|25[0-5]).'||
					 '(([0-1][0-9]{2})|(2[0-4][0-9])|25[0-5]).'||
					 '(([0-1][0-9]{2})|(2[0-4][0-9])|25[0-5]).'||
					 '(([0-1][0-9]{2})|(2[0-4][0-9])|25[0-5])'),
	nombre char(40));

drop table if exists ordenadores;
create table ordenadores(
	ip char(15) check( ip similar to '((([0-1][0-9]{2})|(2[0-4][0-9])|25[0-5]).){3}'||
					 '(([0-1][0-9]{2})|(2[0-4][0-9])|25[0-5])'),
	nombre char(40));



/*
insert into ordenadores values
	('125.125.125.225', 'ordenador de Pepe'),
	('349.295.125.225', 'ordenador de Maria');	
*/

insert into ordenadores values
	('125.125.125.225', 'ordenador de Pepe'),
	('255.000.125.225', 'ordenador de Maria');		

select * from ordenadores where ip similar to '___.[^0]%';	

