drop database StockSafe;
create database StockSafe;
use StockSafe;

  create table tb_funcionario (
    id_funcionario int identity(1, 1) not null,
    nome varchar(125),
    funcao varchar(75),
    data_nascimento date,
    foto varchar(300) null,
    email varchar(125),
    senha varchar(20),
    primary key (id_funcionario)
  )

  create table tb_servidor (
    id_servidor int identity(1, 1) not null,
    codigo char(6) not null,
    armazenamento_total decimal(4, 1) null,
    armazenamento_usado decimal(4, 1) null,
    id_autenticador int,
    primary key (id_servidor),
    foreign key (id_autenticador) references tb_funcionario (id_funcionario)
  )

  create table tb_categoria (
    id_cat int not null,
    tipo_cat varchar(45) not null,
    unidade_cat varchar(25),
    primary key (id_cat)
  )

  create table tb_monitorar (
    fk_servidor int not null,
    fk_cat int not null,
    primary key (fk_servidor, fk_cat),
    foreign key (fk_servidor) references tb_servidor (id_servidor),
    foreign key (fk_cat) references tb_categoria (id_cat)
  )

  create table tb_registro (
    id_registro int identity(1, 1) not null,
    fk_servidor int not null,
    fk_cat int not null,
    data_hora datetime2 default current_timestamp,
    valor decimal(8, 2) not null,
    primary key (id_registro, fk_servidor, fk_cat),
    foreign key (fk_servidor) references tb_servidor (id_servidor),
    foreign key (fk_cat) references tb_categoria (id_cat)
  )

  create table tb_opcao (
    id_opcao int identity(1, 1) not null,
    banda_larga smallint default 155,
    taxa_de_transferência decimal(10, 2) default 1000.00,
    intervalo_atualizacao int default 60000,
    primary key (id_opcao)
  )
  
  
  create table tb_alerta (
    id_alerta int identity(1, 1) not null,
    data_hora datetime2 default current_timestamp,
    nivel_alerta tinyint not null,
    visualizado bit default 0,
    descricao varchar(250) not null,
    fk_servidor int not null,
    foreign key (fk_servidor) references tb_servidor (id_servidor),
    check (nivel_alerta in (0, 1, 2, 3)),
    primary key (id_alerta)
  )

create table tb_tag (
  id_tag int identity(1, 1) not null,
  nome_tag varchar(75) not null,
  cor_tag char(6) not null,
  unique (nome_tag),
  primary key (id_tag)
);

create table tb_tag_servidor (
  fk_servidor int not null,
  fk_tag int not null,
  foreign key (fk_servidor) references tb_servidor (id_servidor),
  foreign key (fk_tag) references tb_tag (id_tag),
  primary key (fk_servidor, fk_tag)
);

