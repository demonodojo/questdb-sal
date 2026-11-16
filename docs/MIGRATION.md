# Proceso de migración Rust → SAL

## Objetivo

Portar progresivamente `questdb-rust` a SAL manteniendo su comportamiento verificable y, aguas arriba, la compatibilidad comprobada con QuestDB OSS 10.1.0. El Rust hermano es la especificación ejecutable del trabajo SAL; no es autoridad para declarar equivalencia con QuestDB cuando sus propios documentos registran límites o diferencias.

## Ciclo por unidad

1. **Fijar referencias.** Anota `git -C ../questdb-rust rev-parse HEAD`, la fecha, los archivos fuente y los tests Rust pertinentes. Si ese repo no está disponible, registra el bloqueo.
2. **Entender el comportamiento.** Traza entradas, salida, errores, invariantes, efectos y dependencias. Lee la evidencia de QuestDB indicada por los tests/docs Rust. Clasifica qué parte está verificada y cuál solo está implementada.
3. **Definir el corte SAL.** Identifica los tipos/funciones SAL mínimos, la interfaz pública y las capacidades que se rechazan explícitamente. Escribe casos de aceptación antes de portar.
4. **Portar verticalmente.** Implementa un camino pequeño de extremo a extremo en SAL, siguiendo las abstracciones y convenciones del compilador/runtime SAL y las buenas prácticas de la sección siguiente. Evita copiar módulos grandes sin una prueba ejecutable.
5. **Comparar.** Cuando la instrucción local autorice ejecutar pruebas, ejecuta casos equivalentes sobre SAL y Rust; compara valores, tipos, orden cuando esté especificado, errores y efectos. Usa fixtures versionadas. Cuando haya oráculo QuestDB disponible, coteja también los casos de compatibilidad afectados. Si la ejecución no está autorizada, deja escrito el comando pendiente y no marques el alcance como `verified`.
6. **Revisar fronteras.** Comprueba entradas vacías/mínimas, NULL, límites, errores y cualquier efecto de memoria/IO. Para formatos binarios, prueba corrupción y truncamiento antes de aceptar datos.
7. **Medir rendimiento.** Cuando el slice tenga un camino ejecutable, ejecuta la comparación de rendimiento descrita abajo contra Rust y, si está disponible, contra QuestDB 10.1.0. Ser correcto manda sobre ser rápido; una regresión medida se registra como divergencia, no se oculta.
8. **Cerrar el registro.** Actualiza `docs/STATUS.md` con estado `not-started`, `in-progress`, `verified` o `blocked`, evidencia/rutas, divergencias, resultados de rendimiento cuando existan, issues abiertas en SAL y una próxima unidad concreta.

## Orden recomendado

No presupongas que la arquitectura Rust debe reproducirse crate por crate. Respeta dependencias y busca primero el menor slice útil:

1. Auditoría del repositorio SAL, herramientas de compilación y accesibilidad del hermano/oráculo.
2. Tipos fundamentales y representación de errores; contratos de plataforma y filesystem si el slice los necesita.
3. Lectura read-only de una fixture real y validación estricta de límites.
4. CLI/consulta vertical mínima, si el diseño de SAL permite ejecutarla en el entorno previsto.
5. Banco de rendimiento mínimo sobre ese camino ejecutable: escenario, fixtures con checksum, arnés repetible y primera medición contra Rust y QuestDB.
6. Ampliación por módulos según el grafo real de dependencias Rust: SQL, almacenamiento, catálogo, protocolos, escritura/WAL, etc.

El orden preciso se decide a partir del inventario real; no se declara un hito solo por crear archivos vacíos.

## Evidencia y estados

- **not-started**: no hay implementación.
- **in-progress**: hay código o exploración sin cobertura suficiente.
- **verified**: tests reproducibles pasan para el alcance indicado y hay comparación con la fuente Rust; indica aparte si también se cotejó con QuestDB.
- **blocked**: dependencia externa o limitación técnica identificada con evidencia y siguiente acción para desbloquear.

No uses porcentajes subjetivos. Distingue compilación, pruebas unitarias, equivalencia Rust, compatibilidad QuestDB y rendimiento. Los artefactos derivados deben incluir versión, comando de generación y checksum cuando corresponda.

`verified` califica corrección, no velocidad: un slice correcto puede ser más lento que Rust y seguir `verified`, siempre que la diferencia esté medida y registrada. Igualmente, un slice más rápido pero con datos incorrectos o no durables no es aceptable.

## Pruebas de rendimiento

El rendimiento se compara en tres puntos: SAL (implementación nueva), `questdb-rust` (referencia inmediata) y QuestDB OSS 10.1.0 (oráculo). No se declara «igual de rápido» ni «más rápido» sin una medición reproducible; la intención o el diseño no cuentan como evidencia.

**Precedencia.** Corrección, seguridad de memoria y durabilidad van antes que el rendimiento. No se acepta un número rápido obtenido con datos incorrectos, sin fsync cuando el contrato lo exige o con una prueba que evita el camino real.

**Metodología mínima.**

- Misma máquina, SO, runtime y parámetros de build (release, flags, heap/páginas) para los tres motores. Si alguno no puede ejecutarse en el mismo host, registra la diferencia y no compares tiempos absolutos entre hosts; usa solo comparaciones internas.
- Carga definida y reproducible: entrada/SQL exacta, esquema, orden de inserción, concurrencia, duración o número de operaciones y estado inicial del almacenamiento (vacío, precargado, tras compactación).
- Calentamiento y repeticiones: descarta el warmup, ejecuta al menos 5 repeticiones y reporta mediana más dispersión (p50/p99 de latencia, desviación o rango). Una sola ejecución no es evidencia.
- Mide al menos: throughput (ops/s o MB/s), latencia por percentiles, memoria residente/pico, CPU y bytes de I/O. Si el slice incluye arranque o carga de datos, mide esa fase por separado.
- No mezcles fases (arranque, ingestión, compactación, consulta) en un único número.
- Aísla el ruido: sin otras cargas en el host, caches en estado conocido y logs/telemetría desactivados o incluidos explícitamente en el escenario.
- Conserva el arnés, su configuración, la salida cruda y un checksum; el escenario debe repetirse con un comando documentado.

**Comparación entre motores.**

- Mismo escenario lógico aunque el arnés difiera; documenta las equivalencias (consulta SQL idéntica, mismo esquema, mismo dataset de fixtures con checksum).
- Para QuestDB fija imagen/versión y configuración relevante (`server.conf`), y usa el mismo dataset de fixtures; no reutilices datos mutables del servidor del hermano ni `target/`.
- Si un motor no puede ejecutar el escenario porque la capacidad no está implementada, registra `blocked` o N/A con el motivo; no extrapoles ni inventes un número.
- Reporta el factor relativo (p. ej. latencia p99 SAL/Rust = 1.7×) junto con los valores absolutos y la dispersión observada, no solo el porcentaje.

**Registro.** En `docs/STATUS.md` anota escenario, commit de Rust, versión de QuestDB, comando exacto, fecha/máquina y resultado con dispersión. Mantén el rendimiento en una fila o sección separada del estado funcional para no confundir corrección con velocidad.

## Incidencias del compilador de SAL

Todo problema achacable al compilador, runtime, biblioteca estándar o tooling de SAL se reporta como **issue en el repositorio de SAL**. No se rodea con un workaround silencioso ni se degrada a “limitación del port” sin reportarlo; tampoco se parchea `../sal` desde aquí.

**Triaje antes de reportar** (para no atribuir al compilador un fallo propio):

1. Reproduce el fallo con el mínimo SAL posible, fuera del código del port y sin dependencias de QuestDB.
2. Descarta API mal usada, tipos/ownership/lifetimes incorrectos y documentación mal leída.
3. Fija la versión: `git -C ../sal rev-parse HEAD` y la versión del compilador/runtime.
4. Comprueba si ya está corregido en el commit actual de SAL antes de abrir nada.

Si el fallo está en el port, se corrige aquí. Si está en el compilador/runtime, se reporta.

**Contenido obligatorio del reporte:**

- Versión/commit de SAL, versión del compilador, SO y arquitectura.
- Programa mínimo reproducible, autocontenido, y el comando exacto de compilación/ejecución.
- Salida observada frente a la esperada, con el mensaje de error literal.
- Impacto en el port (qué slice bloquea o qué rendimiento degrada) y workaround aplicado, si existe, con su riesgo.
- Enlace a la unidad y a la entrada correspondiente de `docs/STATUS.md`.

**Destino y seguimiento:** issues de `github.com/demonodojo/sal` (remoto `origin` de `../sal`), por ejemplo `gh issue create -R demonodojo/sal`. No se abre un PR ni se modifica el repo hermano. Registra número/URL en `docs/STATUS.md` junto a la unidad; marca la unidad `blocked` si el compilador impide avanzar y retira el bloqueo cuando el fix esté en el commit de SAL que uses. Un workaround que evita el camino real no cuenta como funcionalidad portada.

Crear la issue es una acción externa: si la tarea en curso no autoriza publicarla, prepara el informe completo y pide confirmación antes de crearla, sin sustituirla por una nota local.

## Buenas prácticas de SAL

El port no es una traducción de Rust: se escribe en SAL idiomático. La autoridad es `../sal/SPEC.md` para la semántica y la sección «Estilo de fuente `.sal`» de `../sal/AGENTS.md` para el estilo; esto resume lo que aplica a este repo.

**Métodos antes que funciones.** Define `method T.f(...)` cuando hay receptor y `static T.f(...)` cuando no lo hay y `T` es un tipo propio del módulo. Llama `s.len()`, `xs.push(v)`, `List.new[Int]()`, no `str_len(s)`, `list_push(xs, v)` ni `list_new()`. Una función libre solo cuando la operación no pertenece a ningún tipo.

**Structs y enums como unidad de modelado.** Un struct por fichero y el fichero se llama como el struct en snake_case (`TypeEnv` → `type_env.sal`). Dentro del fichero: el struct, después sus `method`/`static`, y las funciones al final. Agrupa en carpetas y subcarpetas por función, con nombres que digan de qué van. Modela con structs/enums antes que con tuplas o parámetros sueltos, y construye con `init(...)` para no romper el invariante.

**Protocolos para abstraer.** Expresa el contrato con `protocol P` y `impl P` en la cabecera del struct/enum, en lugar de duplicar métodos o pasar callbacks sueltos. Respeta la regla de huérfanos: el `impl` va en el módulo del tipo o en el del protocolo. Usa `any[P]` solo cuando el despacho dinámico sea el requisito real: exige `alloc` y no admite métodos genéricos ni `static` por vtable.

**Lambdas para operaciones locales.** Prefiere la forma de lambda final en `map`, `reduce` y filtros: `xs.map x => x * 2`, `xs.reduce(0) (a, x) => a + x`. Recuerda sus límites: un tipo `fn(...)` solo vale como tipo de parámetro, la lambda no se guarda en un struct ni se devuelve, no admite `return`/`break` dentro, y dentro de `match` el `=>` pertenece al brazo.

**Propiedad y efectos.** Modelo de Rust más `@arena`: movimiento por defecto, `&T`/`&mut T` para prestar (con lifetimes y elisión), `x.clone()` explícito para copia profunda y liberación por glue al salir de ámbito. Nada de copias implícitas ni heurísticas de valor «fresco».

**Formato y linter.** Sangría con espacios (un tabulador es `E_PARSE`), comentarios con `#`, y la última expresión del bloque es el valor. Todo `.sal` editado pasa por `standard check` antes de cerrar la unidad; aplica `standard fix` y revisa el diff. `sal fmt` es idempotente pero no aplica las reglas de `standard`. Cita el comando exacto y su resultado en `docs/STATUS.md`; si no se pudo ejecutar, dilo.

**Límites del lenguaje.** No amplíes la superficie de SAL ni inventes códigos `E_*` para que entre el port: lo no soportado se adapta en el diseño o se reporta como incidencia del compilador. Si una práctica se repite y `standard` no la cubre, se propone en el repo de SAL, no se aplica parcheando `../sal`.

## Entorno y límites actuales

Este checkout contiene el port SAL bajo `src/`, regresiones bajo `tests/` y herramientas/docs del proyecto según vayan apareciendo. La toolchain canónica SAL está en `../sal`; QuestDB Rust está en `../questdb-rust`. No modificar esos repos. Las skills canónicas residen en `.agents/skills/`. La instrucción activa prohíbe ejecutar pruebas salvo petición explícita del usuario; `sal check` solo valida el programa y no ejecuta la regresión.
