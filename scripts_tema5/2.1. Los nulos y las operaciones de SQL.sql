drop table if exists miTabla;

create table miTabla(
  campo1 char(20),
  campo2 char(20),
  campo3 char(20) default 'por defecto'
 );

INSERT INTO miTabla ( Campo1, Campo3 )
VALUES ('Valor Campo 1', 'Valor Campo 3');

INSERT INTO miTabla ( Campo1, Campo3 )
VALUES ('Valor Campo 1', null);

INSERT INTO miTabla
VALUES ('Valor Campo 1', 'Valor Campo 2');

UPDATE miTabla
SET Campo1=null
WHERE campo2='Valor Campo 2';

ALTER TABLE miTabla
ADD COLUMN Campo4 CHAR(5);

ALTER TABLE miTabla
ADD COLUMN Campo5 CHAR(5) DEFAULT 'x';

INSERT INTO miTabla ( Campo1, Campo2, Campo3 )
VALUES ('', '      ', null);

select * from miTabla;

drop table if exists Facturas cascade;
create table facturas (
 numFactura 	integer primary key,
 razonSocial    char(40),
 total		numeric(8,2)
);

insert into facturas values (1, null, null), (2, 'Pepe', 10);

SELECT numFactura, total*1.15, 'A la atencion de '||razonSocial , cos(total), substr(razonSocial, 2, 3)
FROM Facturas;
