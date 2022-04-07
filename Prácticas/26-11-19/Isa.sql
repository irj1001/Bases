drop table if exists barcos, portaaviones, submarinos, flotas, aviones cascade;

create table flotas(
  idflota char(2) primary key,
  base    varchar(20)
);

create table barcos(
 nombre   varchar(40) primary key,
 eslora   smallint,
 tonelaje integer,
 idFlota  char(2) not null references flotas
);

insert into flotas values ('F1', 'Cartagena'), ('F2', 'Cadiz'), ('F3', 'Ferrol');

insert into barcos values('PortaAviones1', 200, 6000, 'F1'), ('PortaAviones2', 200, 6000, 'F2'),
			 ('Acorazado1',    200, 6000, 'F1'), ('Acorazado2',    200, 6000, 'F2'),
			 ('Submarino1',    200, 6000, 'F1'), ('Submarino2',     200, 6000, 'F3');

create table submarinos(
	nombre 		varchar(40) primary key references barcos,
	n_torpedos	smallint
);

insert into submarinos values ('Submarino1',    8), ('Submarino2',     12);

create table portaaviones(
	nombre 		varchar(40) primary key references barcos,
	n_aviones       smallint
);

insert into portaaviones values ('PortaAviones1', 20), ('PortaAviones2', 30);

create table aviones(
	idAvion		varchar(20) primary key,
	modelo		varchar(10),
	portaaviones    varchar(40) references portaaviones
);

insert into aviones values ('Avion10', 'F18', 'PortaAviones1'), ('Avion11', 'F18', 'PortaAviones1'), ('Avion12', 'F18', 'PortaAviones1'),
			   ('Avion20', 'F18', 'PortaAviones1'), ('Avion21', 'F18', 'PortaAviones2'), ('Avion22', 'F18', 'PortaAviones2');


-- Hacer un informe de todos los barcos con todos los atributos
select *
from flotas join barcos using(idFlota) 
		left join submarinos using (nombre)
		left join portaaviones using (nombre)
		left join aviones on(nombre=portaaviones)
order by idFlota;

-- Demostrar que se podria insertar un submarino - portaaviones

-- Crear la solucion de una tabla y repetir las 2 preguntas anteriores

-- Demostrar que en la solucion de una tabla podemos llevar un avion en un submarino

drop table if exists barcos, portaaviones, submarinos, flotas, aviones cascade;

create table flotas(
  idflota char(2) primary key,
  base    varchar(20)
);

create table barcos(
 nombre   varchar(40) primary key,
 eslora   smallint,
 tonelaje integer,
 idFlota  char(2) not null references flotas,
 tipo	varchar(1) not null check( tipo in ('B', 'S', 'P')),
 n_aviones smallint,
 n_torpedos smallint,
 check((tipo='S' and n_aviones is null) or (tipo='P' and n_torpedos is null and n_aviones is not null) or (tipo='B' and n_aviones is null and n_torpedos is null))
);
