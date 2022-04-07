drop table if exists profesores cascade;
drop table if exists departamentos cascade;

create table profesores(
	dni 			numeric(8) primary key,
	nombre 			char(40) not null,
	Nro_Departamento	smallint not null );

create table departamentos(
	Nro_Departamento	smallint primary key,
	Nombre_Dept		char(40) not null,
	DNI_director_Depto 	numeric(8) unique references profesores);

alter table profesores add foreign key(Nro_Departamento) references departamentos;	

insert into departamentos (Nro_Departamento, Nombre_Dept) values ( 1, 'MATEMATICAS'), ( 2, 'FISICA');
insert into profesores values ( 1, 'Pepe', 1), (2, 'Juan', 1), (3, 'Ana', 2);
update departamentos set DNI_director_Depto = 2 where Nro_Departamento=1;
update departamentos set DNI_director_Depto = 3 where Nro_Departamento=2;

