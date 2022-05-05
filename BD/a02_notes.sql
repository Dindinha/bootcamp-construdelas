/* PARTE 2: Criando uma database nova */
CREATE DATABASE BikeStores;

/* Importando 'create objects.sql' e 'load data.sql' */
	/*
		File > Open > File...  [ou Ctrl + O];
		Seleciona na pasta;
		Seleciona todos os scrips to arquivo e executa;
	*/


/* Removendo tabelas 'drop all objects.sql' */



/* Concatenando informa��es da tabela sales.customers */
SELECT CONCAT('Nome: ', first_name, ' ', last_name, ' | E-mail: ', email)
	FROM sales.customers;

/* Ordena��o de um ou mais campos */
SELECT * FROM sales.customers
	ORDER BY state, first_name DESC, last_name DESC;

/* Adicionando uma nova coluna teste */
ALTER TABLE production.brands
	ADD coluna_teste INT;

/* Adicionando o valor 5 a todos os itens da coluna */
UPDATE production.brands SET coluna_teste = 5;

/* Visualizando */
SELECT * FROM production.brands;

/* Excluindo a nova coluna teste */
ALTER TABLE production.brands
	DROP COLUMN coluna_teste;

/* Selecionando os 5 primeiros registros */
SELECT TOP 5 *
	FROM sales.customers
	WHERE state LIKE 'NY'
	ORDER BY first_name DESC;

/* Usando inner join */
SELECT	a.first_name, --mesmo que a declara��o do ALIAS 'a' esteja somente ali embaixo, ela pode ser usada antes
		a.last_name,
		b.order_date,
		b.shipped_date
	FROM sales.customers AS a
	INNER JOIN sales.orders AS b
	ON a.customer_id = b.customer_id
	WHERE b.shipped_date IS NOT NULL --somente quando o campo n�o for NULL
	ORDER BY a.first_name;

/* Trazendo os campos da production.products que n�o existam na tabela production.stocks */
SELECT a.*, b.*
	FROM production.products a
	LEFT JOIN production.stocks b ON a.product_id = b.product_id
	WHERE b.product_id IS NULL;

/* Desafio: trazer produtos e quantidade em estoque da tabela products (stocks e quantity), e a qual loja (stores) eles pertencem */
SELECT a.product_name, b.quantity, c.store_name
	FROM production.products a
	LEFT JOIN production.stocks b ON a.product_id = b.product_id
	LEFT JOIN sales.stores c on b.store_id = c.store_id;

/* Usando right join */
SELECT a.first_name, a.last_name, b.order_date, b.shipped_date
	FROM sales.customers a
	RIGHT JOIN sales.orders b ON a.customer_id = b.customer_id;

	/* O contr�rio � igual � left join */
	SELECT b.first_name, b.last_name, a.order_date
		FROM sales.orders a
		LEFT JOIN sales.customers b ON a.customer_id = b.customer_id;

/* Usando group by para agrupar cidades com o mesmo nome, e depois estados */
SELECT city, count(customer_id), state
	FROM sales.customers
	GROUP BY city, state
	ORDER BY city;

	/* Neste caso, priorizando o agrupamento de estados antes de cidades */
	SELECT state, city, count(customer_id)
		FROM sales.customers
		GROUP BY city, state;

/* Limitando group by com having (� parecido com where) */
SELECT city, COUNT(customer_id)
	FROM sales.customers
	GROUP BY city
	HAVING COUNT(customer_id) > 10
	ORDER BY city;

/* Usando condicional */
SELECT a.first_name, a.last_name, b.order_date,
	CASE
		WHEN b.shipped_date IS NULL THEN 'N�o enviado' ELSE 'Enviado'
	END --as 'Status de Envio'
	FROM sales.customers a
	LEFT JOIN sales.orders b ON a.customer_id = b.customer_id;

/* Usando a fun��es */
	/* soma */
	SELECT a.order_id, SUM(b.list_price * b.quantity)
		FROM sales.orders a
		INNER JOIN sales.order_items b ON a.order_id = b.order_id
		GROUP BY a.order_id;

		/* Contador */
		SELECT a.order_id, COUNT(b.item_id)
			FROM sales.orders a
			INNER JOIN sales.order_items b ON a.order_id = b.order_id
			GROUP BY a.order_id;

	/* m�dia */
	SELECT c.product_name, avg(estoque.quantity)
		FROM production.stocks estoque
		INNER JOIN production.products c ON c.product_id = estoque.product_id
		GROUP BY c.product_name;

	/* mai�sculas e min�sculas */
	SELECT
		UPPER(first_name) AS nome,
		LOWER(last_name) AS sobrenome
		FROM sales.customers;

	/* detectando pal�ndromo */
	SELECT UPPER(first_name) AS nome,
		REVERSE(UPPER(first_name)) AS nomereverso,
		CASE
			WHEN UPPER(first_name) = REVERSE(UPPER(first_name))
			THEN 'Pal�ndromo'
			ELSE 'N�o � pal�ndromo'
		END
		FROM sales.customers
		WHERE CASE
			WHEN UPPER(first_name) = REVERSE(UPPER(FIRST_NAME))
			THEN 'Pal�ndromo'
			ELSE 'N�o � Pal�ndromo'
			END = 'Pal�ndromo';


	/* TAREFA: */

/*
O que � SCHEMA: 
	� uma cole��o de objetos.

O que � COMMIT:
	Salva um conte�do da begin transaction.

O que � ROLLBACK: 
	Desfaz um conte�do da begin transaction.
*/




	/* ANOTA��ES */

/*
# Schema:
	nome_schema.nome_tabela
	
	Classifica as tabelas por categoria, separando por ponto (� como um nome composto para organizar).


# Ordenar um ou mais campos
	SELECT nome_coluna1, nome_coluna2, nome_coluna3
		FROM nome_tabela
		ORDER BY nome_coluna1;

		� Tipos de ordena��o:
			ASC (ascendente [default])
			DESC (descendente)

		Modelo:
		SELECT nome_coluna1, nome_coluna2, nome_coluna3
			FROM nome_tabela
			ORDER BY 1, 3 DESC;

		� � necess�rio informar na frente de cada coluna, ele n�o se aplica a todas.

	� Prioriza a ordem (ascendente ou descendente) conforme a sequ�ncia de colunas informadas.
	� � a ordem dos itens, e n�o a ordem que aparecem as colunas na exibi��o.


# Adicionar, excluir ou alterar nomes de colunas

	Adicionar colunas:
	ALTER TABLE nome_tabela
		ADD nome_novacoluna tipo constraint;

	ALTER TABLE nome tabela
		ADD nome_novacoluna1 INT,
			nome_novacoluna2 VARCHAR;

	Deletar coluna:
	ALTER TABLE nome_tabela
		DROP COLUMN nome_coluna;

	� Para n�o perder dados, ao atualizar uma coluna, fa�a uma c�pia dela por garantia.


# Selecionar os n primeiros na sa�da de dados
	SELECT TOP n FROM nome_tabela

	� Em outros bancos, o comando pode ser LIMIT, usado no final da query.


# Valores distintos
	SELECT DISTINCT nome_coluna FROM nome_tabela;

	� Por n�o ter repeti��es, pode acabar omitindo dados desejados.

	SELECT DISTINCT nome_coluna1, nome_coluna2 FROM nome_tabela;
	� Repete os nomes da coluna1 porque o distinct se aplica � linha toda como se estivesse concatenada.
	  Ent�o as somas das colunas1e2 s�o diferentes caso os valores de coluna1 forem iguais, mas os da coluna2 forem diferentes.


# Matches em comum entre duas tabelas

	## O INNER JOIN faz o match de cada linha da tabela1 com cada linha da tabela2, e s� traz os valores em comum entre ambas
	[ a [AB] b ] : Considere que o conte�do exibido s�o s� as mai�sculas.

	SELECT	nome_tabela1.nome_coluna1,
			nome_tabela2.nome_coluna2
		FROM nome_tabela1
		INNER JOIN nome_tabela2 AS nome_novatabela
		ON nome_tabela1.nome_coluna1 = nome_tabela2.nome_coluna2;


	## O LEFT JOIN faz o match de cada linha da tabela1 com cada linha da tabela2, e traz todos valores da tabela1 mais os valores em comum entre ambas as tabelas.
	[ A [AB] b ] : Considere que o conte�do exibido s�o s� as mai�sculas.

	SELECT	nome_tabela1.nome_coluna1,
			nome_tabela2.nome_coluna2
		FROM nome_tabela1
		LEFT JOIN nome_tabela2 AS nome_novatabela
		ON nome_tabela1.nome_coluna1 = nome_tabela2.nome_coluna2;

	## O RIGHT JOIN faz o mesmo que o Left Join, mas trazendo todo o conte�do da segunda tabela.
		[ a [AB] B ] : Considere que o conte�do exibido s�o s� as mai�sculas.


	## O CROSS JOIN trar� as linhas das duas tabelas como em um plano cartesiano
		� n�o funciona em todos os bancos de dados
		� cria possibilidades diferentes para cada campo (como em an�lise combinat�ria)
			� cada campo da tabela1 ser� recriado para cada campo da tabela2

			SELECT	nome_tabela1.nome_coluna1,
			nome_tabela2.nome_coluna2
		FROM nome_tabela1
		CROSS JOIN nome_tabela2;

		Exemplo: tabela1 [A, B, C] e tabela2 [1, 2]
			| A | 1 |
			| A | 2 |
			| B | 1 |
			| B | 2 |
			| C | 1 |
			| C | 2 |


# Agrupar registros com base em semelhan�as
	SELECT nome_coluna1
		FROM nome_tabela GROUP BY nome_coluna1;

	� Caso utilize ORDER BY, o agrupamento deve vir antes
	SELECT COUNT(nome_colunaX), nome_coluna2, nome_coluna3
		FROM nome_tabela
		GROUP BY nome_coluna2, nome_coluna3;

	� Normalmente � usado com Fun��es de agrega��o:
		COUNT()
		MIN()
		MAX()


# Especificar com HAVING condi��es de filtros dos grupos group by (� parecido com where)
	SELECT COUNT(nome_coluna) AS apelido, nome_coluna2, nome_coluna3
		FROM nome_tabela
		GROUP BY nome_coluna2, nome_coluna3
		HAVING apelido > n;


# Colocar uma condi��o com CASE
	SELECT
		CASE
			WHEN condi��o1 THEN resultado1
			WHEN condi��o2 THEN resultado2
			ELSE resultado
		END
		FROM nome_tabela;


# Fun��es
	� CONCAT() - Concatena duas colunas ou strings
	� DATEDIFF() - Calcula a diferen�a entre duas datas
	� LEN(texto) - Retorna o tamanho de uma string
	� LOWER(texto) - Converte uma string para min�sculo 
	� UPPER(text) - Converte uma string para mai�sculo
	� SUBSTRING(texto, indexinicial, indexfinal) - Recorta um texto dentro de um texto 
	� REPLACE(texto, valor1, valor2) - Substitui valor1 com valor2 dentro de texto
	� REPLICATE(texto, numerodevezes) - Replica um texto N vezes
	� REVERSE(texto) - Escreve um texto ao contr�rio
	� TRIM(texto) - Remove espa�os de um texto
	� AVG(valor) - Retorna a m�dia (desconsidera os NULL, podendo afetar a m�dia)
	� MAX(valor) - Retorna o valor m�ximo
	� MIN(valor) - Retorna o valor m�nimo
	� SUM(valor) - Retorna a soma
	� DATEADD(intervalo, valor, dia) - Retorna uma data adicionada de valor de acordo com o intervalo
	� ISDATE(data) - Valida se um valor � uma data
	� CAST(valor) - Converte um valor de um tipo para um tipo espec�fico
	� ISNULL(express�o,valor) - Se a express�o for nula, ent�o valor � retornado
*/