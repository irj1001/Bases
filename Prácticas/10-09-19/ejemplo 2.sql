drop table if exists asignaturas;

create table asignaturas (
idAsignatura      integer,
nombre            varchar(40) not null,
titulacion        varchar(40),
ncreditos         smallint,
cuatrimestral     boolean,

--comentario de una linea
/*comentario normal*/
/**comentario 2 **/

constraint pk_asignaturas
primary key ( nombre, titulacion),

constraint unq_asignaturas
unique(nombre, titulacion),

constraint chk_rango_creditos
check(ncreditos>0 and ncreditos<=12)
);

insert into asignaturas values
('Algebra', 'GII', 6, true),
('Calculo', 'GII', null, null);