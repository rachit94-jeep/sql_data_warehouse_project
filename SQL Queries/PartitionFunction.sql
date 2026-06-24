--Step 1: Create Partition Function on Date Range

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31','2024-12-31','2025-12-31')


--Select Query to retrieve the metadata about partitions
select * from sys.partition_functions


--Step 2:Create FileGroups for each partition (for placing the data files as per partition scheme)

ALTER DATABASE Sales ADD FILEGROUP FG_2023;
ALTER DATABASE Sales ADD FILEGROUP FG_2024;
ALTER DATABASE Sales ADD FILEGROUP FG_2025;
ALTER DATABASE Sales ADD FILEGROUP FG_2026;

--To Remove FileGroup
ALTER DATABASE Sales REMOVE FILEGROUP FG_2023;

--Query list all File Groups

select * from sys.filegroups


--Step 3: Add .ndf data files to file group

ALTER DATABASE Sales ADD FILE
( NAME = P_2023, --Logical Name
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE Sales ADD FILE 
( NAME = P_2024, --Logical Name
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE Sales ADD FILE 
( NAME = P_2025, --Logical Name
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE Sales ADD FILE 
( NAME = P_2026, --Logical Name
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

-- Query: List All Existing Files in Sales Database
SELECT 
    fg.name AS FilegroupName,
    mf.name AS LogicalFileName,
    mf.physical_name AS PhysicalFilePath,
    mf.size / 128 AS SizeInMB
FROM 
    sys.filegroups fg
JOIN 
    sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE 
    mf.database_id = DB_ID('Sales')


--Step 4: Create Partition Scheme (connects partitions to file groups)
-- Sort the file groups according to the result of the function's partition
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)

-- Query lists all Partition Scheme
SELECT 
    ps.name AS PartitionSchemeName,
    pf.name AS PartitionFunctionName,
    ds.destination_id AS PartitionNumber,
    fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

/* ==============================================================================
   Step 5: Create the Partitioned Table
============================================================================== */

CREATE TABLE sales.Orders_Partitioned 
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)


/* ==============================================================================
   Step 6: Insert Data Into the Partitioned Table
============================================================================== */

INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);


/* ==============================================================================
   Step 7: Verify Partitioning and Compare Execution Plans
============================================================================== */

-- Query: Verify that data is correctly partitioned and assigned to the appropriate filegroups 
SELECT 
    p.partition_number AS PartitionNumber,
    f.name AS PartitionFilegroup, 
    p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';

-- Compare Execution Plans by creating a non-partitioned copy
-- Create a table without partitions using SELECT INTO
SELECT *
INTO Sales.Orders_NoPartition
FROM Sales.Orders_Partitioned;
  
-- Query on Partitioned Table
SELECT *
FROM Sales.Orders_Partitioned
WHERE OrderDate IN ('2026-01-01', '2025-12-31');
  
-- Query on Non-Partitioned Table
SELECT *
FROM Sales.Orders_NoPartition
WHERE OrderDate IN ('2026-01-01', '2025-12-31');
