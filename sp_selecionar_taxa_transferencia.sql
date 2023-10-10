USE StockSafe;

DROP PROCEDURE IF EXISTS sp_selecionar_taxa_transferencia;
delimiter //
CREATE PROCEDURE sp_selecionar_taxa_transferencia (IN servidor_selecionado INT(11))
	BEGIN
		SELECT fk_servidor, taxa_transferencia FROM tb_registro
        WHERE fk_servidor = servidor_selecionado AND taxa_transferencia IS NOT NULL;
	END  
// delimiter ;