CREATE DATABASE Recrutamento;

USE Recrutamento;

CREATE TABLE Candidatos (
 CandidatoID INT AUTO_INCREMENT PRIMARY KEY,
 Nome VARCHAR(255) NOT NULL,
 Qualificacoes TEXT
);

CREATE TABLE Vagas (
 VagaID INT AUTO_INCREMENT PRIMARY KEY,
 Cargo VARCHAR(255) NOT NULL,
 DataFechamento DATE
);

CREATE TABLE Aplicacoes (
 AplicacaoID INT AUTO_INCREMENT PRIMARY KEY,
 CandidatoID INT,
 VagaID INT,
 DataAplicacao DATE,
 Status ENUM('Pendência', 'Entrevista Agendada', 'Rejeitado') DEFAULT
'Pendência',
 FOREIGN KEY (CandidatoID) REFERENCES Candidatos(CandidatoID),
 FOREIGN KEY (VagaID) REFERENCES Vagas(VagaID)
);

INSERT INTO Candidatos (Nome, Qualificacoes) VALUES
('Maria Oliveira', 'Engenheira de Software com 5 anos de experiência'),
('Pedro Costa', 'Analista de Sistemas com experiência em SQL'),
('Lucas Fernandes', 'Desenvolvedor Frontend com experiência em React'),
('Fernanda Lima', 'Gerente de Projetos com 7 anos de experiência'),
('Ana Souza', 'Designer Gráfico com experiência em UX/UI'),
('João Silva', 'Administrador de Banco de Dados');

INSERT INTO Vagas (Cargo, DataFechamento) VALUES
('Desenvolvedor Backend', '2024-08-15'),
('Analista de Dados', '2024-08-20'),
('Desenvolvedor Frontend', '2024-08-25'),
('Gerente de Projetos', '2024-08-30'),
('Designer Gráfico', '2024-09-05'),
('Administrador de Banco de Dados', '2024-09-10');

INSERT INTO Aplicacoes (CandidatoID, VagaID, DataAplicacao, Status) VALUES
(1, 1, '2024-07-12', 'Pendência'),
(2, 2, '2024-07-15', 'Entrevista Agendada'),
(3, 3, '2024-07-18', 'Pendência'),
(4, 4, '2024-07-20', 'Rejeitado'),
(5, 5, '2024-07-22', 'Pendência'),
(6, 6, '2024-07-25', 'Pendência');

-- 1. Crie uma procedure que gere um relatório de candidatos para as vagas encerradas (DataFechamento) até uma
-- determinada data. A data deve ser passada como parâmetro na procedure. Inclua no relatório as qualificações, nome do
-- candidato, a data que se candidataram e cargo.

DELIMITER //
create procedure gerar_relatorio(in data_fim date)
begin
	select candidatos.Nome,candidatos.Qualificacoes,aplicacoes.DataAplicacao,vagas.cargo
    from candidatos join aplicacoes
    on candidatos.CandidatoID=aplicacoes.CandidatoID 
    join vagas on vagas.VagaID=aplicacoes.VagaID
    where vagas.DataFechamento<=data_fim;
end //
DELIMITER ;

call gerar_relatorio('2024-08-25');


-- 2. Desenvolva um trigger que ao ser inserido um registro na tabela de aplicações, caso a data de aplicação for posterior a
-- data de fechamento da vaga, automaticamente a aplicação será atualizada para rejeitada.


DELIMITER //
create procedure atualizar_status(in id_apl int)
begin
	update aplicacoes set Status='Rejeitado' where aplicacoes.AplicacaoID=id_apl;
end //
DELIMITER ;
Delimiter //

CREATE TRIGGER after_insert_aplicacoes
AFTER INSERT ON Aplicacoes
FOR EACH ROW
BEGIN
	declare dat date;
    set dat=(select DataFechamento from vagas join aplicacoes on aplicacoes.VagaID=vagas.VagaID where aplicacoes.AplicacaoID=new.AplicacaoID);
	if new.DataAplicacao>dat  then
		call atualizar_status(new.AplicacaoID);
    end if;
   
END //

Delimiter ;






select * from Aplicacoes;


-- 3. Configure um novo usuário para os recrutadores, permitindo as operações de inserção, atualização, exclusão e seleção de
-- candidatos, mas restringindo operações nas demais tabelas. O usuário deverá poder verificar o relatório de candidatos, ou
-- seja, pode executar a procedure.

CREATE ROLE recrutador;
grant insert,select,update,delete,usage on Recrutamento.Candidatos to recrutador;
CREATE USER 'recrutador1'@'localhost' IDENTIFIED BY 'recrutador1';
grant recrutador to 'recrutador1'@'localhost';

set default role recrutador to 'recrutador1'@'localhost';









