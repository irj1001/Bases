
/*
tipo de ISA		c1<-R1->c2		c3<-R2->c4		c5<-R3->c6		c7<-R4->c8		c9<-R5->c10
SOLAPADA y TOTAL	(1,1)<---->(0,1)	(0,n)<---->(1,1)	(0,n)<---->(0,1)	(0,1)<---->(0,n)	(0,n)<---->(0,n)

*/

drop table if exists A,B,C,D,E,F,G,R5 cascade;

create table E (
	e1 integer primary key,
	e2 integer
);

create table A (
	a1 integer primary key,
	a2 integer,
	e1 integer not null references E
);

create table B (
	b1 integer not null,
	b2 integer,
	a1 integer references A primary key
);

create table C (
	c1 integer,
	c2 integer,
	a1 integer references A primary key,
	e1 integer references E
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
	a1 integer references B,
	f1 integer references F,
	primary key (a1,f1)
);
