drop table if exists controla_currelas;

create table controla_currelas(
idTrabajador     integer,
entrada          timestamp,
salida           timestamp not null,

primary key(idTrabajador, entrada),
unique (idTrabajador, salida),
check(entrada<salida)
);

insert into controla_currelas values
(1, '10-09-2019 8:08', '10-09-2019 14:00');

select * from controla_currelas;

select current_timestamp;
