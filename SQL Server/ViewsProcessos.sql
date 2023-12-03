USE StockSafe;

INSERT INTO tb_processo (pid_proc, nome_proc, uso_cpu, uso_ram, uso_bytes_mb, uso_memoria_virtual_mb, fk_servidor)
VALUES 
    (101, 'Processo A', 15.2, 2048, 512.5, 1024.75, 1),
    (102, 'Processo B', 25.5, 4096, 1024.5, 2048.75, 2),
    (103, 'Processo C', 18.8, 3072, 768.2, 1536.4, 1),
    (104, 'Processo D', 22.3, 6144, 1536.9, 3072.3, 2);

DELETE FROM tb_processo 
WHERE pid_proc IN (101, 102, 103, 104);
 
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



