SELECT * FROM tb_funcionario;

SELECT * FROM tb_funcionario WHERE nome IS NULL;

SELECT COUNT(*) AS qtd_nomes_nulos
FROM tb_funcionario
WHERE nome IS NULL;

SELECT COUNT(*) AS qtd_nomes_nulos
FROM tb_funcionario
WHERE nome IS NOT NULL;

SELECT funcao, COUNT(*) AS qtd
FROM tb_funcionario
GROUP BY funcao
ORDER BY qtd DESC

