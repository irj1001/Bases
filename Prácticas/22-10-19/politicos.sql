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

INSERT INTO aceptaResignadamente VALUES ( 1, 'politico_1', 'regalo_1'),
( 2, 'politico_1', 'regalo_1'),
( 3, 'politico_3', 'regalo_1'),
( 4, 'politico_4', 'regalo_1'),
( 5, 'politico_5', 'regalo_4');

--todos los regalos con los politicos que los aceptan
select regalo, nombre
from regalos left join aceptaResignadamente using (regalo);
/*Solucion;

"regalo_1            ";"politico_1"
"regalo_1            ";"politico_1"
"regalo_1            ";"politico_3"
"regalo_1            ";"politico_4"
"regalo_4            ";"politico_5"
"regalo_2            "; null
"regalo_3            "; null

*/



select regalo, coalesce (nombre, 'NO REGALADO')
from regalos left join aceptaResignadamente using (regalo)
;
--todos los regalos con los politicos que los aceptan, si un regalo no lo acepta nadie que ponga "NO REGALADO"
/*Solucion

"regalo_1            ";"politico_1"
"regalo_1            ";"politico_1"
"regalo_1            ";"politico_3"
"regalo_1            ";"politico_4"
"regalo_4            ";"politico_5"
"regalo_2            ";"NO REGALADO"
"regalo_3            ";"NO REGALADO"
*/



select distinct regalo, coalesce (partido, 'NO REGALADO')
from regalos left join (aceptaResignadamente join politicos using (nombre) )using (regalo)
order by regalo;

--todos los regalos con los partidos que los aceptan (usa disitntc y ordena por regalo)
/*Solucion
"regalo_1            ";"partido_1 "
"regalo_1            ";"partido_2 "
"regalo_2            ";""
"regalo_3            ";""
"regalo_4            ";"partido_2 "
*/



--todos los regalos con los políticos, cargos y partidos donde un cargo distinto del cargo 2 lo ha aceptado:
/*Solucion
"regalo_1            ";"politico_1";"cargo_1   ";"partido_1 "
"regalo_1            ";"politico_3";"cargo_1   ";"partido_2 "
"regalo_2            ";null;null;null
"regalo_3            ";null;null;null
"regalo_4            ";null;null;null
*/



select distinct regalo, aceptaresignadamente.nombre, cargo, partido
from regalos left join
(aceptaResignadamente join politicos on (aceptaResignadamente.nombre=politicos.nombre and cargo!='cargo_2') ) using (regalo)
 order by regalo;