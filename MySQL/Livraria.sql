create database livraria;

use livraria;

create table editora(
cod_editora int auto_increment primary key,
descricao varchar(45) not null,
endereco varchar(45)
);

create table livro(
cod_livro int auto_increment primary key,
isbn varchar(45) not null,
titulo varchar(45) not null,
num_edicao int,
preco float not null,
cod_editora int not null,
foreign key (cod_editora) references editora(cod_editora)
);

create table livro_autor(
cod_livro int not null,
cod_autor int not null,
foreign key (cod_livro) references livro(cod_livro),
foreign key (cod_autor) references autor(cod_autor)
);

create table autor(
cod_autor int auto_increment primary key,
nome varchar(45) not null,
sexo char(1),
data_nascimento date not null 
);

alter table editora
change  descricao nome varchar(45);





drop database livraria;