drop table if exists empleados cascade;

create table empleados(
	id 		integer primary key,	
	nombre  	char(20),
	salario 	numeric(8,2) not null check ( salario > 100),
	comision 	numeric(8,2) check ( comision > 10)
);

--insert into empleados values ( 1, 'Pepe', 50, 20);
--insert into empleados values ( 1, 'Pepe', null, 20);
insert into empleados values ( 1, 'Pepe', 1000, null);
select * from empleados;

drop table if exists empleados cascade;

create table empleados(
	id 		integer primary key,
	nombre  	char(20),
	salario NUMERIC( 8,2)	CHECK (salario IS NOT NULL AND salario>10),
	comision NUMERIC( 8,2)	CHECK (comision IS NULL OR comision>100)
);
--insert into empleados values ( 1, 'Pepe', 50, 20);
--insert into empleados values ( 1, 'Pepe', null, 20);
insert into empleados values ( 1, 'Pepe', 1000, null);
select * from empleados;

drop table if exists empleados cascade;

create table empleados(
	id integer primary key,
	dni numeric(8) unique
);

--insert into empleados values ( null, 1);
insert into empleados values ( 1, null), (2, null);

--Con claves compuestas
drop table if exists vecinos;

CREATE TABLE vecinos (
	nombre	CHAR(20),
	ape1	CHAR(20),
	ape2	CHAR(20),
	planta	SMALLINT,
	letra	CHAR(1),
	tfno	NUMERIC(9),
	PRIMARY KEY (nombre, ape1, ape2),
	UNIQUE ( planta, letra)
);

--insert into vecinos ( nombre, ape1, ape2 ) values (null, 'Garcia', 'Fernandez');	
--insert into vecinos ( nombre, ape1, ape2 ) values ('Pedro', null, 'Fernandez');	
--insert into vecinos ( nombre, ape1, ape2 ) values ('Pedro', 'Garcia', null);	

insert into vecinos ( nombre, ape1, ape2, planta, letra ) values ('Pedro', 'Garcia', 'Fernandez', 1, null);	
insert into vecinos ( nombre, ape1, ape2, planta, letra ) values ('Ana', 'Garcia', 'Fernandez', 1, null);	
insert into vecinos ( nombre, ape1, ape2, planta, letra ) values ('Pedro', 'Gomez', 'Fernandez', null, 'A');	
insert into vecinos ( nombre, ape1, ape2, planta, letra ) values ('Ana', 'Gomez', 'Fernandez', null, 'A');	
insert into vecinos ( nombre, ape1, ape2, planta, letra ) values ('Pedro', 'Gomez', 'Rodriguez', null, null);	
insert into vecinos ( nombre, ape1, ape2, planta, letra ) values ('Ana', 'Gomez', 'Rodriguez', null, null);	

select * from vecinos;