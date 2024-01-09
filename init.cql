DROP KEYSPACE IF EXISTS test;
CREATE KEYSPACE IF NOT EXISTS test WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 3};
USE test;


// Bad way to store data in big partitions
DROP TABLE IF EXISTS one_partition_tbl;
CREATE TABLE IF NOT EXISTS one_partition_tbl (
    partition int,
    clustering1 text,
    clustering2 int,
    other1 text, 
    other2 int,
    PRIMARY KEY ((partition), clustering1, clustering2)
) WITH CLUSTERING ORDER BY (clustering1 ASC, clustering2 DESC);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 3, 'Sorted4', 100);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 1, 'Sorted8', 107);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'B', 2, 'Sorted2', 121);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 1, 'Sorted5', 111);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 3, 'Sorted1', 165);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'B', 1, 'Sorted7', 122);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 2, 'Sorted9', 121);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 2, 'Sorted3', 199);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'B', 3, 'Sorted6', 134);


DROP TABLE IF EXISTS several_partitions_tbl;
CREATE TABLE IF NOT EXISTS several_partitions_tbl (
    partition int,
    clustering1 text,
    clustering2 int,
    other1 text, 
    other2 int,
    PRIMARY KEY ((partition), clustering1, clustering2)
) WITH CLUSTERING ORDER BY (clustering1 ASC, clustering2 DESC);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 0, 'ChangedToC', 100);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 0, 'ChangedToA', 107);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'B', 0, 'ChangedToB', 121);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'C', 0, 'ChangedToA', 111);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'A', 0, 'ChangedToB', 165);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'B', 0, 'ChangedToC', 122);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'B', 0, 'ChangedToA', 121);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'C', 0, 'ChangedToB', 199);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'A', 0, 'ChangedToC', 134);