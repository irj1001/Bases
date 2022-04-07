drop table if exists CHICOS, CHICAS, CONOCE;


create table CHICOS(
	DNIchico 	integer primary key,
	nombre	 	varchar(10),
	colorPelo 	varchar(10),
	instituto	varchar(20)
);

insert into CHICOS values	
	 (1, 'Pepe', 'Negro', 'Instituto 1'),
	 (2, 'Juan', 'Rubio', 'Instituto 2'),
	 (3, 'Luis', 'Negro', 'Instituto 2'),
	 (7, 'Martin', 'Marron', 'Instituto 3');

create table CHICAS(
	DNIchica 	integer primary key,
	nombre	 	varchar(10),
	colorPelo 	varchar(10),
	instituto	varchar(20)
);

insert into CHICAS values	
	 (4, 'Ana',	'Rojo',  'Instituto 1'),
	 (5, 'Maria',	'Rojo',  'Instituto 2'),
	 (6, 'Pepa',    'Negro', 'Instituto 2');

create table CONOCE( 
	DNIchico integer references CHICOS,
	DNIchica integer references CHICAS,
	PRIMARY KEY (DNIChico, DNIChica));
	
insert into CONOCE values
	 (1, 4),
	 (1, 5),
	 (1, 6),
	 (2, 4),
	 (2, 5),
	 (3, 5),
	 (3, 6),
	 (7, 4);

--DNI Chicos que conocen a todas las chicas

SELECT DNIchico FROM conoce
GROUP BY DNIchico
HAVING count(*) = ( SELECT COUNT(*) FROM Chicas);

--Nombre chicos que conocen a todas las chicas

SELECT DNIchico, nombre FROM conoce natural join chicos
GROUP BY DNIchico, nombre
HAVING count(*) = ( SELECT COUNT(*) FROM Chicas);

--insertamos una chica que no conoce nadie
insert into CHICAS values	
	 (7, 'Luisa',	'Negro',  'Instituto 1');

--Nombre chicos que conocen a todas las chicas que son conocidas por algun chico
SELECT DNIchico, nombre FROM conoce natural join chicos
GROUP BY DNIchico, nombre
HAVING count(*) = ( SELECT COUNT(distinct dniChica) FROM Conoce);

--borramos a la chica desconocida
delete from chicas where dniChica=7;

--los institutos tal que entre todos sus chicos conocen a todas las chicas
SELECT instituto FROM conoce natural join chicos
GROUP BY instituto
HAVING count(DISTINCT dniChica) = ( SELECT COUNT(*) FROM Chicas);

--Chicos que conocen a todas las pelirrojas

--MAL
SELECT DNIchico, nombre FROM conoce natural join chicos
GROUP BY DNIchico, nombre
HAVING count(*) = ( SELECT COUNT(*) FROM Chicas
			WHERE colorPelo='Rojo');

--BIEN
SELECT DNIchico, chicos.nombre 
FROM (conoce natural join chicos) join chicas using (DNIchica)
WHERE chicas.colorPelo='Rojo'
GROUP BY DNIchico, chicos.nombre 
HAVING count(*) = ( SELECT COUNT(*) FROM Chicas
			WHERE colorPelo='Rojo');

--Chicos del instituto 2 que conocen a todas las pelirrojas
SELECT DNIchico, chicos.nombre 
FROM (conoce natural join chicos) join chicas using (DNIchica)
WHERE chicas.colorPelo='Rojo'
AND chicos.instituto='Instituto 2'
GROUP BY DNIchico, chicos.nombre 
HAVING count(*) = ( SELECT COUNT(*) FROM Chicas
			WHERE colorPelo='Rojo');

--chicos que conocen a más del 50% de las chicas
SELECT DNIchico, nombre FROM conoce natural join chicos
GROUP BY DNIchico, nombre
HAVING count(*) >= 0.5*( SELECT COUNT(*) FROM Chicas);