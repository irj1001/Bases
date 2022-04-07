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
				( 4, 'Luis', 'OFI_2', null, 15),
				( 5, 'Ana', null, null, 5),
				( 6, 'Antonio', 'OFI_3', null, null);			   
			   
SELECT oficina FROM empleados
GROUP BY oficina;

/*Es lo mismo que*/
SELECT DISTINCT oficina FROM empleados;

SELECT oficina, AVG(comision) FROM empleados
GROUP BY oficina;

SELECT oficina, cargo, AVG(comision) FROM empleados
GROUP BY oficina, cargo;

/*Referencia a campo no agrupado
SELECT oficina, cargo, AVG(comision), nombre FROM empleados
GROUP BY oficina, cargo;
*/

SELECT oficina, poblacion, comision
FROM empleados, oficinas
WHERE oficina = n_oficina;

/*Da error aun cuando casualmente todos los miembros del grupo coincidan en el valor no agrupado(poblacion)
SELECT oficina, poblacion, AVG(comision)
FROM empleados, oficinas
WHERE oficina = n_oficina
GROUP BY oficina;*/

SELECT oficina, poblacion, AVG(comision)
FROM empleados, oficinas
WHERE oficina = n_oficina
GROUP BY oficina, poblacion;

SELECT poblacion, AVG(comision)
FROM empleados, oficinas
WHERE oficina = n_oficina
GROUP BY poblacion;

SELECT poblacion, oficina, AVG(comision)
FROM empleados, oficinas
WHERE oficina = n_oficina
GROUP BY poblacion, oficina;

------------------------------Comparando con cuando no había GROUP BY---------------------------
--Puedo poner campos (cargo) y expresiones con referencias a campos (sal) si estos estan en el GROUP BY
SELECT empleados.cargo, sal*AVG(comision)
FROM empleados, categorias
WHERE empleados.cargo = categorias.cargo
GROUP BY empleados.cargo, sal;

--Si ninguna fila de un frupo cumple el WHERE ese grupo no sale

SELECT oficina, AVG(comision) FROM empleados
GROUP BY oficina;

SELECT oficina, AVG(comision) FROM empleados
WHERE comision IS NOT NULL
GROUP BY oficina;

--Si en todas las filas del grupo en las que se cumple el WHERE la expresión del parámetro vale nulo:
--COUNT (<expresión> ) devuelve cero, los demás (excepto COUNT(*)) devuelven nulo.
--COUNT(*) al no tener parámetros no se ve afectado por esta regla (devuelve el número de elementos que tenga el grupo).
--En el siguiente ejemplos fijarnos en el grupo de OFI_3

SELECT oficina, count(comision), count(*), sum(comision), avg(comision), max(comision), min(comision)
FROM empleados
GROUP BY oficina;

--Ordenaciones por resultado de funcion sumaria
SELECT oficina, count(*)
FROM empleados
GROUP BY oficina
ORDER BY count(*) DESC;

