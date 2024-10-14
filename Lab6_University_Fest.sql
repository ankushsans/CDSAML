show databases;
create database if not exists fest_database;
use fest_database;

create table fest(
	fest_id varchar(5),
	fest_name varchar(25) unique not null,
	year year,
	head_teamid varchar(5) unique,
	primary key (fest_id)
	);
-- desc fest;

create table team(
	team_id varchar(5),
	team_name varchar(25) not null,
	team_type enum('mng','org') default 'org',
	fest_id varchar(5),
	primary key (team_id),
	foreign key (fest_id) references fest(fest_id)
	);
-- desc team;

alter table fest add constraint fest_head_name foreign key(head_teamid) references team(team_id);
-- desc fest;

create table member(
	mem_id varchar(5),
	mem_name varchar(25) not null,
	dob date,
	super_memid varchar(5),
	team_id varchar(5),
	primary key (mem_id),
	foreign key (super_memid) references member(mem_id),
	foreign key (team_id) references team(team_id)
	);
-- desc member;

create table event(
	event_id varchar(5),
	event_name varchar(25) not null,
	building varchar(15),
	floor varchar(10),
	room_no int,
	price decimal(10,2),
	team_id varchar(5),
	primary key (event_id),
	check (price <= 1500.00),
	foreign key (team_id) references team(team_id) on delete cascade
	);
-- desc event;
-- show create table event;

create table event_conduction(
	event_id varchar(5),
	date_of_conduction date,
	primary key(event_id,date_of_conduction),
	foreign key (event_id) references event(event_id)
	);
-- desc event_conduction;

create table participant(
	srn varchar(10),
	name varchar(25) not null,
	department varchar(20),
	semester int,
	gender enum('male','female'),
	primary key (srn)
	);
-- desc participant;

create table visitor(
	srn varchar(10),
	name varchar(25),
	age int,
	gender enum('male','female'),
	primary key (srn,name),
	foreign key (srn) references participant(srn)
	);
-- desc visitor;

create table registration(
	event_id varchar(5),
	srn varchar(10),
	registration_id varchar(5) not null,
	primary key (event_id,srn),
	foreign key (event_id) references event(event_id),
	foreign key (srn) references participant(srn)
	);
-- desc registration;

create table stall(
	stall_id varchar(5),
	name varchar(25) unique not null,
	fest_id varchar(5),
	primary key (stall_id),
	foreign key (fest_id) references fest(fest_id)
	);
-- desc stall;

create table item(
	name varchar(25),
	type enum('veg','non-veg'),
	primary key (name)
	);
-- desc item;

create table stall_items(
	stall_id varchar(5),
	item_name varchar(25),
	price_per_unit decimal(10,2),
	total_quantity int,
	primary key (stall_id,item_name),
	foreign key (stall_id) references stall(stall_id),
	foreign key (item_name) references item(name)
	);
-- desc stall_items;

create table purchased(
	srn varchar(10),
	stall_id varchar(5),
	item_name varchar(25),
	timestamp timestamp,
	quantity int,
	primary key (srn,stall_id,item_name,timestamp),
	foreign key (srn) references participant(srn),
	foreign key (stall_id) references stall(stall_id),
	foreign key (item_name) references item(name)
	);
-- desc purchased;

-- insertion statements

use fest_database;

-- inserting values into fest table
insert into fest(fest_id, fest_name, year) values('f101', "atmatrisha", 2023),
												('f102', "samarpana", 2022),
												('f201', "graduation", 2022),
												('f202', "annual day", 2021);

-- inserting values into teams table
insert into team values('t1', "leads", "mng", 'f101'),
						('t2', "logistics_atm", "mng", 'f101'),
						('t3', "crazy hunters", "org", 'f101'),
						('t4', "techno", "org", 'f101'),
						('t5', "the heads", "mng", 'f102'),
						('t6', "eutopians", "org", 'f102'),
						('t7', "managers", "mng", 'f102'),
						('t8', "cultural", "org", 'f102'),
						('t9', "tech buzzers", "org", 'f102'),
						('t10', "grad_head", "mng", 'f201'),
						('t11', "arts", "mng", 'f201'),
						('t12', "conduction", "org",'f201'),
						('t13', "fest heads", "mng", 'f202'),
						('t14', "cul team", "org", 'f202'),
						('t15', "dystopia", "org", 'f202');

-- adding the head teams into the fest table
update fest set head_teamid = case when fest_id = 'f101' then 't1'
								   when fest_id = 'f102' then 't5'
                                   when fest_id = 'f201' then 't10'
                                   when fest_id = 'f202' then 't13'
                                   end;


-- adding values into members
insert into member (mem_id, mem_name, dob, super_memid, team_id)
values
  ('m1', 'john doe', '1995-05-10', null, 't1'),
  ('m2', 'alice smith', '1996-08-15', 'm1', 't1'),
  ('m3', 'michael johnson', '1997-11-20', 'm1', 't1'),
  ('m4', 'emily davis', '1998-03-25', 'm1', 't1'),
  ('m5', 'robert wilson', '1994-07-05', 'm1', 't1'),
  ('m7', 'christopher brown', '1996-01-18', null, 't2'),
  ('m6', 'sarah thompson', '1995-10-12', 'm7', 't2'),
  ('m8', 'jessica anderson', '1997-04-24', 'm7', 't2'),
  ('m9', 'david anderson', '1994-04-12', 'm8', 't2'),
  ('m10', 'jessica brown', '1995-07-18', 'm8', 't2'),
  ('m11', 'christopher wilson', '1996-10-22', null, 't3'),
  ('m12', 'sophia taylor', '1997-01-30', 'm11', 't3'),
  ('m13', 'william moore', '1993-06-08', 'm11', 't3'),
  ('m14', 'olivia clark', '1994-09-14', 'm11', 't3'),
  ('m15', 'andrew lee', '1995-12-20', 'm14', 't3'),
  ('m16', 'emma martinez', '1996-03-28', 'm11', 't3'),
  ('m17', 'matthew harris', '1994-02-05', 'm14', 't3'),
  ('m18', 'olivia adams', '1995-05-11', 'm14', 't3'),
  ('m22', 'daniel clark', '1996-08-16', null, 't4'),
  ('m20', 'sophia hall', '1997-11-21', 'm22', 't4'),
  ('m21', 'michael turner', '1993-10-02', 'm22', 't4'),
  ('m19', 'emily walker', '1994-12-08', 'm21', 't4'),
  ('m23', 'jacob lewis', '1996-03-15', 'm21', 't4'),
  ('m24', 'mia rodriguez', '1997-06-21', 'm22', 't4'),
  ('m25', 'daniel robinson', '1993-09-01', 'm23', 't4'),
  ('m26', 'ava walker', '1994-12-06', 'm23', 't4'),
  ('m27', 'william turner', '1995-03-13', null, 't5'),
  ('m28', 'sophia williams', '1996-06-19', 'm27', 't5'),
  ('m29', 'jacob anderson', '1997-09-25', 'm27', 't5'),
  ('m30', 'olivia moore', '1998-12-31', 'm29', 't5'),
  ('m31', 'ethan thompson', '1994-02-07', 'm29', 't5'),
  ('m32', 'emily clark', '1995-05-14', null, 't6'),
  ('m33', 'jacob lewis', '1996-08-20', 'm32', 't6'),
  ('m34', 'mia rodriguez', '1997-11-26', 'm32', 't6'),
  ('m35', 'daniel robinson', '1993-09-03', 'm32', 't6'),
  ('m36', 'ava walker', '1994-12-09', 'm34', 't6'),
  ('m37', 'william turner', '1995-03-16', 'm34', 't6'),
  ('m38', 'sophia williams', '1996-06-22', 'm34', 't6'),
  ('m39', 'jacob anderson', '1997-09-28', 'm35', 't6'),
  ('m44', 'olivia moore', '1998-01-03', null, 't7'),
  ('m41', 'ethan thompson', '1994-02-10', 'm44', 't7'),
  ('m42', 'emily clark', '1995-05-16', 'm44', 't7'),
  ('m43', 'jacob lewis', '1996-08-22', 'm41', 't7'),
  ('m40', 'mia rodriguez', '1997-11-28', 'm42', 't7'),
  ('m45', 'daniel robinson', '1993-09-05', null, 't8'),
  ('m46', 'ava walker', '1994-12-11', 'm45', 't8'),
  ('m47', 'william turner', '1995-03-18', 'm45', 't8'),
  ('m48', 'sophia williams', '1996-06-24', 'm45', 't8'),
  ('m49', 'jacob anderson', '1997-09-30', 'm46', 't8'),
  ('m50', 'olivia moore', '1998-01-05', 'm46', 't8'),
  ('m51', 'ethan thompson', '1994-02-12', 'm47', 't8'),
  ('m52', 'emily clark', '1995-05-18', 'm48', 't8'),
  ('m53', 'jacob lewis', '1996-08-26', null, 't9'),
  ('m54', 'mia rodriguez', '1997-11-02', 'm53', 't9'),
  ('m55', 'daniel robinson', '1993-09-07', 'm53', 't9'),
  ('m56', 'ava walker', '1994-12-13', 'm54', 't9'),
  ('m57', 'william turner', '1995-03-20', 'm54', 't9'),
  ('m58', 'sophia williams', '1996-06-26', 'm54', 't9'),
  ('m59', 'jacob anderson', '1997-09-02', 'm55', 't9'),
  ('m60', 'olivia moore', '1998-01-07', 'm55', 't9'),
  ('m61', 'emily clark', '1995-05-20', null, 't12'),
  ('m62', 'jacob lewis', '1996-08-28', 'm61', 't12'),
  ('m63', 'mia rodriguez', '1997-11-04', 'm61', 't12'),
  ('m64', 'daniel robinson', '1993-09-09', 'm62', 't12'),
  ('m65', 'ava walker', '1994-12-15', 'm62', 't12'),
  ('m66', 'william turner', '1995-03-22', 'm63', 't12'),
  ('m67', 'sophia williams', '1996-06-28', 'm63', 't12'),
  ('m68', 'jacob anderson', '1997-09-04', 'm63', 't12'),
  ('m69', 'olivia moore', '1998-01-09', null, 't14'),
  ('m70', 'ethan thompson', '1994-02-14', 'm69', 't14'),
  ('m71', 'emily clark', '1995-05-22', 'm69', 't14'),
  ('m72', 'jacob lewis', '1996-08-30', 'm69', 't14'),
  ('m73', 'mia rodriguez', '1997-11-06', 'm71', 't14'),
  ('m74', 'daniel robinson', '1993-09-11', 'm71', 't14'),
  ('m75', 'ava walker', '1994-12-17', 'm72', 't14'),
  ('m76', 'william turner', '1995-03-24', 'm72', 't14'),
  ('m77', 'sophia williams', '1996-06-30', null, 't15'),
  ('m78', 'jacob anderson', '1997-09-06', 'm77', 't15'),
  ('m79', 'olivia moore', '1998-01-11', 'm77', 't15'),
  ('m80', 'ethan thompson', '1994-02-16', 'm79', 't15'),
  ('m81', 'emily clark', '1995-05-24', 'm79', 't15'),
  ('m82', 'jacob lewis', '1996-09-02', 'm76', 't15'),
  ('m83', 'mia rodriguez', '1997-11-08', 'm76', 't15'),
  ('m84', 'daniel robinson', '1993-09-13', 'm76', 't15');


-- adding into event table
insert into event (event_id, event_name, building, floor, room_no, price, team_id)
values 
  -- team 3: crazy hunters
  ('e1', 'adventure trek', 'outdoors', '1', 101, 200.00, 't3'),
  ('e2', 'paintball tournament', 'sports comp%ex', '2', 201, 150.00, 't3'),
  ('e3', 'escape room challenge', 'm@in building', '1', 102, 120.00, 't3'),
  -- team 4: techno
  ('e4', 'photography contest', '@udi%orium', '2', 202, 850.00, 't4'),
  ('e5', 'code jam', '@computer%lab%', '1', 101, 100.00, 't4'),
  ('e6', 'robot wars', 'robotics arena', '1', 201, 100.00, 't4'),
  ('e7', 'tech expo', 'm@in building', '2', 203, 550.00, 't4'),
  ('e8', 'gaming tournament', 'sports comp%ex', '1', 103, 800.00, 't4'),
  -- team 6: eutopians
  ('e9', 'drama play', '@udi%orium', '1', 102, 100.00, 't6'),
  ('e10', 'music concert', 'amphi%he@ter', '2', 202, 120.00, 't6'),
  ('e11', 'art workshop', 'm@in building', '1', 101, 150.00, 't6'),
  ('e12', 'film screening', 'theater', '2', 203, 500.00, 't6'),
  -- team 8: cultural
  ('e13', 'traditional dance wars', '@udi%orium', '1', 102, 850.00, 't8'),
  ('e14', 'singing contest', 'm@in building', '2', 203, 500.00, 't8'),
  ('e15', 'fashion exhibition', 'sports comp%ex', '1', 103, 120.00, 't8'),
  ('e16', 'poetry slam', 'amphi%he@ter', '2', 201, 100.00, 't8'),
  -- team 9: tech buzzers
  ('e17', 'quiz competition', '@udi%orium', '1', 102, 100.00, 't9'),
  ('e18', 'tech talk', 'seminar hall', '1', 101, 200.00, 't9'),
  ('e19', 'web design contest', '@computer%lab%', '2', 202, 890.00, 't9'),
  ('e20', 'hackathon', 'm@in building', '1', 103, 650.00, 't9'),
  -- team 12: conduction
  ('e21', 'stage setup', 'm@in building', '2', 203, 900.00, 't12'),
  ('e22', 'sound and lighting', '@udi%orium', '1', 102, 250.00, 't12'),
  ('e23', 'event coordination', 'sports comp%ex', '1', 103, 500.00, 't12'),
  ('e24', 'volunteer management', 'm@in building', '3', 303, 600.00, 't12'),
  -- team 14: cul team
  ('e25', 'baking competition', 'kitchen', '1', 101, 850.00, 't14'),
  ('e26', 'food tasting', 'cafeteria', '2', 202, 500.00, 't14'),
  ('e27', 'cooking workshop', 'm@in building', '1', 102, 120.00, 't14'),
  -- team 15: dystopia
  ('e29', 'short film screening', 'theater', '1', 103, 400.00, 't15'),
  ('e30', 'literary debate', 'seminar hall', '1', 101, 550.00, 't15'),
  ('e31', 'writing competition', 'library', '2', 202, 950.00, 't15'),
  ('e32', 'poetry recitation', 'amphi%he@ter', '1', 102, 100.00, 't15');

-- adding values into participants table
insert into participant (srn, name, department, semester, gender)
values
  ('p1001', 'john smith', 'computer science', 5, 'male'),
  ('p1002', 'emily johnson', 'electrical', 6, 'female'),
  ('p1003', 'michael williams', 'mechanical', 4, 'male'),
  ('p1004', 'sophia brown', 'civil', 7, 'female'),
  ('p1005', 'jacob jones', 'chemical', 5, 'male'),
  ('p1006', 'olivia davis', 'computer science', 6, 'female'),
  ('p1007', 'ethan miller', 'electrical', 4, 'male'),
  ('p1008', 'ava wilson', 'mechanical', 7, 'female'),
  ('p1009', 'william taylor', 'civil', 5, 'male'),
  ('p1010', 'emma anderson', 'chemical', 6, 'female'),
  ('p1011', 'liam martinez', 'computer science', 5, 'male'),
  ('p1012', 'isabella thompson', 'electrical', 6, 'female'),
  ('p1013', 'james harris', 'mechanical', 4, 'male'),
  ('p1014', 'mia davis', 'civil', 7, 'female'),
  ('p1015', 'benjamin clark', 'chemical', 5, 'male'),
  ('p1016', 'charlotte baker', 'computer science', 6, 'female'),
  ('p1017', 'daniel lopez', 'electrical', 4, 'male'),
  ('p1018', 'amelia turner', 'mechanical', 7, 'female'),
  ('p1019', 'henry hill', 'civil', 5, 'male'),
  ('p1020', 'victoria young', 'chemical', 6, 'female'),
  ('p1021', 'david lee', 'computer science', 5, 'male'),
  ('p1022', 'sofia green', 'electrical', 6, 'female'),
  ('p1023', 'christopher moore', 'mechanical', 4, 'male'),
  ('p1024', 'scarlett evans', 'civil', 7, 'female'),
  ('p1025', 'andrew martinez', 'chemical', 5, 'male');


  
-- values for registration table
insert into registration (event_id, srn, registration_id)
values
  ('e1', 'p1001', 'r1'),
  ('e1', 'p1002', 'r2'),
  ('e1', 'p1003', 'r3'),
  ('e1', 'p1004', 'r4'),
  ('e1', 'p1005', 'r5'),
  ('e1', 'p1006', 'r1'),
  ('e1', 'p1017', 'r2'),
  ('e1', 'p1022', 'r3'),
  ('e1', 'p1025', 'r4'),
  ('e1', 'p1008', 'r5'),
  ('e2', 'p1006', 'r6'),
  ('e2', 'p1007', 'r7'),
  ('e2', 'p1008', 'r8'),
  ('e2', 'p1009', 'r9'),
  ('e2', 'p1010', 'r10'),
  ('e3', 'p1011', 'r11'),
  ('e3', 'p1012', 'r12'),
  ('e3', 'p1013', 'r13'),
  ('e3', 'p1014', 'r14'),
  ('e3', 'p1015', 'r15'),
  ('e3', 'p1001', 'r11'),
  ('e3', 'p1002', 'r12'),
  ('e3', 'p1023', 'r13'),
  ('e3', 'p1024', 'r14'),
  ('e3', 'p1025', 'r15'),
  ('e4', 'p1016', 'r16'),
  ('e4', 'p1017', 'r17'),
  ('e4', 'p1018', 'r18'),
  ('e4', 'p1019', 'r19'),
  ('e4', 'p1020', 'r20'),
  ('e5', 'p1021', 'r21'),
  ('e5', 'p1022', 'r22'),
  ('e5', 'p1023', 'r23'),
  ('e5', 'p1024', 'r24'),
  ('e5', 'p1025', 'r25'),
  ('e5', 'p1004', 'r24'),
  ('e5', 'p1005', 'r25'),
  ('e6', 'p1001', 'r26'),
  ('e6', 'p1002', 'r27'),
  ('e6', 'p1003', 'r28'),
  ('e6', 'p1004', 'r29'),
  ('e6', 'p1005', 'r30'),
  ('e7', 'p1006', 'r31'),
  ('e7', 'p1007', 'r32'),
  ('e7', 'p1008', 'r33'),
  ('e7', 'p1009', 'r34'),
  ('e7', 'p1010', 'r35'),
  ('e7', 'p1001', 'r33'),
  ('e7', 'p1002', 'r34'),
  ('e7', 'p1020', 'r35'),
  ('e8', 'p1011', 'r36'),
  ('e8', 'p1012', 'r37'),
  ('e8', 'p1013', 'r38'),
  ('e8', 'p1014', 'r39'),
  ('e8', 'p1015', 'r40'),
  ('e9', 'p1016', 'r41'),
  ('e9', 'p1017', 'r42'),
  ('e9', 'p1018', 'r43'),
  ('e9', 'p1019', 'r44'),
  ('e9', 'p1020', 'r45'),
  ('e9', 'p1024', 'r43'),
  ('e9', 'p1022', 'r44'),
  ('e9', 'p1001', 'r45'),
  ('e9', 'p1004', 'r43'),
  ('e9', 'p1005', 'r44'),
  ('e9', 'p1025', 'r45'),
  ('e10', 'p1021', 'r46'),
  ('e10', 'p1022', 'r47'),
  ('e10', 'p1023', 'r48'),
  ('e10', 'p1024', 'r49'),
  ('e10', 'p1025', 'r50'),
  ('e10', 'p1001', 'r49'),
  ('e10', 'p1005', 'r50'),
  ('e11', 'p1001', 'r51'),
  ('e11', 'p1002', 'r52'),
  ('e11', 'p1003', 'r53'),
  ('e11', 'p1004', 'r54'),
  ('e11', 'p1005', 'r55'),
  ('e11', 'p1021', 'r56'),
  ('e11', 'p1022', 'r57'),
  ('e11', 'p1023', 'r58'),
  ('e11', 'p1024', 'r59'),
  ('e11', 'p1025', 'r60'),
  ('e12', 'p1006', 'r56'),
  ('e12', 'p1007', 'r57'),
  ('e12', 'p1008', 'r58'),
  ('e12', 'p1009', 'r59'),
  ('e12', 'p1010', 'r60'),
  ('e13', 'p1011', 'r61'),
  ('e13', 'p1012', 'r62'),
  ('e13', 'p1013', 'r63'),
  ('e13', 'p1014', 'r64'),
  ('e13', 'p1015', 'r65'),
  ('e14', 'p1016', 'r66'),
  ('e14', 'p1017', 'r67'),
  ('e14', 'p1018', 'r68'),
  ('e14', 'p1019', 'r69'),
  ('e14', 'p1020', 'r70'),
  ('e15', 'p1021', 'r71'),
  ('e15', 'p1022', 'r72'),
  ('e15', 'p1023', 'r73'),
  ('e15', 'p1024', 'r74'),
  ('e15', 'p1025', 'r75'),
  ('e16', 'p1001', 'r76'),
  ('e16', 'p1002', 'r77'),
  ('e16', 'p1003', 'r78'),
  ('e16', 'p1004', 'r79'),
  ('e16', 'p1005', 'r80'),
  ('e16', 'p1021', 'r71'),
  ('e16', 'p1022', 'r72'),
  ('e16', 'p1023', 'r73'),
  ('e16', 'p1024', 'r74'),
  ('e16', 'p1025', 'r75'),
  ('e17', 'p1006', 'r81'),
  ('e17', 'p1007', 'r82'),
  ('e17', 'p1008', 'r83'),
  ('e17', 'p1009', 'r84'),
  ('e17', 'p1010', 'r85'),
  ('e17', 'p1011', 'r86'),
  ('e17', 'p1012', 'r87'),
  ('e17', 'p1013', 'r88'),
  ('e17', 'p1021', 'r89'),
  ('e17', 'p1023', 'r90'),
  ('e17', 'p1025', 'r91'),
  ('e18', 'p1011', 'r86'),
  ('e18', 'p1012', 'r87'),
  ('e18', 'p1013', 'r88'),
  ('e18', 'p1014', 'r89'),
  ('e18', 'p1015', 'r90'),
  ('e19', 'p1016', 'r91'),
  ('e19', 'p1017', 'r92'),
  ('e19', 'p1018', 'r93'),
  ('e19', 'p1019', 'r94'),
  ('e19', 'p1020', 'r95'),
  ('e20', 'p1021', 'r96'),
  ('e20', 'p1022', 'r97'),
  ('e20', 'p1023', 'r98'),
  ('e20', 'p1024', 'r99'),
  ('e20', 'p1025', 'r100'),
  ('e20', 'p1001', 'r98'),
  ('e20', 'p1004', 'r99'),
  ('e20', 'p1005', 'r100'),
  ('e21', 'p1001', 'r101'),
  ('e21', 'p1002', 'r102'),
  ('e21', 'p1003', 'r103'),
  ('e21', 'p1004', 'r104'),
  ('e21', 'p1005', 'r105'),
  ('e22', 'p1006', 'r106'),
  ('e22', 'p1007', 'r107'),
  ('e22', 'p1008', 'r108'),
  ('e22', 'p1009', 'r109'),
  ('e22', 'p1010', 'r110'),
  ('e22', 'p1020', 'r108'),
  ('e22', 'p1022', 'r109'),
  ('e22', 'p1025', 'r110'),
  ('e23', 'p1001', 'r101'),
  ('e23', 'p1002', 'r102'),
  ('e23', 'p1003', 'r103'),
  ('e23', 'p1004', 'r104'),
  ('e23', 'p1005', 'r105'),
  ('e23', 'p1011', 'r111'),
  ('e23', 'p1012', 'r112'),
  ('e23', 'p1013', 'r113'),
  ('e23', 'p1014', 'r114'),
  ('e23', 'p1015', 'r115'),
  ('e24', 'p1016', 'r116'),
  ('e24', 'p1017', 'r117'),
  ('e24', 'p1018', 'r118'),
  ('e24', 'p1019', 'r119'),
  ('e24', 'p1020', 'r120'),
  ('e25', 'p1021', 'r121'),
  ('e25', 'p1022', 'r122'),
  ('e25', 'p1023', 'r123'),
  ('e25', 'p1024', 'r124'),
  ('e25', 'p1025', 'r125'),
  ('e26', 'p1001', 'r126'),
  ('e26', 'p1002', 'r127'),
  ('e26', 'p1003', 'r128'),
  ('e26', 'p1004', 'r129'),
  ('e26', 'p1005', 'r130'),
  ('e27', 'p1006', 'r131'),
  ('e27', 'p1007', 'r132'),
  ('e27', 'p1008', 'r133'),
  ('e27', 'p1009', 'r134'),
  ('e27', 'p1010', 'r135'),
  ('e29', 'p1016', 'r141'),
  ('e29', 'p1017', 'r142'),
  ('e29', 'p1018', 'r143'),
  ('e29', 'p1019', 'r144'),
  ('e29', 'p1020', 'r145'),
  ('e30', 'p1021', 'r146'),
  ('e30', 'p1022', 'r147'),
  ('e30', 'p1023', 'r148'),
  ('e30', 'p1024', 'r149'),
  ('e30', 'p1025', 'r150'),
  ('e31', 'p1001', 'r151'),
  ('e31', 'p1002', 'r152'),
  ('e31', 'p1003', 'r153'),
  ('e31', 'p1004', 'r154'),
  ('e31', 'p1005', 'r155'),
  ('e32', 'p1016', 'r141'),
  ('e32', 'p1017', 'r142'),
  ('e32', 'p1018', 'r143'),
  ('e32', 'p1019', 'r144'),
  ('e32', 'p1020', 'r145'),
  ('e32', 'p1001', 'r151'),
  ('e32', 'p1002', 'r152'),
  ('e32', 'p1003', 'r153'),
  ('e32', 'p1004', 'r154'),
  ('e32', 'p1006', 'r156'),
  ('e32', 'p1007', 'r157'),
  ('e32', 'p1008', 'r158'),
  ('e32', 'p1009', 'r159'),
  ('e32', 'p1010', 'r160');

-- event conduction table 
insert into event_conduction (event_id, date_of_conduction)
values
  ('e1', '2023-04-15'),
  ('e2', '2023-04-16'),
  ('e3', '2023-04-17'),
  ('e4', '2023-04-18'),
  ('e5', '2023-04-19'),
  ('e6', '2023-04-15'),
  ('e7', '2023-04-16'),
  ('e8', '2023-04-17'),
  ('e9', '2022-04-15'),
  ('e9', '2022-04-16'),
  ('e10', '2022-04-17'),
  ('e11', '2022-04-18'),
  ('e12', '2022-04-19'),
  ('e13', '2022-04-15'),
  ('e14', '2022-04-16'),
  ('e15', '2022-04-17'),
  ('e16', '2022-04-18'),
  ('e17', '2022-04-19'),
  ('e17', '2022-04-20'),
  ('e18', '2022-04-15'),
  ('e19', '2022-04-16'),
  ('e20', '2022-04-17'),
  ('e21', '2022-04-18'),
  ('e22', '2022-04-19'),
  ('e23', '2022-04-15'),
  ('e24', '2022-04-16'),
  ('e25', '2021-04-15'),
  ('e26', '2021-04-16'),
  ('e27', '2021-04-17'),
  ('e29', '2021-04-19'),
  ('e30', '2021-04-15'),
  ('e31', '2021-04-16'),
  ('e32', '2021-04-17'),
  ('e32', '2021-04-18');


-- visitors table values
insert into visitor (srn, name, age, gender)
values
  ('p1001', 'john doe', 25, 'male'),
  ('p1002', 'jane smith', 30, 'female'),
  ('p1001', 'michael johnson', 22, 'male'),
  ('p1014', 'emily davis', 28, 'female'),
  ('p1001', 'david wilson', 35, 'male'),
  ('p1014', 'sophia brown', 27, 'female'),
  ('p1003', 'daniel taylor', 23, 'male'),
  ('p1016', 'olivia anderson', 29, 'female'),
  ('p1003', 'andrew thomas', 26, 'male'),
  ('p1016', 'isabella martinez', 31, 'female');
  
  -- stall table entries
  insert into stall values('s1', "flavor fusion", 'f101'),
			('s2', "tastebud oasis", 'f101'),
			('s3', "munchie magic", 'f101'),
			('s4', "culinary haven", 'f102'),
			('s5', "savory delights", 'f102'),
			('s6', "spicehub", 'f102'),
			('s7', "yumbliss café", 'f201'),
			('s8', "bitestreet", 'f201'),
			('s9', "flavorcraft", 'f101');

-- item table values
insert into item (name, type) values
('veggie wrap', 'veg'),
('chicken noodle soup', 'non-veg'),
('classic caesar salad', 'veg'),
('bbq chicken sandwich', 'non-veg'),
('mushroom risotto', 'veg'),
('grilled steak', 'non-veg'),
('spinach and feta omelette', 'veg'),
('fish tacos', 'non-veg'),
('margherita pizza', 'veg'),
('mutton stroganoff', 'non-veg'),
('caprese salad', 'veg'),
('shrimp scampi', 'non-veg'),
('vegetable stir-fry', 'veg'),
('bacon-wrapped shrimp', 'non-veg'),
('vegetable pad thai', 'veg');

-- stall_items values
insert into stall_items (stall_id, item_name, price_per_unit, total_quantity) values
('s1', 'veggie wrap', 399.00, 50),
('s2', 'veggie wrap', 429.00, 40),
('s3', 'veggie wrap', 379.00, 55),
('s7', 'veggie wrap', 412.50, 45),
('s5', 'veggie wrap', 400.00, 60),

('s2', 'chicken noodle soup', 529.00, 30),
('s3', 'chicken noodle soup', 564.50, 25),
('s4', 'chicken noodle soup', 519.75, 35),
('s6', 'chicken noodle soup', 550.00, 28),
('s8', 'chicken noodle soup', 525.00, 32),
('s9', 'chicken noodle soup', 590.00, 32),

('s1', 'classic caesar salad', 349.50, 45),
('s7', 'classic caesar salad', 382.50, 38),
('s5', 'classic caesar salad', 349.25, 50),
('s9', 'classic caesar salad', 360.00, 48),

('s4', 'bbq chicken sandwich', 489.00, 20),
('s9', 'bbq chicken sandwich', 524.50, 18),
('s7', 'bbq chicken sandwich', 510.00, 16),
('s8', 'bbq chicken sandwich', 490.00, 24),

('s1', 'mushroom risotto', 359.00, 30),
('s2', 'mushroom risotto', 387.00, 28),
('s3', 'mushroom risotto', 349.00, 35),
('s7', 'mushroom risotto', 378.50, 32),
('s5', 'mushroom risotto', 360.00, 38),
('s9', 'mushroom risotto', 378.50, 40),

('s8', 'grilled steak', 589.00, 15),
('s6', 'grilled steak', 622.50, 14),
('s4', 'grilled steak', 573.75, 17),

('s1', 'spinach and feta omelette', 259.00, 40),
('s3', 'spinach and feta omelette', 282.50, 38),
('s9', 'spinach and feta omelette', 257.25, 45),

('s2', 'fish tacos', 449.00, 25),
('s3', 'fish tacos', 481.50, 23),
('s4', 'fish tacos', 470.00, 28),
('s6', 'fish tacos', 470.00, 26),
('s7', 'fish tacos', 450.00, 30),
('s8', 'fish tacos', 450.00, 30),
('s9', 'fish tacos', 470.00, 30),

('s1', 'margherita pizza', 350.00, 25),
('s5', 'margherita pizza', 349.00, 25),
('s7', 'margherita pizza', 375.00, 23),
('s9', 'margherita pizza', 339.00, 28),

('s9', 'mutton stroganoff', 559.00, 20),
('s7', 'mutton stroganoff', 594.50, 18),

('s1', 'caprese salad', 249.00, 35),

('s4', 'shrimp scampi', 419.00, 20),
('s6', 'shrimp scampi', 412.75, 22),
('s8', 'shrimp scampi', 420.00, 24),

('s1', 'vegetable stir-fry', 299.00, 30),
('s2', 'vegetable stir-fry', 322.00, 28),
('s3', 'vegetable stir-fry', 293.00, 35),
('s7', 'vegetable stir-fry', 318.50, 32),
('s9', 'vegetable stir-fry', 300.00, 38),

('s9', 'bacon-wrapped shrimp', 589.00, 15),

('s1', 'vegetable pad thai', 329.00, 25),
('s5', 'vegetable pad thai', 324.25, 28),
('s9', 'vegetable pad thai', 340.00, 32);

-- inserting values into the purchased table
insert into purchased values
('p1001', 's1', 'veggie wrap', '2023-04-15 12:00:00', 2),
('p1001', 's1', 'mushroom risotto', '2023-04-15 13:00:05', 3),
('p1005', 's2', 'fish tacos', '2023-04-16 10:30:00', 4),
('p1005', 's3', 'chicken noodle soup', '2023-04-16 11:05:00', 2),
('p1005', 's3', 'fish tacos', '2023-04-16 12:15:00', 5),
('p1005', 's9', 'mutton stroganoff', '2023-04-16 13:35:00', 1),
('p1017', 's1', 'spinach and feta omelette', '2023-04-16 10:05:00', 2),
('p1017', 's1', 'classic caesar salad', '2023-04-16 10:05:00', 3),
('p1017', 's3', 'chicken noodle soup', '2023-04-16 12:25:00', 3),
('p1017', 's3', 'vegetable stir-fry', '2023-04-16 12:25:00', 4),
('p1017', 's2', 'fish tacos', '2023-04-16 16:00:00', 5),
('p1017', 's9', 'bacon-wrapped shrimp', '2023-04-16 17:30:00', 2),
('p1002', 's9', 'margherita pizza', '2023-04-16 12:30:00', 1),
('p1002', 's1', 'caprese salad', '2023-04-16 13:33:00', 3),
('p1002', 's1', 'classic caesar salad', '2023-04-16 13:33:00', 3),
('p1002', 's9', 'vegetable stir-fry', '2023-04-16 17:19:00', 5),
('p1006', 's9', 'vegetable stir-fry', '2023-04-16 10:45:00', 2),
('p1006', 's1', 'margherita pizza', '2023-04-16 14:50:00', 1),
('p1006', 's2', 'fish tacos', '2023-04-16 15:55:00', 1),
('p1010', 's9', 'mutton stroganoff', '2023-04-16 13:10:00', 1),
('p1010', 's9', 'spinach and feta omelette', '2023-04-16 13:10:00', 1),
-- 2022 
('p1001', 's5', 'veggie wrap', '2022-04-17 10:10:00', 3),
('p1001', 's5', 'classic caesar salad', '2022-04-17 10:10:00', 2),
('p1005', 's4', 'fish tacos', '2022-04-17 12:50:00', 3),
('p1005', 's4', 'bbq chicken sandwich', '2022-04-17 13:20:00', 2),
('p1005', 's4', 'chicken noodle soup', '2022-04-17 13:20:00', 1),
('p1005', 's4', 'grilled steak', '2022-04-17 14:30:00', 2),
('p1005', 's4', 'shrimp scampi', '2022-04-17 14:30:00', 1),
('p1024', 's6', 'shrimp scampi', '2022-04-17 11:05:00', 3),
('p1024', 's6', 'grilled steak', '2022-04-17 11:05:00', 2),
('p1024', 's4', 'chicken noodle soup', '2022-04-17 13:15:00', 1),
('p1024', 's5', 'vegetable pad thai', '2022-04-17 15:00:00', 2),
('p1008', 's6', 'fish tacos', '2022-04-17 10:45:00', 3),
('p1008', 's6', 'grilled steak', '2022-04-17 10:45:00', 2),
('p1008', 's5', 'mushroom risotto', '2022-04-17 15:00:00', 3),
('p1008', 's5', 'vegetable pad thai', '2022-04-17 15:00:00', 1),
('p1008', 's4', 'bbq chicken sandwich', '2022-04-17 15:10:00', 1),
('p1010', 's4', 'chicken noodle soup', '2022-04-17 13:05:00', 3),
('p1010', 's5', 'mushroom risotto', '2022-04-17 17:15:00', 1),
('p1010', 's6', 'shrimp scampi', '2022-04-17 17:20:00', 2),
('p1003', 's7', 'fish tacos', '2022-04-19 11:25:00', 2),
('p1003', 's8', 'shrimp scampi', '2022-04-19 12:25:00', 2),
('p1003', 's8', 'fish tacos', '2022-04-19 12:25:00', 1),
('p1003', 's7', 'veggie wrap', '2022-04-19 14:00:00', 1),
('p1004', 's7', 'veggie wrap', '2022-04-19 11:00:00', 4),
('p1004', 's7', 'margherita pizza', '2022-04-19 11:00:00', 2);


  
