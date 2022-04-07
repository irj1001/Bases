/*
tipo de ISA		c1<-R1->c2		c3<-R2->c4		c5<-R3->c6		c7<-R4->c8		c9<-R5->c10
SOLAPADA y TOTAL	(1,1)<---->(0,1)	(0,n)<---->(1,1)	(0,n)<---->(0,1)	(0,1)<---->(0,n)	(0,n)<---->(0,n)

*/

drop table if exists A,D,E,F,G,R5 cascade;

create table E (
	e1 integer primary key,
	e2 integer
);

create table A (
	a1 integer primary key,
	a2 integer,
	eR1 integer not null references E,
	b1 integer,
	b2 integer,
	c1 integer,
	c2 integer,
	eR3 integer references E,
	tipo char(2) not null
			check(
				(tipo='B' and b1 is not null and c1 is null and c2 is null and eR3 is null)
				OR
				(tipo='C' and b1 is null and b2 is null)
				OR
				(tipo='BC' and b1 is not null)
			)
);


create table D (
	d1 integer primary key,
	d2 integer,
	a1 integer not null unique references A
);

create table F (
	f1 integer primary key,
	f2 integer
);

create table G (
	g1 integer primary key,
	g2 integer,
	a1 integer references A
);

create table R5(
	a1 integer references A,
	f1 integer references F,
	primary key (a1,f1)
);
