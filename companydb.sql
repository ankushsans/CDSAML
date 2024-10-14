


CREATE TABLE `department` (
  `Dname` varchar(15) NOT NULL,
  `Dnumber` int(11) NOT NULL,
  `Mgr_ssn` char(9) NOT NULL,
  `Mgr_start_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `department` (`Dname`, `Dnumber`, `Mgr_ssn`, `Mgr_start_date`) VALUES
('Headquarters', 1, '888665555', '1981-06-19'),
('Administration', 4, '987654321', '1995-01-01'),
('Research', 5, '333445555', '1988-05-22');

CREATE TABLE `dependent` (
  `Essn` char(9) NOT NULL,
  `Dependent_name` varchar(15) NOT NULL,
  `Gender` char(1) DEFAULT NULL,
  `Bdate` date DEFAULT NULL,
  `Relationship` varchar(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



INSERT INTO `dependent` (`Essn`, `Dependent_name`, `Gender`, `Bdate`, `Relationship`) VALUES
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
('123456789', 'Michael', 'F', '1988-01-04', 'Son'),
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse');


CREATE TABLE `dept_locations` (
  `Dnumber` int(11) NOT NULL,
  `Dlocation` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



INSERT INTO `dept_locations` (`Dnumber`, `Dlocation`) VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Houston'),
(5, 'Sugarland');


CREATE TABLE `employee` (
  `Fname` varchar(15) NOT NULL,
  `Minit` char(1) DEFAULT NULL,
  `Lname` varchar(15) NOT NULL,
  `Ssn` char(9) NOT NULL,
  `Bdate` date DEFAULT NULL,
  `Address` varchar(30) DEFAULT NULL,
  `Gender` char(1) DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `Super_ssn` char(9) DEFAULT NULL,
  `Dno` int(11) NOT NULL
);



INSERT INTO `employee` (`Fname`, `Minit`, `Lname`, `Ssn`, `Bdate`, `Address`, `Gender`, `Salary`, `Super_ssn`, `Dno`) VALUES
('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren,Houston,TX', 'M', '30000.00', '888665555', 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 voss,Houston,TX', 'M', '40000.00', '888665555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice,Houston,TX', 'F', '25000.00', '333445555', 5),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', '38000.00', '333445555', 5),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston,TX', 'M', '55000.00', NULL, 1),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire,Tx', 'F', '43000.00', '333445555', 4),
('Ahmed', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston,TX', 'M', '25000.00', '987654321', 4),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle,Spring,Tx', 'F', '25000.00', '333445555', 4);

CREATE TABLE `project` (
  `Pname` varchar(15) NOT NULL,
  `Pnumber` int(11) NOT NULL,
  `Plocation` varchar(15) DEFAULT NULL,
  `Dnum` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



INSERT INTO `project` (`Pname`, `Pnumber`, `Plocation`, `Dnum`) VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);



CREATE TABLE `works_on` (
  `Essn` char(9) NOT NULL,
  `Pno` int(11) NOT NULL,
  `Hours` decimal(3,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



INSERT INTO `works_on` (`Essn`, `Pno`, `Hours`) VALUES
('123456789', 1, '32.5'),
('123456789', 2, '7.5'),
('333445555', 2, '10.0'),
('333445555', 3, '10.0'),
('333445555', 10, '10.0'),
('333445555', 20, '10.0'),
('453453453', 1, '20.0'),
('453453453', 2, '20.0'),
('666884444', 3, '40.0'),
('888665555', 20, NULL),
('987654321', 20, '15.0'),
('987654321', 30, '20.0'),
('987987987', 10, '35.0'),
('987987987', 30, '5.0'),
('999887777', 10, '10.0'),
('999887777', 30, '30.0');


ALTER TABLE `department`
  ADD PRIMARY KEY (`Dnumber`),
  ADD UNIQUE KEY `Dname` (`Dname`),
  ADD KEY `d_fk2` (`Mgr_ssn`);


ALTER TABLE `dependent`
  ADD PRIMARY KEY (`Essn`,`Dependent_name`);


ALTER TABLE `dept_locations`
  ADD PRIMARY KEY (`Dnumber`,`Dlocation`);


ALTER TABLE `employee`
  ADD PRIMARY KEY (`Ssn`),
  ADD KEY `e_fk1` (`Dno`),
  ADD KEY `e_fk2` (`Super_ssn`);


ALTER TABLE `project`
  ADD PRIMARY KEY (`Pnumber`),
  ADD UNIQUE KEY `Pname` (`Pname`),
  ADD KEY `p_fk1` (`Dnum`);


ALTER TABLE `works_on`
  ADD PRIMARY KEY (`Essn`,`Pno`),
  ADD KEY `w_fk2` (`Pno`);


ALTER TABLE `department`
  ADD CONSTRAINT `d_fk2` FOREIGN KEY (`Mgr_ssn`) REFERENCES `employee` (`Ssn`);


ALTER TABLE `dependent`
  ADD CONSTRAINT `dep_fk1` FOREIGN KEY (`Essn`) REFERENCES `employee` (`Ssn`);


ALTER TABLE `employee`
  ADD CONSTRAINT `e_fk1` FOREIGN KEY (`Dno`) REFERENCES `department` (`Dnumber`),
  ADD CONSTRAINT `e_fk2` FOREIGN KEY (`Super_ssn`) REFERENCES `employee` (`Ssn`);


ALTER TABLE `project`
  ADD CONSTRAINT `p_fk1` FOREIGN KEY (`Dnum`) REFERENCES `department` (`Dnumber`);


ALTER TABLE `works_on`
  ADD CONSTRAINT `w_fk1` FOREIGN KEY (`Essn`) REFERENCES `employee` (`Ssn`),
  ADD CONSTRAINT `w_fk2` FOREIGN KEY (`Pno`) REFERENCES `project` (`Pnumber`);
