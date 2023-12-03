USE StockSafe;

-- Para testes
INSERT INTO tb_processo (pid_proc, nome_proc, uso_cpu, uso_ram, uso_bytes_mb, uso_memoria_virtual_mb, fk_servidor)
VALUES 
    (101, 'Processo A', 15.2, 20.48, 512.5, 1024.75, 1),
    (102, 'Processo B', 25.5, 40.96, 1024.5, 2048.75, 2),
    (103, 'Processo C', 18.8, 30.72, 768.2, 1536.4, 1),
    (104, 'Processo D', 22.3, 61.44, 1536.9, 3072.3, 2);

/*
DELETE FROM tb_processo 
WHERE pid_proc IN (101, 102, 103, 104);
*/

SELECT p.*, 
s.codigo
FROM tb_processo AS p
JOIN tb_servidor AS s
ON p.fk_servidor = s.id_servidor;
GO
-- SELECT para tabela web
/*
SELECT p.*,
s.codigo
FROM tb_processo AS p
JOIN tb_servidor AS s 
ON p.fk_servidor = s.id_servidor
WHERE s.codigo = 'SVJW32' 
    AND p.data_hora >= DATEADD(MINUTE, -1, GETDATE())
ORDER BY p.nome_proc;
*/

-- SELECT para o gráfico
/*
SELECT TOP 5 p.nome_proc AS nome,
              COUNT(p.nome_proc) AS quantidade,
              s.codigo AS codigo
FROM tb_processo AS p
JOIN tb_servidor AS s ON p.fk_servidor = s.id_servidor
WHERE s.codigo = 'SVJW32'
      AND CAST(p.data_hora AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY p.nome_proc, s.codigo
ORDER BY quantidade DESC;
*/

-- Views para as KPIS
CREATE OR ALTER VIEW vw_total_cpu AS
SELECT SUM(uso_cpu) AS uso_total_cpu
FROM tb_processo
WHERE data_hora >= DATEADD(MINUTE, -1, GETDATE());

GO

CREATE OR ALTER VIEW vw_total_ram AS
SELECT SUM(uso_ram) AS uso_total_ram
FROM tb_processo
WHERE data_hora >= DATEADD(MINUTE, -1, GETDATE());

GO

CREATE OR ALTER VIEW vw_max_cpu AS
SELECT TOP 1 nome_proc AS nome_cpu, uso_cpu AS proc_total_cpu
FROM tb_processo
WHERE data_hora >= DATEADD(MINUTE, -1, GETDATE())
ORDER BY uso_cpu DESC;

GO

CREATE OR ALTER VIEW vw_max_ram AS
SELECT TOP 1 nome_proc AS nome_ram, uso_ram AS proc_total_ram
FROM tb_processo
WHERE data_hora >= DATEADD(MINUTE, -1, GETDATE())
ORDER BY uso_ram DESC;

GO

CREATE OR ALTER VIEW vw_proc_kpi AS
SELECT 
    cpu.uso_total_cpu,
    ram.uso_total_ram,
    max_cpu.nome_cpu,
    max_cpu.proc_total_cpu,
    max_ram.nome_ram,
    max_ram.proc_total_ram,
    s.codigo
FROM vw_total_cpu cpu
CROSS JOIN vw_total_ram ram
CROSS JOIN vw_max_cpu max_cpu
CROSS JOIN vw_max_ram max_ram
CROSS JOIN tb_servidor s
WHERE s.id_servidor IN (SELECT DISTINCT fk_servidor FROM tb_processo WHERE data_hora >= DATEADD(MINUTE, -1, GETDATE()));

GO

SELECT * FROM vw_proc_kpi WHERE codigo = 'SVJW32';


