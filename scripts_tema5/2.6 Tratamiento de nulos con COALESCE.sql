drop table if exists empleados;

create table empleados(
	dni	numeric(8)	primary key,	
	nombre	varchar(20),
	nacidoEn	char(8),
	ViveEn	char(8) ,
	salario	numeric(6,2),
	bonus	numeric(5));


insert into empleados values
	( 1, 'Pepe', 'Burgos', 'Madrid', 2000, null),
	( 2, 'Juan', 'Burgos', 'Burgos', null, null),
	( 3, 'Ana',  null,     'Soria',  null, 1500),
	( 4, 'Luis', null,      null,    500, 1000);

SELECT nombre,
	CASE
		WHEN salario IS NOT NULL THEN salario
		WHEN salario IS NULL THEN 0
	END
FROM Empleados;

SELECT nombre, coalesce( salario, 0)
FROM Empleados;


SELECT nombre, coalesce( nacidoEn, ViveEn, '¿?')
FROM Empleados;

SELECT * FROM empleados WHERE nacidoEn=null;

SELECT * FROM empleados WHERE nacidoEn is null;

SELECT * FROM empleados 
WHERE coalesce(nacidoEn, '$')='$';


SELECT * FROM empleados order by bonus;
SELECT * FROM empleados order by bonus desc;
SELECT * FROM empleados order by bonus nulls first;
SELECT * FROM empleados order by bonus desc nulls last;

SELECT * FROM empleados
order by COALESCE( bonus, -1000000);

SELECT * FROM empleados
order by COALESCE( bonus, 1000000);

SELECT * FROM empleados
order by COALESCE( bonus, 1000000) DESC;

--CAST

/*
select nombre, coalesce(salario, 'no tiene')
from empleados;
*/

select nombre, coalesce(cast(salario as char(7)), 'no tiene')
from empleados;