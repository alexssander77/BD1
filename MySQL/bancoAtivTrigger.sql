create database auladml;
use auladml;

CREATE TABLE banco (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45)
);

CREATE TABLE agencia (
    numero_agencia INT NOT NULL,
    cod_banco INT NOT NULL,
    endereco VARCHAR(100),
    CONSTRAINT PRIMARY KEY (numero_agencia , cod_banco),
    CONSTRAINT fk_banco FOREIGN KEY (cod_banco)
        REFERENCES banco (codigo)
);

CREATE TABLE cliente (
    cpf VARCHAR(14) NOT NULL PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    sexo CHAR(1)
);

CREATE TABLE conta (
    num_conta VARCHAR(7) PRIMARY KEY,
    saldo FLOAT NOT NULL DEFAULT 0,
    tipo_conta INT,
    num_agencia INT,
    CONSTRAINT fk_agencia FOREIGN KEY (num_agencia)
        REFERENCES agencia (numero_agencia)
);

CREATE TABLE historico (
    cpf VARCHAR(14) NOT NULL,
    num_conta VARCHAR(7),
    data_inicio DATE,
    CONSTRAINT PRIMARY KEY (cpf , num_conta),
    CONSTRAINT fk_cpf FOREIGN KEY (cpf)
        REFERENCES cliente (cpf),
    CONSTRAINT fk_numconta FOREIGN KEY (num_conta)
        REFERENCES conta (num_conta)
);

CREATE TABLE telefone_cliente (
    cpf_cli VARCHAR(14) NOT NULL,
    telefone VARCHAR(20),
    CONSTRAINT PRIMARY KEY (cpf_cli , telefone),
    CONSTRAINT fk_cpf_cliente FOREIGN KEY (cpf_cli)
        REFERENCES cliente (cpf)
);

insert into banco values (1, "Banco do Brasil");
insert into banco values (4, "CEF");
insert into banco values (null, "Bradesco");

insert into agencia values (0582, 4, "Rua Joaquim Teixeira, 1555");
insert into agencia values (3153, 1, "Av Marcelino Pires, 1960");

insert into cliente values ("111.222.333-44", "Jennifer B Souza", "Rua Cuiabá, 1050", "F");
insert into cliente values ("666.777.888-99", "Caetano K lima", "Rua Invinhema, 879", "M");
insert into cliente values ("555.444.777-33", "Silva Macedo", "Rua Estados Unidos, 735", "F");

insert into conta values("86340-2", 763.05, 2, 3153);
insert into conta values("23584-7", 3879.12, 1, 0582);

insert into historico values ("111.222.333-44", "23584-7", str_to_date("17-12-1997", "%d-%m-%Y"));
insert into historico values ("666.777.888-99", "23584-7", str_to_date("17-12-1997", "%d-%m-%Y"));
insert into historico values ("555.444.777-33", "86340-2", str_to_date("29-11-2010", "%d-%m-%Y"));
 
insert into telefone_cliente values ("111.222.333-44", "(67)3422-7788" );
insert into telefone_cliente values ("666.777.888-99", "(67)3423-9900" );

insert into telefone_cliente values ("666.777.888-99", "(67)8121-8833" );

-- 1
DELIMITER //

CREATE TRIGGER after_insert_cliente
AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO telefone_cliente (cpf_cli, telefone)
    VALUES (NEW.cpf, '(00)0000-0000');
END//

DELIMITER ;

INSERT INTO cliente (cpf, nome, endereco, sexo)
VALUES ('123.456.789-10', 'João da Silva', 'Rua Alegria, 123', 'M');

SELECT * FROM telefone_cliente;

-- 2


DELIMITER //

CREATE TRIGGER after_delete_cliente
before DELETE ON cliente
FOR EACH ROW
BEGIN
    delete from telefone_cliente 
    where cpf_cli=OLD.cpf;
END//

DELIMITER ;


DELETE FROM cliente WHERE cpf = '123.456.789-10';

select* from cliente;

-- 3

CREATE TABLE log_conta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    num_conta VARCHAR(7) NOT NULL,
    saldo_anterior FLOAT,
    saldo_atual FLOAT,
    tipo_anterior INT,
    tipo_atual INT,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER after_update_conta
AFTER UPDATE ON conta
FOR EACH ROW
BEGIN
    INSERT INTO log_conta (num_conta, saldo_anterior, saldo_atual, tipo_anterior, tipo_atual)
    VALUES (
        OLD.num_conta,
        OLD.saldo,
        NEW.saldo,
        OLD.tipo_conta,
        NEW.tipo_conta
    );
END//

DELIMITER ;

INSERT INTO conta (num_conta, saldo, tipo_conta, num_agencia)
VALUES ('12345-6', 500.00, 1, 3153);

UPDATE conta
SET saldo = 750.00, tipo_conta = 2
WHERE num_conta = '12345-6';

select * from conta;
select * from log_conta;

-- 4

CREATE VIEW view_cliente_conta AS
SELECT 
    cliente.nome AS nome_cliente,
    banco.nome AS nome_banco,
    agencia.endereco AS endereco_agencia,
    conta.num_conta AS numero_conta
FROM 
    cliente
JOIN 
    historico ON cliente.cpf = historico.cpf
JOIN 
    conta ON historico.num_conta = conta.num_conta
JOIN 
    agencia ON conta.num_agencia = agencia.numero_agencia
JOIN 
    banco ON agencia.cod_banco = banco.codigo;


SELECT * FROM view_cliente_conta;
