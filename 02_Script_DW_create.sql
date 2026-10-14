USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name='DW_Association') DROP DATABASE DW_Association;
GO
CREATE DATABASE DW_Association;
GO
USE DW_Association;
GO

-- 1. Dimension Donateur
CREATE TABLE DimDonateur (
    DonateurSK INT PRIMARY KEY IDENTITY(1,1), -- Clé technique
    DonateurID_NK INT,                        -- ID source
    NomDonateur VARCHAR(150),
    TypeDonateur VARCHAR(50),
    Ville VARCHAR(100)
);

-- 2. Dimension Projet
CREATE TABLE DimProjet (
    ProjetSK INT PRIMARY KEY IDENTITY(1,1),
    ProjetID_NK INT,
    NomProjet VARCHAR(150),
    BudgetPrevisionnel DECIMAL(12,2),
    Statut VARCHAR(30)
);

-- 3. Dimension Campagne
CREATE TABLE DimCampagne (
    CampagneSK INT PRIMARY KEY IDENTITY(1,1),
    CampagneID_NK INT,
    NomCampagne VARCHAR(100),
    ObjectifDons DECIMAL(12,2)
);

-- 4. Dimension Temps
CREATE TABLE DimTemps (
    DateSK INT PRIMARY KEY, -- Format YYYYMMDD
    DateComplete DATE,
    Jour INT,
    Mois INT,
    Annee INT,
    NomMois VARCHAR(20)
);

-- 5. Table de Faits : Dons
CREATE TABLE FactDons (
    DonID_NK INT,
    DonateurSK INT FOREIGN KEY REFERENCES DimDonateur(DonateurSK),
    ProjetSK INT FOREIGN KEY REFERENCES DimProjet(ProjetSK),
    CampagneSK INT FOREIGN KEY REFERENCES DimCampagne(CampagneSK),
    DateSK INT FOREIGN KEY REFERENCES DimTemps(DateSK),
    Montant DECIMAL(10,2),
    Canal VARCHAR(50)
);
GO

-- Remplissage automatique de la Dimension Temps
DECLARE @date DATE = '2023-01-01';
DECLARE @end DATE = '2025-12-31';
WHILE @date <= @end BEGIN
    INSERT INTO DimTemps (DateSK, DateComplete, Jour, Mois, Annee, NomMois)
    VALUES (CAST(FORMAT(@date,'yyyyMMdd') AS INT), @date, DAY(@date), MONTH(@date), YEAR(@date), FORMAT(@date, 'MMMM', 'fr-FR'));
    SET @date = DATEADD(DAY, 1, @date);
END
GO
PRINT 'Le Data Warehouse DW_Association est créé et la Dimension Temps est remplie !';