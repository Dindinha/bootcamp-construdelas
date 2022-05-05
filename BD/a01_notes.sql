/* Cria um novo arquivo .sql no SQL Server
	Clique no bot�o "New Query";
*/


/* Cria uma nova database */
CREATE DATABASE escola;

/* Entra na nova database criada */
USE escola;

/* Cria nova tabela "turmas" */
CREATE TABLE turmas (
	id_turma INT IDENTITY (1,1) PRIMARY KEY, --(1, 1) � o valor de incremento. Se for (1, 2), ele vai somar de 2 em 2, come�ando por 1.
	nome_turma VARCHAR(50)
);

/* Cria nova tabela "alunos */
CREATE TABLE alunos (
	id_aluno INT IDENTITY (1,1) PRIMARY KEY,
	nome_aluno VARCHAR(50) NOT NULL, --not null s�o campos obrigat�rios
	sobrenome_aluno VARCHAR(100) NOT NULL,
	data_nascimento DATE,
	data_matricula DATETIME,

	id_turma INT NOT NULL, --mesmo nome que a primary key da outra tabela a quem vai ser vinculada
	FOREIGN KEY (id_turma) --vincula � primary key da outra tabela
	REFERENCES turmas (id_turma) --indica a qual tabela pertence a primary key (primary key)

	/* ON DELETE NO ACTION */
);

/* Insere informa��es na tabela */
INSERT INTO turmas (nome_turma) VALUES ('Turma de .NET');

INSERT INTO alunos (nome_aluno, sobrenome_aluno, data_nascimento, data_matricula, id_turma) VALUES --n�o adicionar id_aluno, pois � identity, completa sozinho com auto incremento
	('Ingrid', 'Wagner', '1990-05-05', '2022-04-28 10:29:37', 1),
	('Fulano', 'da Silva', '1990-01-05', '2022-04-28 10:31:48', 1),
	('Ciclano', 'Sauro', '1992-09-28', '2022-04-28 10:33:14', 1);

/* Exibe idade e nome completo */
SELECT
	DATEDIFF (YEAR, data_nascimento, SYSDATETIME()) AS idade,
	CONCAT (nome_aluno, ' ', sobrenome_aluno) AS nome_completo
	FROM alunos;

/* Seleciona o nome e sobre nome dos alunos com 18 anos ou mais */
SELECT nome_aluno, sobrenome_aluno,
	DATEDIFF(YEAR, data_nascimento, SySDATETIME()) AS idade FROM alunos
	WHERE DATEDIFF(YEAR, data_nascimento, SYSDATETIME()) >= 18;

/* Inserindo uma nova turma na tabela 'turmas' */
INSERT INTO turmas(nome_turma) VALUES ('Turma de Python');

/* Seleciona todos de 'turmas' */
SELECT * FROM turmas;

/* Seleciona todos de 'alunos' */
SELECT * FROM alunos;

/* Atualiza o aluno com id_aluno 2 para a Python (que possui id_turma 2)*/
UPDATE alunos SET id_turma = 2 WHERE id_aluno = 2;

/* Seleciona o nome e sobre nome dos alunos com 18 anos ou mais que sejam da turma de Python (id_turma 2) */
SELECT nome_aluno, sobrenome_aluno,
	DATEDIFF(YEAR, data_nascimento, SySDATETIME()) AS idade FROM alunos
	WHERE DATEDIFF(YEAR, data_nascimento, SYSDATETIME()) >= 18 AND id_turma = 2;

/* SETA (coloca) o nome do aluno de Ciclanildo no aluno com nome Ciclano */
UPDATE alunos
	SET nome_aluno = 'Ciclanildo'
	WHERE nome_aluno like 'ciclano';

/* Deleta o aluno Ciclanildo */
DELETE FROM alunos WHERE nome_aluno LIKE 'ciclanildo';

/* Insere o aluno Ciclano na tabela alunos */
INSERT INTO alunos (nome_aluno, sobrenome_aluno, data_nascimento, data_matricula, id_turma) VALUES
	('Ciclano', 'Sauro', '1992-09-28', '2022-04-28 10:33:14', 2); --Agora ele � inserido com o id_aluno seguinte



	/* ANOTA��ES */

/*
# Tipos:
	Texto: VARCHAR, CHAR (value deve estar entre aspas simples)
	Datas: DATE, DATETIME (value deve estar entre aspas simples)
	Bin�rio: VARBINARY
	Num�ricos: INT, DECIMAL, NUMERIC, BIT


# Criar database
	CREATE DATABASE nome_do_banco;


# Entrar em uma database espec�fica (funciona como branches)
	USE nome_do_banco;


# Criar tabela
	CREATE TABLE nome_da_tabela (
		primeiro_campo INT IDENTITY (1,1) PRIMARY KEY,
		segundo_campo VARCHAR(200) NOT NULL,
		terceiro_campo VARCHAR(10),
		quarto_campo DATETIME,
		quinto_campo INT,
		FOREIGN KEY (quinto_campo)
		REFERENCES nome_tabela (campo)
	);


# Exibir informa��es da tabela:
	EXEC SP_HELP 'nome_tabela';


# Excluir tabelas:
	DROP TABLE nome_tabela;


# Inserir dados 
	INSERT INTO nome_tabela VALUES (valor1, valor2, valorN);
		- Sendo N o n�mero de colunas

			ou

	INSERT INTO  nome_tabela (nome_coluna1, nome_coluna2, nome_coluna3) VALUES
		(valor1, 'valor2', null),
		(valor1, 'valor2', valor3),
		(valor1, 'valor2', valor3);

	- Campos VARCHAR, DATETIME e DATE devem estar entre aspas simples
		- Formatos:
		--> Date: 'AAAA-MM-DD'
		--> Datetime: 'AAAA-MM-DD HH:MM:SS'


# Selecionar colunas
	- Coluna espec�fica:
		SELECT nome_coluna FROM nome_tabela;

	- Todas as colunas:
		SELECT * FROM nome_tabela;


# Exibir duas colunas concatenadas
	SELECT CONCAT (nome_coluna1, ' ', nome_coluna2) AS novo_nome FROM nome_tabela;

	- Necess�rio adicionar um ' ' (espa�o) para separar os dois campos
	- AS significa ALIAS, que d� um apelido ao novo conte�do concatenado


# Calcular um per�odo de tempo entre uma data e outra
	SELECT DATEDIFF (datepart, datainicio, datafim) FROM nome_tabela;

	Exemplo:
		SELECT DATEDIFF (YEAR, data_nascimento, SYSDATETIME()) AS novo_nome FROM nome_tabela;


# Deletar tudo de uma tabela
	truncate TABLE nome_tabela;


# Modificar coluna de uma tabela
	alter TABLE nome_tabela change nome_coluna
		nome_coluna INT NOT NULL AUTO_INCREMENT, 
		add PRIMARY KEY ('id');


# Buscar na tabela
	SELECT nome_coluna1 FROM nome_tabela
	where nome_coluna2 = 'Valor1';

	- � case sensitive
	- Procura pelo conte�do inteiro

	- Para que a busca contenha trechos:
		SELECT * FROM nome_tabela
		WHERE nome_coluna LIKE '%trecho%';

		- Varia��es:
			'x%': Procura algo que come�a com x.
			'%x': Procura algo que termina com x.
			'%x%': Procura algo que contenha x.


# Filtrar os registros com where
	SELECT * FROM nome_coluna1 WHERE nome_coluna2 = n;

	Combina��es:
	SELECT nome_coluna1, nome_coluna2 WHERE nome_coluna3 = n;
	SELECT nome_coluna1, nome_coluna2 WHERE nome_coluna3 = n1 OR nome_colunan2;


# Operadores
	= (Igual a)	Igual a
	> (Maior que)	Maior que
	< (Menor que)	Menor que
	>= (Maior ou igual a)	Maior ou igual a
	<= (Menor ou igual a)	Menor que ou igual a
	<> (Diferente de)	� diferente de
	!= (Diferente de)	Diferente de (n�o � padr�o ISO)
	!< (N�o � menor que)	N�o � menor que (n�o � padr�o ISO)
	!> (N�o � maior que)	N�o � maior que (n�o � padr�o ISO)

	ALL			TRUE se tudo em um conjunto de compara��es for TRUE.
	AND			TRUE se as duas express�es boolianas forem TRUE.
	QUALQUER	TRUE se qualquer conjunto de compara��es for TRUE.
	BETWEEN		TRUE se o operando estiver dentro de um intervalo.
	EXISTS		TRUE se uma subconsulta tiver qualquer linha.
	IN			TRUE se o operando for igual a um de uma lista de express�es.
	LIKE		TRUE se o operando corresponder a um padr�o.
	NOT			Inverte o valor de qualquer outro operador booliano.
	OR			TRUE se qualquer express�o booliana for TRUE.
	SOME		TRUE se algum conjunto de compara��es for TRUE.


# Atualizar dados
	UPDATE nome_tabela
		SET nome_coluna = valor;

	Combina��es:
	UPDATE nome_tabela
		SET nome_coluna1 = valor1;
		WHERE nome_coluna2 = valor2;

	UPDATE nome_tabela
		SET nome_coluna1 = valor1;
		WHERE nome_coluna2 LIKE 'valor2'; --LIKE procura similares, n�o sendo case sensitive, comum com campos de texto


# Deletar dado buscado com where
	DELETE FROM nome_tabela
	WHERE nome_coluna LIKE '%trecho%';
*/
