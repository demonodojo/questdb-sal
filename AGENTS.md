# Migrar QuestDB Rust a SAL

Este repositorio porta a SAL el proyecto hermano `../questdb-rust`, que a su vez reimplementa QuestDB OSS 10.1.0. Trabaja solo en este repositorio. No edites `../questdb-rust`, `../sal` ni los datos del oráculo.

## Al iniciar

1. Lee `docs/MIGRATION.md`, `docs/STATUS.md` y la skill pertinente de `.agents/skills/`.
2. Inspecciona el estado real de este repositorio y de `../questdb-rust`; no presupongas que el hermano sigue en el mismo commit o estado descrito en estos documentos.
3. Comprueba qué compilador, runner, bibliotecas y convenciones SAL están disponibles aquí. No inventes comandos ni declares una verificación que no ejecutaste.
4. Elige una unidad pequeña del port Rust, registra su fuente, dependencias y criterio de aceptación en `docs/STATUS.md`, y completa una rebanada funcional antes de avanzar.

## Fuente de verdad y fidelidad

- `../questdb-rust` es la referencia inmediata para comportamiento implementado, API, límites y pruebas. Registra su commit al empezar cada etapa.
- QuestDB 10.1.0 sigue siendo el oráculo de compatibilidad final. El port a SAL debe conservar la semántica ya validada en Rust y no perpetuar divergencias conocidas como si fueran comportamiento correcto.
- Lee el código y las pruebas Rust; no traduzcas sintaxis mecánicamente. Modela datos, errores, ownership, efectos y límites en las abstracciones idiomáticas de SAL.
- No copies `target/`, builds ni datos generados del hermano. Copia fixtures pequeños con procedencia, versión y checksum documentados.
- No afirmes compatibilidad de almacenamiento o protocolos sin pruebas de interoperabilidad reproducibles.

## Reglas de implementación

- Una característica solo cuenta como portada si compila/ejecuta y tiene pruebas equivalentes. Las pruebas diferenciales deben comparar SAL con Rust y, cuando exista evidencia, con QuestDB.
- Conserva fallos explícitos para capacidades no implementadas; no devuelvas resultados plausibles pero incorrectos.
- Un fallo achacable al compilador, runtime, stdlib o tooling de SAL se reporta como issue en `github.com/demonodojo/sal` con caso mínimo, versiones, comando, salida observada/esperada e impacto. Reportar no es editar: sigue sin modificar `../sal`; registra la issue en `docs/STATUS.md`.
- Trata con cuidado NULL/sentinels, overflow, Unicode, precisión temporal, orden, errores y límites binarios.
- Seguridad de memoria y durabilidad preceden al rendimiento. Usa `unsafe` solo si el lenguaje/runtime lo exige, con invariantes locales y pruebas de borde.
- Mide el rendimiento, no lo supongas: cada slice ejecutable se compara con `../questdb-rust` y, cuando el oráculo esté disponible, con QuestDB 10.1.0 usando el escenario reproducible de `docs/MIGRATION.md`. Registra comando, máquina, repeticiones y dispersión; sin medición no se declara un resultado de velocidad.
- Escribe SAL idiomático, no Rust transliterado: `method`/`static` antes que funciones libres, structs y enums como unidad de modelado (un struct por fichero en snake_case), protocolos con `impl` para contratos, lambdas finales en `map`/`reduce`, y `standard check` sobre cada `.sal` editado. Detalle en `docs/MIGRATION.md` y en `../sal/SPEC.md` / `../sal/AGENTS.md`.
- No añadas dependencias, generación de código o infraestructura sin una razón concreta y registrada.
- No ejecutes pruebas salvo que el usuario las pida; cuando se soliciten, usa los checks existentes y reporta el comando exacto y su resultado.
- Mantén `docs/STATUS.md` actualizado al cerrar cada unidad: fuente Rust, cambios SAL, evidencia, limitaciones y siguiente tarea concreta.

## Skills locales

Las skills de este repositorio están en `.agents/skills/`. Consulta `.agents/skills/README.md`. No hace falta instalarlas globalmente.
