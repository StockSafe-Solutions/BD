CREATE OR ALTER  VIEW vw_base_registros AS
	SELECT 
    r.fk_servidor,
	data_hora,
    tipo_cat,
    avg(valor) as media
		FROM tb_registro AS r
        JOIN tb_categoria AS c on r.fk_cat = c.id_cat
			GROUP BY fk_servidor, data_hora, c.id_cat
go

create or alter view vw_registro as 
select
  fk_servidor,
  data_hora,
  max(case
    when tipo_cat = 'Pacotes enviados' then media
  end) as pacotes_enviados,
  max(case
    when tipo_cat = 'Taxa de transferência' then media
  end) as taxa_de_transferência,
  max(case
    when tipo_cat = 'Uso da CPU' then media
  end) as uso_da_cpu,
  max(case
    when tipo_cat = 'Uso da RAM' then media
  end) as uso_da_ram
from vw_base_registros
group by fk_servidor, data_hora
go

select * from vw_servidor;

create or alter view vw_servidor
as
select
  s.*,
  FORMAT(data_hora, 'dd/MMMM/yyyy','pt-BR') as 'ultimaData',
  FORMAT(data_hora, 'hh:mm','pt-BR') as 'ultimoHorario'
from tb_servidor s
  left outer join (
    select
      fk_servidor,
      max(data_hora) data_hora
    from vw_registro
    group by fk_servidor
  ) d
    on s.id_servidor = d.fk_servidor
go
   
   
create or alter view vw_cpu as
select
  fk_servidor,
  avg(uso_da_cpu) uso_da_cpu,
  FORMAT(data_hora, 'dd/MMMM/yyyy h:i') dataDados
from vw_registro
group by
  FORMAT(data_hora, 'dd/MMMM/yyyy h:i'),
  fk_servidor
go


create or alter view vw_cpu_geral
as
select
  avg(uso_da_cpu) uso_da_cpu,
  FORMAT(data_hora, 'dd/MM/yyyy hh:mm') dataDados
from vw_registro
group by FORMAT(data_hora, 'dd/MM/yyyy hh:mm')
go


create or alter view vw_ram as
select
  fk_servidor,
  avg(uso_da_ram) uso_da_ram,
  FORMAT(data_hora, 'dd/MM/yyyy hh:mm') dataDados
from vw_registro
group by
  FORMAT(data_hora, 'dd/MM/yyyy hh:mm'),
  fk_servidor
go


create or alter view vw_ram_geral as
select
  avg(uso_da_ram) uso_da_ram,
  FORMAT(data_hora, 'dd/MM/yyyy hh:mm') dataDados
from vw_registro
group by FORMAT(data_hora, 'dd/MM/yyyy hh:mm')
go


create or alter view vw_taxa_de_transferência as
select
  fk_servidor,
  avg(taxa_de_transferência) as taxa_de_transferência,
  data_hora
from vw_registro
group by data_hora, fk_servidor
go


create or alter view vw_pacotes_enviados as
select
  fk_servidor,
  avg(pacotes_enviados) as pacotes_enviados,
  data_hora
from vw_registro
group by data_hora, fk_servidor
go