drop table if exists oficinas cascade;
drop table if exists vendedores cascade;

create table oficinas(
	n_oficina 	char(5) primary key,
	poblacion	char(40)
);

create table vendedores(
	cod 		integer primary key,
	nombre		char(40),
	oficina 	char(5) references oficinas,
	ventas		numeric(6,2)
);


insert into oficinas values ( 'OFI_1', 'Burgos'),
			    ( 'OFI_2', 'Leon'),
			    ( 'OFI_3', 'Burgos');

insert into vendedores values 	( 1, 'Pepe',   'OFI_1', 100),
				( 2, 'Juan',   'OFI_1', 200),
				( 3, 'Jorge',  'OFI_1', 300),
				( 4, 'Luis',   'OFI_2',1500),
				( 5, 'Ana',     null,   500),
				( 6, 'Antonio', 'OFI_3', null);			   

--Oficinas de Burgos que han vendido mas de 100 con el promedio de ventas de cada vendedor			   
SELECT n_oficina, AVG(ventas)
FROM vendedores, oficinas
WHERE oficina = n_oficina
AND poblacion = 'Burgos'
GROUP BY n_oficina
HAVING SUM(ventas) > 100;

--Paso 1:
SELECT n_oficina, ventas
FROM vendedores, oficinas
WHERE oficina = n_oficina
AND poblacion = 'Burgos';

--Paso 2:
SELECT n_oficina, AVG(ventas), SUM(ventas)
FROM vendedores, oficinas
WHERE oficina = n_oficina
AND poblacion = 'Burgos'
GROUP BY n_oficina;

--Paso 3:
SELECT n_oficina, AVG(ventas)
FROM vendedores, oficinas
WHERE oficina = n_oficina
AND poblacion = 'Burgos'
GROUP BY n_oficina
HAVING SUM(ventas) > 100;
---------------------------------------------------------------------------------------
--A veces la condicion HAVING puede ir en el WHERE, suele ir mas deprisa xq elimina filas antes

SELECT n_oficina, AVG(ventas), poblacion
FROM vendedores, oficinas
WHERE oficina = n_oficina
GROUP BY n_oficina, poblacion
HAVING SUM(ventas) > 100 AND poblacion = 'Burgos';

SELECT n_oficina, AVG(ventas), poblacion
FROM vendedores, oficinas
WHERE oficina = n_oficina
AND poblacion = 'Burgos'
GROUP BY n_oficina, poblacion
HAVING SUM(ventas) > 100;

----------------------------------------
--HAVING sin GROUP BY, o da una fila o no da ninguna

SELECT SUM(ventas) FROM vendedores
HAVING AVG(Ventas)>100;
 
SELECT SUM(ventas) FROM vendedores
HAVING AVG(Ventas)>1000;
