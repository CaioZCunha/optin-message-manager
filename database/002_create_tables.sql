-- ===================================================================
-- Optin Message Manager - Tabelas do Sistema
-- ===================================================================

USE optin_manager;
GO

-- ===================================================================
-- TABELA: contatos
-- Descrição: Armazena empresas/pessoas que deram opt-in
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'contatos')
BEGIN
    CREATE TABLE contatos (
        id INT IDENTITY(1,1) PRIMARY KEY,
        empresa VARCHAR(255) NOT NULL,
        telefone VARCHAR(20) NOT NULL UNIQUE,
        opt_in BIT NOT NULL DEFAULT 1,
        data_optin DATETIME NOT NULL DEFAULT GETDATE(),
        ativo BIT NOT NULL DEFAULT 1,
        observacoes VARCHAR(500) NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        
        -- Índices
        INDEX idx_telefone (telefone),
        INDEX idx_empresa (empresa),
        INDEX idx_opt_in (opt_in),
        INDEX idx_ativo (ativo)
    );
    PRINT 'Tabela contatos criada com sucesso!';
END;
GO

-- ===================================================================
-- TABELA: templates_mensagem
-- Descrição: Templates de mensagens com variáveis personalizáveis
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'templates_mensagem')
BEGIN
    CREATE TABLE templates_mensagem (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(100) NOT NULL UNIQUE,
        texto VARCHAR(1000) NOT NULL,
        variaveis VARCHAR(200) NULL, -- JSON: ["empresa", "nome"]
        ativo BIT NOT NULL DEFAULT 1,
        descricao VARCHAR(255) NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        
        INDEX idx_nome (nome),
        INDEX idx_ativo (ativo)
    );
    PRINT 'Tabela templates_mensagem criada com sucesso!';
END;
GO

-- ===================================================================
-- TABELA: campanhas
-- Descrição: Agrupa envios de mensagens por campanha
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'campanhas')
BEGIN
    CREATE TABLE campanhas (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nome VARCHAR(200) NOT NULL,
        descricao VARCHAR(500) NULL,
        template_id INT NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'RASCUNHO', -- RASCUNHO, EM_ANDAMENTO, FINALIZADA, CANCELADA
        total_contatos INT DEFAULT 0,
        total_enviados INT DEFAULT 0,
        total_sucesso INT DEFAULT 0,
        total_erro INT DEFAULT 0,
        total_pendente INT DEFAULT 0,
        data_inicio DATETIME NULL,
        data_fim DATETIME NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        
        FOREIGN KEY (template_id) REFERENCES templates_mensagem(id),
        INDEX idx_status (status),
        INDEX idx_template_id (template_id),
        INDEX idx_created_at (created_at)
    );
    PRINT 'Tabela campanhas criada com sucesso!';
END;
GO

-- ===================================================================
-- TABELA: envios
-- Descrição: Log detalhado de cada mensagem enviada
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'envios')
BEGIN
    CREATE TABLE envios (
        id INT IDENTITY(1,1) PRIMARY KEY,
        campanha_id INT NOT NULL,
        contato_id INT NOT NULL,
        telefone VARCHAR(20) NOT NULL,
        mensagem_enviada VARCHAR(1000) NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE', -- PENDENTE, ENVIADO, ERRO, CANCELADO
        erro_descricao VARCHAR(500) NULL,
        tentativas INT DEFAULT 0,
        data_envio DATETIME NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE(),
        
        FOREIGN KEY (campanha_id) REFERENCES campanhas(id),
        FOREIGN KEY (contato_id) REFERENCES contatos(id),
        INDEX idx_campanha_id (campanha_id),
        INDEX idx_contato_id (contato_id),
        INDEX idx_status (status),
        INDEX idx_telefone (telefone),
        INDEX idx_data_envio (data_envio)
    );
    PRINT 'Tabela envios criada com sucesso!';
END;
GO

-- ===================================================================
-- TABELA: optin_messages (compatibilidade com versão anterior)
-- Descrição: Mantida para retrocompatibilidade
-- ===================================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'optin_messages')
BEGIN
    CREATE TABLE optin_messages (
        id INT IDENTITY(1,1) PRIMARY KEY,
        phone_number VARCHAR(20) NOT NULL,
        message_text VARCHAR(500) NOT NULL,
        optin_date DATETIME NOT NULL DEFAULT GETDATE(),
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        
        INDEX idx_phone_number (phone_number)
    );
    PRINT 'Tabela optin_messages criada com sucesso!';
END;
GO

PRINT '===================================================================';
PRINT 'Todas as tabelas foram criadas com sucesso!';
PRINT '===================================================================';
GO