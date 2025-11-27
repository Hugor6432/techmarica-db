# Sistema de Controle de Produção - TechMaricá

Este projeto foi desenvolvido para a matéria de Banco de Dados.  
O objetivo era criar um sistema para controlar a produção da empresa fictícia **TechMaricá Indústria Eletrônica S.A.**

O banco inclui funcionários, produtos, máquinas e ordens de produção.

---

## O que foi feito

### 1. Criação das tabelas
Criei o banco `db_techmarica` e as tabelas:
- Funcionarios  
- Maquinas  
- Produtos  
- OrdensProducao  

Cada tabela tem chave primária, campos obrigatórios e data automática.

---

## 2. Inserção de dados  
Inseri dados fictícios para simular o funcionamento real da fábrica.

---

## 3. Consultas SQL  
Fiz consultas para:
- listar ordens com JOIN  
- filtrar funcionários inativos  
- contar produtos por responsável  
- buscar produtos que começam com S  
- calcular idade dos produtos  

---

## 4. View  
A view `vw_relatorio_producao` mostra um relatório organizado juntando dados de várias tabelas.

---

## 5. Procedure  
A procedure `sp_registrar_ordem` cadastra automaticamente uma nova ordem de produção usando a data atual.

---

## 6. Trigger  
A trigger `trg_finaliza_ordem` muda o status para FINALIZADA quando a data de conclusão é preenchida.

---

## 7. Sobre o DELIMITER  
Eu usei `DELIMITER $$` porque procedures e triggers têm vários pontos e vírgulas dentro delas.  
Então eu mudo o delimitador para $$, escrevo tudo, e depois volto para `;`.

---

## Como rodar o projeto
1. Abra o MySQL Workbench  
2. Cole o conteúdo de `script.sql`  
3. Execute tudo de uma vez  

O sistema estará criado e funcionando.
