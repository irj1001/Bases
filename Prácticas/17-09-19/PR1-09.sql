 drop table if exists articulos;
 create table articulos(
	cod_Seccion         numeric(4)     not null,
	cod_Articulo        numeric(4)             ,
	cod_Armario         numeric(4)     not null,
	existencias         numeric(4)     not null,
	precio              numeric(5,2)   not null,
	coste               numeric(5,2)   not null,

	
	constraint chk_precio_coste check(precio>=coste),
	constraint PK_articulos primary key(cod_Articulo),
	constraint chk_existencias_positivas check(existencias>=0),
	constraint unq_seccion_armario unique(cod_Seccion,cod_Armario)  
);
insert into articulos 
values 
(1111,1,2,5,4,3),
(232,2,6,5,6,3);

select * from articulos