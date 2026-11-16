# Fixture `sensors`

- Source: `../questdb-rust/tests/fixtures/h1/db/sensors` at questdb-rust commit `72d535d37bdc1dded435fee84fcaf04a7898d20a`.
- Database writer/oracle: QuestDB OSS 10.1.0, commit `e11c837f8a169b533540bd6fa57ef3d520b68ad9`.
- Table: `sensors`, `PARTITION BY NONE`, WAL disabled, 4 rows; binary files are copied unchanged under `db/sensors/`.
- Reproduction input: [load.sql](load.sql). It describes the deterministic table and inserts; it is not a script to apply to the binary copy.
- Verify copied binary files with `sha256sum -c SHA256SUMS` from this directory.

The copy contains only the table directory, not the sibling project's generated query corpus, build artifacts, server data, or mutable runtime.
