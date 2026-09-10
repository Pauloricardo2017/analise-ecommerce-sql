-- =========================================
-- ANÁLISE DE LOGÍSTICA
-- =========================================
USE ecommerce_logistica;

-- 1. Tempo médio de entrega por transportadora
SELECT 
    transportadora,
    ROUND(AVG(DATEDIFF(data_entrega_real, data_envio)), 1) AS media_dias_entrega
FROM entregas
WHERE data_entrega_real IS NOT NULL
GROUP BY transportadora
ORDER BY media_dias_entrega ASC;

-- 2. Taxa de atraso por transportadora
SELECT 
    transportadora,
    COUNT(*) AS total_entregas,
    SUM(CASE WHEN data_entrega_real > data_entrega_prevista THEN 1 ELSE 0 END) AS atrasos,
    ROUND(SUM(CASE WHEN data_entrega_real > data_entrega_prevista THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_atraso
FROM entregas
WHERE data_entrega_real IS NOT NULL
GROUP BY transportadora
ORDER BY pct_atraso ASC;

-- 3. Volume de pedidos por transportadora
SELECT 
    transportadora, 
    COUNT(*) AS total_pedidos
FROM entregas
GROUP BY transportadora
ORDER BY total_pedidos DESC;

-- 4. Top 5 pedidos com maior atraso
SELECT 
    e.pedido_id, 
    e.transportadora,
    DATEDIFF(data_entrega_real, data_entrega_prevista) AS dias_atraso
FROM entregas e
WHERE data_entrega_real IS NOT NULL
  AND data_entrega_real > data_entrega_prevista
ORDER BY dias_atraso DESC
LIMIT 5;

-- 5. Entregas ainda sem confirmação
SELECT 
    COUNT(*) AS entregas_sem_confirmacao
FROM entregas
WHERE data_entrega_real IS NULL;