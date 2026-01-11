
-- DROP, SE NECESSÁRIO, DE ALGUM PROCEDURE

-- IF EXISTS (SELECT 1 from SYS.OBJECTS WHERE TYPE = 'P' AND NAME = 'X')
   -- BEGIN   
     -- DROP PROCEDURE X 
   -- END
-- GO




-- CRIAÇÃO DE PROCEDURE SIMPLES, PARA CONSULTA GERAL DA TABELA

--CREATE PROCEDURE SP_CONSULTAR
--AS
--SELECT * FROM imoveis.dbo.real_estate
--GO

--EXEC SP_CONSULTAR;

-- CRIAÇÃO DE PROCEDURE PARA CONSULTA DE MÊS

--CREATE PROCEDURE SP_CONSULTAR_MES
    --@mes INT
--AS
--BEGIN
    --SELECT *  
    --FROM imoveis.dbo.real_estate
    --WHERE MONTH(X1_date_transaction) = @mes;
--END;
--GO

-- TESTE DO PROCEDURE EXEC SP_CONSULTAR_MES @mes=6;




-- CRIAÇÃO DE FUNCTION PARA PARAMETRIZAR MEDIDA 

--CREATE FUNCTION fn_preco_padronizado()
--RETURNS TABLE
--AS
--RETURN
--(
    --SELECT
        --*,
        --ROUND(Y_house_price_of_unit_area * 10000.0 / 3.3, 2) AS preco_ntd_m2,
        --ROUND(Y_house_price_of_unit_area * 10000.0 / 3.3 * 0.032, 2) AS preco_usd_m2
    --FROM imoveis.dbo.real_estate
--);



-- PROPRIEDADES MAIS NOVA E MAIS ANTIGA
SELECT 
    CONCAT(MIN(X2_house_age), ' anos') AS propriedade_mais_nova, 
    CONCAT(MAX(X2_house_age), ' anos') AS propriedade_mais_antiga,
    CONCAT(AVG(X2_house_age), ' anos') AS media_idade_propriedades
FROM imoveis.dbo.real_estate;



-- MÉDIA DE PREÇO DE ACORDO COM IDADE DAS PROPRIEDADES
SELECT 
    X2_house_age AS idade_anos,
    FORMAT(
        ROUND(AVG(preco_ntd_m2), 2), 'N2'
    ) + ' NTD/m²' AS preco_m2
FROM dbo.fn_preco_padronizado()
GROUP BY X2_house_age
ORDER BY X2_house_age ASC;



-- PREÇO MÁXIMO, MÉDIO E MÍNIMO POR M²
SELECT 
    CONCAT(ROUND(MIN(preco_ntd_m2), 2), ' NTD/m²') AS preco_min_ntd,
    CONCAT(ROUND(MAX(preco_ntd_m2), 2), ' NTD/m²') AS preco_max_ntd,
    CONCAT(ROUND(AVG(preco_ntd_m2), 2), ' NTD/m²') AS preco_medio_ntd
FROM dbo.fn_preco_padronizado();



-- QUANTIDADE DE CASAS POR IDADE
SELECT 
    X2_house_age AS idade_anos,
    COUNT(*) AS quantidade
FROM imoveis.dbo.real_estate
GROUP BY X2_house_age
ORDER BY X2_house_age ASC;



-- MÉDIA DE PREÇO DE PROPRIEDADES DE ACORDO COM A PROXIMIDADE COM ESTAÇÕES DE MRT (MASS RAPID TRANSIT)
SELECT 
    CONCAT(X3_distance_to_the_nearest_MRT_station, ' m') AS distancia_m_MRT,
    FORMAT(
        ROUND(AVG(preco_ntd_m2), 2), 'N2'
    ) + ' NTD/m²' AS preco_m2,
    FORMAT(
        ROUND(AVG(preco_usd_m2), 2), 'N2'
    ) + ' USD/m²' AS preco_usd_m2
FROM dbo.fn_preco_padronizado()
GROUP BY X3_distance_to_the_nearest_MRT_station
ORDER BY X3_distance_to_the_nearest_MRT_station ASC;



-- MÉDIA DE PREÇO DE PROPRIEDADES DE ACORDO COM FAIXAS DE DISTÂNCIA
SELECT
    CASE 
        WHEN X3_distance_to_the_nearest_MRT_station <= 500 THEN '0-500m'
        WHEN X3_distance_to_the_nearest_MRT_station <= 1000 THEN '501-1000m'
        ELSE '1001m+' 
    END AS faixa_distancia,
    FORMAT(
        ROUND(AVG(preco_ntd_m2), 2), 'N2'
    ) + ' NTD/m²' AS preco_m2
FROM dbo.fn_preco_padronizado()
GROUP BY 
    CASE 
        WHEN X3_distance_to_the_nearest_MRT_station <= 500 THEN '0-500m'
        WHEN X3_distance_to_the_nearest_MRT_station <= 1000 THEN '501-1000m'
        ELSE '1001m+' 
    END
ORDER BY preco_m2 DESC;



-- MÉDIA DE PREÇO DE PROPRIEDADES DE ACORDO COM O NÚMERO DE LOJAS DE CONVENIÊNCIA PRÓXIMAS
SELECT
    X4_number_of_convenience_stores AS nmr_lojas,
    FORMAT(
        ROUND(AVG(preco_ntd_m2), 2), 'N2'
    ) + ' NTD/m²' AS preco_m2,
    FORMAT(
        ROUND(AVG(preco_usd_m2), 2), 'N2'
    ) + ' USD/m²' AS preco_usd_m2
FROM dbo.fn_preco_padronizado()
GROUP BY X4_number_of_convenience_stores
ORDER BY nmr_lojas DESC;



-- MESES COM MAIOR NÚMERO DE COMPRAS DE IMÓVEIS
SELECT 
    MONTH(X1_date_transaction) AS mes,
    COUNT(*) AS num_imoveis_adquiridos
FROM imoveis.dbo.real_estate
GROUP BY MONTH(X1_date_transaction)
ORDER BY num_imoveis_adquiridos DESC;