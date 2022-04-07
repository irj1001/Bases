drop table if exists alumnos;

create table alumnos(
	alumno		integer,
	asignatura	char(5),	
	nota		numeric(4,2),
	primary key(alumno,asignatura)
);

insert into alumnos values ( 1, 'BDS', 	 2.2), ( 2, 'BDS',   5.2), ( 3, 'BDS',   6.2);
insert into alumnos values ( 1, 'FPROG', 5.2), ( 2, 'FPROG', 2.2), ( 3, 'FPROG', 8.2);
insert into alumnos values ( 1, 'IB',    2.2), ( 2, 'IB',    2.2), ( 3, 'IB',    8.2);

/*1.1*/
select alumno, AVG(nota)
from alumnos
group by alumno
having AVG(nota)>=5;

/*1.2*/
select asignatura, AVG(nota)
from alumnos
where nota>=5
group by asignatura
having count (nota)>1;

