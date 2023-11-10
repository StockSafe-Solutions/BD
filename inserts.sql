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
		(4, "Taxa de transferência", "MB/s");

INSERT INTO tb_monitorar VALUES 
		(2000,1),(2000,2),(2000,3),(2000,4),
		(2001,1),(2001,2),(2001,3),
		         (2002,2),(2002,3),(2002,4),
		(2003,1),         (2003,3),(2003,4),
		(2004,1),(2004,2),(2004,3),(2004,4),
		         (2005,2),(2005,3),(2005,4);

INSERT INTO tb_registro VALUES 
		(null, 2000, 1, '2023-10-23 10:00:00', 204),
		(null, 2000, 2, '2023-10-23 10:00:00', 23),
		(null, 2000, 3, '2023-10-23 10:00:00', 34),
		(null, 2000, 4, '2023-10-23 10:00:00', 499),
        
        (null, 2000, 1, '2023-10-23 12:00:00', 84),
		(null, 2000, 2, '2023-10-23 12:00:00', 5),
		(null, 2000, 3, '2023-10-23 12:00:00', 21),
		(null, 2000, 4, '2023-10-23 12:00:00', 487),
        
        (null, 2000, 1, '2023-10-23 14:00:00', 402),
		(null, 2000, 2, '2023-10-23 14:00:00', 67),
		(null, 2000, 3, '2023-10-23 14:00:00', 58),
		(null, 2000, 4, '2023-10-23 14:00:00', 439),
        
        (null, 2000, 1, '2023-10-23 16:00:00', 694),
		(null, 2000, 2, '2023-10-23 16:00:00', 72),
		(null, 2000, 3, '2023-10-23 16:00:00', 85),
		(null, 2000, 4, '2023-10-23 16:00:00', 402),
        
        (null, 2000, 1, '2023-10-23 18:00:00', 1230),
		(null, 2000, 2, '2023-10-23 18:00:00', 98),
		(null, 2000, 3, '2023-10-23 18:00:00', 99),
		(null, 2000, 4, '2023-10-23 18:00:00', 489);
        
INSERT INTO tb_registro VALUES
		(null, 2001, 1, '2023-10-23 10:00:00', 309),
		(null, 2001, 2, '2023-10-23 10:00:00', 45),
		(null, 2001, 3, '2023-10-23 10:00:00', 42),
        
        (null, 2001, 1, '2023-10-23 12:00:00', 102),
		(null, 2001, 2, '2023-10-23 12:00:00', 18),
		(null, 2001, 3, '2023-10-23 12:00:00', 21),
        
        (null, 2001, 1, '2023-10-23 14:00:00', 494),
		(null, 2001, 2, '2023-10-23 14:00:00', 56),
		(null, 2001, 3, '2023-10-23 14:00:00', 48),
        
        (null, 2001, 1, '2023-10-23 16:00:00', 853),
		(null, 2001, 2, '2023-10-23 16:00:00', 89),
		(null, 2001, 3, '2023-10-23 16:00:00', 78),
        
        (null, 2001, 1, '2023-10-23 18:00:00', 940),
		(null, 2001, 2, '2023-10-23 18:00:00', 94),
		(null, 2001, 3, '2023-10-23 18:00:00', 87);
        
INSERT INTO tb_registro VALUES
		(null, 2002, 2, '2023-10-23 10:00:00', 28),
		(null, 2002, 3, '2023-10-23 10:00:00', 39),
		(null, 2002, 4, '2023-10-23 10:00:00', 498),
        
        (null, 2002, 2, '2023-10-23 12:00:00', 14),
		(null, 2002, 3, '2023-10-23 12:00:00', 19),
		(null, 2002, 4, '2023-10-23 12:00:00', 499),
        
        (null, 2002, 2, '2023-10-23 14:00:00', 59),
		(null, 2002, 3, '2023-10-23 14:00:00', 78),
		(null, 2002, 4, '2023-10-23 14:00:00', 464),
        
        (null, 2002, 2, '2023-10-23 16:00:00', 85),
		(null, 2002, 3, '2023-10-23 16:00:00', 89),
		(null, 2002, 4, '2023-10-23 16:00:00', 421),
        
        (null, 2002, 2, '2023-10-23 18:00:00', 95),
		(null, 2002, 3, '2023-10-23 18:00:00', 93),
		(null, 2002, 4, '2023-10-23 18:00:00', 413);
        
INSERT INTO tb_alerta VALUES
 (NULL,'2023-10-23 10:00:00',1,default,'CPU em 74% do funcionamento normal', 2000),
 (NULL,'2023-10-23 12:00:00',0,default,'RAM em 9% do funcionamento normal', 2000),
 (NULL,'2023-10-23 14:00:00',3,default,'CPU em 97% do funcionamento normal', 2001),
 (NULL,'2023-10-23 16:00:00',1,default,'CPU em 74% do funcionamento normal', 2001),
 (NULL,'2023-10-23 18:00:00',0,default,'RAM em 34% do funcionamento normal', 2002);
        
INSERT INTO tb_opcao VALUE (NULL, 100, 500, 30000);