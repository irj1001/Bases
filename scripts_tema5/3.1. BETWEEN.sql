drop table  if exists alumnos;

create table alumnos(
    nombre 		char(20),
    ape1                char(20),
    ape2                char(20),
    fecha_nacimiento	date,
    altura		numeric(3,2),
    primary key ( nombre, ape1, ape2 )
);

insert into alumnos values
( 'Pepe', 'Alvarez',   'Fernandez', current_date-365*17, 1.70),
( 'Pepe', 'Fernandez', 'Fernandez', current_date-365*18, 1.70),    
( 'Pepe', 'Garcia',    'Fernandez', current_date-365*19, 1.90),
( 'Pepe', 'Gonzalez',  'Fernandez', current_date-365*20, 1.70),
( 'Pepe', 'Lopez',     'Fernandez', current_date-365*21, 1.70),    
( 'Pepe', 'Rodriguez', 'Fernandez', current_date-365*22, 1.70);

SELECT ape1 FROM alumnos
WHERE fecha_nacimiento BETWEEN CURRENT_DATE-365*19 AND CURRENT_DATE-365*18;

SELECT nombre, ape1, ape2 FROM alumnos
WHERE ape1 BETWEEN 'Garcia' AND 'Lopez';

SELECT nombre, ape1, ape2 FROM alumnos
WHERE NOT ape1 BETWEEN 'Garcia' AND 'Lopez'
OR altura > 1.70;

drop table if exists ejemplo;

CREATE TABLE ejemplo (
 fiebre NUMERIC( 3, 1) CHECK (fiebre BETWEEN 36 AND 42),
 fechNacimiento	DATE CHECK(
  fechNacimiento BETWEEN DATE '1900-01-01' AND CURRENT_DATE),
 hepatitis CHAR(1) CHECK (hepatitis BETWEEN 'A' AND 'C')
);