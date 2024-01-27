Introduction 

The main difference between the logical and physical replication (already implemented for the current replica, for example), is that physical replication works at the level of data blocks. Changes made to the primary database are copied directly as data blocks to the secondary database. In the other hand, Logical replication works at the row or even SQL statement level. Changes made to the primary database are replicated as SQL statements or row-level changes. PostgreSQL supports both mechanisms concurrently.

The logical replication provides greater flexibility by allowing you to select which specific tables or data should be replicated. It also allows transformations to be performed during replication. To apply WHERE condition for replicating data is only available from version 15 and above, we're currently in 14.7, so at this moment we only can specify the list of tables to be replicated. 

How it works in a nutshell: 

In the source database (publisher), we have to create publications for every table (or set of tables) to be replicated. In the target database (subscriber), we need to create a subscription to those publications to start replication for the published tables. 

Logical replication of a table typically starts with taking a snapshot of the data on the publisher database and copying that to the subscriber. Once that is done, the changes on the publisher are sent to the subscriber as they occur in real-time.

Previously, we have to create the schema and tables in the target database, with the following limitations:

The tables are matched between the publisher and the subscriber using the fully qualified table name. Replication to differently-named tables on the subscriber is not supported.

Columns of a table are also matched by name. The order of columns in the subscriber table does not need to match that of the publisher.

The data types of the columns do not need to match, as long as the text representation of the data can be converted to the target type.

Only regular tables can be published, we cannot replicate to a view. 

When a subscription table is dropped and recreated, the synchronization information is lost. This means that the data has to be resynchronized afterwards.

Requisites:

Postgres version: logical replication is supported in the current version 14.7, but with not WHERE condition allowed. From version 15, we can add table selection and WHERE condition in logical replication, this conditional filtering makes the difference when the xid field will be implemented in the database. 

WAL level: For logical replication we need wal_level = logical, the sentence SHOW wal_level; outputs the current detail WAL level. In production database currently we have wal_level=replica. This isn't enough for logical replication, so we need to change the RDS parameter rds.logical_replication = 1 (this require a database restart!!!) 

Examples:

We have created a Master Postgres DB (version 14.7 to be fully compatible with the current versions in Greyfinch, but we can do a replication between different version of postgres, e.g. 15 -> 14.7 or 14.7 -> 15). 

We have created a master postgres db (version 14.7) to replicate data on a replica postgres db with logical replication. 

In this example we have created two tables employees and employee_statuses in both data database master and replica with the same structure, we have added a few rows in both tables, and created publications and subscribers to test how it works.

In the example you can see all the steps and implementations running the initi-script.sh

** Testing WHERE filtering in logical replica works fine for postgres 15. But there is not available in this example. Pending TODO.