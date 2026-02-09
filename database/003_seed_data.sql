-- ===================================================================
-- Optin Message Manager - Dados de Exemplo (SEED)
-- Descrição: Insere dados iniciais para testes
-- ===================================================================

USE optin_manager;
GO

PRINT 'Inserindo dados de exemplo...';
GO

-- ===================================================================
-- SEED: Templates de Mensagem
-- ===================================================================
IF NOT EXISTS (SELECT * FROM templates_mensagem WHERE nome = 'Boas Vindas')
BEGIN
    INSERT INTO templates_mensagem (nome, texto, variaveis, descricao)
    VALUES (
        'Boas Vindas',
        'Olá {{empresa}}! 👋 Seja bem-vindo ao nosso sistema de comunicação. Estamos felizes em ter você conosco!',
        '["empresa"]',
        'Template padrão de boas vindas'
    );
    PRINT '✓ Template "Boas Vindas" inserido';
END;
GO

IF NOT EXISTS (SELECT * FROM templates_mensagem WHERE nome = 'Oferta Especial')
BEGIN
    INSERT INTO templates_mensagem (nome, texto, variaveis, descricao)
    VALUES (
        'Oferta Especial',
        'Olá {{empresa}}! 🎉 Temos uma oferta especial exclusiva para você. Aproveite até {{data_limite}}!',
        '["empresa", "data_limite"]',
        'Template para ofertas promocionais'
    );
    PRINT '✓ Template "Oferta Especial" inserido';
END;
GO

IF NOT EXISTS (SELECT * FROM templates_mensagem WHERE nome = 'Lembrete')
BEGIN
    INSERT INTO templates_mensagem (nome, texto, variaveis, descricao)
    VALUES (
        'Lembrete',
        'Oi {{empresa}}, tudo bem? Este é um lembrete amigável sobre {{assunto}}. Qualquer dúvida, estamos à disposição!',
        '["empresa", "assunto"]',
        'Template para lembretes gerais'
    );
    PRINT '✓ Template "Lembrete" inserido';
END;
GO

-- ===================================================================
-- SEED: Contatos de Exemplo
-- ===================================================================
IF NOT EXISTS (SELECT * FROM contatos WHERE telefone = '5511999999999')
BEGIN
    INSERT INTO contatos (empresa, telefone, opt_in, observacoes)
    VALUES 
        ('Empresa ABC Tecnologia', '5511999999999', 1, 'Cliente Premium'),
        ('XYZ Consultoria Ltda', '5511988888888', 1, 'Parceiro comercial'),
        ('Inovação Tech LTDA', '5511977777777', 1, 'Novo cliente'),
        ('Digital Solutions SA', '5511966666666', 1, NULL),
        ('Smart Business Corp', '5511955555555', 1, 'Lead qualificado');
    
    PRINT '✓ Contatos de exemplo inseridos';
END;
GO

-- ===================================================================
-- SEED: Campanha de Exemplo
-- ===================================================================
DECLARE @template_id INT;
SELECT @template_id = id FROM templates_mensagem WHERE nome = 'Boas Vindas';

IF NOT EXISTS (SELECT * FROM campanhas WHERE nome = 'Campanha de Boas Vindas - Exemplo')
BEGIN
    INSERT INTO campanhas (nome, descricao, template_id, status, total_contatos)
    VALUES (
        'Campanha de Boas Vindas - Exemplo',
        'Campanha inicial de teste do sistema',
        @template_id,
        'RASCUNHO',
        5
    );
    PRINT '✓ Campanha de exemplo criada';
END;
GO

PRINT '===================================================================';
PRINT 'Dados de exemplo inseridos com sucesso!';
PRINT 'Sistema pronto para uso! 🚀';
PRINT '===================================================================';
GO