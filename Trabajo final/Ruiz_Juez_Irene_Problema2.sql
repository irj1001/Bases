drop table if exists A,B,C,D,E,F,G,R1,R2 cascade;

create table A(
	a1 integer primary key,
	a2 integer
);

create table B(
	b1 integer primary key,
	b2 integer
);

create table R1(
	a1 integer references A,
	b1 integer references B,
	r1 integer,
	primary key (a1,b1)
);

create table C(
	c1 integer primary key,
	c2 integer
);

create table D(
	d1 integer primary key,
	d2 integer
);

create table R2(
	c1 integer references C,
	d1 integer references D,
	a1 integer not null,
	b1 integer not null,
	foreign key (a1, b1) references R1,
	primary key(c1,d1)
);

create table F(
	f1 integer primary key,
	f2 integer,
	a1 integer not null,
	b1 integer not null,
	unique (a1,b1),
	foreign key (a1,b1) references R1
);

create table E(
	e1 integer,
	e2 integer,
	a1 integer not null,
	b1 integer not null,
	foreign key (a1,b1) references R1,
	primary key (a1,b1,e1) 
);

create table G(
	g1 integer primary key,
	g2 integer,
	a1 integer,
	b1 integer,
	foreign key (a1, b1) references R1
);