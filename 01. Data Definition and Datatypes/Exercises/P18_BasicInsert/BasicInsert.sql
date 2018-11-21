USE SoftUni

--Insert Towns
INSERT INTO Towns([Name])
VALUES('Sofia')

INSERT INTO Towns([Name])
VALUES('Plovdiv')

INSERT INTO Towns([Name])
VALUES('Varna')

INSERT INTO Towns([Name])
VALUES('Burgas')

--Insert Departments
INSERT INTO Departments([Name])
VALUES('Engineering')

INSERT INTO Departments([Name])
VALUES('Sales')

INSERT INTO Departments([Name])
VALUES('Marketing')

INSERT INTO Departments([Name])
VALUES('Software Development')

INSERT INTO Departments([Name])
VALUES('Quality Assurance')

--Insert Departments
INSERT INTO Employees(FirstName, MiddleName, LastName,
JobTitle, DepartmentId, HireDate, Salary)
VALUES('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '02-01-2013', 3500)

INSERT INTO Employees(FirstName, MiddleName, LastName,
JobTitle, DepartmentId, HireDate, Salary)
VALUES('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '03-02-2004', 4000)

INSERT INTO Employees(FirstName, MiddleName, LastName,
JobTitle, DepartmentId, HireDate, Salary)
VALUES('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08-28-2016', 525.25)

INSERT INTO Employees(FirstName, MiddleName, LastName,
JobTitle, DepartmentId, HireDate, Salary)
VALUES('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '12-09-2007', 3000)

INSERT INTO Employees(FirstName, MiddleName, LastName,
JobTitle, DepartmentId, HireDate, Salary)
VALUES('Peter', 'Pan', 'Pan', 'Intern', 3, '08-28-2016', 599.88)