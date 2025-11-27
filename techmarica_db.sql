DROP DATABASE IF EXISTS db_techmarica;
CREATE DATABASE db_techmarica;
USE db_techmarica;

CREATE TABLE Funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    area_atuacao VARCHAR(50) NOT NULL,
    situacao ENUM('ATIVO', 'INATIVO') DEFAULT 'ATIVO' NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Maquinas (
    id_maquina INT AUTO_INCREMENT PRIMARY KEY,
    codigo_patrimonio VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    modelo VARCHAR(50),
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    codigo_interno VARCHAR(20) UNIQUE NOT NULL,
    nome_comercial VARCHAR(100) NOT NULL,
    responsavel_tecnico VARCHAR(100) NOT NULL,
    custo_estimado DECIMAL(10,2) NOT NULL,
    data_criacao DATE NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrdensProducao (
    id_ordem INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    id_maquina INT NOT NULL,
    id_funcionario_autorizacao INT NOT NULL,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATETIME,
    status VARCHAR(20) DEFAULT 'AGUARDANDO',
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto),
    FOREIGN KEY (id_maquina) REFERENCES Maquinas(id_maquina),
    FOREIGN KEY (id_funcionario_autorizacao) REFERENCES Funcionarios(id_funcionario)
);

INSERT INTO Funcionarios (nome, area_atuacao, situacao) VALUES
('Carlos Silva', 'Montagem', 'ATIVO'),
('Ana Souza', 'Controle de Qualidade', 'ATIVO'),
('Roberto Mendes', 'Engenharia', 'INATIVO'),
('Fernanda Lima', 'Supervisão', 'ATIVO'),
('João Pedro', 'Logística', 'INATIVO');

INSERT INTO Maquinas (codigo_patrimonio, nome, modelo) VALUES
('MQ-001', 'Insersora SMD', 'Pick&Place X200'),
('MQ-002', 'Forno de Refusão', 'HeatMax 5000'),
('MQ-003', 'Bancada de Teste', 'TestPro v3');

INSERT INTO Produtos (codigo_interno, nome_comercial, responsavel_tecnico, custo_estimado, data_criacao) VALUES
('PRD-001', 'Sensor de Umidade IoT', 'Eng. Roberto Mendes', 45.50, '2020-05-10'),
('PRD-002', 'Placa Controladora WiFi', 'Eng. Amanda Costa', 120.00, '2021-01-15'),
('PRD-003', 'Módulo Bluetooth 5.0', 'Eng. Roberto Mendes', 30.00, '2022-08-20'),
('PRD-004', 'Display OLED 1.3', 'Eng. Amanda Costa', 25.90, '2023-02-01'),
('PRD-005', 'Microcontrolador RISC-V', 'Eng. Lucas Pereira', 15.00, '2019-11-30');

INSERT INTO OrdensProducao (id_produto, id_maquina, id_funcionario_autorizacao, data_inicio, data_conclusao, status) VALUES
(1, 1, 4, '2023-10-01 08:00:00', '2023-10-01 12:00:00', 'FINALIZADA'),
(2, 2, 4, '2023-10-02 09:00:00', NULL, 'EM PRODUÇÃO'),
(3, 1, 1, '2023-10-03 10:30:00', NULL, 'EM PRODUÇÃO'),
(4, 3, 2, '2023-10-04 14:00:00', '2023-10-04 16:00:00', 'FINALIZADA'),
(1, 3, 4, '2023-10-05 08:00:00', NULL, 'AGUARDANDO');

SELECT
    OP.id_ordem,
    P.nome_comercial,
    M.nome AS maquina,
    F.nome AS funcionario_autorizou,
    OP.data_inicio,
    OP.status
FROM OrdensProducao OP
INNER JOIN Produtos P ON OP.id_produto = P.id_produto
INNER JOIN Maquinas M ON OP.id_maquina = M.id_maquina
INNER JOIN Funcionarios F ON OP.id_funcionario_autorizacao = F.id_funcionario;

SELECT * FROM Funcionarios WHERE situacao = 'INATIVO';

SELECT responsavel_tecnico, COUNT(*) AS total_produtos
FROM Produtos
GROUP BY responsavel_tecnico;

SELECT * FROM Produtos WHERE nome_comercial LIKE 'S%';

SELECT
    nome_comercial,
    data_criacao,
    TIMESTAMPDIFF(YEAR, data_criacao, CURDATE()) AS idade_produto
FROM Produtos;

CREATE OR REPLACE VIEW vw_relatorio_producao AS
SELECT
    OP.id_ordem,
    P.codigo_interno,
    P.nome_comercial,
    M.nome AS maquina_utilizada,
    F.nome AS funcionario_responsavel,
    OP.status
FROM OrdensProducao OP
LEFT JOIN Produtos P ON OP.id_produto = P.id_produto
LEFT JOIN Maquinas M ON OP.id_maquina = M.id_maquina
LEFT JOIN Funcionarios F ON OP.id_funcionario_autorizacao = F.id_funcionario;

DELIMITER $$

CREATE PROCEDURE sp_registrar_ordem(
    IN p_id_produto INT,
    IN p_id_funcionario INT,
    IN p_id_maquina INT
)
BEGIN
    INSERT INTO OrdensProducao (id_produto, id_maquina, id_funcionario_autorizacao, data_inicio, status)
    VALUES (p_id_produto, p_id_maquina, p_id_funcionario, NOW(), 'EM PRODUÇÃO');

    SELECT 'Ordem registrada com sucesso.' AS mensagem;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_finaliza_ordem
BEFORE UPDATE ON OrdensProducao
FOR EACH ROW
BEGIN
    IF NEW.data_conclusao IS NOT NULL AND OLD.data_conclusao IS NULL THEN
        SET NEW.status = 'FINALIZADA';
    END IF;
END $$

DELIMITER ;
