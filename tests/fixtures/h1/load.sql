-- Deterministic table written by QuestDB 10.1.0 (commit e11c837f8a169b533540bd6fa57ef3d520b68ad9).
-- cairo.wal.enabled.default=false, so the table is non-WAL and PARTITION BY NONE.
-- Rows are inserted in timestamp order. Do not edit the copied column files by hand.

CREATE TABLE sensors (
  ts TIMESTAMP,
  id LONG,
  flags INT,
  reading DOUBLE,
  score FLOAT,
  ok BOOLEAN,
  code SHORT,
  b BYTE,
  ch CHAR,
  note STRING,
  location SYMBOL,
  tag VARCHAR,
  day DATE
) TIMESTAMP(ts) PARTITION BY NONE;

INSERT INTO sensors VALUES ('2020-01-02T03:04:05.000000Z', 1, 10, 1.5, 1.25, true, 7, 3, 'A', 'alpha', 'madrid', 'v1', '2020-01-02T00:00:00.000Z');
INSERT INTO sensors VALUES ('2020-01-02T03:04:06.000000Z', 2, NULL, NULL, NULL, false, 0, 0, cast(0 as char), NULL, NULL, NULL, NULL);
INSERT INTO sensors VALUES ('2020-01-02T03:04:07.000000Z', NULL, 0, 0.0, 0.0, true, -32768, -128, 'β', '', 'madrid', 'héllo', '1970-01-01T00:00:00.000Z');
INSERT INTO sensors VALUES ('2020-01-02T03:04:08.000000Z', -1, 42, -0.0, -1.5, false, 1, 1, '東', 'βeta', '東京', '0123456789ABCDEF', '2020-06-15T12:30:00.000Z');
