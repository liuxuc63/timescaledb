-- This file and its contents are licensed under the Apache License 2.0.
-- Please see the included NOTICE for copyright information and
-- LICENSE-APACHE for a copy of the license.

\ir include/insert_two_partitions.sql

SELECT * FROM hypertable_detailed_size('"public"."two_Partitions"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_device_id_timeCustom_idx"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_timeCustom_device_id_idx"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_timeCustom_idx"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_timeCustom_series_0_idx"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_timeCustom_series_1_idx"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_timeCustom_series_2_idx"');
SELECT * FROM hypertable_index_size('"public"."two_Partitions_timeCustom_series_bool_idx"');
SELECT * FROM chunks_detailed_size('"public"."two_Partitions"') order by chunk_name;

CREATE TABLE timestamp_partitioned(time TIMESTAMP, value TEXT);
SELECT * FROM create_hypertable('timestamp_partitioned', 'time', 'value', 2);

INSERT INTO timestamp_partitioned VALUES('2004-10-19 10:23:54', '10');
INSERT INTO timestamp_partitioned VALUES('2004-12-19 10:23:54', '30');
SELECT * FROM chunks_detailed_size('timestamp_partitioned') order by chunk_name;


CREATE TABLE timestamp_partitioned_2(time TIMESTAMP, value CHAR(9));
SELECT * FROM create_hypertable('timestamp_partitioned_2', 'time', 'value', 2);

INSERT INTO timestamp_partitioned_2 VALUES('2004-10-19 10:23:54', '10');
INSERT INTO timestamp_partitioned_2 VALUES('2004-12-19 10:23:54', '30');
SELECT * FROM chunks_detailed_size('timestamp_partitioned_2') order by chunk_name;

CREATE TABLE toast_test(time TIMESTAMP, value TEXT);
-- Set storage type to EXTERNAL to prevent PostgreSQL from compressing my
-- easily compressable string and instead store it with TOAST
ALTER TABLE toast_test ALTER COLUMN value SET STORAGE EXTERNAL;
SELECT * FROM create_hypertable('toast_test', 'time');

INSERT INTO toast_test VALUES('2004-10-19 10:23:54', $$
this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k.
$$);
SELECT * FROM chunks_detailed_size('toast_test');

CREATE TABLE approx_count(time TIMESTAMP, value int);
SELECT * FROM create_hypertable('approx_count', 'time');
INSERT INTO approx_count VALUES('2004-01-01 10:00:01', 1);
INSERT INTO approx_count VALUES('2004-01-01 10:00:02', 2);
INSERT INTO approx_count VALUES('2004-01-01 10:00:03', 3);
INSERT INTO approx_count VALUES('2004-01-01 10:00:04', 4);
INSERT INTO approx_count VALUES('2004-01-01 10:00:05', 5);
INSERT INTO approx_count VALUES('2004-01-01 10:00:06', 6);
INSERT INTO approx_count VALUES('2004-01-01 10:00:07', 7);
INSERT INTO approx_count VALUES('2004-01-01 10:00:08', 8);
INSERT INTO approx_count VALUES('2004-01-01 10:00:09', 9);
INSERT INTO approx_count VALUES('2004-01-01 10:00:10', 10);
ANALYZE approx_count;

SELECT * FROM hypertable_approximate_row_count('approx_count');

-- all hypertables
SELECT * FROM hypertable_approximate_row_count();
SELECT * FROM hypertable_approximate_row_count(NULL);

SELECT * FROM chunks_detailed_size(NULL);
SELECT * FROM hypertable_detailed_size(NULL);
SELECT * FROM hypertable_index_size(NULL);

-- tests with tables that are not hypertables
CREATE TABLE regtab( a integer, b integer);
CREATE INDEX regtab_idx ON regtab( a);
SELECT * FROM hypertable_index_size('regtab_idx');
