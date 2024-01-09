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
    clustering_key1, clustering_key2, ...)
) WITH CLUSTERING ORDER BY (clustering_key1 `ASC/DESC`, clustering2, ...);
```
<!-- After table creation we can only reverse all columns. -->
`ORDER BY` is only supported when the partition key is restricted by an `EQ` or an `IN`.

However, next query leads to error
```SQL
SELECT * FROM `table_name` 
  WHERE partition IN (value1, value2, ...)
  ORDER BY clustering1 ASC;
```
Error:  ```InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot page queries with both ORDER BY and a IN restriction on the partition key; you must either remove the ORDER BY or the IN and sort client side, or disable paging for this query"```

So when we want to sort our data, we should filter our partition with `EQ` and then get results, sorted by clustering keys inside previous key results.

### Views
To change clustering order we can use `MATERIALIZED VIEWS`, based on the `table_name`
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
`PRIMARY KEY` must contain all partition and clustering fields and may contain one `NON-PRIMARY KEY` from the original table. Otherwise we get an Error: ```InvalidRequest: Error from server: code=2200 [Invalid query] message="Cannot create Materialized View 'something_view' without primary key columns from base 'something_tbl' ('key_name')"```

To fill it we must filter all their values. Otherwise we get an Error: ```InvalidRequest: Error from server: code=2200 [Invalid query] message="Primary key column 'key_name' is required to be filtered by 'IS NOT NULL'"```

This method allows to change cluster level for sorting but still depends on `partition key(s)`


## Sorting examples
You should run `docker-compose.yaml`, create and fill tables by running `init.cql`, check [scripts](/scripts.md) file and add `views` for sortings. 
💬 Test columns' names don't contain `_key` text to make better screenshots.

### One partition table :heavy_exclamation_mark:`Bad way to store data`:heavy_exclamation_mark:

Table with partition_key `partition`, sorted by `clustering1/ASC` and `clustering2/DESC`

![изображение](https://github.com/AlexBrand12345/scylla-sorting/assets/62651944/4a929aaa-fc8c-47e3-bf02-3a0e3bf11705)

View with partition_key `partition`, sorted by `other1/DESC`

![изображение](https://github.com/AlexBrand12345/scylla-sorting/assets/62651944/507df71e-883b-4d4f-a353-3ead23f584cd)

### Multiple partition table
*You may see strange things in `partition_key`, check [notice](#notice)*

Table with partition_key `partition`, sorted by `clustering1/ASC` and `clustering2/DESC`

![изображение](https://github.com/AlexBrand12345/scylla-sorting/assets/62651944/74fbcace-b1a8-4726-9378-4aa0961b61d6)

View with partition_key `partition`, sorted by `other2/ASC`

![изображение](https://github.com/AlexBrand12345/scylla-sorting/assets/62651944/1ebd48d8-d26d-417f-85c5-1a65e84ecc44)

#### Notice
View with partition_key `other2`, sorted by default `token(other2)`. Token added to results.

![изображение](https://github.com/AlexBrand12345/scylla-sorting/assets/62651944/d306edb5-6941-48e5-a32e-efd6969c5493)

## Results
As we see, we have opportunity to change table `clustering order` by `views`. 
It allows to sort the whole table if it has only one `partition_key` value, but several `partition_key` values returns exactly the same number of sorted chunks. Also keep in mind, that `partition_key` column is sorted by `token`, not by `value`.
