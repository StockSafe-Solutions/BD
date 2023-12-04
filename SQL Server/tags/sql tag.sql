USE StockSafe;
GO

CREATE OR ALTER VIEW vw_tag_mais_servidores AS
SELECT TOP 1
nome_tag,
cor_tag,
count(fk_tag) AS qtd_servidores
FROM 
	tb_tag AS t
    JOIN tb_tag_servidor AS ts on t.id_tag = ts.fk_tag
GROUP BY id_tag, nome_tag, cor_tag
ORDER BY (qtd_servidores) DESC;
GO;

CREATE OR ALTER VIEW vw_tag_menos_servidores AS
SELECT TOP 1
id_tag,
nome_tag,
cor_tag,
count(fk_tag) AS qtd_servidores
FROM 
	tb_tag AS t
    JOIN tb_tag_servidor AS ts on t.id_tag = ts.fk_tag
GROUP BY id_tag, nome_tag, cor_tag
ORDER BY (qtd_servidores);
GO;

CREATE OR ALTER VIEW vw_tag_maior_consumo AS
SELECT TOP 1
id_tag,
nome_tag,
cor_tag,
ROUND(AVG(uso_da_cpu+uso_da_ram)/2,2) AS media_total
FROM vw_registro AS v
JOIN tb_tag_servidor AS ts ON v.fk_servidor = ts.fk_servidor
JOIN tb_tag AS t ON t.id_tag = ts.fk_tag
GROUP BY id_tag, nome_tag, cor_tag
ORDER BY media_total DESC;
GO;

CREATE OR ALTER VIEW vw_tag_mais_erros AS
SELECT TOP 1
id_tag,
nome_tag,
cor_tag,
COUNT(a.id_alerta) AS quantidade_erros
FROM tb_tag AS t
JOIN tb_tag_servidor AS ts ON t.id_tag = ts.fk_tag
JOIN tb_alerta AS a ON a.fk_servidor = ts.fk_servidor
GROUP BY id_tag, nome_tag, cor_tag
ORDER BY quantidade_erros DESC;
GO;

CREATE OR ALTER VIEW vw_kpis_tags AS
SELECT
maS.nome_tag as tag_mais_servidores,
maS.qtd_servidores as qtd_mais_servidores,
maS.cor_tag as cor_mais_servidores,
--
meS.nome_tag as tag_menos_servidores,
meS.qtd_servidores as qtd_menos_servidores,
meS.cor_tag as cor_menos_servidores,
--
mc.nome_tag as tag_maior_consumo,
mc.media_total as qtd_maior_consumo,
mc.cor_tag as cor_maior_consumo,
--
me.nome_tag as tag_mais_erros,
me.quantidade_erros as qtd_mais_erros,
me.cor_tag as cor_mais_erros
FROM
vw_tag_mais_servidores AS maS,
vw_tag_menos_servidores AS meS,
vw_tag_maior_consumo AS mc,
vw_tag_mais_erros AS me;
GO;

select
data_hora,
round(avg (uso_da_cpu),1) as uso_da_cpu,
round(avg (uso_da_ram),1) as uso_da_ram
from vw_registro as r
join tb_tag_servidor as ts on r.fk_servidor = ts.fk_servidor
join tb_tag as t on ts.fk_tag = t.id_tag
where id_tag = 1
group by data_hora;

SELECT
		avg(taxt.taxa_de_transferencia) AS kpi_taxa,
		(select taxa_de_transferencia from tb_opcao) AS base_taxa,
		sum(pct.pacotes_enviados) AS kpi_pacotes_enviados,
		sum((armazenamento_usado * 100) / armazenamento_total) AS kpi_armazenamento,
		sum(armazenamento_total) AS base_armazenamento
		FROM tb_servidor
			JOIN vw_taxa_de_transferencia AS taxt ON taxt.fk_servidor = id_servidor
			JOIN vw_pacotes_enviados AS pct ON pct.fk_servidor = id_servidor
            JOIN tb_tag_servidor AS ts ON ts.fk_servidor = id_servidor
            JOIN tb_tag AS t ON t.id_tag = ts.fk_tag
			WHERE id_tag = 1 OR id_tag = 2
            GROUP BY DAY(pct.data_hora);
GO

CREATE OR ALTER VIEW vw_historico_tags AS
SELECT
t.nome_tag,
a.data_hora,
a.nivel_alerta,
a.descricao,
s.codigo AS 'codigo_servidor'
FROM tb_alerta AS a
JOIN tb_servidor AS s ON a.fk_servidor = s.id_servidor
JOIN tb_tag_servidor AS ts ON s.id_servidor = ts.fk_servidor
JOIN tb_tag AS t ON t.id_tag = ts.fk_tag
WHERE
	a.data_hora >= DATEADD(day,-30,GETDATE()) 
	AND a.data_hora <= getdate();