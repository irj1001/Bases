-- El esquema para RelaX se encuentra al final del script

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

	/*Parte 5
1)nombre, tipo de cliente y descuento por tipo de cliente de los clientes ordenados por descuento descendentemente



Solucion
"Exclusivas Segundo";"FRECUENTE ";15.00
"Pepe y Pepa Ltd.";"ESPORADICO";0.00
*/
select nombre, tipo, descuento
from tipos_cliente join clientes using (tipo)
order by descuento desc;



--Solución en RelaX
-- pi nombre, tipo, descuento (clientes join tipos_cliente)

--Repetirla haciendo que salgan todos los tipos de cliente, incluyendo los tipos sin cliente
select nombre, tipo, descuento
from tipos_cliente left join clientes using (tipo)
order by descuento desc;


--Solución en RelaX
-- pi nombre, tipo, descuento (clientes right join tipos_cliente)

--Repetirla haciendo que no se muestreb los tipos en los que el descuento sea 0
--Utiliza coalesce( nombre, 'NO HAY CLIENTES')

select coalesce (nombre, 'NO HAY CLIENTES'), tipo, descuento
from tipos_cliente left join clientes using (tipo)
where descuento!=0
order by descuento desc;



/*2)Que solo salgan clientes españoles (ya no hace falta salgan tipos sin cliente)
Solucion
"Exclusivas Segundo";"FRECUENTE ";15.00
"Pepe y Pepa Ltd.";"ESPORADICO";0.00
*/



--Repetirla en RelaX
	

--2bis Que solo salgan clientes españoñes o portugueses, ¿se puede hacer asi?

select clientes.nombre, clientes.tipo, descuento 
from clientes, tipos_cliente, ciudades
where clientes.tipo=tipos_cliente.tipo and ciudad=acronimo
and (pais='ESPAÑA' or pais='PORTUGAL')
order by descuento desc;





--3) Incorpora al listado anterior la forma de pago y el descuento de la forma de pago

/*sol:
nombre              tipo          dto_por_tipo  dto_por_forma_pago
------------------------------------------------------------------
"Exclusivas Segundo";"FRECUENTE ";       15.00;               0.00
"Pepe y Pepa Ltd."  ;"ESPORADICO";        0.00;               2.50
*/

select clientes.nombre, tipo.tipos_cliente
from clientes join tipos_cliente using (tipo)
              join ciudades on (ciudad=acronimo)
              join formas_pago on (forma_pago_habitual=formas_pago.acronimo)

--3.bis repetirla en RelaX

--4) listado de "todas" las ciudades con sus clientes
/*Sol
"BUR";	"Burgos";	"Pepe y Pepa Ltd."
"MAD";	"Madrid";	"Exclusivas Segundo"
"LIS";	"Lisboa";	"Cliente 3"
"LON";	"Londres";	""
*/

--Repetirla en RelaX

--5) Se puede actualizar una vista basada en un join?

drop view if exists prueba;
create view prueba as select *
from clientes natural join tipos_cliente;

select * from prueba;

delete from prueba where cif=12345678;


/**************************************************ALGEBRA
clientes = {	cif letra_cif	nombre direccion telefono	nro_cuenta forma_pago_habitual ciudad	tipo
12345678 'A' 'Pepe y Pepa Ltd.'   'C/Del cliente 1 nº1'  123456789 123456789012345678901 'CONTA' 'BUR' 'ESPORADICO'
22222222 'B' 'Exclusivas Segundo' 'Av/Del cliente 2 nº2' 222222222 222222222222222222222 'LET30' 'MAD' 'FRECUENTE'
33333333 'C' 'Cliente 3'          'Carretera cli 3 nº3'  333333333 333333333333333333333 'PAYPAL' 'LIS' 'POTENCIAL'
}

tipos_cliente = { tipo	descripcion	descuento
	'ESPORADICO' 'Cliente normal sin descuentos'         0
	'FRECUENTE'  'Frecuente o que hace grandes compras' 15
	'POTENCIAL',  'Cliente a captar bonificado con descuento', 5
	'ANTIGÜO',    'Cliente a recuperar',                      10
}

ciudades = { acronimo	nombre	pais
						'BUR' 'Burgos' 'ESPAÑA'
            'MAD' 'Madrid' 'ESPAÑA'
						'LON' 'Londres' 'UK'
						'LIS', 'Lisboa',  'PORTUGAL'
}

paises = {	pais 
					'ESPAÑA'
					'UK'
					'PORTUGAL'
					}

formas_pago = { acronimo	descripcion	descuento
								'CONTA' 'Al contado' 	2.5
								'LET30' 'Letra a 30 dias'	0
								'TARJ'  'Tarjeta'		0
								'PAYPAL', 'Pago con Pay Pal',  0
							}							
*/

