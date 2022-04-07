--Reflexivas

/* Caso (0,1):N

   Empleados (0,n) ---- < es jefe de > ( 0, 1) Empleados (Figura 51 de los apuntes)


*/

drop table if exists empleados cascade;

create table empleados (
	dni   		numeric(8) primary key,
	dni_jefe	numeric(8) references empleados,
	nombre          varchar(30) not null,
	salario         numeric( 7, 2)
);


/* 
Insertar las siguientes filas EN ORDEN sin que de error
*/

insert into empleados values ( 1, null, 'Pepe',  10000 );
insert into empleados values ( 2, 1,    'Juan',   3000 );
insert into empleados values ( 3, 1,    'Maria',  3000 );
insert into empleados values ( 4, 2,    'Luis',   1000 );
insert into empleados values ( 5, 2,    'Ana',    1000 );
insert into empleados values ( 6, 3,    'Jorge',  1000 );

/*
Ejercicio
Listado nombre empleado con el nombre de su jefe
*/
select subordinados.nombre, jefes.nombre
from empleados subordinados left join empleados jefes 
	on(subordinados.dni_jefe=jefes.dni);




--Ejercicio: jefes que ganan mas del doble que la suma del salario de sus subordinados directos

select  jefes.nombre, jefes.salario, sum(subordinados.salario)
from empleados subordinados left join empleados jefes 
	on(subordinados.dni_jefe=jefes.dni)
group by jefes.nombre, jefes.salario
having jefes.salario>2*sum(subordinados.salario);

/* Caso (1,1):N

   Empleados (0,n) ---- < es jefe de > ( 1, 1) Empleados (Figura 51 de los apuntes)
*/

drop table if exists empleados cascade;

create table empleados (
	dni   		numeric(8) primary key,
	dni_jefe	numeric(8) references empleados not null,
	nombre          varchar(30) not null,
	salario         numeric( 7, 2)
);


--Es lo mismo pero Pepe es jefe de si mismos
insert into empleados values ( 1, 1,    'Pepe',  10000 );

--lo mismo que antes
insert into empleados values ( 2, 1,    'Juan',   3000 );
insert into empleados values ( 3, 1,    'Maria',  3000 );
insert into empleados values ( 4, 2,    'Luis',   1000 );
insert into empleados values ( 5, 2,    'Ana',    1000 );
insert into empleados values ( 6, 3,    'Jorge',  1000 );


--ya no necesito sea join externo
select subordinados.nombre empleado, jefes.nombre jefe_directo
from empleados subordinados join empleados jefes on( subordinados.dni_jefe=jefes.dni);

/* Caso (0,1):(0,1)

 Pelicula (0,1) --- < Continua con > --- (0,1) Pelicula (figura 57 de los apuntes)

*/

drop table if exists peliculas;

create table peliculas (
	titulo		varchar(40) primary key,
	le_sigue	varchar(40) references peliculas unique,
	año		smallint,
	director	char(50)
);

insert into peliculas values ('Rocky',     null,        1976, 'John G. Avildsen');
insert into peliculas values ('Rocky II',  'Rocky',     1979, 'Sylvester Stallone');
insert into peliculas values ('Rocky III', 'Rocky II',  1982, 'Sylvester Stallone');
insert into peliculas values ('Rocky IV',  'Rocky III', 1985, 'Sylvester Stallone');

insert into peliculas values ('La Comunidad del Anillo', null, 				2001, 'Peter Jackson');
insert into peliculas values ('Las dos torres', 	'La Comunidad del Anillo', 	2002, 'Peter Jackson');
insert into peliculas values ('El retorno del rey',     'Las dos torres', 	 	2003, 'Peter Jackson');

--Caben peliculas que no sean de una serie
insert into peliculas values ('Titanic', null, 1997, 'James Cameron');

/*
No puedo insertar mas de una secuela de la misma pelicula gracias al unique
insert into peliculas values ('Otro Rocky II',  'Rocky',     null, null);

Tampoco una precuela de la misma pelicula gracias a la PK
insert into peliculas values ('Rocky II',  'Rocky I',     null, null);
*/


/*Ejercicio
Hacer la consulta que devuelva este resultado
"Rocky"		;		1976;	""				;""
"Rocky II";			1979;	"Rocky"				;1976
"Rocky III";			1982;	"Rocky II"			;1979
"Rocky IV";			1985;	"Rocky III"			;1982
"Titanic";			1997;	""				;""
"La Comunidad del Anillo";	2001;	""				;""
"Las dos torres";		2002;	"La Comunidad del Anillo"	;2001
"El retorno del rey";		2003;	"Las dos torres"		;2002
*/

select pelicula.titulo,pelicula.año, pelicula.le_sigue, anterior. año
from peliculas pelicula left join peliculas anteriores on(anteriores.titulo=pelicula.le_sigue)
order by pelicula.año;--?¿

/*Caso (1,1):(1,1)

  Vertices manzana (1,1)-------le sigue--------(1,1) Vertices manzana           figura 58 de los apuntes

*/

drop table if exists vertices_manzana cascade;

create table vertices_manzana (
	x float, 	
	y float,
	x_siguiente float not null,
	y_siguiente float not null,
	primary key (x,y),
	foreign key (x_siguiente, y_siguiente) references vertices_manzana,
	unique (x_siguiente, y_siguiente)
);

--no funciona viola FK
/*
insert into vertices_manzana values ( 0,  0,  1, 1);
insert into vertices_manzana values ( 1,  1,  1, 0);
insert into vertices_manzana values ( 1 , 0,  0, 0);
*/

/*Anecdota: si funcionaria en un solo insert*/
-- insert into vertices_manzana values ( 0, 0, 1, 1 ), (1,1,1,0), (1,0, 0,0);

--no funciona viola el not null
/*
insert into vertices_manzana values ( 0, 0, null, null);
insert into vertices_manzana values ( 1 ,1, null, null);

update vertices_mazanas
set x_siguiente=1, y_siguiente=1
where x=0 and y=0;
*/


/*no funcion viola el unique*/
/*
insert into vertices_manzana values ( 0, 0, 0, 0 );
insert into vertices_manzana values ( 1, 1, 0, 0 );

update vertices_mazanas
set x_siguiente=1, y_siguiente=1
where x=0 and y=0;
*/

--Con una restriccion DEFERRABLE no comprueba la violacion de la restriccion hasta el momento de hacer commit de la transaccion

drop table if exists vertices_manzana cascade;

create table vertices_manzana (
	x float, 	
	y float,
	x_siguiente float not null,
	y_siguiente float not null,
	primary key (x,y),
	constraint FK_vm foreign key (x_siguiente, y_siguiente) references vertices_manzana DEFERRABLE,
	unique (x_siguiente, y_siguiente)
);

begin transaction;

	SET CONSTRAINTS FK_VM DEFERRED;
	insert into vertices_manzana values ( 0, 0, 1, 1);
	insert into vertices_manzana values ( 1 ,1, 1, 0);
	insert into vertices_manzana values ( 1 ,0, 0, 0);

commit;

/*Una alternativa => relajar las restricciones por ejemplo quitando los not null y controlar desde 
las aplicaciones que al final de cada actualizacion las manzanas queden cerradas
*/

/*
Representar 1<--->1 no implica que las relaciones representadas sean simetricas

Personas (0,1) ---- se casan -- Personas (0,1)           figura 59 de los apuntes
*/


drop table if exists personas cascade;

CREATE TABLE personas(
	DNI		NUMERIC(8) PRIMARY KEY,
	DNI_conyuge	NUMERIC(8) REFERENCES personas   UNIQUE,
	nombre		CHAR(30) NOT NULL,
	email		CHAR(50)
);

--Caso normal
insert into personas values 	( 1, 2,    'Pepe',  'pepe@pep.com' ),
				( 2, 1,    'María', 'maria@maria.com' ),
				( 3, null, 'Juan',  'juan@juan.com' );

--Triangulo/cadena amoros@
insert into personas values 	( 10, 20,    'Pepe',  'pepe@pep.com' ),
				( 30, null,  'Juan',  'juan@juan.com' ),
				( 20, 30,    'María', 'maria@maria.com' );


/*Alternativas
Controlar esos casos desde la aplicación
Controlarlo con triggers, aserciones => carga el sistema y no se aconseja
*/

/*Caso N:M

Ciudades (0,n) ---- conectadas con ----- (0,n) Ciudades                     figura 61 de los apuntes

*/

drop table if exists ciudades, conecta cascade;
    
CREATE TABLE ciudades(
	ID		INTEGER PRIMARY KEY,
	nombre		CHAR(20) UNIQUE NOT NULL,
	n_plazas	INTEGER
);
CREATE TABLE conecta(
	idOrigen	INTEGER REFERENCES ciudades
			ON DELETE CASCADE ON UPDATE CASCADE,
	idDestino	INTEGER REFERENCES ciudades
			ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY( idOrigen, idDestino)
);

insert into ciudades values( 1, 'BURGOS', 1000), (2, 'MADRID', 50000), (3, 'BARCELONA', 100000);

insert into conecta values ( 1, 2 ), ( 2, 1), (2, 3), (3, 2);


--Ejercicio: cuidades a las que puedo llegar desde Madrid sin escalas

select destino.nombre
from ciudades origen join conecta on (idOrigen=origen.ID)
		join ciudades destino on(idDestino=destino.ID)
where origen.nombre='MADRID';

