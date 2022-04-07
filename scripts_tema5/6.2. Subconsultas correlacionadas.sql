DROP TABLE IF EXISTS oficinas CASCADE;
DROP TABLE IF EXISTS vendedores CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;

CREATE TABLE oficinas(
 n_oficina  integer primary key,
 poblacion     char(20),
 objetivo   integer,
 ventas     integer
 );

INSERT INTO oficinas VALUES ( 1, 'Burgos',     200, 400);
INSERT INTO oficinas VALUES ( 2, 'Madrid',    1000, 1000);
INSERT INTO oficinas VALUES ( 3, 'Barcelona', 1000, 0);

 CREATE TABLE categorias(
  cargo char(20) primary key,
  sal   integer
 );

INSERT INTO categorias VALUES ('COMERCIAL',          100);
INSERT INTO categorias VALUES ('TECNICO COMERCIAL',  150);
INSERT INTO categorias VALUES ('DIRECTOR COMERCIAL', 250);

 CREATE TABLE vendedores(
  idVendedor integer primary key,
  nombre     char(20),
  cuota      integer,
  comision   integer,
  oficina    integer  references oficinas,
  cargo      char(20) references categorias
 );

INSERT INTO vendedores VALUES ( 1, 'Pepe', 100, 20, 1, 'DIRECTOR COMERCIAL');
INSERT INTO vendedores VALUES ( 2, 'Juan', 100, 10, 1, 'TECNICO COMERCIAL');
INSERT INTO vendedores VALUES ( 3, 'Ana',  100, 0, 1, 'COMERCIAL');

INSERT INTO vendedores VALUES ( 4, 'Maria', 100, 7, 2, 'DIRECTOR COMERCIAL');
INSERT INTO vendedores VALUES ( 5, 'Luis',  100, 7, 2, 'COMERCIAL');

SELECT poblacion FROM oficinas 
WHERE objetivo >(SELECT SUM(cuota)
		FROM vendedores
		WHERE oficina=n_oficina);

SELECT cargo FROM categorias
WHERE sal > (	SELECT SUM(cuota)
		FROM vendedores
		WHERE cargo=categorias.cargo); 

SELECT poblacion FROM oficinas 
WHERE objetivo > (	SELECT SUM(cuota)
			FROM vendedores
			WHERE oficina=n_oficina);
/*

SELECT n_oficina, poblacion, objetivo FROM oficinas;

--Oficinas.n_oficina=1, objetivo=200
SELECT poblacion FROM oficinas 
WHERE objetivo > (	SELECT SUM(cuota)
			FROM vendedores
			WHERE oficina=1)
AND n_oficina=1;

--Oficinas.n_oficina=2, objetivo=1000
SELECT poblacion FROM oficinas 
WHERE objetivo > (	SELECT SUM(cuota)
			FROM vendedores
			WHERE oficina=2)
AND n_oficina=2;

--Oficinas.n_oficina=3, objetivo=1000
SELECT poblacion FROM oficinas 
WHERE objetivo > (	SELECT SUM(cuota)
			FROM vendedores
			WHERE oficina=3)
AND n_oficina=3;
*/

--Correlacionada en la SELECT
--Empleados con su desviacion de comision respecto a la media de SU oficina

/*
SELECT nombre, comision, oficina 
FROM vendedores;

        Comision
Pepe Ofi1 20
Juan Ofi1 10
Ana  Ofi1  0
           Promedio Ofi1 = (20+10)/3=10
           
Maria Ofi2 7
Luis  Ofi2 7
	  Promedio Ofi2 = 7
*/

SELECT nombre, comision - ( SELECT AVG(comision)
                            FROM vendedores
                            WHERE oficina = v.oficina )
FROM vendedores v;

/*Deshacer la correlación oficina de vendedor por oficina de vendedor

SELECT nombre, comision, comision - ( SELECT AVG(comision)
                            FROM vendedores
                            WHERE oficina = 1)
FROM vendedores e
WHERE oficina=1

union

SELECT nombre, comision, comision - ( SELECT AVG(comision)
                            FROM vendedores
                            WHERE oficina = 2)
FROM vendedores e
WHERE oficina=2

union

SELECT nombre, comision, comision - ( SELECT AVG(comision)
                            FROM vendedores
                            WHERE oficina = 3)
FROM vendedores e
WHERE oficina=3;

*/

/*******************************************
SELECT * FROM vendedores;

while haya vendedores que leer{
	e := siguiente vendedor;

        sP_nombre   := e.nombre;
        sP_comision := e.comision;
        sP_oficina  := e.oficina;
        
        avg_comison := SELECT AVG(comision)
                            FROM vendedores
                            WHERE oficina = [sP_oficina];

        mostrar( sP_nombre, sP_comision, sP_comision-avg_comison );
}

*******************************************/

--Correlacionadas en el where con ANY/ALL
--Poblaciones con oficinas en las que las ventas son menores
--que la comision*1000 de ALGUNO de SUS vendedeores (los de ESA oficina)

SELECT poblacion FROM oficinas                                         
WHERE ventas < ANY( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=n_oficina);


SELECT n_oficina, poblacion, ventas, comision*100 as "comision x 100"
FROM oficinas left join vendedores ON(oficina=n_oficina)
order by n_oficina;

--Deshago la correlación razonando oficina por ofician

--Burgos->Ofi1->Ventas=400
--                     Pepe 20*100=2000 => OK =>Burgos ya sale, ANY le basta con que lo cumpla uno
--                     Juan 10*100=1000 => OK
--                     Ana   0*100=0 => NO
--
--Madrid->Ofi2->Ventas=1000
--                     Maria 7*100=700 => NO
--                     Luis  7*100=700 => NO =>Madrid no sale ANY necesita que lo cumpla alguno
--Barcelona->Ofi3->Ventas=0 sin empleados => NO => Barcelona no sale (no tiene empleados => no lo puede cumplir ninguno)

/*Deshago la correlación en SQL

SELECT poblacion, ventas FROM oficinas 
where n_oficina=1                    
and ventas < ANY( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=1)

union

SELECT poblacion, ventas FROM oficinas 
where n_oficina=2                    
and ventas < ANY( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=2)

union

SELECT poblacion, ventas FROM oficinas 
where n_oficina=3                    
and ventas < ANY( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=3);

*/

/*************************************************
--Deshago la correlacion via pseudocodigo

SELECT * FROM oficinas;

while haya oficinas que leer{
       leer siguiente oficina; 

       sP_poblacion    := oficinas.poblacion;
       sP_ventas    := oficinas.ventas;	 
       sP_n_oficina := oficinas.n_oficina;

       SELECT *
       FROM vendedores
       WHERE oficina=[sp_n_oficina];

       heEncontradoAlguno := FALSE;

       while (haya vendedores que leer AND NOT heEncontradoAlguno) {
        subconsulta_comisionx100 := vendedores.comison*100;

	if (sP_ventas < subconsulta_comisionx100==TRUE){
	       heEncontradoAlguno := TRUE;
        }
       }

       if (heEncontradoAlguno)
            mostrar(sP_poblacion)
}

**************************************************/

--Poblaciones con oficinas en las que las ventas son menores
--que la comision*1000 de TODOS SUS vendedeores (los de ESA oficina)

SELECT poblacion FROM oficinas 
WHERE ventas < ALL( SELECT comision*1000
		    FROM vendedores
		    WHERE oficina=n_oficina);

/*
SELECT n_oficina, poblacion, ventas, comision*1000 as "comision x 1000"
FROM oficinas left join vendedores ON(oficina=n_oficina)
order by n_oficina;
*/

--Deshago la correlación razonando oficina por oficina
--Burgos->Ofi1->Ventas=400
--                     Pepe 20*1000=20000 
--                     Juan 10*1000=10000 
--                     Ana   0*1000=0 => Contraejemplo en el que ventas<comision*1000 no es verdadero => ALL no se cumple => Burgos no sale
--
--Madrid->Ofi2->Ventas=1000
--                     Maria 7*1000=7000 
--                     Luis  7*1000=7000 => No hay Contraejemplos => Madrid sale
--
--Barcelona->Ofi3->Ventas=0 sin empleados => No Contraejemplo => Barcelona sale

/*

--Deshago la correlación en SQL

SELECT poblacion, ventas FROM oficinas 
where n_oficina=1                    
and ventas < ALL( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=1)
union

SELECT poblacion, ventas FROM oficinas 
where n_oficina=2                    
and ventas < ALL( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=2)

union

SELECT poblacion FROM oficinas 
WHERE ventas < ALL ( SELECT comision*100
                    FROM vendedores
                    WHERE oficina=3)
and n_oficina=3;                    

*/

/*************************************************
--Deshago la correlacion via pseudocodigo

SELECT * FROM oficinas;

while haya oficinas que leer{
       leer siguiente oficina; 

       sP_poblacion    := oficinas.poblacion;
       sP_ventas    := oficinas.ventas;	 
       sP_n_oficina := oficinas.n_oficina;

       SELECT *
       FROM vendedores
       WHERE oficina=[sp_n_oficina];

       heEncontradoAlgunContraejemplo := FALSE;

       while (haya vendedores que leer OR heEncontradoAlgunContraejemplo{
        subconsulta_comisionx100 := vendedores.comison*100;

	if not (sP_ventas < subconsulta_comisionx100==TRUE){
	       heEncontradoAlgunContraejemplo := TRUE;
        }
       }

       if not (heEncontradoAlgunContraejemplo)
            mostrar(sP_poblacion)
}

**************************************************/

--Subconsultas correlacionadas en el having
--Poblaciones en las que el promedio de la comision de sus oficinas
--es menor que el doble de la comision de todos sus empleados => hay mucha varianza en las comisiones (estan mal repartidas)

SELECT poblacion
FROM oficinas JOIN vendedores ON(oficina=n_oficina)
GROUP BY n_oficina, poblacion		--Podia haber habido 2 oficinas en la misma poblacion
HAVING AVG(comision) < ALL( SELECT comision*2
                            FROM vendedores
                            WHERE oficina=n_oficina);


/*
SELECT poblacion, comision*2 "comision*2", (select avg(comision) from vendedores where oficina=n_oficina) "avg(comision)"
FROM oficinas JOIN vendedores ON(oficina=n_oficina);	
*/

--Deshago la correlación razonando poblacion por poblacion

--Burgos->Ofi1->Avg comision = 10
--                     Pepe 20*2=40 
--                     Juan 10*2=20 
--                     Ana   0*2=0 => Contraejemplo
--
--Madrid->Ofi2->Avg comision = 7
--                     Maria 7*2=14 
--                     Luis  7*2=14
--				 => NO Contraejemplo
--Barcelona->Ofi3-> Aunque No Contraejemplo
--   El grupo no llega a existir porque esa oficina se pierde en el join por ser interno

/*
--Deshago la correlación en SQL

SELECT poblacion, avg(comision)
FROM oficinas JOIN vendedores ON(oficina=n_oficina)
WHERE n_oficina=1
GROUP BY n_oficina, poblacion		--Podia haber habido 2 oficinas en la misma poblacion
HAVING AVG(comision) < ALL( SELECT comision*2
                            FROM vendedores
                            WHERE oficina=1)

union

SELECT poblacion, avg(comision)
FROM oficinas JOIN vendedores ON(oficina=n_oficina)
WHERE n_oficina=2
GROUP BY n_oficina, poblacion		--Podia haber habido 2 oficinas en la misma poblacion
HAVING AVG(comision) < ALL( SELECT comision*2
                            FROM vendedores
                            WHERE oficina=2)
                            
union

SELECT poblacion, avg(comision)
FROM oficinas JOIN vendedores ON(oficina=n_oficina)
WHERE n_oficina=3
GROUP BY n_oficina, poblacion		--Podia haber habido 2 oficinas en la misma poblacion
HAVING AVG(comision) < ALL( SELECT comision*2
                            FROM vendedores
                            WHERE oficina=3)



*/

/*************************************************
--Deshago la correlacion via pseudocodigo

SELECT n_oficina, poblacion, AVG(comision) avgComision
FROM FROM oficinas JOIN vendedores ON(oficina=n_oficina)
GROUP BY n_oficina, poblacion;

while haya oficinas que leer{//Cada oficina es un grupo del group by
       leer siguiente oficina; 

       sP_poblacion    := oficinas.poblacion;
       sP_n_oficina := oficinas.n_oficina;
       sP_avg       := avgComision;	 

       SELECT *
       FROM vendedores
       WHERE oficina=[sp_n_oficina];

       heEncontradoAlgunContraejemplo := FALSE;

       while (haya vendedores que leer AND NOT heEncontradoAlgunContraejemplo){
        subconsulta_comisionx2 := vendedores.comison*2;

	if not (sP_avg < subconsulta_comisionx2==TRUE){
	       heEncontradoAlgunContraejemplo := TRUE;
        }
       }

       if not (heEncontradoAlgunContraejemplo)
            mostrar(sP_oficina, sP_poblacion)
}

**************************************************/


--Correlacionadas con EXISTS
--	*El EXISTS solo tiene sentido con las correlacionadas
--      *La subselect se pone con *, porque da igual que campos devuelva

select nombre, ventas
FROM oficinas JOIN vendedores ON(oficina=n_oficina);

--Vendedores de oficinas con ventas > 500
--Vendedores tales que existe una oficina igual que la suya y las ventas de la misma es > 500
/*             Ventas
Ofi1,  'Burgos',   400
Ofi2, 'Madrid',    1000
Ofi3, 'Barcelona', 0
*/

SELECT nombre, oficina FROM vendedores
WHERE EXISTS ( SELECT * FROM oficinas
               WHERE oficina=n_oficina
               AND ventas > 500);
/*
--correlacion deshecha en SQL

SELECT nombre, oficina FROM vendedores
WHERE oficina=1
and EXISTS ( SELECT * FROM oficinas
               WHERE n_oficina=1
               AND ventas > 500)

union

SELECT nombre, oficina FROM vendedores
WHERE oficina=2
and EXISTS ( SELECT * FROM oficinas
               WHERE n_oficina=2
               AND ventas > 500)
union
               
SELECT nombre, oficina FROM vendedores
WHERE oficina=3
and EXISTS ( SELECT * FROM oficinas
               WHERE n_oficina=3
               AND ventas > 500)
;

*/
/*************************************************
--correlacion deshecha en pseudocodigo

SELECT * FROM vendedores;

while haya vendedores que leer{
       leer siguiente vendedor; 

       sP_nombre   := vendedor.nombre;
       sP_oficina  := vendedor.oficina;

       cuantas := SELECT COUNT(*) FROM oficinas
                  WHERE n_oficina=[sp_oficina]
                  AND ventas > 500;

       if (cuantas>0)
            mostrar(sP_nombre, sP_oficina);
}

**************************************************/

SELECT nombre, oficina FROM vendedores
WHERE 0<    (  SELECT COUNT(*) FROM oficinas
               WHERE oficina=n_oficina
               AND ventas > 500);

--Suelen tener una equivalente directa con join
SELECT nombre, oficina
FROM vendedores join oficinas ON(oficina=n_oficina)
WHERE ventas > 500;

--Tambien son utiles para hacer intersecciones
--Oficinas con tecnicos comerciales y directores comerciales
SELECT oficina FROM vendedores where cargo='COMERCIAL'
intersect
SELECT oficina FROM vendedores where cargo='DIRECTOR COMERCIAL';

--Es lo mismo que
SELECT n_oficina FROM oficinas
where exists (select * from vendedores where cargo='COMERCIAL' and oficina=n_oficina)
and exists (select * from vendedores where cargo='DIRECTOR COMERCIAL' and oficina=n_oficina);

/*
--Deshago correlación razonando
Ofi1
'Pepe', 'DIRECTOR COMERCIAL'
'Juan', 'TECNICO COMERCIAL'
'Ana',  'COMERCIAL'

Ofi2
'Maria', 'DIRECTOR COMERCIAL'
'Luis',  'COMERCIAL'

Ofi3 => Vacía

*/

/*
--Deshago correlacion con SQL

SELECT n_oficina FROM oficinas
where n_oficina=1
and exists (select * from vendedores where cargo='COMERCIAL' and oficina=1)
and exists (select * from vendedores where cargo='DIRECTOR COMERCIAL' and oficina=1)

union

SELECT n_oficina FROM oficinas
where n_oficina=2
and exists (select * from vendedores where cargo='COMERCIAL' and oficina=2)
and exists (select * from vendedores where cargo='DIRECTOR COMERCIAL' and oficina=2)

union

SELECT n_oficina FROM oficinas
where n_oficina=3
and exists (select * from vendedores where cargo='COMERCIAL' and oficina=3)
and exists (select * from vendedores where cargo='DIRECTOR COMERCIAL' and oficina=3);

*/

--Con el NOT tiene equivalencia con el EXCEPT
--Con Algebra: Vendedores de las oficinas donde no existen técnicos comerciales = Vendedores de todas las oficinas - vendedores de las oficinas con tecnicos
select nombre from vendedores, (select n_oficina
				from oficinas
				except
				select oficina
				from  vendedores
				where cargo = 'TECNICO COMERCIAL'
				) as ifSinTecnic
where oficina=n_oficina;
/*
--Deshago correlación razonando
Ofi1
'Pepe', 'DIRECTOR COMERCIAL'
'Juan', 'TECNICO COMERCIAL'
'Ana',  'COMERCIAL'

Ofi2
'Maria', 'DIRECTOR COMERCIAL'
'Luis',  'COMERCIAL'

Ofi3 => Vacía

*/

SELECT nombre, oficina FROM vendedores externa
WHERE NOT EXISTS ( SELECT * FROM vendedores 
                   WHERE externa.oficina=oficina
                   AND cargo='TECNICO COMERCIAL');

/*

--Deshago correlacion en SQL

SELECT nombre, oficina, cargo FROM vendedores externa
WHERE oficina=1
and NOT EXISTS ( SELECT * FROM vendedores 
                   WHERE oficina=1
                   AND cargo='TECNICO COMERCIAL')

union

SELECT nombre, oficina, cargo FROM vendedores externa
WHERE oficina=2
and NOT EXISTS ( SELECT * FROM vendedores 
                   WHERE oficina=2
                   AND cargo='TECNICO COMERCIAL')

union
                   
SELECT nombre, oficina, cargo FROM vendedores externa
WHERE oficina=3
and NOT EXISTS ( SELECT * FROM vendedores 
                   WHERE oficina=3
                   AND cargo='TECNICO COMERCIAL');

*/

/*************************************************

--Deshago correlación en pseudocódigo

SELECT * FROM vendedores externa;

while haya vendedores de externa que leer{
       leer siguiente vendedor de externa; 

       sP_nombre   := vendedor de externa.nombre;
       sP_oficina  := vendedor de externa.oficina;

       cuantas := SELECT COUNT(*) FROM vendedores
                  WHERE oficina=[sp_oficina]
                  AND cargo='TECNICO COMERCIAL';

       if (cuantas=0)
            mostrar(sP_nombre, sP_oficina);
}

**************************************************/

SELECT nombre, oficina FROM vendedores externa
WHERE 0=( SELECT count(*) FROM vendedores 
          WHERE externa.oficina=oficina
          AND cargo='TECNICO COMERCIAL');



/*************************************************
Cociente basado en el calculo

Oficinas con todas las categorias =
Oficinas en las que no existe una categoria que no tengan
(para una oficina O tener una categoria C equivale a que EXISTA una fila < O, C > en la tabla de vendedores
*************************************************/	       

SELECT n_oficina from oficinas
WHERE not exists ( SELECT * FROM categorias
                   WHERE not exists ( SELECT * FROM vendedores
                                      WHERE oficina = n_oficina
                                      AND cargo = categorias.cargo));

/*
--Descorrelacion razonada
Ofi1
'Pepe', 'DIRECTOR COMERCIAL'
'Juan', 'TECNICO COMERCIAL'
'Ana',  'COMERCIAL'

Ofi2
'Maria', 'DIRECTOR COMERCIAL'
'Luis',  'COMERCIAL'

Ofi3 => Vacía

*/


/*
--Descorrelacion en SQL, seria muy larga pues hay que ir viendo todas las combinaciones oficina-cargo

SELECT n_oficina from oficinas
WHERE n_oficina=1 and
not exists ( SELECT * FROM categorias
                   WHERE cargo='COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 1
                                      AND cargo = 'COMERCIAL')
              union

	       SELECT * FROM categorias
                   WHERE cargo='TECNICO COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 1
                                      AND cargo = 'TECNICO COMERCIAL')

               union

               SELECT * FROM categorias
                   WHERE cargo='TECNICO COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 1
                                      AND cargo = 'DIRECTOR COMERCIAL')
              )

union

SELECT n_oficina from oficinas
WHERE n_oficina=2 and
not exists ( SELECT * FROM categorias
                   WHERE cargo='COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 2
                                      AND cargo = 'COMERCIAL')
              union

	       SELECT * FROM categorias
                   WHERE cargo='TECNICO COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 2
                                      AND cargo = 'TECNICO COMERCIAL')

               union

               SELECT * FROM categorias
                   WHERE cargo='TECNICO COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 2
                                      AND cargo = 'DIRECTOR COMERCIAL')
              )

union 

SELECT n_oficina from oficinas
WHERE n_oficina=3 and
not exists ( SELECT * FROM categorias
                   WHERE cargo='COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 3
                                      AND cargo = 'COMERCIAL')
              union

	       SELECT * FROM categorias
                   WHERE cargo='TECNICO COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 3
                                      AND cargo = 'TECNICO COMERCIAL')

               union

               SELECT * FROM categorias
                   WHERE cargo='TECNICO COMERCIAL' and
                   not exists ( SELECT * FROM vendedores
                                      WHERE oficina = 3
                                      AND cargo = 'DIRECTOR COMERCIAL')
              )

;

*/                                      
                                           

/*************************************************

Descorrelacion en pseudocódigo exige dos bucles anidados, uno para las oficinas, otro para los empleados:

SELECT * from oficinas;

while haya oficinas que leer{
       leer siguiente oficina; 

       s1_n_oficina  := oficina.n_oficina;

       SELECT * from categorias;                               

       //NOT EXISTS externo suponemos q es verdad
       cuantasCategoriasNoTieneEsaOficina := 0; //Es decir, suponemos q esa oficina pertenece al cociente
                                                //  => no existen categorias que no tenga algun vendedores de esa oficina
       
       while (haya categorias que leer AND (cuantasCategoriasNoTieneEsaOficina==0)){
                
		leer siguiente categoria; 

                s2_cargo := categorias.cargo;

		cuantosVendedoresDeEsaCategoriaYoficina := SELECT COUNT(*) FROM vendedores
							   WHERE oficina=[s1_n_oficina]
                                                           AND cargo=[s2_cargo];

                //Si NOT EXISTS interno se hace verdadero
		if (cuantosVendedoresDeEsaCategoriaYoficina==0) //Hemos encontrado una categoria para la que no hay vendedores de esa oficina
			//NOT EXISTS externo se hace falso
			cuantasCategoriasNoTieneEsaOficina++;			
         }

	//if NOT EXISTS externo es verdad
         if (cuantasCategoriasNoTieneEsaOficina==0)
		mostrar(s1_n_oficina);                           
}

**************************************************/         

--Ejemplos reformular ANY, ALL, IN con EXISTS

--poblaciones de las oficinas en las que las ventas sean menores que 10 veces la cuota de un vendedor

SELECT poblacion FROM oficinas 
WHERE ventas < ANY(	SELECT cuota*10
			FROM vendedores
			WHERE oficina=n_oficina); 
		
               
SELECT poblacion FROM oficinas 
WHERE EXISTS(	SELECT *
		FROM vendedores
		WHERE oficina=n_oficina
		AND ventas < cuota*10); 

--oficinas con empleados (de esa/su oficina) cuyo salario sea superior al 50% del objetivo de la oficina
SELECT n_oficina FROM oficinas
WHERE (objetivo/2)< ANY(
	SELECT sal+comision*ventas/100
	FROM vendedores JOIN categorias USING(cargo)
	WHERE oficina=n_oficina	);

SELECT n_oficina FROM oficinas
WHERE EXISTS( SELECT *
	FROM vendedores JOIN categorias USING(cargo)
	WHERE oficina=n_oficina
	AND (objetivo/2)<sal+comision*ventas/100);



