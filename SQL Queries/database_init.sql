--Create Database 'DataWarehouse'

create database DataWarehouse;
GO
use DataWarehouse;
GO
--Create Schemas for each layer: Bronze, Silver and Gold

create schema bronze;
GO  --tells SQL Go to the next statement after completing the above one
	--this way we can run all the commands in a chain
create schema silver;
GO
create schema gold;
GO