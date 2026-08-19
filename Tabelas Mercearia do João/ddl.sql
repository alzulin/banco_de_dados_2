-- ==========================================================
-- BANCO DE DADOS - MERCEARIA JOÃO
-- Modelo Relacional - 3FN
-- PostgreSQL
-- ==========================================================

-- Remoção das tabelas (caso existam)
DROP TABLE IF EXISTS itens_venda CASCADE;
DROP TABLE IF EXISTS vendas CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- ==========================================================
-- TABELA CLIENTES
-- ==========================================================

CREATE TABLE clientes (

    id SERIAL PRIMARY KEY,

    nome_cliente VARCHAR(100) NOT NULL,

    cpf_cliente CHAR(11) NOT NULL UNIQUE,

    endereco_cliente VARCHAR(200),

    telefone_cliente VARCHAR(20)

);

COMMENT ON TABLE clientes IS 'Cadastro de clientes';
COMMENT ON COLUMN clientes.cpf_cliente IS 'CPF sem máscara';

-- ==========================================================
-- TABELA PRODUTOS
-- ==========================================================

CREATE TABLE produtos (

    id SERIAL PRIMARY KEY,

    nome_produto VARCHAR(100) NOT NULL,

    quantidade_produto_estoque INTEGER NOT NULL
        CHECK (quantidade_produto_estoque >= 0),

    data_validade_produto DATE NOT NULL

);

COMMENT ON TABLE produtos IS 'Cadastro de produtos';

-- ==========================================================
-- TABELA VENDAS
-- ==========================================================

CREATE TABLE vendas (

    id SERIAL PRIMARY KEY,

    id_cliente INTEGER NOT NULL,

    data_venda DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

COMMENT ON TABLE vendas IS 'Cabeçalho das vendas';

-- ==========================================================
-- TABELA ITENS_VENDA
-- ==========================================================

CREATE TABLE itens_venda (

    id_venda INTEGER NOT NULL,

    id_produto INTEGER NOT NULL,

    quantidade_venda_item INTEGER NOT NULL
        CHECK (quantidade_venda_item > 0),

    valor_venda NUMERIC(10,2) NOT NULL
        CHECK (valor_venda >= 0),

    CONSTRAINT pk_itens_venda
        PRIMARY KEY (id_venda, id_produto),

    CONSTRAINT fk_item_venda
        FOREIGN KEY (id_venda)
        REFERENCES vendas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

COMMENT ON TABLE itens_venda IS 'Itens pertencentes a uma venda';

-- ==========================================================
-- ÍNDICES AUXILIARES
-- ==========================================================

CREATE INDEX idx_vendas_cliente
ON vendas(id_cliente);

CREATE INDEX idx_itens_produto
ON itens_venda(id_produto);

CREATE INDEX idx_produto_nome
ON produtos(nome_produto);

CREATE INDEX idx_cliente_nome
ON clientes(nome_cliente);

-- ==========================================================
-- FIM DO SCRIPT
-- ==========================================================