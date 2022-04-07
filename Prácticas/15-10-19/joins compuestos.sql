drop table if exists clientes, tipos_cliente, ciudades, paises, formas_pago cascade;

create table tipos_cliente(
	tipo			varchar(10) primary key,
	descripcion		varchar(50),
	descuento		numeric(4,2) check (descuento >= 0 and descuento<=100)
);

create table paises(
	pais varchar(20) primary key);

create table ciudades(
        acronimo		varchar(3)  primary key,
	nombre			varchar(20) not null,
	pais			varchar(20) not null references paises,
	unique( nombre, pais)
);

create table formas_pago(
	acronimo	    varchar(6) primary key,
	descripcion         varchar(20),
	descuento	    numeric(4,2) check (descuento >= 0 and descuento<=100)
);

create table clientes(
	cif 			numeric(8),
	letra_cif		char(1), 	
	nombre 			varchar(30) 	not null,
	direccion 		varchar(50),
	telefono 		numeric(9)      not null check(telefono > 0),
	nro_cuenta 		numeric(21)	unique not null,
	forma_pago_habitual 	char(10) references formas_pago,	
	ciudad			varchar(3) references ciudades,
	tipo			char(10) references tipos_cliente,
	primary key(cif, letra_cif)
);


insert into tipos_cliente values 
	('ESPORADICO', 'Cliente normal sin descuentos',         0),	
	('FRECUENTE',  'Frecuente o que hace grandes compras', 15),
	('POTENCIAL',  'Cliente a captar bonificado con descuento', 5),
	('ANTIGÜO',    'Cliente a recuperar',                      10);

insert into paises values ('ESPAÑA'), ('UK'), ('PORTUGAL');

insert into ciudades values ('BUR', 'Burgos',  'ESPAÑA'),
                            ('MAD', 'Madrid',  'ESPAÑA'),
                            ('LON', 'Londres', 'UK'),
                            ('LIS', 'Lisboa',  'PORTUGAL');

insert into formas_pago values 
	('CONTA', 'Al contado', 	2.5),
	('LET30', 'Letra a 30 dias',	0),
	('TARJ',  'Tarjeta',		0),
	('PAYPAL', 'Pago con Pay Pal',  0);
	
insert into clientes values
	(12345678, 'A', 'Pepe y Pepa Ltd.',  'C/Del cliente 1 nº1',  123456789, 123456789012345678901, 'CONTA', 'BUR', 'ESPORADICO'),
	(22222222, 'B', 'Exclusivas Segundo','Av/Del cliente 2 nº2', 222222222, 222222222222222222222, 'LET30', 'MAD', 'FRECUENTE'),
	(33333333, 'C', 'Cliente 3','Carretera del cliente 3 nº3', 333333333, 333333333333333333333, 'PAYPAL', 'LIS', 'POTENCIAL');

/*
1) Haz los arreglos oportunos en el create table para que admita los inserts
*/
drop table if exists facturas cascade;


CREATE TABLE facturas(
	nro NUMERIC(5) CONSTRAINT PK_nro_facturas PRIMARY KEY CHECK(nro>=0),
	fecha DATE NOT NULL,
	cif_cliente numeric(8) not null,
	letra_cif_cliente char(1) not null,
	forma_pago char(10) CONSTRAINT FK_facturas_Formas_pago REFERENCES formas_pago
		ON UPDATE CASCADE,	
	CONSTRAINT FK_facturas_Clientes foreign key(cif_cliente,letra_cif_cliente) REFERENCES clientes
);

INSERT INTO facturas VALUES (101,'5-02-2018', '12345678', 'A','LET30'),
			    (102,'25-12-2016','22222222', 'B','CONTA'),
			    (103,'26-12-2016','22222222', 'B','TARJ'),			    
			    (104,'4-08-2017', '22222222', 'B', 'CONTA'),
			    (105,'5-06-2018', '12345678', 'A', 'TARJ'),
			    (106,'25-12-2016','22222222', 'B', 'CONTA');

/*2) Obtener cif, letra_cif, nombre del cliente y número de factura. Han de salir también los clientes sin facturas
ordenado por cif de cliente y nro de factura

Solución:
12345678;"A";"Pepe y Pepa Ltd."		;101	;"2018-02-05"
12345678;"A";"Pepe y Pepa Ltd."		;105	;"2018-06-05"
22222222;"B";"Exclusivas Segundo"	;102	;"2016-12-25"
22222222;"B";"Exclusivas Segundo"	;103	;"2016-12-26"
22222222;"B";"Exclusivas Segundo"	;104	;"2017-08-04"
22222222;"B";"Exclusivas Segundo"	;106	;"2016-12-25"
33333333;"C";"Cliente 3"		;	;""

*/
select cif, letra_cif, nombre, nro
from clientes left join facturas on(cif=cif_cliente and letra_cif=letra_cif_cliente)
order by clientes.cif, facturas.nro;


/*
3) Modifica el create table y la consulta anterior renombrando los campos 
	cif_cliente y letra_cif_cliente
   con el mismo nombre que tienen en la tabla de clientes, es decir:
	cif y letra_cif

*/



