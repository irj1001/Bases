drop table if exists pacientes;

create table pacientes(
	nombre char(10) primary key,
	cama   integer  unique not null,
	peso   numeric(4,1) not null
);

insert into pacientes values ('Pepe', 1, 67), ('Juan', 2, 83), ('Luis', 3, 67), ('Ana', 4, 60);

SELECT cama FROM pacientes
WHERE nombre IN ( 'Pepe', 'Ana', 'Pedro');

SELECT nombre FROM pacientes
WHERE peso IN ( 67, 83, 61);

SELECT nombre FROM pacientes
WHERE peso = 67 OR peso = 83  OR peso = 61;

SELECT nombre FROM pacientes
WHERE NOT peso IN ( 67, 83);

--Not puede cambiarse de sitio para que suene mas natural
SELECT nombre FROM pacientes
WHERE peso NOT IN ( 67, 83);

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
	
