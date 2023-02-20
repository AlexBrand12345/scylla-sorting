/* common query */

/*  
    table uses WITH CLUSTERING ORDER BY 
    if no clustering order set on creation, can't change the ordering
*/

/* 
    Error from server: code=2200 [Invalid query] 
    message="Cannot page queries with both ORDER BY and a IN restriction on the partition key; you must either remove the ORDER BY or the IN and sort client side, or disable paging for this query"
*/
SELECT * FROM different_partitions_tbl 
    WHERE partition IN (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10) /* only partition = ? works but it always returns one row */
    ORDER BY clustering1 ASC ALLOW FILTERING;


/* view */

DROP MATERIALIZED VIEW IF EXISTS different_partitions_view;

/* incorrect view, sorting works inside each partition */
CREATE MATERIALIZED VIEW different_partitions_view AS
        SELECT * FROM different_partitions_tbl
        WHERE partition IS NOT NULL AND clustering1 IS NOT NULL AND clustering2 IS NOT NULL AND other2 IS NOT NULL
        PRIMARY KEY(partition, other2, clustering2, clustering1)
        WITH CLUSTERING ORDER BY (other2 ASC);

/* All clustering keys must be presented in view PRIMARY KEY, next query will lead to error */
/* 
    InvalidRequest: Error from server: code=2200 [Invalid query] 
    message="Cannot create Materialized View different_partitions_view without primary key columns from base different_partitions_tbl (clustering1)" 
*/
CREATE MATERIALIZED VIEW different_partitions_view AS
        SELECT * FROM different_partitions_tbl
        WHERE partition IS NOT NULL AND clustering1 IS NOT NULL AND clustering2 IS NOT NULL AND other2 IS NOT NULL
        PRIMARY KEY(partition, other2, clustering2) /* no clustering1 field */
        WITH CLUSTERING ORDER BY (other2 ASC);

SELECT * FROM different_partitions_view;