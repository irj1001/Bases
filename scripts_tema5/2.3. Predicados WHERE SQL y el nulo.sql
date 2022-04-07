drop table if exists empleados cascade;

create table empleados(
	id 	integer primary key,
	nombre  char(20),
	salario numeric(8,2)
);

insert into empleados values ( 1, 'Pepe', 50), (2, 'Juan', null), ( 3, 'Ana', 200);

SELECT nombre FROM empleados WHERE salario>100;

SELECT nombre FROM empleados WHERE salario=NULL;

SELECT nombre FROM empleados WHERE salario IS NULL;

SELECT nombre FROM empleados WHERE salario<>NULL;

SELECT nombre FROM empleados WHERE NOT salario IS NULL;

SELECT nombre FROM empleados WHERE salario IS NOT NULL;

drop table if exists alumnos cascade;

create table alumnos(	
	nombre  char(20) primary key,
	altura  numeric(3,2),
	peso	numeric(3,1)
);

insert into alumnos values ( 'Pepe', null, 70), ('Juan', 1.80, null),
			   ('Ana', null, null), ('Luis', 1.50, null), ('Maria', null, 60);


SELECT nombre FROM alumnos
WHERE peso>67 OR altura>1.70;

SELECT nombre FROM alumnos
WHERE peso>67 OR peso<=67;

