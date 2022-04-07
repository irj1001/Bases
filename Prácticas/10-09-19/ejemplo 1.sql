drop table if exists estudiantes;

create table estudiantes(
idAlumno           integer 
                   constraint pk_estdiantes primary key,
dni                numeric(8)
                   constraint unq_dni_estudiantes unique not null,
nombre             varchar(40)
                   not null,
fecha_nacimiento   date,
nota               numeric(4,2)
                   default 5
                   constraint chk_nota_positiva check(nota>0),
provincia          varchar(15) default 'Burgos'
);

insert into estudiantes
(idAlumno, dni, nombre, fecha_nacimiento, nota)
values 
(1,71569854, 'Pepe', date '25-07-1985',6),
(2,56987456, 'Juan', current_date - 365*30,5);

insert into estudiantes values
(3,33333333, 'Ana', date '25-09-1963',5, null),
(4,44444444, 'Luis', date '26-03-1956',9, null);

select * from estudiantes;