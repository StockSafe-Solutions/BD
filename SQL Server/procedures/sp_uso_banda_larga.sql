-- USO DE BANDA LARGA TOTAL
IF OBJECT_ID('sp_uso_banda_larga', 'P') IS NOT NULL
    DROP PROCEDURE sp_uso_banda_larga;
GO

CREATE PROCEDURE sp_uso_banda_larga
AS
BEGIN
    DECLARE @limite INT;

    SELECT @limite = COUNT(id_servidor) FROM tb_servidor;

    IF OBJECT_ID('tempdb..#banda_larga') IS NOT NULL
        DROP TABLE #banda_larga;

    CREATE TABLE #banda_larga (
        uso_banda_larga DECIMAL(10, 2)
    );

    INSERT INTO #banda_larga
    SELECT TOP (@limite) ROUND(SUM(taxa_de_transferencia), 2) AS uso_banda_larga
    FROM vw_taxa_de_transferencia
    GROUP BY fk_servidor
    ORDER BY SUM(taxa_de_transferencia) DESC

    SELECT * FROM #banda_larga;
END;
