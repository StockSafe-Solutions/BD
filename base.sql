-- VISUALIZAÇÃO DOS REGISTROS DE FORMA DINÂMICA
SET @sql = NULL; -- Criando uma variável para armazenar o comando
SELECT
    GROUP_CONCAT(DISTINCT CONCAT('max(case when tipo_cat = \'',
                tipo_cat,
                '\' then media end) \'',
                tipo_cat,'\'')) -- Listando todas as colunas e criando um case para cada uma
INTO @sql FROM vw_base_registros; -- Aqui vem o nome da sua view!
select @sql;

SET @sql = CONCAT('
CREATE OR REPLACE VIEW vw_servidor AS
SELECT fk_servidor, data_hora, ', @sql, '
FROM vw_base_registros
GROUP BY fk_servidor, data_hora'); -- Lembra de trocar as informações (idServidor, MomentoRegistro, tabelaRegistros) pelos nomes que você usou na view
select @sql;
PREPARE registros FROM @sql; -- Prepara um statement para executar o comando guardado na variável @sql
EXECUTE registros; -- Executa o statement

SELECT * FROM vw_servidor;