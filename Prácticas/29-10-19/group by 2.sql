DROP TABLE IF EXISTS regalos CASCADE;
DROP TABLE IF EXISTS politicos CASCADE;
DROP TABLE IF EXISTS aceptaResignadamente CASCADE;

CREATE TABLE regalos(
  regalo CHAR(20) PRIMARY KEY,
  valor  INTEGER NOT NULL );

CREATE TABLE politicos(
  nombre  CHAR(10) PRIMARY KEY,
  partido CHAR(10)  NOT NULL,
  cargo  CHAR(10) NOT NULL,
  regaloFavorito CHAR(20) NOT NULL REFERENCES REGALOS );

CREATE TABLE aceptaResignadamente(
  id	INTEGER  PRIMARY KEY,
  nombre        CHAR(10) REFERENCES politicos,
  regalo        CHAR(20) REFERENCES regalos  
);  

INSERT INTO regalos VALUES ( 'regalo_1', 100 ),
  ( 'regalo_2', 200 ),
  ( 'regalo_3', 300 ),
  ( 'regalo_4', 400 );

INSERT INTO politicos VALUES ( 'politico_1', 'partido_1', 'cargo_1', 'regalo_1'),
    ( 'politico_2', 'partido_1', 'cargo_1', 'regalo_2'),
    ( 'politico_3', 'partido_2', 'cargo_1', 'regalo_2'),
    ( 'politico_4', 'partido_2', 'cargo_2', 'regalo_1'),
    ( 'politico_5', 'partido_2', 'cargo_2', 'regalo_3');

INSERT INTO aceptaResignadamente VALUES 
( 1, 'politico_1', 'regalo_1'),
( 2, 'politico_1', 'regalo_1'),
( 3, 'politico_3', 'regalo_1'),
( 4, 'politico_4', 'regalo_1'),
( 5, 'politico_5', 'regalo_4');

--Partidos que aceptan regalos con el número de regalos que aceptan. 
--Ordenardos descendentemente por nro de regalos aceptados

select partido, count(regalo)
from politicos join aceptaResignadamente using (nombre)
group by partido
order by count(regalo) DESC;

/*Solucion
"partido_2 ";3
"partido_1 ";2
*/

--Partidos en los que la suma de los regalos aceptados supera los 500 euros

select partido, sum(valor)
from politicos 	join aceptaResignadamente using (nombre)
		join regalos using (regalo)
group by partido
having sum(valor) >=500;

--Solucion: "partido_2 ";600

--todos los politicos con su partido y la suma del valor de los regalos que los aceptan.
--Si un politico no acepta regalos que ponga cero en la suma del valor.
--Ordenardos descendentemente por la suma del valor de los regalos aceptados

select nombre, partido, coalesce (sum(valor),0)
from politicos 	left join aceptaResignadamente using (nombre)
		left join regalos using (regalo)
group by nombre
order by coalesce (sum(valor),0) desc;

/*Solucion
"politico_5";"partido_2 ";400
"politico_1";"partido_1 ";200
"politico_3";"partido_2 ";100
"politico_4";"partido_2 ";100
"politico_2";"partido_1 ";0
*/


--Valor máximo valor de la suma de los regalos aceptados por cada partido 
--Solucion: 600


