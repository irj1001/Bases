drop table if exists alumnos cascade;

create table alumnos(
  nombre varchar(40) primary key,
  altura numeric(3,2) not null,
  peso   numeric(3,1),
  nota   numeric(4,2) not null default 5
);

insert into alumnos values
('Pepe', 1.7, 67), ('Ana', 1.72, 67),
('Juan', 1.7, 83), ('Luis', 1.7, 83);

drop table if exists copia;
create table copia as select * from alumnos;
select * from copia;

drop view if exists vista;
create view vista as select * from alumnos;
select * from vista;

delete from alumnos where nombre='Pepe';
select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;

---------------------------------------
delete from copia where nombre='Ana';

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;
----------------------------------------

delete from vista where nombre='Luis';

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;
----------------------------------------

update alumnos set altura=2 where nombre='Juan';

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;
----------------------------------------
update copia set altura=3 where nombre='Juan';

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;

----------------------------------------
update vista set altura=4 where nombre='Juan';

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;

------------------------------------------
insert into alumnos values ('Alumno', 0, 0);

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;

------------------------------------------
insert into copia values ('Copia', 0, 0);

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;

------------------------------------------
insert into vista values ('Vista', 0, 0);

select 'alumnos' as origen, * from alumnos
union
select 'copia',   * from copia
union
select 'vista', * from vista
order by origen, nombre;

------------------------------------------------------------

drop view if exists insertable;
create view insertable as
select nombre, altura, nota
from alumnos
where altura>1.60;

select * from insertable;
insert into insertable values
('Jorge', 1.80, 6), ('Luisa', 1.50, 6);



select 'alumnos' as origen, * from alumnos
union
select 'insertable',*, null from insertable
order by origen, nombre;

------------------------------------------------------
drop view if exists actualizable;
create view actualizable as select nombre, nota
from alumnos
where nota>=5;

/*
insert into actualizable values ( 'Jesus', 8);


ERROR: el valor null para la columna «altura» viola la restricción not null
Estado SQL:23502
Detalle:La fila que falla contiene (Jesus, null, null, 8.00).
*/

update actualizable
set nota=10
where nombre = 'Ana';

update actualizable
set nota=0
where nombre = 'Jorge';

select 'alumnos' as origen, * from alumnos
union
select 'actualizable', nombre, null, null, nota from actualizable
order by origen, nombre;

----------------------------------------------
drop view if exists borrable;
create view borrable as
select nombre, nota*10 nota_sobre_100
from alumnos
where nota>=5;

/*
update borrable
set nota_sobre_100 = 50
where nombre = 'Ana';

ERROR: no se puede actualizar la columna «nota_sobre_100» vista «borrable»
Estado SQL:0A000
*/

delete from borrable
where nombre='Ana';

select 'alumnos' as origen, * from alumnos
union
select 'borrable', nombre, null, null, nota_sobre_100 from borrable
order by origen, nombre;

-------------------------------------------------

drop view if exists sin_cambios1;
create view sin_cambios1 as 
select distinct altura, peso from alumnos;

/*
delete from sin_cambios1 where peso>80;

ERROR: no se puede eliminar de la vista «sin_cambios1»
Estado SQL:55000
Detalle:Las vistas que contienen DISTINCT no son automáticamente actualizables.
Sugerencias:Para activar las eliminaciones en la vista, provea un disparador INSTEAD OF DELETE o una regla incondicional ON DELETE DO INSTEAD.
*/

drop view if exists sin_cambios2;
create view sin_cambios2 as 
select altura, peso from alumnos
union
select altura*2, peso*2 from alumnos;

/*
delete from sin_cambios2 where peso>80;

ERROR: no se puede eliminar de la vista «sin_cambios2»
Estado SQL:55000
Detalle:Las vistas que contienen UNION, INTERSECT o EXCEPT no son automáticamente actualizables.
Sugerencias:Para activar las eliminaciones en la vista, provea un disparador INSTEAD OF DELETE o una regla incondicional ON DELETE DO INSTEAD.
*/

/*
Hay mas situaciones que no permiten ni siquiera borrar que veremos mas adelante
(p.e. Varias tablas en el FROM, GROUP BY, SELECT COUNT, AVG, SUM, MIN, MAX ...)
*/

/*Utilidad de las vistas para seguridad*/

drop table if exists cuentas cascade;
create table cuentas(
	nroCta  numeric(10) primary key,
	titular varchar(20),
	saldo   numeric(10,2),
	oficina varchar(10)
);

insert into cuentas values
( 1, 'Pepe', 1000, 'OFI_01'), ( 2, 'Juan',  1000, 'OFI_01'),
( 3, 'Pepe', 2000, 'OFI_02'), ( 4, 'Maria', 2000, 'OFI_02');

drop view if exists cuentas_ofi1;
create view cuentas_ofi1 as
select * from cuentas where oficina='OFI_1';

update cuentas_ofi1
set saldo=saldo*10
where nroCta=4;