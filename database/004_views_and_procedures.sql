-- ===================================================================
-- Optin Message Manager - Views e Procedures
-- Descrição: Views para relatórios e procedures úteis
-- ===================================================================

USE optin_manager;
GO

-- ===================================================================
-- VIEW: vw_estatisticas_gerais
-- Descrição: Estatísticas gerais do sistema
-- ===================================================================
IF OBJECT_ID('vw_estatisticas_gerais', 'V') IS NOT NULL
    DROP VIEW vw_estatisticas_gerais;
GO

CREATE VIEW vw_estatisticas_gerais AS
SELECT 
    (SELECT COUNT(*) FROM contatos WHERE ativo = 1 AND opt_in = 1) AS total_contatos_ativos,
    (SELECT COUNT(*) FROM templates_mensagem WHERE ativo = 1) AS total_templates_ativos,
    (SELECT COUNT(*) FROM campanhas) AS total_campanhas,
    (SELECT COUNT(*) FROM campanhas WHERE status = 'EM_ANDAMENTO') AS campanhas_em_andamento,
    (SELECT COUNT(*) FROM envios) AS total_envios,
    (SELECT COUNT(*) FROM envios WHERE status = 'ENVIADO') AS total_envios_sucesso,
    (SELECT COUNT(*) FROM envios WHERE status = 'ERRO') AS total_envios_erro,
    (SELECT COUNT(*) FROM envios WHERE status = 'PENDENTE') AS total_envios_pendentes,
    CASE 
        WHEN (SELECT COUNT(*) FROM envios) > 0 
        THEN CAST((SELECT COUNT(*) FROM envios WHERE status = 'ENVIADO') AS FLOAT) / (SELECT COUNT(*) FROM envios) * 100
        ELSE 0 
    END AS taxa_sucesso_percentual;
GO

PRINT '✓ View vw_estatisticas_gerais criada';
GO

-- ===================================================================
-- VIEW: vw_campanhas_detalhadas
-- Descrição: Campanhas com informações do template
-- ===================================================================
IF OBJECT_ID('vw_campanhas_detalhadas', 'V') IS NOT NULL
    DROP VIEW vw_campanhas_detalhadas;
GO

CREATE VIEW vw_campanhas_detalhadas AS
SELECT 
    c.id,
    c.nome AS campanha_nome,
    c.descricao AS campanha_descricao,
    c.status,
    t.nome AS template_nome,
    t.texto AS template_texto,
    c.total_contatos,
    c.total_enviados,
    c.total_sucesso,
    c.total_erro,
    c.total_pendente,
    CASE 
        WHEN c.total_enviados > 0 
        THEN CAST(c.total_sucesso AS FLOAT) / c.total_enviados * 100
        ELSE 0 
    END AS taxa_sucesso_percentual,
    c.data_inicio,
    c.data_fim,
    c.created_at,
    c.updated_at
FROM campanhas c
INNER JOIN templates_mensagem t ON c.template_id = t.id;
GO

PRINT '✓ View vw_campanhas_detalhadas criada';
GO

-- ===================================================================
-- PROCEDURE: sp_atualizar_estatisticas_campanha
-- Descrição: Atualiza contadores de uma campanha
-- ===================================================================
IF OBJECT_ID('sp_atualizar_estatisticas_campanha', 'P') IS NOT NULL
    DROP PROCEDURE sp_atualizar_estatisticas_campanha;
GO

CREATE PROCEDURE sp_atualizar_estatisticas_campanha
    @campanha_id INT
AS
BEGIN
    UPDATE campanhas
    SET 
        total_enviados = (SELECT COUNT(*) FROM envios WHERE campanha_id = @campanha_id AND status IN ('ENVIADO', 'ERRO')),
        total_sucesso = (SELECT COUNT(*) FROM envios WHERE campanha_id = @campanha_id AND status = 'ENVIADO'),
        total_erro = (SELECT COUNT(*) FROM envios WHERE campanha_id = @campanha_id AND status = 'ERRO'),
        total_pendente = (SELECT COUNT(*) FROM envios WHERE campanha_id = @campanha_id AND status = 'PENDENTE'),
        updated_at = GETDATE()
    WHERE id = @campanha_id;
END;
GO

PRINT '✓ Procedure sp_atualizar_estatisticas_campanha criada';
GO

PRINT '===================================================================';
PRINT 'Views e Procedures criados com sucesso!';
PRINT '===================================================================';
GO