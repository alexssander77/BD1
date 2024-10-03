create database livraria;

use livraria;

create table editora(
cod_editora int auto_increment primary key,
descricao varchar(45) not null,
endereco varchar(45),

foreign key (id_grupo) references grupo(id_grupo)
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

create table autor(
cod_autor int auto_increment primary key,
nome varchar(45) not null,
sexo char(1),
data_nascimento date not null 
);
create table livro_autor(
cod_livro int not null,
cod_autor int not null,
primary key(cod_livro, cod_autor),  
foreign key (cod_livro) references livro(cod_livro),
foreign key (cod_autor) references autor(cod_autor)
);

alter table editora
change  descricao nome varchar(45);

alter table autor
change sexo sexo varchar(1);

alter table livro 
add constraint unique_isbn unique (isbn);

alter table livro 
modify preco decimal(10, 2) default 10.00;

alter table livro 
drop column num_edicao;

alter table livro
add edicao int;

create table grupo(
id_grupo int auto_increment primary key,
nome varchar(45)
);

alter table editora
add id_grupo int;

alter table editora 
add constraint fk_grupo
foreign key (id_grupo) references grupo(id_grupo)
on delete set null on update cascade;
