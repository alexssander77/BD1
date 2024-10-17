create database Banco;

use Banco;

create table banco(
cod_banco int primary key not null auto_increment,
nome varchar(45) 
);

create table agencia(
num_agencia int not null,
cod_banco int not null,
primary key(num_agencia,cod_banco),
foreign key (cod_banco) references banco(cod_banco),
endereco varchar(100)
);

create table conta(
num_conta varchar(7) primary key not null,
saldo float not null,
tipo_conta int,
num_agencia int,
foreign key (num_agencia) references agencia(num_agencia)
);

create table cliente(
cpf varchar(14) primary key not null,
nome varchar(45) not null,
endereco varchar(100),
sexo char(1)
);

create table historico(
cpf varchar(14),
num_conta varchar(7),
primary key(cpf,num_conta),
foreign key (cpf) references cliente(cpf),
foreign key (num_conta) references conta(num_conta),
data_inicio date
);

create table telefone_cliente(
cpf_cli varchar(14),
telefone varchar(20),
primary key(cpf_cli,telefone),
foreign key (cpf_cli) references cliente(cpf)

);

insert into banco (cod_banco,nome) values (1,"Banco do Brasil");
insert into banco (cod_banco,nome) values (4,"CEF");
insert into agencia (num_agencia,endereco,cod_banco) values (0562,"Rua Joaquim Teixeira Alves, 1555",4);
insert into agencia (num_agencia,endereco,cod_banco) values (3153,"Av Marcelino Pires, 1960",1);
insert into cliente (cpf,nome,sexo,endereco) values ("111.222.333-44","Jennifer B Souza",'F',"Rua Cuiabá, 1050");
insert into cliente (cpf,nome,sexo,endereco) values ("666.777.888-99","Caetano K Lima",'M',"Rua Ivinhema, 879");
insert into cliente (cpf,nome,sexo,endereco) values ("555.444.777-33","Silvia Macedo",'F',"Rua Estados Unidos, 735");
insert into conta(num_conta,saldo,tipo_conta,num_agencia) values ("86340-2",763.05,2,3153);
insert into conta(num_conta,saldo,tipo_conta,num_agencia) values ("23584-7",3879.12,1,0562);
insert into historico(cpf,num_conta,data_inicio) values("111.222.333-44","23584-7","1997-12-17");
insert into historico(cpf,num_conta,data_inicio) values("666.777.888-99","23584-7","1997-12-17");
insert into historico(cpf,num_conta,data_inicio) values("555.444.777-33","86340-2","2010-11-29");
insert into telefone_cliente(cpf_cli,telefone) values("111.222.333-44","(67)3422-7788");
insert into telefone_cliente(cpf_cli,telefone) values("666.777.888-99","(67)3423-9900");
insert into telefone_cliente(cpf_cli,telefone) values("666.777.888-99","(67)8121-8833");
