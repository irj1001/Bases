/*Irene Ruiz Juez
Problema 1
 c1<-R1->c2		c3<-R2->c4		c5<-R3->c6		c7<-R4->c8		c9<-R5->c10		c11<-R6->c12	
(1,1)<-ID=>(0,n)	(1,1)<---->(0,n)	(0,n)<---->(0,1)	(1,1)<-ID=>(0,n)	(0,n)<---->(0,n)	(1,1)<---->(0,1)	

 c13<-R7->c14		c15<-R8->c16		c17<-R9->c18		c19<-R10->c20		c21<-R11->c22
(0,n)<---->(1,1)	(0,1)<---->(0,n)	(0,n)<---->(0,n)	(0,n)<---->(0,1)	(0,1)<---->(0,n)

*/


drop table if exists A, B, G, F, C, D, E, H, I, R5, R9 cascade;

create table A(
	a1 integer  primary key,
	a2 integer
);

create table R9(
	a1 integer references A,
	a1_R9 integer references A,
	primary key (a1,a1_R9)
);

create table B(
	b1 integer,
	b2 integer,
	a1 integer not null references A,
	primary key (a1,b1)
);

create table D(
	d1 integer primary key,
	d2 integer
);

create table H(
	h1 integer primary key,
	h2 integer
);

create table C(
	c1 integer primary key,
	c2 integer,
	a1 integer not null,
	b1 integer not null,
	d1 integer references D,
	h1 integer not null references H,
	foreign key (a1,b1) references B
);

create table F(
	f1 integer primary key,
	f2 integer
);

create table R5(
	c1 integer references C,
	f1 integer references F,
	primary key(c1,f1)
);

create table G(
	g1 integer primary key,
	g2 integer,
	g1_R10 integer references G,
	f1 integer unique not null references F
);

create table E(
	e1 integer,
	e2 integer,
	d1 integer not null references D,
	primary key (d1,e1)
);

create table I(
	i1 integer primary key,
	i2 integer,
	i1_R11 integer references I,
	h1 integer references H
)
	