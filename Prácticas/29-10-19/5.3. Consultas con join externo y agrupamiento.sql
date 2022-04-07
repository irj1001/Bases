drop table if exists oficinas cascade;
drop table if exists categorias cascade;
drop table if exists empleados cascade;

create table oficinas(
	n_oficina 	char(5) primary key,
	poblacion	char(40),
	region		char(20),
	ventas		numeric(8),
	objetivo	numeric(8)
);

create table categorias(
	cargo 		char(10) primary key,
	sal 		numeric(5)
);

create table empleados(
	cod 		integer primary key,
	nombre		char(40),
	oficina 	char(5) references oficinas,
	cargo 		char(10) references categorias,
	comision	numeric(4,2)
);


insert into oficinas values ( 'OFI_1', 'Burgos', null, null, null),
			    ( 'OFI_2', 'Leon', null, null, null),
			    ( 'OFI_3', 'Burgos', null, null, null);

insert into categorias values ('GERENTE', 10000), ('SECRETARIO', 1000), ('VENDEDOR', 3000);

insert into empleados values 	( 1, 'Pepe', 'OFI_1', 'VENDEDOR', 10),
				( 2, 'Juan', 'OFI_1', 'VENDEDOR', 20),
				( 3, 'Jorge','OFI_1', 'GERENTE', 30),
				( 4, 'Luis', 'OFI_2', null, 15);

--Consulta 1: Todas las oficinas con el numero de empleados de cada una

--Mal: la oficina 3 no tiene 1 empleado
select n_oficina, count(*)
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;

--Mal tambien
select n_oficina, count(n_oficina)
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;

--asi bien, queremos que cuente las veces q oficina no es nulo.
select n_oficina, count(oficina)
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;

--tb bien así, o con cualquier otro campo de empleados
select n_oficina, count(cod)
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;

--Consulta 2: Todos los cargos junto con el número de empleados que los ocupan
--MAL
select cargo, count(cargo)
from categorias natural left join empleados
group by cargo;

--Ese "cargo" nunca vale nulo => si no digo nada es el del lado del join (LEFT) y queremos el de empleados
select cargo, nombre, categorias.cargo, empleados.cargo
from categorias natural left join empleados;

select cargo, count(empleados.cargo)
from categorias natural left join empleados
group by cargo;


--Consulta 3: Todas las oficinas con la comision máxima de empleado de cada una.
--Si una oficina no tiene empleados que salga "SIN EMPLEADOS" en lugar de la comisión máxima

--Paso 1
select n_oficina, max(comision)
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;

--Paso 2:MAL 
/*
select n_oficina, coalesce( max(comision), 'SIN EMPLEADOS')
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;
*/

--necesitamos convertir la comisión a cadena para que sea del mismo tipo que "SIN EMPLEADOS"
select n_oficina, coalesce( cast (max(comision) as CHAR(15)), 'SIN EMPLEADOS')
from oficinas left join empleados on (n_oficina=oficina)
group by n_oficina;

--Consulta 4: Todos los cargos junto con la comision promedio
--Si una oficina no tiene empleados que salga "SIN EMPLEADOS" en lugar de la comisión promedio
select cargo, coalesce( cast (AVG(comision) as CHAR(15)), 'SIN EMPLEADOS')
from categorias natural left join empleados
group by cargo;



