-- =========================================
-- MODELO DE DADOS - E-COMMERCE E LOGÍSTICA
-- =========================================
-- Relacionamentos:
-- clientes (1) -> pedidos (N)
-- pedidos (1) -> itens_pedido (N)
-- produtos (1) -> itens_pedido (N)
-- vendedores (1) -> itens_pedido (N)
-- pedidos (1) -> entregas (1)
-- =========================================

CREATE DATABASE ecommerce_logistica;
USE ecommerce_logistica;

CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    data_cadastro DATE
);

CREATE TABLE produtos (
    produto_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(150),
    categoria VARCHAR(50),
    preco DECIMAL(10,2)
);

CREATE TABLE vendedores (
    vendedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_vendedor VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATE,
    status VARCHAR(30),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE itens_pedido (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    produto_id INT,
    vendedor_id INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores(vendedor_id)
);

CREATE TABLE entregas (
    entrega_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    transportadora VARCHAR(50),
    data_envio DATE,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);