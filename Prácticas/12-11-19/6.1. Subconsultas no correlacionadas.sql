

/*IMPORTANTE:

Puede que algunos resultados de algunas selects te parezcan que dan cero
Por ejemplo:

0000000

Eso es porque te esta calculando los resultado con todos los decimales que puede
y por alguna extraña razon en las ultimas versiones de pgAdmin los resultados
te salen ajustados a la derecha, de forma que esos ceros que estas viendo no son
mas que los ultimos decimales de un numero, por ejemplo:

54.6875000000000000

Lo que tienes que hacer para ver el numero al completo es ensanchar la columna
donde se muestra el resultado arrastarndo el raton en el borde de la cabecera con el nombre
del campo de la misma forma que harias en las hojas de calculo para ensanchar una
columna

*/

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


insert into oficinas values ( 'OFI_1', 'Burgos', 10000, 10000, null),
			    ( 'OFI_2', 'Leon', 20000,   20000, null),
			    ( 'OFI_3', 'Burgos', null, 30000, null);

insert into categorias values ('GERENTE', 10000), ('SECRETARIO', 1000), ('VENDEDOR', 3000);

insert into empleados values 	( 1, 'Pepe', 'OFI_1', 'VENDEDOR', 10),
				( 2, 'Juan', 'OFI_1', 'VENDEDOR', 20),
				( 3, 'Alicia','OFI_1', 'GERENTE', 30),
				( 4, 'Luis', 'OFI_2', null, 15);


--Subconsultas en la SELECT

--funciona, pero no lo podemos saber hasta ejcutar la select, la cuarta columna es constante
select cod, nombre, comision, (select comision from empleados 
				where nombre like 'Alicia%')
from empleados;

--no hay ataulfos => la cuarta columna es null
select cod, nombre, comision, (select comision from empleados 
				where nombre='ataulfo')
from empleados;

--no funciona, hay mas de un empleado que tiene una "a" en su nombre
/*
select cod, nombre, comision, (select comision from empleados 
				where nombre like '%a%')
from empleados;
*/

SELECT nombre, comision - (	SELECT AVG(comision)
				FROM empleados, oficinas
				WHERE oficina=n_oficina
				AND poblacion='Madrid' )
FROM empleados;

--Subconsultas en el FROM

SELECT nombre, comision
FROM (	SELECT * FROM empleados
		WHERE comision > 20) temporal;

SELECT nombre, comision
FROM (	SELECT * FROM empleados
		WHERE comision > 20) AS temporal;

SELECT nombre, porcentaje
FROM (	SELECT nombre, comision AS porcentaje
	FROM empleados
	WHERE comision > 20) temporal;

SELECT cargo, comision*1.15
FROM (	SELECT * FROM empleados
	WHERE comision > 20) temporal;

SELECT sqrt(   AVG(POW( comision, 2)) - POW( AVG( comision ), 2 ) )
FROM empleados;

SELECT avg(comision) FROM empleados;

SELECT (comision - (SELECT avg(comision) FROM empleados))
	 *(comision - (SELECT avg(comision) FROM empleados))
FROM empleados;

SELECT pow(comision - (SELECT avg(comision) FROM empleados), 2)
FROM empleados;

SELECT AVG(diferencias)
FROM (SELECT pow(comision - (SELECT avg(comision)
			     FROM empleados)      
		, 2) diferencias
       FROM empleados)   AS tablaDiferencias
;

SELECT sqrt(AVG(diferencias))
FROM (SELECT pow(comision - (SELECT avg(comision)
			     FROM empleados)      
		, 2) diferencias
       FROM empleados)   AS tablaDiferencias
;

--Las subconsultas en el FROM para emular el anidamiento de funciones sumarias

drop table if exists datosMetereologicos;

CREATE TABLE datosMetereologicos(
	provincia	CHAR(11),
	localidad	CHAR(20),
	fecha		DATE,
	temperatura	NUMERIC(4,2),	
PRIMARY KEY( provincia, localidad, fecha)
);

INSERT INTO datosMetereologicos VALUES ( 'BURGOS', 'BURGOS',  CURRENT_DATE-1, 15);
INSERT INTO datosMetereologicos VALUES ( 'BURGOS', 'ARANDA',  CURRENT_DATE-1, 16);
INSERT INTO datosMetereologicos VALUES ( 'BURGOS', 'MIRANDA', CURRENT_DATE-1, 17);
INSERT INTO datosMetereologicos VALUES ( 'MADRID', 'MADRID',  CURRENT_DATE-2, 21);
INSERT INTO datosMetereologicos VALUES ( 'MADRID', 'GETAFE',  CURRENT_DATE-2, 23);

SELECT fecha, AVG(temperatura)
FROM datosMetereologicos
GROUP BY fecha;

SELECT MAX(promedio) FROM (
	SELECT fecha, AVG(temperatura) promedio
	FROM datosMetereologicos
	GROUP BY fecha
	) AS promedios;
/*--Ejercicio 10:
--oficinas que tienen todos los cargos
--todas las oficinas
except
select oficina
from subconsulta con las oficinas que no tienen todos los cargos=
					select todas las combinaciones oficina, cargo
					except combinaciones oficina, cargo reales*/

delete from categorias where cargo='SECRETARIO';



select oficina 
from empleados
except 
select oficina
from (select oficina, categorias.cargo from empleados, categorias
	except 
	select oficina, cargo from empleados /*join categorias using (cargo) */
	)as sub ;

select n_oficina 
from oficinas
except 
select n_oficina
from (select n_oficina, cargo from oficinas, categorias
	except 
	select oficina, cargo from empleados /*join categorias using (cargo) */
	)as sub ;


/*Ejercicio 11
1 Hallar la mínima comisión de entre las comisiones máxima de cada ciudad => MIN(MAX)
2 Hallar el número promedio de empleados que ay en cada oficina => AVG(COUNT())*/

/*1*/
Select MIN(promedio) 
from (select MAX(comision) promedio 
	from empleados join oficinas on(oficina=n_oficina)
	group by poblacion) as x;



/*2*/
select avg(emp)
from (select count(*) emp
	from empleados
	group by oficina) as x;

/*2*/
select avg(num)
from (select count(cod) num
	from empleados right join oficinas on (n_oficina=oficina)
	group by oficina) as x;




--Subconsultas en el WHERE

--Mal porque hay 2 oficinas en Burgos
/*
SELECT cod, nombre FROM empleados
WHERE Oficina = (	SELECT n_Oficina
			FROM oficinas
			WHERE poblacion = 'Burgos ');
*/

--Bien, pero no devuelve nada porque no hay oficinas en Aranda
SELECT cod, nombre FROM empleados
WHERE Oficina = (	SELECT n_Oficina
			FROM oficinas
			WHERE poblacion = 'Aranda ');

--Correcto: sólo hay una oficina en Leon
SELECT cod, nombre FROM empleados
WHERE Oficina = (	SELECT n_Oficina
			FROM oficinas
			WHERE poblacion = 'Leon ');

--Se podia haber hecho asi mejor, con un join => posiblemente mas eficiente
--En un examen hazala con un join, y asi no me quedan dudas de si sabes o no lo que es un join
SELECT cod, nombre FROM empleados, oficinas
WHERE Oficina = n_Oficina
AND poblacion = 'Leon ';			

SELECT * FROM empleados natural join categorias
WHERE sal > (	SELECT AVG( sal )
		FROM empleados natural join categorias);

SELECT * FROM empleados natural join categorias
WHERE sal > 0.5*(	SELECT ventas
		FROM oficinas
		WHERE n_Oficina='OFI_1');


/*ejercicio 12
1 Obtener el nombre del empleado con la comisión máxima.
2 Hallar el empleado que más gana, teniendo en cuenta que el sueldo se calcula como sal+comision*ventas/100.
*/

/*1*/ 
select nombre 
from empleados
where comision= (select max(comision) from empleados);

/*2*/
select nombre 
from empleados join oficinas on(oficina=n_oficina) join categorias using (cargo)
where sal+comision*ventas/100=( select max(sal+comision*ventas/100) from empleados join oficinas on(oficina=n_oficina) join categorias using (cargo));


--ANY, SOME e IN

SELECT * FROM empleados natural join categorias
WHERE sal > ANY (SELECT 0.5*ventas FROM oficinas);


SELECT * FROM empleados natural join categorias
WHERE sal > ANY (	SELECT ventas FROM oficinas
			WHERE ventas=-1);

SELECT * FROM empleados natural join categorias
WHERE sal > SOME (SELECT 0.5*ventas FROM oficinas);

SELECT * FROM empleados
WHERE oficina =ANY (	SELECT n_oficina
			FROM oficinas
			WHERE ventas > 10000);

SELECT * FROM empleados
WHERE oficina IN (	SELECT n_oficina
			FROM oficinas
			WHERE ventas > 10000);

SELECT empleados.*
FROM empleados, oficinas
WHERE oficina = n_oficina
AND ventas > 10000;

--ALL

SELECT * FROM empleados natural join categorias
WHERE sal < ALL (SELECT ventas FROM oficinas);

SELECT * FROM empleados natural join categorias
WHERE sal = ALL (SELECT ventas FROM oficinas);

SELECT * FROM empleados natural join categorias
WHERE sal < (SELECT MIN(ventas) FROM oficinas);

update oficinas
set objetivo =10000
where n_oficina='OFI_1';

update oficinas
set objetivo =20000
where n_oficina='OFI_2';

SELECT * FROM empleados natural join categorias
WHERE sal < ALL (SELECT objetivo FROM oficinas);

SELECT * FROM empleados natural join categorias
WHERE sal > 10000 AND sal > 20000 AND sal > null;


SELECT empleados.* FROM empleados natural join categorias
WHERE sal < ALL (SELECT ventas FROM oficinas
		WHERE ventas < 0);


--Repetir el ejercicio anterior utilizando ALL en lugar de MAX

select nombre
from empleados
where comision=(select max(comision) from empleados);

select nombre
from empleados
where comision>=ALL(select comision from empleados);

select nombre 
from empleados join oficinas on(oficina=n_oficina) join categorias using (cargo)
where sal+comision*ventas/100=( select max(sal+comision*ventas/100) from empleados join oficinas on(oficina=n_oficina) join categorias using (cargo));

select nombre 
from empleados join oficinas on(oficina=n_oficina) join categorias using (cargo)
where sal+comision*ventas/100>=ALL( select (sal+comision*ventas/100) from empleados join oficinas on(oficina=n_oficina) join categorias using (cargo));

--subconsultas HAVING

SELECT oficina
FROM empleados	JOIN categorias USING(cargo)
		JOIN oficinas ON (oficina=n_oficina)
GROUP BY oficina
HAVING 
  MAX(sal+comision*ventas/100) > ( SELECT MIN(ventas)
				   FROM oficinas);

/*Las que tengan más empleados que alguna oficina (con empleados)*/
SELECT oficina
FROM empleados
GROUP BY oficina
HAVING COUNT(*) > ANY ( SELECT COUNT(*)
			FROM empleados
			GROUP BY oficina);

/*O también todas menos las que tienen el mismo número de empleados que la oficina que tiene menos*/
SELECT oficina FROM empleados
EXCEPT
SELECT oficina FROM empleados
GROUP BY oficina
HAVING COUNT(*) = (SELECT MIN(nro)
		   FROM ( SELECT COUNT(*) AS nro
		          FROM empleados
		          GROUP BY oficina ) AS T
		   );

--WITH

WITH promedios AS (
	SELECT fecha, AVG(temperatura) promedio
	FROM datosMetereologicos
	GROUP BY fecha
	) 
SELECT MAX(promedio) FROM promedios;

select nombre, sal+comision*ventas/100
from empleados join oficinas on(oficina=n_oficina) natural join categorias
where sal+comision*ventas/100 > (	select avg(sal+comision*ventas/100)
					from empleados join oficinas on(oficina=n_oficina) natural join categorias);

with empleadosConSuSueldo as(
	select *, sal+comision*ventas/100 totalSueldo
	from empleados join oficinas on(oficina=n_oficina) natural join categorias)
select nombre, totalSueldo
from empleadosConSuSueldo
where totalSueldo > (select avg(totalSueldo)
		     from empleadosConSuSueldo);


select nombre, comision-(select avg(comision) from empleados where cargo = 'VENDEDOR')
from empleados
where comision < (select avg(comision) from empleados where cargo = 'VENDEDOR')
and cargo = 'VENDEDOR';


with comisionPromedioVendedores as(
	select avg(comision) valor from empleados where cargo = 'VENDEDOR')
select nombre, comision - (select valor from comisionPromedioVendedores)
from empleados
where comision < (select valor from comisionPromedioVendedores)
and cargo = 'VENDEDOR';


with 	joinOficinasEmpleados as ( select * from empleados join oficinas on (oficina=n_oficina)),
	promediosComisionesPorCargo as ( select cargo, avg(comision) avgCargo from empleados group by cargo),
	promediosComisionesPorPoblacion as ( select poblacion, avg(comision) avgPob from joinOficinasEmpleados group by poblacion)
select nombre, cargo, comision - avgCargo, poblacion, comision - avgPob
from joinOficinasEmpleados  natural left join promediosComisionesPorPoblacion
natural left join promediosComisionesPorCargo;


--Ejercicio 10 pero con with
--Oficinas que tienen todos los cargos
delete from categorias where cargo='SECRETARIO';
select n_oficina from oficinas
except
select n_oficina
from (select n_oficina,cargo
from oficinas, categorias
except
select oficina, cargo 
from empleados) as resta;

with productoCartesiano as(select n_oficina, cargo from oficinas, categorias),
resta as( select * from productoCartesiano except select oficina, cargo from empleados)
select n_oficina
from oficinas
except select n_oficina from resta;