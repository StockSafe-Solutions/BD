insert into tb_funcionario
values (
  'Danilo Marques', 
  'Analista', 
  '2005-07-11', 
  null, 
  'danilo@b3.com', 
  'urubu100'
);
insert into tb_funcionario
values (
  'Gustavo Pereira', 
  'Analista', 
  '2005-06-13', 
  null, 
  'gustavo@b3.com', 
  'urubu100'
);
insert into tb_funcionario
values (
  'Gabriel Bazante', 
  'Gerente de infraestrutura', 
  '2005-06-13', 
  null, 
  'gabriel@b3.com', 
  'urubu100'
);
insert into tb_funcionario
values (
  'Stephany Justino', 
  'Gerente de operações', 
  '2005-06-13', 
  null, 
  'stephany@b3.com', 
  'urubu100'
);
insert into tb_funcionario
values (
  5, 
  'Rafael Rocha', 
  'COO', 
  '2005-06-13', 
  null, 
  'rafael@b3.com', 
  'urubu100'
);
insert into tb_servidor (codigo, armazenamento_total, armazenamento_usado, id_autenticador)
values (
  'SVJW32', 
  cast(500.5 as numeric), 
  cast(250.2 as numeric), 
  1
), (
  'B7WGPJ', 
  cast(750.0 as numeric), 
  cast(375.5 as numeric), 
  1
), (
  'RQ8Q28', 
  cast(300.3 as numeric), 
  cast(150.1 as numeric), 
  1
), (
  'Y5WR5Y', 
  cast(900.0 as numeric), 
  cast(500.0 as numeric), 
  null
), (
  'TCUHVQ', 
  cast(800.8 as numeric), 
  cast(400.4 as numeric), 
  null
), (
  '17P51N', 
  cast(600.6 as numeric), 
  cast(300.3 as numeric), 
  null
);
insert into tb_categoria
values (
  1, 
  'Pacotes enviados', 
  null
), (
  2, 
  'Uso da CPU', 
  '%'
), (
  3, 
  'Uso da RAM', 
  '%'
), (
  4, 
  'Taxa de transferência', 
  'MB/s'
);
insert into tb_monitorar
values (
  2000, 
  1
), (
  2000, 
  2
), (
  2000, 
  3
), (
  2000, 
  4
), (
  2001, 
  1
), (
  2001, 
  2
), (
  2001, 
  3
), (
  2002, 
  2
), (
  2002, 
  3
), (
  2002, 
  4
), (
  2003, 
  1
), (
  2003, 
  3
), (
  2003, 
  4
), (
  2004, 
  1
), (
  2004, 
  2
), (
  2004, 
  3
), (
  2004, 
  4
), (
  2005, 
  2
), (
  2005, 
  3
), (
  2005, 
  4
);
insert into tb_registro
values (
  null, 
  2000, 
  1, 
  '2023-10-23 10:00:00', 
  204
), (
  null, 
  2000, 
  2, 
  '2023-10-23 10:00:00', 
  23
), (
  null, 
  2000, 
  3, 
  '2023-10-23 10:00:00', 
  34
), (
  null, 
  2000, 
  4, 
  '2023-10-23 10:00:00', 
  499
), (
  null, 
  2000, 
  1, 
  '2023-10-23 12:00:00', 
  84
), (
  null, 
  2000, 
  2, 
  '2023-10-23 12:00:00', 
  5
), (
  null, 
  2000, 
  3, 
  '2023-10-23 12:00:00', 
  21
), (
  null, 
  2000, 
  4, 
  '2023-10-23 12:00:00', 
  487
), (
  null, 
  2000, 
  1, 
  '2023-10-23 14:00:00', 
  402
), (
  null, 
  2000, 
  2, 
  '2023-10-23 14:00:00', 
  67
), (
  null, 
  2000, 
  3, 
  '2023-10-23 14:00:00', 
  58
), (
  null, 
  2000, 
  4, 
  '2023-10-23 14:00:00', 
  439
), (
  null, 
  2000, 
  1, 
  '2023-10-23 16:00:00', 
  694
), (
  null, 
  2000, 
  2, 
  '2023-10-23 16:00:00', 
  72
), (
  null, 
  2000, 
  3, 
  '2023-10-23 16:00:00', 
  85
), (
  null, 
  2000, 
  4, 
  '2023-10-23 16:00:00', 
  402
), (
  null, 
  2000, 
  1, 
  '2023-10-23 18:00:00', 
  1230
), (
  null, 
  2000, 
  2, 
  '2023-10-23 18:00:00', 
  98
), (
  null, 
  2000, 
  3, 
  '2023-10-23 18:00:00', 
  99
), (
  null, 
  2000, 
  4, 
  '2023-10-23 18:00:00', 
  489
);
insert into tb_registro
values (
  null, 
  2001, 
  1, 
  '2023-10-23 10:00:00', 
  309
), (
  null, 
  2001, 
  2, 
  '2023-10-23 10:00:00', 
  45
), (
  null, 
  2001, 
  3, 
  '2023-10-23 10:00:00', 
  42
), (
  null, 
  2001, 
  1, 
  '2023-10-23 12:00:00', 
  102
), (
  null, 
  2001, 
  2, 
  '2023-10-23 12:00:00', 
  18
), (
  null, 
  2001, 
  3, 
  '2023-10-23 12:00:00', 
  21
), (
  null, 
  2001, 
  1, 
  '2023-10-23 14:00:00', 
  494
), (
  null, 
  2001, 
  2, 
  '2023-10-23 14:00:00', 
  56
), (
  null, 
  2001, 
  3, 
  '2023-10-23 14:00:00', 
  48
), (
  null, 
  2001, 
  1, 
  '2023-10-23 16:00:00', 
  853
), (
  null, 
  2001, 
  2, 
  '2023-10-23 16:00:00', 
  89
), (
  null, 
  2001, 
  3, 
  '2023-10-23 16:00:00', 
  78
), (
  null, 
  2001, 
  1, 
  '2023-10-23 18:00:00', 
  940
), (
  null, 
  2001, 
  2, 
  '2023-10-23 18:00:00', 
  94
), (
  null, 
  2001, 
  3, 
  '2023-10-23 18:00:00', 
  87
);
insert into tb_registro
values (
  null, 
  2002, 
  2, 
  '2023-10-23 10:00:00', 
  28
), (
  null, 
  2002, 
  3, 
  '2023-10-23 10:00:00', 
  39
), (
  null, 
  2002, 
  4, 
  '2023-10-23 10:00:00', 
  498
), (
  null, 
  2002, 
  2, 
  '2023-10-23 12:00:00', 
  14
), (
  null, 
  2002, 
  3, 
  '2023-10-23 12:00:00', 
  19
), (
  null, 
  2002, 
  4, 
  '2023-10-23 12:00:00', 
  499
), (
  null, 
  2002, 
  2, 
  '2023-10-23 14:00:00', 
  59
), (
  null, 
  2002, 
  3, 
  '2023-10-23 14:00:00', 
  78
), (
  null, 
  2002, 
  4, 
  '2023-10-23 14:00:00', 
  464
), (
  null, 
  2002, 
  2, 
  '2023-10-23 16:00:00', 
  85
), (
  null, 
  2002, 
  3, 
  '2023-10-23 16:00:00', 
  89
), (
  null, 
  2002, 
  4, 
  '2023-10-23 16:00:00', 
  421
), (
  null, 
  2002, 
  2, 
  '2023-10-23 18:00:00', 
  95
), (
  null, 
  2002, 
  3, 
  '2023-10-23 18:00:00', 
  93
), (
  null, 
  2002, 
  4, 
  '2023-10-23 18:00:00', 
  413
);
insert into tb_alerta
values (
  null, 
  '2023-10-23 10:00:00', 
  1, 
  default, 
  'CPU em 74% do funcionamento normal', 
  2000
), (
  null, 
  '2023-10-23 12:00:00', 
  0, 
  default, 
  'RAM em 9% do funcionamento normal', 
  2000
), (
  null, 
  '2023-10-23 14:00:00', 
  3, 
  default, 
  'CPU em 97% do funcionamento normal', 
  2001
), (
  null, 
  '2023-10-23 16:00:00', 
  1, 
  default, 
  'CPU em 74% do funcionamento normal', 
  2001
), (
  null, 
  '2023-10-23 18:00:00', 
  0, 
  default, 
  'RAM em 34% do funcionamento normal', 
  2002
);
with
  VALUE as (
    select *
    from tb_opcao
  )
insert into VALUE
values (
  null, 
  100, 
  500, 
  30000
);
insert into tb_tag
values (
  null, 
  'Principal', 
  'F9C849'
), (
  null, 
  'Backup', 
  'F9C849'
), (
  null, 
  'Em operação', 
  '11EC2B'
), (
  null, 
  'Em manutenção', 
  'ECCC11'
), (
  null, 
  'Fora de serviço', 
  'C0241D'
), (
  null, 
  'Ações', 
  ''
), (
  null, 
  'Clientes', 
  ''
), (
  null, 
  'Interno', 
  '585858'
);
insert into tb_tag_servidor
values (
  2000, 
  1
), (
  2000, 
  3
), (
  2000, 
  6
), (
  2001, 
  4
), (
  2001, 
  5
), (
  2002, 
  2
), (
  2002, 
  3
), (
  2002, 
  6
), (
  2003, 
  4
), (
  2003, 
  5
), (
  2003, 
  8
), (
  2004, 
  2
), (
  2004, 
  5
), (
  2005, 
  5
);