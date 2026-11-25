# Views no Banco Escola de Cursos

**Curso:** Engenharia de Software e ADS  
**Disciplina:** Administração em Banco de Dados: Otimização e Segurança  
**Professor:** Niltemberg Carvalho  
**Aluna:** Crislânia  
**Banco de dados:** `escola_cursos`  
**Ferramenta:** MySQL 8.0 / MySQL Workbench

## Sobre a atividade

Nesta atividade, trabalhei com Views no banco de dados `escola_cursos`, dando continuidade ao laboratório de SQL que fiz anteriormente.

Comecei criando Views para consultar alunos, cursos e professores ativos e também para separar as mensalidades que estavam abertas ou vencidas. Depois, passei a relacionar informações de tabelas diferentes usando `INNER JOIN`, como turmas e cursos, matrículas e alunos, disciplinas e professores.

Também montei relatórios acadêmicos e financeiros usando as Views. Fiz consultas para filtrar matrículas por curso, ano e semestre, conferir mensalidades vencidas, somar os valores pagos e identificar alunos que ainda tinham parcelas em aberto.

Na parte de agregações, utilizei `COUNT`, `AVG` e `SUM` para contar alunos por turma, calcular médias de avaliações e montar um resumo financeiro por aluno. Usei também `COALESCE` para tratar valores de pagamento que poderiam estar nulos.

Depois pratiquei a administração das Views: listei as Views existentes com `SHOW FULL TABLES`, consultei a definição de uma delas com `SHOW CREATE VIEW`, alterei a View de alunos ativos usando `CREATE OR REPLACE VIEW` e criei e removi uma View de teste com `DROP VIEW`.

Por último, trabalhei a parte de segurança. Criei uma View com dados básicos dos alunos, sem expor informações pessoais que não eram necessárias para a consulta, e outra com os dados necessários para o setor financeiro. Também incluí um exemplo de como liberar acesso de leitura a uma View sem dar acesso direto às tabelas originais.

O objetivo foi entender, na prática, como as Views ajudam a organizar consultas, reaproveitar comandos SQL e limitar quais informações cada usuário pode visualizar.

## Arquivo da atividade

- [`views_escola_cursos.sql`](views_escola_cursos.sql): comandos SQL organizados na ordem das 19 questões, com comentários explicando cada etapa.

## Como executar

1. Abra o MySQL Workbench.
2. Conecte-se ao servidor MySQL.
3. Abra o arquivo `views_escola_cursos.sql`.
4. Confirme que o banco `escola_cursos` está disponível.
5. Execute os comandos em partes, seguindo a ordem das questões.
6. Confira os resultados e registre os prints solicitados pelo professor.

> **Atenção:** os nomes de cursos, anos, semestres e situações usados em alguns filtros são exemplos. Se os dados do banco forem diferentes, ajuste esses valores antes de executar. A consulta final da questão 16 está comentada de propósito: depois de excluir a View, execute-a separadamente para observar o erro esperado. O comando `GRANT` da questão 18 também está comentado porque depende da existência de um usuário MySQL válido.

## O que pratiquei

- `CREATE VIEW` e `CREATE OR REPLACE VIEW`
- Consultas em Views com `SELECT` e `WHERE`
- `INNER JOIN` e `LEFT JOIN`
- `COUNT`, `SUM`, `AVG` e `GROUP BY`
- `SHOW FULL TABLES` e `SHOW CREATE VIEW`
- `DROP VIEW`
- Uso de Views como apoio ao controle de acesso aos dados
