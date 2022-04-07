
drop table if exists alumnos;
create table alumnos(
	nombre	 char(20) primary key,	
	practica numeric(4,2),
	teoria numeric(4,2)
);

insert into alumnos values ('Pedro', 5, 7),
			   ('Pablo',   1, 5),
			   ('Ana', 8, null),
			   ('Pepe',  6, 6);
						    
SELECT 	AVG((practica+teoria)/2), AVG(DISTINCT (practica+teoria)/2)
FROM alumnos;

delete from alumnos;
insert into alumnos values ('Pedro', 5, 7),
			   ('Ana', null, 5),
			   ('Pablo',  8, null),			   
			   ('Pepe',  6, 6);


SELECT 	AVG(practica) FROM alumnos
WHERE Nombre<'Ana';

SELECT AVG(practica) FROM alumnos
WHERE Nombre<='Ana';

SELECT 	AVG((practica+teoria)/2) FROM alumnos
WHERE Nombre<'Pedro';