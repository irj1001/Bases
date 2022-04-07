drop table if exists alumnos;

create table alumnos	(
	nombre char(10) primary key,
	nota   numeric(3,1),
	fechaMatricula date
);

insert into alumnos values
('Pepe', 4, CURRENT_DATE-1), ('Juan', 5, CURRENT_DATE-1), ('Luis', 6, CURRENT_DATE-1),
('Ana', 7, CURRENT_DATE-2),  ('Maria', 8, CURRENT_DATE-2), ('Olga', 10, CURRENT_DATE-2),
('Laura', 11, CURRENT_DATE-3), ('Iker', null, CURRENT_DATE-3);

--Laura e Iker Sobresaliente ¿?
SELECT nombre,
	CASE
		WHEN nota < 5 THEN 'Suspenso'
		WHEN nota < 7 THEN 'Aprobado'
		WHEN nota < 9 THEN 'Notable'
		ELSE 'Sobresaliente'
	END, fechaMatricula
FROM Alumnos;

--Laura e Iker sin nota
SELECT nombre,
	CASE
		WHEN nota < 5 THEN 'Suspenso'
		WHEN nota < 7 THEN 'Aprobado'
		WHEN nota < 9 THEN 'Notable'
		WHEN nota <=10 THEN 'Sobresaliente'
	END, fechaMatricula
FROM Alumnos;

--o lo que es lo mismo
SELECT nombre,
	CASE
		WHEN nota < 5 THEN 'Suspenso'
		WHEN nota < 7 THEN 'Aprobado'
		WHEN nota < 9 THEN 'Notable'
		WHEN nota <=10 THEN 'Sobresaliente'
		ELSE NULL
	END, fechaMatricula
FROM Alumnos;

-- mas elegante
SELECT nombre,
	CASE
		WHEN nota < 5 THEN 'Suspenso'
		WHEN nota < 7 THEN 'Aprobado'
		WHEN nota < 9 THEN 'Notable'
		WHEN nota <=10 THEN 'Sobresaliente'
		ELSE 'No evaluado'
	END, fechaMatricula
FROM Alumnos;
------------------------------------------------------------------------------
drop table if exists socios;

CREATE TABLE socios(
	DNI NUMERIC(8) PRIMARY KEY,
	nombre CHAR(20),
	tipo	CHAR(1) CHECK (tipo IN ( 'N', 'T', 'J', 'V'))
);

insert into socios values
	( 1, 'Pepe', 'N'),
	( 2, 'Ana',  'T'),
	( 3, 'Luis', 'J'),
	( 4, 'Maria', 'V');

select nombre, case
		when tipo='N' then 'Niño'
		WHEN tipo='T' THEN 'Trabajador'
		WHEN tipo='J' THEN 'Jubilado'
		WHEN tipo='V' THEN 'VIP'
		ELSE 'Valor incorrecto o nulo'
	       end
from socios;


select nombre, case tipo
		when 'N' then 'Niño'
		WHEN 'T' THEN 'Trabajador'
		WHEN 'J' THEN 'Jubilado'
		WHEN 'V' THEN 'VIP'
		ELSE 'Valor incorrecto o nulo'
	       end
from socios;
	
------------------------
--CASE anidado
drop table if exists empleados cascade;
create table empleados(
	dni numeric(8) primary key,
	nombre char(15),
	sueldo numeric(7,2),
	horasSemana numeric(2));

insert into empleados values
	(1, 'Pepe', 500, 40),
	(2, 'Maria', 1200, 20),
	(3, 'Jorge', 1200, 40);

SELECT 'El empleado', nombre,
 CASE
  WHEN sueldo > 1000 THEN
    CASE
      WHEN horasSemana < 35 THEN 'Vive como un rey'
      ELSE 'Trabaja mucho pero cobra bien'
    END
  ELSE
  'Le están explotando'
END
FROM Empleados;

--No tiene sentido hacerlo tan complicado ...

SELECT nombre
FROM Alumnos
WHERE 'Aprobado' =
	CASE
		WHEN nota < 5 THEN 'Suspenso'
		WHEN nota < 7 THEN 'Aprobado'
		WHEN nota < 9 THEN 'Notable'
		WHEN nota <=10 THEN 'Sobresaliente'
	END;

SELECT nombre
FROM Alumnos
WHERE nota >= 5 AND nota < 7;

SELECT nombre
FROM Socios
WHERE 	'Jubilado'=
	CASE
		WHEN tipo='N' THEN 'Niño'
		WHEN tipo='T' THEN 'Trabajador'
		WHEN tipo='J' THEN 'Jubilado'
		WHEN tipo='V' THEN 'VIP'
		ELSE 'Valor incorrecto o nulo'
	END
;

SELECT nombre
FROM Socios
WHERE tipo='J';

---Ejercicio resuelto

drop table if exists t cascade;

create table t(	a numeric(4));

insert into t values (0), (2000);

UPDATE T SET a= CASE
			WHEN a < 1000 THEN a+1000
			ELSE a-1000
		 END;

select * from t;
