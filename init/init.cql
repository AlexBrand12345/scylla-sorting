CREATE KEYSPACE IF NOT EXISTS testing WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 3};
USE test;

DROP TABLE IF EXISTS different_partitions_tbl;
CREATE TABLE IF NOT EXISTS different_partitions_tbl (
    partition int,
    clustering1 text,
    clustering2 int,
    other1 text, 
    other2 int,
    PRIMARY KEY ((partition), clustering1, clustering2)
);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 45, 'EKwe', 100);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'C', 27, 'seut', 107);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'F', 11, 'Udfg', 121);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (3, 'J', 88, 'W1dx', 111);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (4, 'K', 55, 'Dwcvb', 165);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (5, 'S', 32, 'cwqe', 122);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (6, 'D', 27, 'uidv', 121);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (7, 'D', 45, 'kxvn', 199);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (8, 'F', 16, 'qbvt', 134);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (9, 'C', 67, 'zxmf', 107);
INSERT INTO different_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (10, 'A', 90, 'lpos', 165);

/* Bad way to store data in big partitions */
DROP TABLE IF EXISTS one_partition_tbl;
CREATE TABLE IF NOT EXISTS one_partition_tbl (
    partition int,
    clustering1 text,
    clustering2 int,
    other1 text, 
    other2 int,
    PRIMARY KEY ((partition), clustering1, clustering2)
) WITH CLUSTERING ORDER BY (clustering1 ASC, clustering2 DESC);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 45, 'EKwe', 100);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 27, 'seut', 107);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'F', 11, 'Udfg', 121);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'J', 88, 'W1dx', 111);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'K', 55, 'Dwcvb', 165);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'S', 32, 'cwqe', 122);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'D', 27, 'uidv', 121);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'D', 45, 'kxvn', 199);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'F', 16, 'qbvt', 134);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 67, 'zxmf', 107);
INSERT INTO one_partition_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 90, 'lpos', 165);

DROP TABLE IF EXISTS several_partitions_tbl;
CREATE TABLE IF NOT EXISTS several_partitions_tbl (
    partition int,
    clustering1 text,
    clustering2 int,
    other1 text, 
    other2 int,
    PRIMARY KEY ((partition), clustering1, clustering2)
) WITH CLUSTERING ORDER BY (clustering1 ASC, clustering2 DESC);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'A', 45, 'EKwe', 100);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (0, 'C', 27, 'seut', 107);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'F', 11, 'Udfg', 121);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'J', 88, 'W1dx', 111);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'K', 55, 'Dwcvb', 165);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'S', 32, 'cwqe', 122);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (3, 'D', 27, 'uidv', 121);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (2, 'D', 45, 'kxvn', 199);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (1, 'F', 16, 'qbvt', 134);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (3, 'C', 67, 'zxmf', 107);
INSERT INTO several_partitions_tbl (partition, clustering1, clustering2, other1, other2) VALUES (3, 'A', 90, 'lpos', 165);