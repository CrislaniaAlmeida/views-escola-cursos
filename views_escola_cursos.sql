-- ============================================================================
-- ATIVIDADE PRATICA: VIEWS NO BANCO ESCOLA DE CURSOS
-- Curso: Engenharia de Software e ADS
-- Disciplina: Administracao em Banco de Dados: Otimizacao e Seguranca
-- Professor: Niltemberg Carvalho
-- Aluna: Crislânia
-- Banco de dados: escola_cursos
-- SGBD: MySQL 8.0
--
-- Objetivo:
-- Praticar criacao, consulta, alteracao e exclusao de Views no MySQL,
-- utilizando filtros, JOINs, funcoes de agregacao, relatorios e seguranca.
--
-- Observacao:
-- Execute as questoes na ordem. Confira os nomes e valores existentes no
-- banco escola_cursos antes de usar filtros por curso, ano, semestre ou situacao.
-- ============================================================================

USE escola_cursos;

-- ============================================================================
-- PARTE 1 - PRIMEIRAS VIEWS
-- ============================================================================

-- QUESTAO 1 - Alunos ativos
-- A View mostra somente os dados solicitados dos alunos cuja situacao e Ativo.
CREATE OR REPLACE VIEW vw_alunos_ativos AS
SELECT
    codigo_aluno,
    nome,
    telefone,
    cidade,
    estado
FROM aluno
WHERE situacao = 'Ativo';

-- Consulta todos os registros da View.
SELECT *
FROM vw_alunos_ativos;


-- QUESTAO 2 - Cursos ativos
-- A View facilita a consulta dos cursos que estao ativos.
CREATE OR REPLACE VIEW vw_cursos_ativos AS
SELECT
    codigo_curso,
    nome,
    carga_horaria,
    valor_mensalidade
FROM curso
WHERE situacao = 'Ativo';

SELECT *
FROM vw_cursos_ativos;


-- QUESTAO 3 - Professores ativos
-- Alem do nome e da especialidade, apresento o codigo e a situacao.
CREATE OR REPLACE VIEW vw_professores_ativos AS
SELECT
    codigo_professor,
    nome,
    especialidade,
    situacao
FROM professor
WHERE situacao = 'Ativo';

SELECT *
FROM vw_professores_ativos;


-- QUESTAO 4 - Mensalidades pendentes
-- A View considera mensalidades Abertas ou Vencidas.
CREATE OR REPLACE VIEW vw_mensalidades_pendentes AS
SELECT
    codigo_matricula,
    numero_parcela,
    data_vencimento,
    data_pagamento,
    valor,
    valor_pago,
    situacao
FROM mensalidade
WHERE situacao IN ('Aberta', 'Vencida');

-- Depois de criar a View, filtro somente as mensalidades vencidas.
SELECT *
FROM vw_mensalidades_pendentes
WHERE situacao = 'Vencida';


-- ============================================================================
-- PARTE 2 - VIEWS ENVOLVENDO JOIN
-- ============================================================================

-- QUESTAO 5 - Turmas e cursos
-- O INNER JOIN relaciona cada turma ao curso correspondente.
CREATE OR REPLACE VIEW vw_turmas_cursos AS
SELECT
    t.codigo_turma,
    t.nome AS nome_turma,
    t.ano,
    t.semestre,
    c.nome AS nome_curso
FROM turma AS t
INNER JOIN curso AS c
    ON c.codigo_curso = t.codigo_curso;

SELECT *
FROM vw_turmas_cursos;

-- Exemplo de filtro por curso. Troque o nome pelo curso existente no banco.
SELECT *
FROM vw_turmas_cursos
WHERE nome_curso = 'Excel Profissional';


-- QUESTAO 6 - Matriculas dos alunos
-- Relaciona matricula, aluno e turma para montar um relatorio unico.
CREATE OR REPLACE VIEW vw_matriculas_alunos AS
SELECT
    m.codigo_matricula,
    a.nome AS nome_aluno,
    t.nome AS nome_turma,
    m.data_matricula,
    m.situacao AS situacao_matricula
FROM matricula AS m
INNER JOIN aluno AS a
    ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma AS t
    ON t.codigo_turma = m.codigo_turma;

SELECT *
FROM vw_matriculas_alunos;

-- O filtro abaixo considera o valor de situacao usado para matriculas ativas.
SELECT *
FROM vw_matriculas_alunos
WHERE situacao_matricula = 'Ativa';


-- QUESTAO 7 - Disciplinas e professores
-- Junta cada disciplina ao professor responsavel.
CREATE OR REPLACE VIEW vw_disciplinas_professores AS
SELECT
    d.nome AS nome_disciplina,
    d.carga_horaria,
    p.nome AS nome_professor,
    p.especialidade
FROM disciplina AS d
INNER JOIN professor AS p
    ON p.codigo_professor = d.codigo_professor;

-- A ordenacao e feita na consulta, sem mudar a definicao da View.
SELECT *
FROM vw_disciplinas_professores
ORDER BY nome_professor ASC;


-- ============================================================================
-- PARTE 3 - VIEWS PARA RELATORIOS
-- ============================================================================

-- QUESTAO 8 - Relatorio academico de matriculas
-- Reune aluno, curso, turma e dados da matricula.
CREATE OR REPLACE VIEW vw_relatorio_matriculas AS
SELECT
    a.nome AS aluno,
    c.nome AS curso,
    t.nome AS turma,
    t.ano,
    t.semestre,
    m.data_matricula,
    m.situacao AS situacao_matricula
FROM matricula AS m
INNER JOIN aluno AS a
    ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma AS t
    ON t.codigo_turma = m.codigo_turma
INNER JOIN curso AS c
    ON c.codigo_curso = t.codigo_curso;

SELECT *
FROM vw_relatorio_matriculas;

-- A) Alunos matriculados em um determinado curso.
-- Exemplo: substitua pelo nome de um curso cadastrado.
SELECT aluno, curso
FROM vw_relatorio_matriculas
WHERE curso = 'Excel Profissional';

-- B) Matriculas de determinado ano e semestre.
-- Os valores abaixo sao um exemplo e podem ser ajustados aos dados existentes.
SELECT *
FROM vw_relatorio_matriculas
WHERE ano = 2026
  AND semestre = 1;

-- C) Quantidade de matriculas por curso.
SELECT
    curso,
    COUNT(*) AS quantidade_matriculas
FROM vw_relatorio_matriculas
GROUP BY curso
ORDER BY curso;


-- QUESTAO 9 - Relatorio financeiro
-- Relaciona mensalidade, matricula, aluno e turma.
CREATE OR REPLACE VIEW vw_financeiro_alunos AS
SELECT
    a.nome AS aluno,
    t.nome AS turma,
    me.numero_parcela AS parcela,
    me.data_vencimento AS vencimento,
    me.data_pagamento AS pagamento,
    me.valor,
    me.valor_pago,
    me.situacao
FROM mensalidade AS me
INNER JOIN matricula AS m
    ON m.codigo_matricula = me.codigo_matricula
INNER JOIN aluno AS a
    ON a.codigo_aluno = m.codigo_aluno
INNER JOIN turma AS t
    ON t.codigo_turma = m.codigo_turma;

SELECT *
FROM vw_financeiro_alunos;

-- A) Mensalidades vencidas.
SELECT *
FROM vw_financeiro_alunos
WHERE situacao = 'Vencida';

-- B) Total efetivamente pago.
SELECT
    SUM(valor_pago) AS total_efetivamente_pago
FROM vw_financeiro_alunos;

-- C) Total pago por aluno.
SELECT
    aluno,
    SUM(valor_pago) AS total_pago
FROM vw_financeiro_alunos
GROUP BY aluno
ORDER BY aluno;

-- D) Alunos que possuem parcelas em aberto.
SELECT DISTINCT aluno
FROM vw_financeiro_alunos
WHERE situacao = 'Aberta'
ORDER BY aluno;


-- ============================================================================
-- PARTE 4 - VIEWS COM AGREGACOES
-- ============================================================================

-- QUESTAO 10 - Quantidade de alunos por turma
-- LEFT JOIN mantem tambem as turmas que ainda nao possuem matriculas.
-- COUNT conta os codigos de matricula encontrados em cada turma.
CREATE OR REPLACE VIEW vw_quantidade_alunos_turma AS
SELECT
    t.codigo_turma,
    t.nome AS turma,
    COUNT(m.codigo_matricula) AS quantidade_alunos
FROM turma AS t
LEFT JOIN matricula AS m
    ON m.codigo_turma = t.codigo_turma
GROUP BY
    t.codigo_turma,
    t.nome;

SELECT *
FROM vw_quantidade_alunos_turma;


-- QUESTAO 11 - Media das avaliacoes
-- COUNT conta as notas registradas e AVG calcula a media de cada avaliacao.
CREATE OR REPLACE VIEW vw_media_avaliacoes AS
SELECT
    av.codigo_avaliacao,
    av.descricao AS avaliacao,
    COUNT(n.nota) AS quantidade_notas,
    AVG(n.nota) AS media_notas
FROM avaliacao AS av
INNER JOIN nota AS n
    ON n.codigo_avaliacao = av.codigo_avaliacao
GROUP BY
    av.codigo_avaliacao,
    av.descricao;

SELECT *
FROM vw_media_avaliacoes;

-- Mostra somente as avaliacoes com media abaixo de 7,0.
SELECT *
FROM vw_media_avaliacoes
WHERE media_notas < 7.0;

-- Vantagem:
-- A View deixa a consulta pronta para reutilizacao. Assim, nao preciso
-- reescrever o JOIN, o GROUP BY e o AVG sempre que quiser consultar as medias.


-- QUESTAO 12 - Resumo financeiro por aluno
-- COALESCE considera valor_pago igual a zero quando o campo estiver NULL.
-- O saldo e calculado pela diferenca entre valor da parcela e valor pago.
CREATE OR REPLACE VIEW vw_resumo_financeiro_aluno AS
SELECT
    a.codigo_aluno,
    a.nome AS aluno,
    COUNT(me.numero_parcela) AS quantidade_parcelas,
    SUM(me.valor) AS valor_total_mensalidades,
    SUM(COALESCE(me.valor_pago, 0)) AS total_pago,
    SUM(me.valor - COALESCE(me.valor_pago, 0)) AS saldo_pendente
FROM aluno AS a
INNER JOIN matricula AS m
    ON m.codigo_aluno = a.codigo_aluno
INNER JOIN mensalidade AS me
    ON me.codigo_matricula = m.codigo_matricula
GROUP BY
    a.codigo_aluno,
    a.nome;

SELECT *
FROM vw_resumo_financeiro_aluno;

-- Identifica os alunos que ainda possuem saldo pendente.
SELECT *
FROM vw_resumo_financeiro_aluno
WHERE saldo_pendente > 0
ORDER BY aluno;


-- ============================================================================
-- PARTE 5 - MANIPULACAO E ADMINISTRACAO DE VIEWS
-- ============================================================================

-- QUESTAO 13 - Inspecao
-- Mostra as tabelas e Views do banco, filtrando para exibir somente Views.
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- Explicacao:
-- O comando lista as Views existentes no banco selecionado.


-- QUESTAO 14 - Estrutura da View
-- Mostra o comando usado para criar a View e suas configuracoes.
SHOW CREATE VIEW vw_alunos_ativos;

-- Explicacao:
-- O resultado apresenta a definicao SQL da View, incluindo o SELECT
-- utilizado e informacoes de configuracao.


-- QUESTAO 15 - Alteracao da View de alunos ativos
-- CREATE OR REPLACE substitui a definicao anterior e inclui o e-mail.
CREATE OR REPLACE VIEW vw_alunos_ativos AS
SELECT
    codigo_aluno,
    nome,
    telefone,
    email,
    cidade,
    estado
FROM aluno
WHERE situacao = 'Ativo';

-- Consulta para comprovar que o atributo email foi incluido.
SELECT *
FROM vw_alunos_ativos;


-- QUESTAO 16 - Criacao, consulta e exclusao de uma View de teste
CREATE OR REPLACE VIEW vw_teste_exclusao AS
SELECT
    codigo_aluno,
    nome
FROM aluno;

-- Primeiro, confirmo que a View pode ser consultada.
SELECT *
FROM vw_teste_exclusao;

-- DROP VIEW remove somente a View, nao apaga os dados da tabela aluno.
DROP VIEW vw_teste_exclusao;

-- Esta consulta deve apresentar erro porque a View foi removida.
-- Execute separadamente para observar o erro esperado.
-- SELECT * FROM vw_teste_exclusao;


-- ============================================================================
-- PARTE 6 - VIEWS E SEGURANCA
-- ============================================================================

-- QUESTAO 17 - Dados publicos dos alunos
-- Disponibiliza apenas dados basicos para consulta academica.
-- Dados como CPF, RG, endereco completo, telefone e e-mail foram omitidos
-- por nao serem necessarios para essa finalidade.
CREATE OR REPLACE VIEW vw_alunos_consulta_publica AS
SELECT
    codigo_aluno,
    nome,
    cidade,
    estado,
    situacao
FROM aluno;

SELECT *
FROM vw_alunos_consulta_publica;


-- QUESTAO 18 - Dados financeiros restritos
-- A View apresenta somente os campos necessarios para acompanhar parcelas.
CREATE OR REPLACE VIEW vw_financeiro_restrito AS
SELECT
    a.nome AS aluno,
    me.numero_parcela,
    me.data_vencimento,
    me.data_pagamento,
    me.valor,
    me.valor_pago,
    me.situacao
FROM mensalidade AS me
INNER JOIN matricula AS m
    ON m.codigo_matricula = me.codigo_matricula
INNER JOIN aluno AS a
    ON a.codigo_aluno = m.codigo_aluno;

SELECT *
FROM vw_financeiro_restrito;

-- Exemplo de permissao de leitura para um usuario do setor financeiro.
-- Este comando e apenas um exemplo: o usuario precisa existir no MySQL.
-- Ajuste o nome e o host conforme a configuracao do seu servidor.
-- GRANT SELECT ON escola_cursos.vw_financeiro_restrito
-- TO 'usuario_financeiro'@'localhost';

-- Explicacao:
-- O administrador pode liberar SELECT na View sem liberar acesso direto
-- as tabelas originais. A View limita os campos que o usuario consegue ver.


-- ============================================================================
-- PARTE 7 - QUESTAO FINAL
-- ============================================================================

-- QUESTAO 19 - Analise
-- Uma consulta complexa precisa ter seus JOINs, filtros e agrupamentos
-- escritos novamente sempre que for utilizada.
--
-- Uma View salva a definicao dessa consulta no banco e permite reutiliza-la.
--
-- Vantagens:
-- 1. Reutilizacao: evita escrever a mesma consulta varias vezes.
-- 2. Organizacao: deixa consultas complexas mais simples de utilizar.
-- 3. Seguranca: permite disponibilizar somente os campos autorizados.
-- 4. Manutencao: centraliza a definicao da consulta.
--
-- Limitacao:
-- Uma View comum nao armazena o resultado. Ela consulta as tabelas de origem
-- quando e utilizada e pode ficar lenta se a consulta for muito complexa.
-- Algumas Views tambem possuem limitacoes para atualizacao dos dados.

-- ============================================================================
-- FIM DA ATIVIDADE
-- ============================================================================
