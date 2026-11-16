---
name: qdb-sal-status
description: Audit what the SAL port actually implements and what is backed by tests, compare its state with questdb-rust, and maintain the migration status and next task. Use for status/evidence reviews; not as a substitute for implementing a requested feature.
---

# Auditar el estado

1. Lee `AGENTS.md`, `docs/MIGRATION.md`, `docs/STATUS.md` y el estado actual de `../questdb-rust`.
2. Inspecciona archivos y pruebas existentes. No heredes las etiquetas de compatibilidad Rust como si fueran SAL.
3. Distingue explícitamente código presente, compilación, pruebas SAL, comparación Rust y comparación QuestDB.
4. Marca `verified` solo con evidencia reproducible del alcance descrito; registra ruta y comando. Si no se ejecutó una comprobación, dilo.
5. Comprueba el estilo SAL del código portado: preferencia por `method`/`static` frente a funciones libres, un struct por fichero en snake_case, protocolos e `impl` en vez de duplicación, lambdas finales donde toca, y `standard check` pasado sobre cada `.sal` tocado. Una desviación sin justificar es deuda, no un detalle cosmético.
6. Distingue fallos del port de fallos del compilador/runtime de SAL. Los segundos deben tener issue abierta en `github.com/demonodojo/sal`; si no la tiene, es un bloqueo pendiente, no una limitación aceptada. Registra número/URL de la issue y el estado de la unidad.
7. Actualiza la tabla y el siguiente paso concreto. Registra bloqueos externos con el error o limitación observada.
