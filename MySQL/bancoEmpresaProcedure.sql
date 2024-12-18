CREATE DATABASE IF NOT EXISTS bd_empresa;
USE bd_empresa;

CREATE TABLE departamento (
    id_depto    Integer    NOT NULL auto_increment PRIMARY KEY,
    nome_depto   VARCHAR(30)   NOT NULL,
    id_gerente  Integer      NOT NULL,
    CONSTRAINT uk_nome UNIQUE (nome_depto)
);

CREATE TABLE funcionario (
    id_func     Integer     NOT NULL PRIMARY KEY auto_increment,
    nome_func    VARCHAR(30)  NOT NULL,
    endereco    VARCHAR(50)  NOT NULL,
    data_nasc    DATE          NOT NULL,
    sexo        CHAR(1)       NOT NULL,
    salario     NUMERIC(8,2)   NOT NULL,
    id_superv   Integer         NULL,
    id_depto    Integer     NOT NULL,
    CONSTRAINT ck_sexo CHECK (sexo='M' or sexo='F')
);

CREATE TABLE projeto (
    id_proj       Integer     NOT NULL PRIMARY KEY auto_increment,
    nome_proj      VARCHAR(30)  NOT NULL,
    localizacao   VARCHAR(30)      NULL,
    id_depto      Integer     NOT NULL,
    CONSTRAINT uk_nome_proj UNIQUE (nome_proj)
);

CREATE TABLE dependente (
    id_dep       Integer     NOT NULL,
    id_func      Integer     NOT NULL,
    nome_dep      VARCHAR(30)  NOT NULL,
    data_nasc     DATE          NOT NULL,
    sexo         CHAR(1)       NOT NULL,
    parentesco   CHAR(15)          NULL,
    CONSTRAINT pk_depend PRIMARY KEY (id_dep, id_func),
    CONSTRAINT ck_sexo_dep CHECK (sexo='M' or sexo='F')
);

CREATE TABLE trabalha (
    id_func    Integer    NOT NULL,
    id_proj    Integer     NOT NULL,
    num_horas   NUMERIC(6,1)       NULL,
    CONSTRAINT pk_trab PRIMARY KEY (id_func,id_proj)
);

INSERT INTO funcionario
VALUES (1,'Joao Silva','R. Guaicui, 175', str_to_date('01/02/1955',"%d/%m/%Y"),'M',500,2,1);
INSERT INTO funcionario
VALUES (2,'Frank Santos','R. Gentios, 22',str_to_date('02/02/1966',"%d/%m/%Y"),'M',1000,8,1);
INSERT INTO funcionario
VALUES (3,'Alice Pereira','R. Curitiba, 11',str_to_date('15/05/1970',"%d/%m/%Y"),'F',700,4,3);
INSERT INTO funcionario
VALUES (4,'Junia Mendes','R. Espirito Santos, 123',str_to_date('06/07/1976',"%d/%m/%Y"),'F',1200,8,3);
INSERT INTO funcionario
VALUES (5,'Jose Tavares','R. Irai, 153',str_to_date('07/10/1975',"%d/%m/%Y"),'M',1500,2,1);
INSERT INTO funcionario
VALUES (6,'Luciana Santos','R. Irai, 175',str_to_date('07/10/1960',"%d/%m/%Y"),'F',600,2,1);
INSERT INTO funcionario
VALUES (7,'Maria Ramos','R. C. Linhares, 10',str_to_date('01/11/1965',"%d/%m/%Y"),'F',1000,4,3);
INSERT INTO funcionario
VALUES (8,'Jaime Mendes','R. Bahia, 111',str_to_date('25/11/1960',"%d/%m/%Y"),'M',2000,NULL,2);

INSERT INTO departamento
VALUES (1,'Pesquisa',2);
INSERT INTO departamento
VALUES (2,'Administracao',8);
INSERT INTO departamento
VALUES (3,'Construcao',4);

INSERT INTO dependente
VALUES (1,2,'Luciana',str_to_date('05/11/1990',"%d/%m/%Y"),'F','Filha');
INSERT INTO dependente
VALUES (2,2,'Paulo',str_to_date('11/11/1992',"%d/%m/%Y"),'M','Filho');
INSERT INTO dependente
VALUES (3,2,'Sandra',str_to_date('05/12/1996',"%d/%m/%Y"),'F','Filha');
INSERT INTO dependente
VALUES (4,4,'Mike',str_to_date('05/11/1997',"%d/%m/%Y"),'M','Filho');
INSERT INTO dependente
VALUES (5,1,'Max',str_to_date('11/05/1979',"%d/%m/%Y"),'M','Filho');
INSERT INTO dependente
VALUES (6,1,'Rita',str_to_date('07/11/1985',"%d/%m/%Y"),'F','Filha');
INSERT INTO dependente
VALUES (7,1,'Bety',str_to_date('15/12/1960',"%d/%m/%Y"),'F','Esposa');

INSERT INTO projeto
VALUES (1,'ProdX','Savassi',1);
INSERT INTO projeto
VALUES (2,'ProdY','Luxemburgo',1);
INSERT INTO projeto
VALUES (3,'ProdZ','Centro',1);
INSERT INTO projeto
VALUES (10,'Computacao','C. Nova',3);
INSERT INTO projeto
VALUES (20,'Organizacao','Luxemburgo',2);
INSERT INTO projeto
VALUES (30,'N. Beneficios','C. Nova',1);

INSERT INTO trabalha
VALUES (1,1,32.5);
INSERT INTO trabalha
VALUES (1,2,7.5);
INSERT INTO trabalha
VALUES (5,3,40.0);
INSERT INTO trabalha
VALUES (6,1,20.0);
INSERT INTO trabalha
VALUES (6,2,20.0);
INSERT INTO trabalha
VALUES (2,2,10.0);
INSERT INTO trabalha
VALUES (2,3,10.0);
INSERT INTO trabalha
VALUES (2,10,10.0);
INSERT INTO trabalha
VALUES (2,20,10.0);
INSERT INTO trabalha
VALUES (3,30,30.0);
INSERT INTO trabalha
VALUES (3,10,10.0);
INSERT INTO trabalha
VALUES (7,10,35.0);
INSERT INTO trabalha
VALUES (7,30,5.0);
INSERT INTO trabalha
VALUES (4,20,15.0);
INSERT INTO trabalha
VALUES (8,20,NULL);

ALTER TABLE funcionario
ADD CONSTRAINT fk_func_depto FOREIGN KEY (id_depto) REFERENCES departamento (id_depto);

ALTER TABLE funcionario
ADD CONSTRAINT fk_func_superv FOREIGN KEY (id_superv) REFERENCES funcionario (id_func);

ALTER TABLE departamento
ADD CONSTRAINT fk_depto_func FOREIGN KEY (id_gerente) REFERENCES funcionario (id_func);

ALTER TABLE projeto
ADD CONSTRAINT fk_proj_depto FOREIGN KEY (id_depto) REFERENCES departamento (id_depto);

ALTER TABLE dependente
ADD CONSTRAINT fk_dep_func FOREIGN KEY (id_func) REFERENCES funcionario (id_func) ON DELETE CASCADE;

ALTER TABLE trabalha
ADD CONSTRAINT fk_trab_func FOREIGN KEY (id_func) REFERENCES funcionario (id_func) ON DELETE CASCADE;

ALTER TABLE trabalha
ADD CONSTRAINT fk_trab_proj FOREIGN KEY (id_proj) REFERENCES projeto (id_proj) ON DELETE CASCADE;

-- 1
insert into projeto(nome_proj,localizacao,id_depto)
values('Novo Projeto','Buritis',1);
-- 2
insert into funcionario(nome_func,endereco,data_nasc,sexo,salario,id_superv,id_depto)
values('Edgar Marinho','R. Alameda, 111','1959/11/13','M',2000.00,NULL,2);
-- 3
update funcionario set salario=1000.00 where nome_func like '%Joao Silva%';
-- 4
select nome_func from funcionario where (id_depto=2 or id_depto=3) and salario between 800.00 and 1200.00;
-- 5
select nome_func,endereco from funcionario join departamento on funcionario.id_depto=departamento.id_depto where nome_depto like '%Pesquisa%';
-- 6
select nome_func,date_format(data_nasc ,'%d/%m/%Y') as 'data de nascimento'  from funcionario where nome_func like '%Joao Silva%';
-- 7
select nome_func from funcionario where isnull(id_superv);
-- 8
select nome_func,nome_depto,nome_proj from funcionario join departamento on funcionario.id_depto=departamento.id_depto join projeto on projeto.id_depto=departamento.id_depto
order by departamento.nome_depto,projeto.nome_proj asc;
-- 9
select sum(salario) as 'soma dos salarios',avg(salario) as 'media de salario',max(salario) as 'maior salario',min(salario) as 'menor salario' from funcionario;
-- 10
select sum(salario) as 'soma dos salarios',avg(salario) as 'media de salario',max(salario) as 'maior salario',min(salario) as 'menor salario' from funcionario join departamento on departamento.id_depto=funcionario.id_depto where nome_depto like '%Pesquisa%';
-- 11
select nome_func from funcionario left join dependente on funcionario.id_func=dependente.id_func where id_dep is null;
-- 12
select id_proj,departamento.id_depto,funcionario.nome_func,endereco,data_nasc from projeto 
join departamento on projeto.id_depto=departamento.id_depto 
join funcionario on departamento.id_gerente=funcionario.id_func where projeto.localizacao like 'Luxemburgo';
-- 13
select nome_proj,localizacao from projeto left join trabalha on projeto.id_proj=trabalha.id_proj  where trabalha.id_func is null;
-- 14
select nome_func from trabalha 
right join funcionario on funcionario.id_func=trabalha.id_func 
left join dependente on dependente.id_func=funcionario.id_func where trabalha.id_proj is null and dependente.id_func is null;
-- 15
select empregado.nome_func as Nome_empregado,supervisor.nome_func as Nome_supervisor from funcionario as Empregado  join funcionario as Supervisor on Empregado.id_superv=Supervisor.id_func;
-- 16
select nome_proj,count(trabalha.id_func) from projeto
left join trabalha on projeto.id_proj=trabalha.id_proj
group by projeto.nome_proj;
-- 17
select nome_proj,count(trabalha.id_func) from projeto
join trabalha on projeto.id_proj=trabalha.id_proj
group by projeto.nome_proj
having count(trabalha.id_func)>2;
-- 18
SELECT d.nome_depto, f.nome_func
FROM departamento d
JOIN funcionario f ON f.id_depto = d.id_depto
WHERE f.salario > 800
AND f.id_depto IN (
    SELECT e.id_depto
    FROM funcionario e
    GROUP BY e.id_depto
    HAVING COUNT(e.id_func) > 2
);

-- Atividade Procedure

-- 1

DELIMITER //
create procedure aplicarTaxaFuncionario(in taxa double ,in id int)
begin
	update funcionario 
    set salario=salario+salario*taxa
    where id=id_func;
	
end //

DELIMITER ;


select * from funcionario;
call aplicarTaxaFuncionario(0.1,1);
select * from funcionario;

-- 2

create table hora_extra(
id_fun int,
qtd_horas float
);

DELIMITER //
create trigger inserir_trabalha
after insert on trabalha
for each row
begin
	declare horas float default 0;
	call somar_horas(new.id_func,horas);
    if horas>40 then 
		insert into hora_extra (id_fun,qtd_horas) values(new.id_func,horas-40);
    
	end if;

end //

DELIMITER ;



DELIMITER //
create procedure somar_horas(in id int,out horas float)
begin
	set horas=(select sum(num_horas) from trabalha where id=id_func);
end //


DELIMITER ;

insert into trabalha(id_func,id_proj,num_horas) values (1,3,10);
select * from trabalha;
select * from hora_extra;




