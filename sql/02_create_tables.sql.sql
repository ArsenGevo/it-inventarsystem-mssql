USE IT_Inventarsystem;
GO

CREATE TABLE dbo.Hersteller (
    hersteller_id INT IDENTITY(1,1) PRIMARY KEY,
    herstellername VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE dbo.Geraetetyp(
    geraetetyp_id INT IDENTITY(1,1) PRIMARY KEY,
    bezeichnung VARCHAR(60) UNIQUE NOT NULL,
    beschreibung VARCHAR(255) NULL
);
GO

CREATE TABLE dbo.Geraetezustand (
    zustand_id INT IDENTITY(1,1) PRIMARY KEY,
    bezeichnung VARCHAR(60) UNIQUE NOT NULL,
    beschreibung VARCHAR(255) NULL
);
GO

CREATE TABLE dbo.Schulungsraum (
    raum_id INT IDENTITY(1,1) PRIMARY KEY,
    raumbezeichnung VARCHAR(20) UNIQUE NOT NULL,
    anzahl_arbeitsplaetze SMALLINT NOT NULL,
    
    CONSTRAINT CK_Schulungsraum_Arbeitsplaetze
    CHECK (anzahl_arbeitsplaetze >= 0)
);
GO

CREATE TABLE dbo.Geraet (
    geraet_id INT IDENTITY(1,1) PRIMARY KEY,
    geraetenummer VARCHAR(30) UNIQUE NOT NULL,
    bezeichnung VARCHAR(100) NOT NULL,
    modell VARCHAR(100) NULL,
    seriennummer VARCHAR(60) NULL,
    anschaffungsdatum DATE NULL,
    hersteller_id INT NOT NULL,
    geraetetyp_id INT NOT NULL,
    zustand_id INT NOT NULL,
    raum_id INT NULL,

    CONSTRAINT FK_Geraet_Hersteller
        FOREIGN KEY (hersteller_id)
        REFERENCES Hersteller(hersteller_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Geraet_Geraetetyp
        FOREIGN KEY (geraetetyp_id)
        REFERENCES Geraetetyp(geraetetyp_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Geraet_Geraetezustand
        FOREIGN KEY (zustand_id)
        REFERENCES Geraetezustand(zustand_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,

    CONSTRAINT FK_Geraet_Schulungsraum
        FOREIGN KEY (raum_id)
        REFERENCES Schulungsraum(raum_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);
GO

CREATE UNIQUE INDEX UX_Geraet_Seriennummer
ON Geraet(seriennummer)
WHERE seriennummer IS NOT NULL;
GO

