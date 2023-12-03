SELECT * FROM tb_processo;
-- TODO: Traduzir views para dialeto SQL SERVER
-- ================================================== SELECTS PARA OS PROCESSOS
-- Pra tabela web (INICIAL)
SELECT proc.*,
    serv.codigo
    FROM tb_processo AS proc
    JOIN tb_servidor AS serv 
    ON proc.fk_servidor = serv.id_servidor
    WHERE serv.codigo = 'SVJW32' 
    AND data_hora >= NOW() - INTERVAL 1 MINUTE
    ORDER BY proc.nome_proc;
-- Ambos o CODIGO do servidor e o ORDER BY serão parametros no MODELS

-- PARA TESTE
SELECT proc.*, serv.codigo
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
WHERE serv.codigo = 'SVJW32' ORDER BY nome_proc;

-- ===================================================== Pro gráfico
-- GRÁFICO INICIAL
SELECT proc.nome_proc AS nome, 
COUNT(proc.nome_proc) AS quantidade,
serv.codigo AS codigo
FROM tb_processo AS proc
JOIN tb_servidor AS serv
ON proc.fk_servidor = serv.id_servidor
WHERE codigo = 'SVJW32'
AND DATE_FORMAT(proc.data_hora, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d')
GROUP BY nome_proc,
codigo
ORDER BY quantidade DESC LIMIT 5;
-- A Data do select é um parametro no MODEL

-- ======================================================= Pras kpis
-- Maior consumidor de CPU
/*
CREATE OR REPLACE VIEW vw_maior_uso_cpu AS
SELECT 
    nome_proc AS nome_cpu,
    SUM(proc.uso_cpu) AS proc_total_cpu,
    proc.fk_servidor,
    ROW_NUMBER() OVER (PARTITION BY proc.fk_servidor ORDER BY SUM(proc.uso_cpu) DESC) AS rn
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
GROUP BY proc.fk_servidor, nome_cpu
ORDER BY proc.fk_servidor, proc_total_cpu DESC;

-- Maior consumidor de RAM
CREATE OR REPLACE VIEW vw_maior_uso_ram AS
SELECT 
    nome_proc AS nome_ram,
    SUM(uso_ram) AS proc_total_ram,
    proc.fk_servidor,
    ROW_NUMBER() OVER (PARTITION BY proc.fk_servidor ORDER BY SUM(uso_ram) DESC) AS rn
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
GROUP BY proc.fk_servidor, nome_ram
ORDER BY proc.fk_servidor, proc_total_ram DESC;

-- Uso total de CPU e RAM
CREATE OR REPLACE VIEW vw_uso_proc_atual AS
SELECT 
    SUM(proc.uso_cpu) AS uso_total_cpu,
    SUM(proc.uso_ram) AS uso_total_ram,
    proc.fk_servidor,
    serv.codigo,
    ROW_NUMBER() OVER (PARTITION BY proc.fk_servidor ORDER BY serv.codigo) AS rn
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
GROUP BY proc.fk_servidor, serv.codigo
ORDER BY proc.fk_servidor, rn;

CREATE OR REPLACE VIEW vw_proc_kpi AS
SELECT 
    uso_cpu.nome_cpu, 
    uso_cpu.proc_total_cpu,
    uso_ram.nome_ram, 
    uso_ram.proc_total_ram,
    uso_atual.*
FROM vw_maior_uso_cpu AS uso_cpu
JOIN vw_maior_uso_ram AS uso_ram ON uso_cpu.fk_servidor = uso_ram.fk_servidor AND uso_cpu.rn = uso_ram.rn
JOIN vw_uso_proc_atual AS uso_atual ON uso_cpu.fk_servidor = uso_atual.fk_servidor AND uso_cpu.rn = uso_atual.rn
JOIN tb_servidor AS serv ON uso_atual.fk_servidor = serv.id_servidor
WHERE uso_cpu.rn = 1;

SELECT * FROM vw_proc_kpi;

SELECT * FROM vw_proc_kpi WHERE codigo = 'SVJW32';
SELECT * FROM vw_proc_kpi WHERE codigo = 'B7WGPJ';
*/

-- =================================================== Com o horário em consideração
-- Maior consumidor de CPU atual
CREATE OR REPLACE VIEW vw_maior_uso_cpu AS
SELECT 
    nome_proc AS nome_cpu,
    SUM(proc.uso_cpu) AS proc_total_cpu,
    proc.fk_servidor,
    ROW_NUMBER() OVER (PARTITION BY proc.fk_servidor ORDER BY SUM(proc.uso_cpu) DESC) AS rn
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
WHERE proc.data_hora >= NOW() - INTERVAL 1 MINUTE
GROUP BY proc.fk_servidor, nome_cpu
ORDER BY proc.fk_servidor, proc_total_cpu DESC;

-- Maior consumidor de RAM atual
CREATE OR REPLACE VIEW vw_maior_uso_ram AS
SELECT 
    nome_proc AS nome_ram,
    SUM(uso_ram) AS proc_total_ram,
    proc.fk_servidor,
    ROW_NUMBER() OVER (PARTITION BY proc.fk_servidor ORDER BY SUM(uso_ram) DESC) AS rn
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
WHERE proc.data_hora >= NOW() - INTERVAL 1 MINUTE
GROUP BY proc.fk_servidor, nome_ram
ORDER BY proc.fk_servidor, proc_total_ram DESC;

-- Uso atual de CPU e RAM
CREATE OR REPLACE VIEW vw_uso_proc_atual AS
SELECT 
    SUM(proc.uso_cpu) AS uso_total_cpu,
    SUM(proc.uso_ram) AS uso_total_ram,
    proc.fk_servidor,
    serv.codigo,
    ROW_NUMBER() OVER (PARTITION BY proc.fk_servidor ORDER BY serv.codigo) AS rn,
    MAX(proc.data_hora) AS data_hora
FROM tb_processo AS proc
JOIN tb_servidor AS serv ON proc.fk_servidor = serv.id_servidor
WHERE proc.data_hora >= NOW() - INTERVAL 1 MINUTE
GROUP BY proc.fk_servidor, serv.codigo
ORDER BY proc.fk_servidor, rn;

CREATE OR REPLACE VIEW vw_proc_kpi AS
SELECT 
    uso_cpu.nome_cpu, 
    uso_cpu.proc_total_cpu,
    uso_ram.nome_ram, 
    uso_ram.proc_total_ram,
    uso_atual.*
FROM vw_maior_uso_cpu AS uso_cpu
JOIN vw_maior_uso_ram AS uso_ram ON uso_cpu.fk_servidor = uso_ram.fk_servidor AND uso_cpu.rn = uso_ram.rn
JOIN vw_uso_proc_atual AS uso_atual ON uso_cpu.fk_servidor = uso_atual.fk_servidor AND uso_cpu.rn = uso_atual.rn
JOIN tb_servidor AS serv ON uso_atual.fk_servidor = serv.id_servidor
WHERE uso_cpu.rn = 1
AND uso_atual.data_hora >= NOW() - INTERVAL 1 MINUTE;


SELECT * FROM vw_proc_kpi WHERE codigo = 'SVJW32';
SELECT * FROM vw_proc_kpi WHERE codigo = 'B7WGPJ';