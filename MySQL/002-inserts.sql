-- LISTA DE INSERTS
  
INSERT INTO tb_funcionario VALUES (1, 'Danilo Marques', 'Analista', '6-07-11', null, 'danilo@b3.com', 'urubu100');
INSERT INTO tb_funcionario VALUES (2,'Gustavo Pereira','Analista','6-06-13',null,'gustavo@b3.com','urubu100');
INSERT INTO tb_funcionario VALUES (3,'Gabriel Bazante','Gerente de infraestrutura','6-06-13',null,'gabriel@b3.com','urubu100');
INSERT INTO tb_funcionario VALUES (4,'Stephany Justino','Gerente de operações','6-06-13',null,'stephany@b3.com','urubu100');
INSERT INTO tb_funcionario VALUES (5,'Rafael Rocha','COO','6-06-13',null,'rafael@b3.com','urubu100');

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
        (5,'Total da RAM','GB'),
        (6,'Uso disponivel da RAM','%');

INSERT INTO tb_monitorar VALUES 
		(1,1),(1,2),(1,3),(1,4),
		(2,1),(2,2),(2,3),
		         (3,2),(3,3),(3,4),
		(4,1),         (4,3),(4,4),
		(5,1),(5,2),(5,3),(5,4),
		         (6,2),(6,3),(6,4);

INSERT INTO tb_registro VALUES 
		(null, 1, 1, '2023-10-23 10:00:00', 204),
		(null, 1, 2, '2023-10-23 10:00:00', 23),
		(null, 1, 3, '2023-10-23 10:00:00', 34),
		(null, 1, 4, '2023-10-23 10:00:00', 499),
        
        (null, 1, 1, '2023-10-23 12:00:00', 84),
		(null, 1, 2, '2023-10-23 12:00:00', 5),
		(null, 1, 3, '2023-10-23 12:00:00', 21),
		(null, 1, 4, '2023-10-23 12:00:00', 487),
        
        (null, 1, 1, '2023-10-23 14:00:00', 402),
		(null, 1, 2, '2023-10-23 14:00:00', 67),
		(null, 1, 3, '2023-10-23 14:00:00', 58),
		(null, 1, 4, '2023-10-23 14:00:00', 439),
        
        (null, 1, 1, '2023-10-23 16:00:00', 694),
		(null, 1, 2, '2023-10-23 16:00:00', 72),
		(null, 1, 3, '2023-10-23 16:00:00', 85),
		(null, 1, 4, '2023-10-23 16:00:00', 402),
        
        (null, 1, 1, '2023-10-23 18:00:00', 1230),
		(null, 1, 2, '2023-10-23 18:00:00', 98),
		(null, 1, 3, '2023-10-23 18:00:00', 99),
		(null, 1, 4, '2023-10-23 18:00:00', 489);
        
INSERT INTO tb_registro VALUES
		(null, 2, 1, '2023-10-23 10:00:00', 309),
		(null, 2, 2, '2023-10-23 10:00:00', 45),
		(null, 2, 3, '2023-10-23 10:00:00', 42),
        
        (null, 2, 1, '2023-10-23 12:00:00', 102),
		(null, 2, 2, '2023-10-23 12:00:00', 18),
		(null, 2, 3, '2023-10-23 12:00:00', 21),
        
        (null, 2, 1, '2023-10-23 14:00:00', 494),
		(null, 2, 2, '2023-10-23 14:00:00', 56),
		(null, 2, 3, '2023-10-23 14:00:00', 48),
        
        (null, 2, 1, '2023-10-23 16:00:00', 853),
		(null, 2, 2, '2023-10-23 16:00:00', 89),
		(null, 2, 3, '2023-10-23 16:00:00', 78),
        
        (null, 2, 1, '2023-10-23 18:00:00', 940),
		(null, 2, 2, '2023-10-23 18:00:00', 94),
		(null, 2, 3, '2023-10-23 18:00:00', 87);
        
INSERT INTO tb_registro VALUES
		(null, 3, 2, '2023-10-23 10:00:00', 28),
		(null, 3, 3, '2023-10-23 10:00:00', 39),
		(null, 3, 4, '2023-10-23 10:00:00', 498),
        
        (null, 3, 2, '2023-10-23 12:00:00', 14),
		(null, 3, 3, '2023-10-23 12:00:00', 19),
		(null, 3, 4, '2023-10-23 12:00:00', 499),
        
        (null, 3, 2, '2023-10-23 14:00:00', 59),
		(null, 3, 3, '2023-10-23 14:00:00', 78),
		(null, 3, 4, '2023-10-23 14:00:00', 464),
        
        (null, 3, 2, '2023-10-23 16:00:00', 85),
		(null, 3, 3, '2023-10-23 16:00:00', 89),
		(null, 3, 4, '2023-10-23 16:00:00', 421),
        
        (null, 3, 2, '2023-10-23 18:00:00', 95),
		(null, 3, 3, '2023-10-23 18:00:00', 93),
		(null, 3, 4, '2023-10-23 18:00:00', 413);
        
INSERT INTO tb_alerta VALUES
 (NULL,'2023-10-23 10:00:00',1,default,'CPU em 74% do funcionamento normal', 1),
 (NULL,'2023-10-23 12:00:00',0,default,'RAM em 9% do funcionamento normal', 1),
 (NULL,'2023-10-23 14:00:00',3,default,'CPU em 97% do funcionamento normal', 2),
 (NULL,'2023-10-23 16:00:00',1,default,'CPU em 74% do funcionamento normal', 2),
 (NULL,'2023-10-23 18:00:00',0,default,'RAM em 34% do funcionamento normal', 3);
        
INSERT INTO tb_opcao VALUE (NULL, 100, 500, 30000);
