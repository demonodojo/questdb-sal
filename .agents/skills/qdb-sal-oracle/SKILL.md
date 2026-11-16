---
name: qdb-sal-oracle
description: Build or inspect reproducible differential evidence for the questdb-sal port against questdb-rust and, where available, QuestDB 10.1.0, including performance benchmarks. Use for semantic mismatches, fixture provenance, compatibility claims, equivalent test cases, and latency/throughput/memory comparisons; not for implementing an unrelated feature.
---

# Evidencia diferencial

1. Identifica la misma entrada y precondiciones en el test Rust, el caso SAL y la referencia QuestDB disponible. Registra commits/versiones.
2. Compara salida estructurada, tipos, NULL, orden definido, errores y efectos; no reduzcas la comparación a “ambos compilan” o conteos si los valores importan.
3. Normaliza únicamente diferencias que el contrato permita (por ejemplo, orden sin garantía); documenta la regla de normalización y conserva los datos crudos.
4. Usa fixtures pequeñas, deterministas, con SQL/entrada de origen, versión y checksum. No copies directorios `target/` ni datos mutable del servidor.
5. Nunca ejecutes ambos motores escribiendo sobre el mismo directorio de datos. No declares compatibilidad binaria o protocolaria sin prueba cruzada reproducible.
6. Para rendimiento aplica la metodología de `docs/MIGRATION.md`: mismo host y build, warmup descartado, ≥5 repeticiones, mediana y dispersión, latencia p50/p99, throughput, memoria e I/O, escenario documentado y salida cruda conservada. Compara SAL con Rust y, si está disponible, con QuestDB 10.1.0; sin medición no hay afirmación de velocidad.
7. Si una divergencia o una medición anómala se debe al compilador, runtime o tooling de SAL, reduce el caso y repórtalo como issue en `github.com/demonodojo/sal`; no la normalices como diferencia del port.
8. Reporta divergencias como tales; no cambies la captura esperada para ocultar una diferencia. Actualiza `docs/STATUS.md` solo con comandos realmente ejecutados.
