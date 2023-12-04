DROP TRIGGER IF EXISTS tr_alerta;

DELIMITER $
CREATE TRIGGER tr_alerta
	AFTER INSERT ON tb_registro
    FOR EACH ROW 
    BEGIN
		SET @codigo_servidor = (SELECT codigo FROM tb_servidor WHERE id_servidor = NEW.fk_servidor);
        SET @taxa_transf = (SELECT taxa_transferencia FROM tb_opcao LIMIT 1);
        SET @nivel = 0;
    
		-- CPU
		IF NEW.uso_cpu >= 80 OR NEW.uso_cpu <= 30 THEN
			SET @nivel = 1;
				IF NEW.uso_cpu >= 80 THEN
					SET @nivel = 2;
					IF NEW.uso_cpu >= 90 THEN
						SET @nivel = 3;
                    END IF;
				END IF; 
                IF NEW.uso_cpu <= 30 THEN
					SET @nivel = 1;
                     IF NEW.uso_cpu <= 20 THEN
						SET @nivel = 0;
                    END IF;
				END IF; 
                
			INSERT INTO tb_alerta VALUE (null,default,@nivel,0,CONCAT("CPU do servidor ",@codigo_servidor," em ",round(NEW.uso_cpu),"%"),NEW.fk_servidor);
        END IF;
        
        -- RAM
        IF NEW.uso_ram >= 80 OR NEW.uso_ram <= 30 THEN
			SET @nivel = 1;
				IF NEW.uso_ram >= 80 THEN
					SET @nivel = 2;
					IF NEW.uso_ram >= 90 THEN
						SET @nivel = 3;
                    END IF;
				END IF; 
                IF NEW.uso_ram <= 30 THEN
					SET @nivel = 1;
                     IF NEW.uso_ram <= 20 THEN
						SET @nivel = 0;
                    END IF;
				END IF; 
                
			INSERT INTO tb_alerta VALUE (null,default,@nivel,0,CONCAT("RAM do servidor ",@codigo_servidor," em ",round(NEW.uso_ram),"%"),NEW.fk_servidor);
        END IF;
        
        -- Taxa de transferência
        IF (NEW.taxa_transferencia*100)/@taxa_transf <= 90 THEN
			IF (NEW.taxa_transferencia*100)/@taxa_transf <= 80 THEN
				SET @nivel = 1;
                ELSE
					SET @nivel = 0;
			END IF;
            
			INSERT INTO tb_alerta VALUE (null,default,@nivel,0,CONCAT("Taxa de transferência do servidor ",@codigo_servidor," em ",
				(NEW.taxa_transferencia*100)/@taxa_transf
                ,"%"),NEW.fk_servidor);
        END IF;
	END $
DELIMITER ;

TRUNCATE tb_alerta;
INSERT INTO tb_registro VALUES (null, 2000, now(), 204, 95, 95, 500);
INSERT INTO tb_registro VALUES (null, 2000, now(), 204, 80, 80, 450);
INSERT INTO tb_registro VALUES (null, 2000, now(), 204, 56, 80, 400);
INSERT INTO tb_registro VALUES (null, 2000, now(), 204, 24, 80, 350);
INSERT INTO tb_registro VALUES (null, 2000, now(), 204, 3, 80, 300);

SELECT * FROM tb_alerta ORDER BY data_hora DESC;