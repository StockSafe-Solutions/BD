CREATE VIEW vw_cpu AS
	SELECT fk_servidor, uso_cpu FROM tb_registro
		WHERE uso_cpu IS NOT NULL;

CREATE VIEW vw_media_pacotes_semana AS
	SELECT fk_servidor,round(AVG(pacotes_enviados)) FROM tb_registro 
		WHERE (pacotes_enviados IS NOT NULL) AND (data_hora > date_sub(curdate(), INTERVAL 7 DAY))
		GROUP BY fk_servidor;

/* Explicação: conta os registros através do data_hora, divide por 4 (atualmente existem CPU,RAM,PACOTES,
TAXA DE TRANSF; isso evita os registros NULL). Então, tira a porcentagem disso de 5
(5 horários: 10:00, 12:00, 14:00, 16:00 e 18:00)
*/
CREATE VIEW vw_uptime AS
	SELECT DATE(data_hora) as dia, fk_servidor, round(((COUNT(data_hora)/4)*100)/5) as uptime
		FROM tb_registro
		GROUP BY fk_servidor, DATE(data_hora);
    
CREATE VIEW vw_servidor AS
	SELECT 
	s.*,
	DATE_FORMAT(d.data_hora,"%d/%m/%Y") as ultimaData,
	DATE_FORMAT(d.data_hora,"%H:%i") as ultimoHorario
		FROM tb_servidor AS s
		LEFT JOIN(SELECT fk_servidor, max(data_hora) as data_hora 
					FROM tb_registro GROUP BY fk_servidor) AS d
			ON s.id_servidor = d.fk_servidor;