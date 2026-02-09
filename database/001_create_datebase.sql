-- ===================================================================
-- Optin Message Manager - Database Creation
-- Descrição: Sistema de gestão de mensagens para contatos opt-in
-- Autor: CaioZCunha
-- Data: 2026-02-09
-- ===================================================================

IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = 'optin_manager'
)
BEGIN
    CREATE DATABASE optin_manager;
    PRINT 'Database optin_manager criado com sucesso!';
END
ELSE
BEGIN
    PRINT 'Database optin_manager já existe.';
END;
GO

USE optin_manager;
GO

PRINT 'Usando database: optin_manager';
GO