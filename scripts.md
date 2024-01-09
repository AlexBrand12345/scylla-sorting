# Add views to make sorting possible (or better)

## One partition table
### Common query for common table
Table uses ```WITH CLUSTERING ORDER BY```, so only the whole ordering(all columns) set on creation can be reversed

##### Base query with default ordering (clustering1 ASC, clustering2 DESC)
```SQL 
SELECT * FROM one_partition_tbl;
```
(result img)

##### Query with changed ordering by second `clustering_key`
```SQL
SELECT * FROM one_partition_tbl 
    WHERE partition = 0 
    ORDER BY clustering2 DESC;
``` 
Error: ```InvalidRequest: Error from server: code=2200 [Invalid query] message="Unsupported order by relation - column clustering1 doesn't have an ordering or EQ relation."```

##### Query with reversed ordering by first `clustering_key`
```SQL
SELECT * FROM one_partition_tbl 
    WHERE partition = 0 
    ORDER BY clustering1 DESC;
```
(result img)

### Query for view, based on table
##### Make sure you don't have active view with name or run next command
```SQL 
DROP MATERIALIZED VIEW IF EXISTS one_partition_view;
```
##### Create view with adding `order_key` and placing it after `partition_key`
```SQL
CREATE MATERIALIZED VIEW one_partition_view AS
        SELECT * FROM one_partition_tbl
        WHERE partition IS NOT NULL 
          AND clustering1 IS NOT NULL 
          AND clustering2 IS NOT NULL 
          AND other1 IS NOT NULL
        PRIMARY KEY(partition, other1, clustering1, clustering2)
        WITH CLUSTERING ORDER BY (other1 DESC);
```
##### Query with prepared order column and any order: ASC/DESC
```SQL
SELECT * FROM one_partition_view;
```
(result img)



## Multiple partition table
### Common query for common table
Table uses ```WITH CLUSTERING ORDER BY```, but ordering can't be reversed

##### Base query with default ordering (clustering1 ASC, clustering2 DESC)
```SQL 
SELECT * FROM several_partition_tbl;
```
(result img)

##### Query with reversed ordering by first `clustering_key`
```SQL
SELECT * FROM several_partitions_tbl 
    WHERE partition IN (0, 1, 2) // only partition = ? works but it returns rows only for one partition
    ORDER BY clustering1 DESC;
``` 
Error: ```Error from server: code=2200 [Invalid query] message="Cannot page queries with both ORDER BY and a IN restriction on the partition key; you must either remove the ORDER BY or the IN and sort client side, or disable paging for this query"```

### Query for view, based on table
##### Make sure you don't have active view with name or run next command
```SQL 
DROP MATERIALIZED VIEW IF EXISTS several_partitions_view;
```
##### Create view with adding sort key and placing it after partition key
```SQL
CREATE MATERIALIZED VIEW several_partitions_view AS
        SELECT * FROM several_partitions_tbl
        WHERE partition IS NOT NULL 
          AND clustering1 IS NOT NULL 
          AND clustering2 IS NOT NULL 
          AND other2 IS NOT NULL
        PRIMARY KEY(partition, other2, clustering2, clustering1)
        WITH CLUSTERING ORDER BY (other2 ASC);
```
##### Now you can select from this view
```SQL
SELECT * FROM several_partition_view;
```
(result img)

##### Notice - partition column isn't sorted by values, it is sorted by their tokens
Follow these steps to see by yourself
```SQL
DROP MATERIALIZED VIEW IF EXISTS several_partitions_tokens_view;
```
```SQL
CREATE MATERIALIZED VIEW several_partitions_tokens_view AS
        SELECT * FROM several_partitions_tbl
        WHERE partition IS NOT NULL 
          AND clustering1 IS NOT NULL 
          AND clustering2 IS NOT NULL 
          AND other2 IS NOT NULL
        PRIMARY KEY(other2, partition, clustering1, clustering2);
```
```SQL
SELECT token(other2), other2, partition, clustering1, clustering2, other1 from several_partitions_tokens_view;
```
(result img)
