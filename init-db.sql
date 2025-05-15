-- init-db.sql
-- This script creates the database if it doesn't exist and initializes basic tables

-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Ecommerce')
BEGIN
    CREATE DATABASE Ecommerce;
END
GO

USE Ecommerce;
GO

-- Create AspNet Identity tables if they don't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetUsers')
BEGIN
    -- This is a simplified version. The actual AspNet Identity tables are more complex.
    -- You might need to run migrations to create proper Identity tables
    CREATE TABLE AspNetUsers (
        Id NVARCHAR(450) PRIMARY KEY,
        UserName NVARCHAR(256) NULL,
        NormalizedUserName NVARCHAR(256) NULL,
        Email NVARCHAR(256) NULL,
        NormalizedEmail NVARCHAR(256) NULL,
        EmailConfirmed BIT NOT NULL,
        PasswordHash NVARCHAR(MAX) NULL,
        SecurityStamp NVARCHAR(MAX) NULL,
        ConcurrencyStamp NVARCHAR(MAX) NULL,
        PhoneNumber NVARCHAR(MAX) NULL,
        PhoneNumberConfirmed BIT NOT NULL,
        TwoFactorEnabled BIT NOT NULL,
        LockoutEnd DATETIMEOFFSET NULL,
        LockoutEnabled BIT NOT NULL,
        AccessFailedCount INT NOT NULL
    );
    
    CREATE TABLE AspNetRoles (
        Id NVARCHAR(450) PRIMARY KEY,
        Name NVARCHAR(256) NULL,
        NormalizedName NVARCHAR(256) NULL,
        ConcurrencyStamp NVARCHAR(MAX) NULL
    );
    
    -- Add more tables as needed...
END
GO

-- Add a test user (optional)
-- INSERT INTO AspNetUsers (Id, UserName, Email, PasswordHash, SecurityStamp, ConcurrencyStamp, EmailConfirmed, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount)
-- VALUES (NEWID(), 'testuser', 'test@example.com', 'AQAAAAIAAYagAAAAELYFKJxGZzj+ZcDCVVqIJh+CanYGGWrTfZq1FnVIlPFWC3HtMY1LAHkiNkiUQdgOUQ==', NEWID(), NEWID(), 1, 0, 0, 0, 0);