-- =========================================
-- ANÁLISE DE VENDAS
-- =========================================
USE ecommerce_logistica;

-- 1. Faturamento total (considerando apenas pedidos entregues)
SELECT 
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM itens_pedido ip
JOIN pedidos p ON ip.pedido_id = p.pedido_id
WHERE p.status = 'entregue';

-- 2. Ticket médio por pedido
SELECT 
    ROUND(AVG(total_pedido), 2) AS ticket_medio
FROM (
    SELECT ip.pedido_id, SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
    FROM itens_pedido ip
    JOIN pedidos p ON ip.pedido_id = p.pedido_id
    WHERE p.status = 'entregue'
    GROUP BY ip.pedido_id
) AS subtotal;

-- 3. Top 5 produtos mais vendidos (em quantidade)
SELECT 
    pr.nome_produto,
    SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produtos pr ON ip.produto_id = pr.produto_id
GROUP BY pr.nome_produto
ORDER BY total_vendido DESC
LIMIT 5;

-- 4. Faturamento por categoria de produto
SELECT 
    pr.categoria,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento
FROM itens_pedido ip
JOIN produtos pr ON ip.produto_id = pr.produto_id
GROUP BY pr.categoria
ORDER BY faturamento DESC;

-- 5. Faturamento por estado do cliente
SELECT 
    c.estado,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento
FROM itens_pedido ip
JOIN pedidos p ON ip.pedido_id = p.pedido_id
JOIN clientes c ON p.cliente_id = c.cliente_id
GROUP BY c.estado
ORDER BY faturamento DESC;

-- 6. Vendas por mês (evolução ao longo de 2026)
SELECT 
    DATE_FORMAT(p.data_pedido, '%Y-%m') AS mes,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento_mes
FROM itens_pedido ip
JOIN pedidos p ON ip.pedido_id = p.pedido_id
WHERE p.status = 'entregue'
GROUP BY mes
ORDER BY mes;

-- 7. Ranking de vendedores por faturamento
SELECT 
    v.nome_vendedor,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento,
    RANK() OVER (ORDER BY SUM(ip.quantidade * ip.preco_unitario) DESC) AS ranking
FROM itens_pedido ip
JOIN vendedores v ON ip.vendedor_id = v.vendedor_id
GROUP BY v.nome_vendedor
ORDER BY faturamento DESC;

-- 8. Taxa de cancelamento de pedidos
SELECT 
    status,
    COUNT(*) AS total,
    ROUND(COUNT() * 100.0 / (SELECT COUNT() FROM pedidos), 2) AS percentual
FROM pedidos
GROUP BY status;

-- 9. Top 5 clientes por valor gasto (RFM simplificado - Valor)
SELECT 
    c.nome,
    COUNT(DISTINCT p.pedido_id) AS qtd_pedidos,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS total_gasto
FROM itens_pedido ip
JOIN pedidos p ON ip.pedido_id = p.pedido_id
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE p.status = 'entregue'
GROUP BY c.nome
ORDER BY total_gasto DESC
LIMIT 5;

-- 10. Média móvel de faturamento mensal (usando window function)
SELECT 
    mes,
    faturamento_mes,
    ROUND(AVG(faturamento_mes) OVER (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS media_movel_3_meses
FROM (
    SELECT 
        DATE_FORMAT(p.data_pedido, '%Y-%m') AS mes,
        SUM(ip.quantidade * ip.preco_unitario) AS faturamento_mes
    FROM itens_pedido ip
    JOIN pedidos p ON ip.pedido_id = p.pedido_id
    WHERE p.status = 'entregue'
    GROUP BY mes
) AS vendas_mensais
ORDER BY mes;