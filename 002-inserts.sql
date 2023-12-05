USE StockSafe;

-- LISTA DE INSERTS
  
INSERT INTO tb_funcionario VALUES (1, 'Danilo Marques', 'Analista', '2005-07-11', null, 'danilo@b3.com', 'urubu100');
INSERT INTO tb_funcionario VALUES (2,'Gustavo Pereira','Analista','2005-06-13',null,'gustavo@b3.com','urubu100');
INSERT INTO tb_funcionario VALUES (3,'Gabriel Bazante','Gerente de infraestrutura','2005-06-13',null,'gabriel@b3.com','urubu100');
INSERT INTO tb_funcionario VALUES (4,'Stephany Justino','Gerente de operações','2005-06-13',null,'stephany@b3.com','urubu100');
INSERT INTO tb_funcionario VALUES (5,'Rafael Rocha','COO','2005-06-13',null,'rafael@b3.com','urubu100');

INSERT INTO tb_servidor (codigo, armazenamento_total, armazenamento_usado, id_autenticador) VALUES
		('SVJW32', 500.5, 250.2, 1),
		('B7WGPJ', 750.0, 375.5, 1),
        ('RQ8Q28', 300.3, 150.1, 1),
        ('Y5WR5Y', 900.0, 500.0, NULL),
        ('TCUHVQ', 800.8, 400.4, NULL),
        ('17P51N', 600.6, 300.3, NULL);

INSERT INTO tb_categoria VALUES
		(1, "Pacotes enviados", null),
		(2, "Uso da CPU", "%"),
		(3, "Uso da RAM", "%"),
		(4, "Taxa de transferência", "MB/s"),
		(5, 'Total da RAM', 'GB'),
        (6, 'Uso disponivel da RAM', '%');

select * from tb_servidor;

INSERT INTO tb_registro (fk_servidor, fk_cat, data_hora, valor)
	VALUES
	(1, 5, '2023-11-29 19:59:59', 123),
	(2, 5, '2023-11-29 20:00:00', 456),
	(3, 5, '2023-11-29 20:00:01', 789),
	(1, 5, '2023-11-29 20:00:02', 234),
	(2, 5, '2023-11-29 20:00:03', 567),
	(3, 5, '2023-11-29 20:00:04', 890),
	(4, 6, '2023-11-29 20:00:05', 120),
	(5, 6, '2023-11-29 20:00:06', 341),
	(6, 6, '2023-11-29 20:00:07', 672),
	(1, 6, '2023-11-29 20:00:08', 993),
	(1, 6, '2023-11-29 20:00:09', 214),
	(2, 6, '2023-11-29 20:00:10', 455),
	(3, 6, '2023-11-29 20:00:11', 786);

	INSERT INTO tb_registro (fk_servidor, fk_cat, data_hora, valor)
	VALUES 
	  (1, 1, '2023-10-23 10:00:00', 204),
	  (1, 2, '2023-10-23 10:00:00', 23),
	  (1, 3, '2023-10-23 10:00:00', 34),
	  (1, 4, '2023-10-23 10:00:00', 499),
	  (1, 1, '2023-10-23 12:00:00', 84),
	  (1, 2, '2023-10-23 12:00:00', 5),
	  (1, 3, '2023-10-23 12:00:00', 21),
	  (1, 4, '2023-10-23 12:00:00', 487),
	  (1, 1, '2023-10-23 14:00:00', 402),
	  (1, 2, '2023-10-23 14:00:00', 67),
	  (1, 3, '2023-10-23 14:00:00', 58),
	  (1, 4, '2023-10-23 14:00:00', 439),
	  (1, 1, '2023-10-23 16:00:00', 694),
	  (1, 2, '2023-10-23 16:00:00', 72),
	  (1, 3, '2023-10-23 16:00:00', 85),
	  (1, 4, '2023-10-23 16:00:00', 402),
	  (1, 1, '2023-10-23 18:00:00', 1230),
	  (1, 2, '2023-10-23 18:00:00', 98),
	  (1, 3, '2023-10-23 18:00:00', 99),
	  (1, 4, '2023-10-23 18:00:00', 489);

	INSERT INTO tb_registro (fk_servidor, fk_cat, data_hora, valor)
	VALUES 
	  (2, 1, '2023-10-23 10:00:00', 309),
	  (2, 2, '2023-10-23 10:00:00', 45),
	  (2, 3, '2023-10-23 10:00:00', 42),
	  (2, 1, '2023-10-23 12:00:00', 102),
	  (2, 2, '2023-10-23 12:00:00', 18),
	  (2, 3, '2023-10-23 12:00:00', 21),
	  (2, 1, '2023-10-23 14:00:00', 494),
	  (2, 2, '2023-10-23 14:00:00', 56),
	  (2, 3, '2023-10-23 14:00:00', 48),
	  (2, 1, '2023-10-23 16:00:00', 853),
	  (2, 2, '2023-10-23 16:00:00', 89),
	  (2, 3, '2023-10-23 16:00:00', 78),
	  (2, 1, '2023-10-23 18:00:00', 940),
	  (2, 2, '2023-10-23 18:00:00', 94),
	  (2, 3, '2023-10-23 18:00:00', 87);


	INSERT INTO tb_registro (fk_servidor, fk_cat, data_hora, valor)
	VALUES 
	  (3, 2, '2023-10-23 10:00:00', 28),
	  (3, 3, '2023-10-23 10:00:00', 39),
	  (3, 4, '2023-10-23 10:00:00', 498),
	  (3, 2, '2023-10-23 12:00:00', 14),
	  (3, 3, '2023-10-23 12:00:00', 19),
	  (3, 4, '2023-10-23 12:00:00', 499),
	  (3, 2, '2023-10-23 14:00:00', 59),
	  (3, 3, '2023-10-23 14:00:00', 78),
	  (3, 4, '2023-10-23 14:00:00', 464),
	  (3, 2, '2023-10-23 16:00:00', 85),
	  (3, 3, '2023-10-23 16:00:00', 89),
	  (3, 4, '2023-10-23 16:00:00', 421),
	  (3, 2, '2023-10-23 18:00:00', 95),
	  (3, 3, '2023-10-23 18:00:00', 93),
	  (3, 4, '2023-10-23 18:00:00', 413);
        
INSERT INTO tb_alerta VALUES
 (NULL,'2023-10-23 10:00:00',1,default,'CPU em 74% do funcionamento normal', 1),
 (NULL,'2023-10-23 12:00:00',0,default,'RAM em 9% do funcionamento normal', 2),
 (NULL,'2023-10-23 14:00:00',3,default,'CPU em 97% do funcionamento normal', 3),
 (NULL,'2023-10-23 16:00:00',1,default,'CPU em 74% do funcionamento normal', 4),
 (NULL,'2023-10-23 18:00:00',0,default,'RAM em 34% do funcionamento normal', 5);
        
INSERT INTO tb_opcao VALUE (NULL, 100, 500, 30000);

INSERT INTO tb_tag VALUES
  (NULL, 'Principal', 'F9C849'),
  (NULL, 'Backup', 'F9C849'),
  (NULL, 'Em operação', '11EC2B'),
  (NULL, 'Em manutenção', 'ECCC11'),
  (NULL, 'Fora de serviço', 'C0241D'),
  (NULL, 'Ações', ''),
  (NULL, 'Clientes', ''),
  (NULL, 'Interno', '585858');
  
INSERT INTO tb_tag_servidor VALUES
	(1, 1),
	(1, 3),
	(1, 6),
	(2, 4),
	(2, 5),
	(3, 2),
	(3, 3),
	(3, 6),
	(4, 4),
	(4, 5),
	(4, 8),
	(5, 2);
    
    INSERT INTO tb_monitorar (fk_servidor, fk_cat)
	VALUES 
		(1, 1), (1, 2), 
		(1, 3), (1, 4), 
		(2, 1), (2, 2), 
		(2, 3), (2, 4),
		(3, 1), (3, 2),  
		(3, 3), (3, 4), 
		(4, 1), (4, 2), 
		(4, 3), (4, 4), 
		(5, 1), (5, 2),
		(5, 3), (5, 4);