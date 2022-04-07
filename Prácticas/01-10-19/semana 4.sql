drop table if exists clientes, tipos_cliente, ciudades, paises, formas_pago cascade;

create table paises(
	pais varchar(20) primary key);

insert into paises values ('ESPAÑA'), ('UK'), ('PORTUGAL');

create table ciudades(
        acronimo		varchar(3)  primary key,
	nombre			varchar(20) not null,
	pais			varchar(20) not null	constraint FK_ciudad_pais references paises on delete cascade,
	unique( nombre, pais)
);

insert into ciudades values ('BUR', 'Burgos', 'ESPAÑA'),
                            ('MAD', 'Madrid', 'ESPAÑA'),
                            ('LON', 'Londres','UK'),
			    ('LIS', 'Lisboa', 'PORTUGAL');

create table formas_pago(
	acronimo	    varchar(6) primary key,
	descripcion         varchar(20),
	descuento	    numeric(4,2) check (descuento >= 0 and descuento<=100)

);

insert into formas_pago values 
	('CONTA', 'Al contado', 	2.5),
	('LET30', 'Letra a 30 dias',	0),
	('TARJ',  'Tarjeta',		0),
	('PAYPAL', 'PayPal',		0);

create table tipos_cliente(
	tipo			varchar(10) primary key,
	descripcion		varchar(50),
	descuento		numeric(4,2) check (descuento >= 0 and descuento<=100)
);

insert into tipos_cliente values 
	('ESPORADICO', 'Cliente normal sin descuentos',         0),	
	('FRECUENTE',  'Frecuente o que hace grandes compras', 15),
	('POTENCIAL',  'se quiere captar',			5);

create table clientes(
	cif 			numeric(8),
	letra_cif		char(1), 	
	nombre 			varchar(30) 	not null,
	direccion 		varchar(50),
	telefono 		numeric(9)      not null check(telefono > 0),
	nro_cuenta 		numeric(21)	unique not null,
	forma_pago_habitual 	char(6)		constraint FK_pago_clientes references formas_pago on update cascade,	
	ciudad			varchar(3)	constraint FK_ciudad_clientes references ciudades on delete cascade,
	tipo			char(10)	constraint FK_tipo_cliente references tipos_cliente,
	primary key(cif, letra_cif)
);

insert into clientes values
	(12345678, 'A', 'Pepe y Pepa Ltd.',  'C/Del cliente 1 nº1',  123456789, 123456789012345678901, 'CONTA', 'BUR', 'ESPORADICO'),
	(22222222, 'B', 'Exclusivas Segundo','Av/Del cliente 2 nº2', 222222222, 222222222222222222222, 'LET30', 'MAD', 'FRECUENTE'),
	(33333333, 'C', 'Cliente 3','Carretera del cliente 3 nº3', 333333333, 333333333333333333333, 'PAYPAL', 'LIS', 'POTENCIAL');

delete from paises 
where pais='PORTUGAL' ;	
	
update formas_pago 
set acronimo='METAL', descripcion='Metalico' 
where acronimo='CONTA';	        

select nombre, tipo, descuento 
from clientes join tipos_cliente using (tipo)
order by descuento desc; 



/*Parte 1:
Declarar las claves ajenas necesarias alterando el orden de la declaracion de las tablas e inserciones si fuese necesario.
*/

/*Parte 2, Se quiere insertar este cliente:
(33333333, 'C', 'Cliente 3','Carretera del cliente 3 nº3', 333333333, 333333333333333333333, 'PAYPAL', 'LIS', 'POTENCIAL');

Donde:
PAYPAL = una forma de pago correspondiente al pago con Pay Pal que tiene descuento cero
LIS = Lisboa en Portugal
POTENCIAL = es un tipo de cliente que se quiere captar que esta bonificado con un descuento del 5%

Haz las inserciones necesarias en el orden correcto
*/

/*Parte 3
Se quiere borrar el pais Portugal
1) Haz los borrados necesarios en el orden correcto
2) Que habría que haber hecho para poder hacerlo con una sola operacion DELETE?
*/

/*Parte 4
Se quiere cambiar el acronimo de la forma de pago CONTA a METAL (que significa metalico)
1) Haz las modificaciones necesarias en el orden correcto
2) Que habría que haber hecho para poder hacerlo con una sola operacion UPDATE?
*/

/*Parte 5
Hacer la consulta: nombre, tipo de cliente y descuento por tipo de cliente de los clientes ordenados por descuento descendentemente

Solucion
"Exclusivas Segundo";"FRECUENTE ";15.00
"Pepe y Pepa Ltd.";"ESPORADICO";0.00
*/