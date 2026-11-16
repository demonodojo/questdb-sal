---
name: qdb-sal-port
description: Port a small module or behavior from the sibling questdb-rust implementation into SAL with idiomatic SAL design — methods and statics over free functions, structs, protocols, lambdas — plus dependency tracing, implementation, style checks, and equivalent evidence. Use when continuing or fixing the QuestDB-to-SAL migration; not for unrelated SAL language changes or documentation-only requests.
---

# Portar una unidad a SAL

1. Lee `AGENTS.md`, `docs/MIGRATION.md` y `docs/STATUS.md`.
2. Registra el commit actual de `../questdb-rust`. Lee el código Rust, sus tests y docs de compatibilidad relevantes; sigue cada dependencia hasta sus contratos observables.
3. Consulta `../sal/SPEC.md`, la sección «Estilo de fuente `.sal`» de `../sal/AGENTS.md` y los ejemplos/tests reales. Diseña un port idiomático según `docs/MIGRATION.md` (buenas prácticas): `method`/`static` en vez de funciones libres, structs y enums como unidad de modelado con un struct por fichero en snake_case, protocolos + `impl` para contratos, lambdas finales en `map`/`reduce`, y el modelo de propiedad de Rust con `clone` explícito. No asumas que Rust y SAL comparten runtime, ownership, IO o representación.
4. Define casos concretos, incluidos error y límites, antes de implementar. Mantén explícitamente unsupported lo que quede fuera del slice.
5. Implementa un camino ejecutable pequeño. No agregues scaffolding vacío para anunciar progreso.
6. A petición del usuario, ejecuta las verificaciones pertinentes y compara SAL con Rust; usa `qdb-sal-oracle` cuando se necesite preparar esa comparación.
7. Si el slice tiene camino ejecutable, añade la medición de rendimiento contra Rust y QuestDB según `docs/MIGRATION.md`, sin sustituir la verificación de corrección ni usar el resultado para justificar datos incorrectos.
8. Si el bloqueo es del compilador, runtime, stdlib o tooling de SAL, no lo esquives: reduce el caso a un programa mínimo, comprueba el commit de `../sal` y abre una issue en ese repositorio con versión, comando, salida observada/esperada e impacto. No edites `../sal`.
9. Pasa `standard check` sobre cada `.sal` tocado (y `sal fmt` si aplica), revisa el diff de `standard fix` y corrige el estilo en vez de silenciarlo. No amplíes la gramática ni inventes códigos `E_*` para acomodar el port.
10. Actualiza `docs/STATUS.md` con commit fuente, archivos, alcance, evidencia ejecutada, resultado de `standard check`, diferencias, resultados de rendimiento, issues de SAL abiertas y próximo paso. `verified` requiere pruebas reales, no solo lectura de código.
