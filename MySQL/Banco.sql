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
foreign key (num_conta) references conta(num_conta)
);

create table telefone_cliente(
cpf_cli varchar(14),
telefone varchar(20),
primary key(cpf_cli,telefone),
foreign key (cpf_cli) references cliente(cpf)
);
