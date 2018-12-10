--CREATE DATABASE WMS
--             GO

USE WMS
 GO

CREATE TABLE Clients(
	ClientId INT IDENTITY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Phone CHAR(12) NOT NULL,

	CONSTRAINT PK_Clients_ClientId
	PRIMARY KEY (ClientId),
)

CREATE TABLE Mechanics(
	MechanicId INT IDENTITY NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,

	CONSTRAINT PK_Mechanics_MechanicId
	PRIMARY KEY (MechanicId),
)

CREATE TABLE Models(
	ModelId INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,

	CONSTRAINT PK_Models_ModelId
	PRIMARY KEY (ModelId),

	CONSTRAINT UQ_Models_Name 
	UNIQUE([Name]),
)

CREATE TABLE Jobs(
	JobId INT IDENTITY NOT NULL,
	ModelId INT NOT NULL,
	[Status] VARCHAR(11) NOT NULL CONSTRAINT DF_Jobs_Status DEFAULT 'Pending',
	ClientId INT NOT NULL,
	MechanicId INT,
	IssueDate DATE NOT NULL,
	FinishDate DATE,

	CONSTRAINT PK_Jobs_JobId
	PRIMARY KEY (JobId),

	CONSTRAINT FK_Jobs_ModelId_Models_ModelId
    FOREIGN KEY (ModelId)     
    REFERENCES Models(ModelId),

	CONSTRAINT CK_Jobs_Status  
    CHECK ([Status] IN ('Pending', 'In Progress', 'Finished')),

	CONSTRAINT FK_Jobs_ClientId_Clients_ClientId
    FOREIGN KEY (ClientId)     
    REFERENCES Clients(ClientId),

	CONSTRAINT FK_Jobs_MechanicId_Mechanics_MechanicId
    FOREIGN KEY (MechanicId)     
    REFERENCES Mechanics(MechanicId),
)

CREATE TABLE Orders(
	OrderId INT IDENTITY NOT NULL,
	JobId INT NOT NULL,
	IssueDate DATE,
	Delivered BIT NOT NULL CONSTRAINT DF_Orders_Delivered DEFAULT 0,

	CONSTRAINT PK_Orders_OrderId
	PRIMARY KEY (OrderId),

	CONSTRAINT FK_Orders_JobId_Jobs_JobId
    FOREIGN KEY (JobId)     
    REFERENCES Jobs(JobId),	
)

CREATE TABLE Vendors(
	VendorId INT IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,

	CONSTRAINT PK_Vendors_VendorId
	PRIMARY KEY (VendorId),

	CONSTRAINT UQ_Vendors_Name
	UNIQUE([Name]),
)

CREATE TABLE Parts(
	PartId INT IDENTITY NOT NULL,
	SerialNumber VARCHAR(50) NOT NULL,
	[Description] VARCHAR(255),
	Price DECIMAL(15, 4) NOT NULL,
	VendorId INT NOT NULL,
	StockQty INT CONSTRAINT DF_Parts_StockQty DEFAULT 0,

	CONSTRAINT PK_Parts_PartId
	PRIMARY KEY (PartId),

	CONSTRAINT UQ_Parts_SerialNumber
	UNIQUE(SerialNumber),

	CONSTRAINT CK_Parts_Price  
    CHECK (Price > 0),

	CONSTRAINT FK_Parts_VendorId_Vendors_VendorId
    FOREIGN KEY (VendorId)     
    REFERENCES Vendors(VendorId),

	CONSTRAINT CK_Parts_StockQty  
    CHECK (StockQty >= 0),
)

CREATE TABLE OrderParts(
	OrderId INT,
	PartId INT,
	Quantity INT CONSTRAINT DF_OrderParts_Quantity DEFAULT 1,

	CONSTRAINT PK_OrderParts_OrderId_PartId
	PRIMARY KEY (OrderId, PartId),

	CONSTRAINT FK_OrderParts_OrderId_Orders_OrderId
    FOREIGN KEY (OrderId)     
    REFERENCES Orders(OrderId),

	CONSTRAINT FK_OrderParts_PartId_Parts_PartId
    FOREIGN KEY (PartId)     
    REFERENCES Parts(PartId),

	CONSTRAINT CK_OrderParts_Quantity
    CHECK (Quantity > 0),
)

CREATE TABLE PartsNeeded(
	JobId INT,
	PartId INT,
	Quantity INT CONSTRAINT DF_PartsNeeded_Quantity DEFAULT 1,

	CONSTRAINT PK_PartsNeeded_JobId_PartId
	PRIMARY KEY (JobId, PartId),

	CONSTRAINT FK_PartsNeeded_JobId_Jobs_JobId
    FOREIGN KEY (JobId)     
    REFERENCES Jobs(JobId),

	CONSTRAINT FK_PartsNeeded_PartId_Parts_PartId
    FOREIGN KEY (PartId)     
    REFERENCES Parts(PartId),

	CONSTRAINT CK_PartsNeeded_Quantity
    CHECK (Quantity > 0),
)