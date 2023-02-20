/* common query */

/* 
    table uses WITH CLUSTERING ORDER BY 
    only whole ordering(all columns) set on creation can be reversed
*/

/* base query with default ordering (clustering1 ASC, clustering2 DESC)*/
SELECT * FROM one_partition_tbl;

/* 
    InvalidRequest: Error from server: code=2200 [Invalid query] 
    message="Unsupported order by relation - column clustering1 doesn't have an ordering or EQ relation." 
*/
SELECT * FROM one_partition_tbl 
    WHERE partition = 0 
    ORDER BY clustering2 DESC;

/* reverse each column ordering where clustering1 is set to ASC on creation */
SELECT * FROM one_partition_tbl 
    WHERE partition = 0 
    ORDER BY clustering1 DESC;


/* view */

DROP MATERIALIZED VIEW IF EXISTS one_partition_view;

/* correct view, works with one partition key only */
CREATE MATERIALIZED VIEW one_partition_view AS
        SELECT * FROM one_partition_tbl
        WHERE partition IS NOT NULL AND clustering1 IS NOT NULL AND clustering2 IS NOT NULL AND other1 IS NOT NULL
        PRIMARY KEY(partition, other1, clustering2, clustering1)
        WITH CLUSTERING ORDER BY (other1 DESC);

/* All clustering keys must be presented in view PRIMARY KEY, next query will lead to error */
/* 
    InvalidRequest: Error from server: code=2200 [Invalid query] 
    message="Cannot create Materialized View one_partition_view without primary key columns from base one_partition_tbl (clustering1)" 
*/
CREATE MATERIALIZED VIEW one_partition_view AS
        SELECT * FROM one_partition_tbl
        WHERE partition IS NOT NULL AND clustering1 IS NOT NULL AND clustering2 IS NOT NULL AND other1 IS NOT NULL
        PRIMARY KEY(partition, other1, clustering2) /* no clustering1 field */
        WITH CLUSTERING ORDER BY (other1 DESC);

SELECT * FROM one_partition_view;