-- Criação do banco de dados Optin Message Manager
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = 'optin_manager'
)
BEGIN
    CREATE DATABASE optin_manager;
END;
GO
