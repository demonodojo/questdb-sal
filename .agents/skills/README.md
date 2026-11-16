# Skills de questdb-sal

Las skills específicas están bajo `.agents/skills/`, donde los runners de agentes las descubren automáticamente. Están escritas con frontmatter Agent Skills y pueden instalarse globalmente si se desea, aunque no es necesario para este repositorio.

| Skill | Aplicación |
| --- | --- |
| [qdb-sal-port](qdb-sal-port/SKILL.md) | Portar una unidad de `questdb-rust` a SAL idiomático (métodos, structs, protocolos, lambdas). |
| [qdb-sal-oracle](qdb-sal-oracle/SKILL.md) | Diseñar/ejecutar comparación funcional y de rendimiento entre Rust, SAL y QuestDB. |
| [qdb-sal-status](qdb-sal-status/SKILL.md) | Auditar y actualizar evidencia de progreso. |
