# Scylla-sorting
## Theory

![изображение](https://user-images.githubusercontent.com/62651944/220197255-7380ab1e-2fae-4362-9263-949bd4dd2910.png)
### Scylladb uses partition system to store data.
That means scylla tables are divided into chunks, called partitions. 
- Each partition contains one or more rows of data sorted in a particular order.
- Table store partition tokens, which define the output order for query.

### How to sort tables?
For sorting feature we should use `clustering key(s)`
```SQL
CREATE TABLE IF NOT EXISTS `table_name` (
  ..., 
  PRIMARY KEY((partition_key1, partition_key2, ...), 
    clustering_key1, clustering_key2, ...))
) WITH CLUSTERING ORDER BY (clustering_key1 `ASC/DESC`, clustering2...);
```
After table creation we can only reverse all columns.
`ORDER BY` only supported when the partition key is restricted by an `EQ` or an `IN`, however next query leads to error.
```SQL
SELECT * FROM `table_name` 
    WHERE partition IN (value1, value2, ...)
    ORDER BY clustering1 ASC;
```
Error:  ```InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot page queries with both ORDER BY and a IN restriction on the partition key; you must either remove the ORDER BY or the IN and sort client side, or disable paging for this query"```

So when we want to sort our data, we should filter our partition with `EQ` and then get results, sorted by clustering keys inside previuos key results.

### Views
To change clustering order we can use `MATERIALIZED VIEWS`:
```SQL
CREATE MATERIALIZED VIEW `view_name` AS
        SELECT * FROM `table_name`
        WHERE partition_key1 IS NOT NULL 
          AND partition_key2 IS NOT NULL 
          AND clustering_key1 IS NOT NULL 
          AND clustering_key2 IS NOT NULL 
          AND other_key2 IS NOT NULL
        PRIMARY KEY(partition_key2, other_key2, partition_key1, clustering_key2, clustering_key1) 
        WITH CLUSTERING ORDER BY (other_key2 ASC);
```
In code beyond we've created view, based on the `table_name` table, we must filter all values, used in `PRIMARY KEY`.
`PRIMARY KEY` must contain all partition and clustering fields and may contain one `NON-PRIMARY KEY` from the original table.

This method allows to change cluster level for sorting but still depends on `partition key(s)`


## Examples
Tables creation `init/init.cql`, `docker-compose.yaml` and sorting scipts you can find in the folder.

### One-partition table `!!!Bad way to store data`

Table with partition `partition`, sorted by `clustering1/ASC` and `clustering2/DESC`

![изображение](https://user-images.githubusercontent.com/62651944/220205750-e7a0bf80-f44c-4c22-b42a-f31512be9209.png)

View with partition `partition`, sorted by `other1/DESC`

![изображение](https://user-images.githubusercontent.com/62651944/220205842-e380493b-8676-4132-915d-034684d08723.png)

### Several partitions table

Table with partition `partition`, sorted by `clustering1/ASC` and `clustering2/DESC`

![изображение](https://user-images.githubusercontent.com/62651944/220206592-250c5a27-dc7a-41b6-8ee7-57edf5342876.png)

View with partition `partition`, sorted by `other2/ASC`

![изображение](https://user-images.githubusercontent.com/62651944/220207231-7f746b0d-60cf-44ec-a7bd-6c322abbb450.png)

View with partition `other2`, sorted by default `token(other2)`. Token added to results.

![изображение](https://user-images.githubusercontent.com/62651944/220207657-ed3409a2-380d-4719-8a2e-fe76762fd20c.png)

## Results
As we see, we have opportunity to change table `clustering order` by `views`. 
It allows to sort the whole table if it has only one partition value, but several partition values returns same amount of sorted chunks. 
