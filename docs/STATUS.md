# Estado del port SAL

## Estado actual — 2026-11-16

| Área | Estado | Evidencia / límite |
| --- | --- | --- |
| Bootstrap documental | verified | `AGENTS.md`, `docs/MIGRATION.md`, `.agents/skills/`. |
| `qdb-types`: tags, sentinels, tipos, fechas y errores | in-progress | `src/qdb_types.sal` porta tags/versiones/sentinels, enum `Scalar`, `type_tag`, `type_name`, conversión días↔fecha civil, parseo UTC DATE/TIMESTAMP, formateo temporal básico y `Error` con posición explícita. `tests/test_qdb_types.sal` contiene regresiones para flags, borrados, NULL tipado, época Unix, fecha anterior a época, fracciones 3/6/9 dígitos, exceso de precisión y campos inválidos. Fuente: `../questdb-rust` commit `72d535d37bdc1dded435fee84fcaf04a7898d20a`, `crates/qdb-types/src/lib.rs`. `sal check` de ambos archivos pasó con el compilador de `../sal` construido en `/tmp/questdb-sal-toolchain`; no se ejecutó el programa. Los casos no se compararon en runtime con Rust/QuestDB. `OptionalInt` es el equivalente local de `Option<i64>` y sus tags/contratos todavía requieren cotejo. |
| Restante de `qdb-types` | not-started | Igualdad bit-exacta/display de `Scalar`, formato float, fracciones/extremos temporales y comparación diferencial quedan pendientes. |
| Lectura de ficheros, `_meta` y `_txn` | in-progress | `src/qdb_storage_io.sal` hace lectura completa y acotada a `Bytes`; `src/qdb_storage_meta.sal` valida cabecera 10.1.0, NONE/DAY, WAL apagado, registros, tags y nombres UTF-16; `src/qdb_storage_txn.sal` selecciona el bloque A/B y valida filas, mapas de símbolos y registros de partición. Regresiones en `tests/test_qdb_storage_meta.sal` y `tests/test_qdb_storage_txn.sal` leen fixture real y consideran cabecera truncada. Los tres módulos y ambas regresiones pasaron `sal check` con `/tmp/questdb-sal-toolchain/debug/sal`; no se ejecutaron. Fuente Rust: `crates/qdb-storage/src/{bytes,meta,txn}.rs` en el commit citado. Falta cotejo de runtime con Rust. |
| Fixture binaria | verified | Copia de `sensors` en `tests/fixtures/h1/db/sensors` (104 KiB), creada por QuestDB OSS 10.1.0 commit `e11c837f8a169b533540bd6fa57ef3d520b68ad9`; cuatro filas, 13 columnas, NONE/WAL off. `load.sql`, `README.md` y `SHA256SUMS` conservan procedencia/reproducción/checksums. `sha256sum -c SHA256SUMS` confirmó los 24 archivos. Solo se copió la tabla, sin corpus `expected/` ni `target/`. |
| Referencia `questdb-rust` | in-progress | Repo inspeccionado en commit `72d535d37bdc1dded435fee84fcaf04a7898d20a`. |
| Oráculo QuestDB | not-started | No hay oráculo ni fixtures en este repo. Reutilizar solo evidencia verificable del hermano y documentar procedencia. |
| Toolchain / dependencia de IO | in-progress | `Sal.toml` declara `io = { std = "io" }`; `/tmp/questdb-sal-toolchain/debug/sal install` creó `sal_modules/io` y permitió compilar la ruta de lectura. `sal_modules/` y `target/` quedan ignorados. |
| Rendimiento SAL vs `questdb-rust` | not-started | Hay parsers estáticos pero aún no un camino de consulta equivalente ejecutado. Exigirá escenario reproducible, ≥5 repeticiones, p50/p99, memoria/IO y comando documentado (ver `docs/MIGRATION.md`). |
| Rendimiento vs QuestDB 10.1.0 | not-started | No hay servidor/oráculo local configurado en este repo; la tabla fixture ya está versionada localmente. No se declaran comparaciones relativas. |

## Incidencias abiertas en `sal`

Ninguna. Cualquier fallo del compilador, runtime, stdlib o tooling de SAL debe abrirse en `github.com/demonodojo/sal` y enlazarse desde aquí.

## Próximo paso

Portar lectura de columnas y salida CLI de filas sobre la fixture local. Después, ejecutar (cuando esté autorizado) las regresiones y cotejar metadata/filas con `questdb-rust`. `qdb-types` aún tiene formato/equivalencia exacta de `Scalar` pendiente. Las regresiones solo se compilaron; la comparación diferencial y los benchmarks siguen pendientes y bloquean `verified` funcional.
