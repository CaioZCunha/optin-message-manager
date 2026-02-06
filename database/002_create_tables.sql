USE optin_manager;
GO

CREATE TABLE optin_messages (
    id INT IDENTITY(1,1) PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL,
    message_text VARCHAR(500) NOT NULL,
    optin_date DATETIME NOT NULL DEFAULT GETDATE(),
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
