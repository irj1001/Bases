drop table if exists alumnos;

create table alumnos(
	Nombre		varchar(20) primary key,
	Altura		numeric(3,2),
	Peso		numeric(3)		

	);
insert into alumnos
values
('Pepe', 1.70,67),
('Ana', 1.72,67),
('Juan', 1.70, 83),
('Luis', 1.70, 83);

