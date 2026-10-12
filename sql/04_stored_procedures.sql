USE IT_Inventarsystem;
GO
-- -------------------------------------------------------------
-- Auswertung 1. Geräte in einem bestimmten Schulungsraum
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetGeraeteNachRaum
    @Raumbezeichnung VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        g.geraetenummer AS Geraetenummer,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        r.raumbezeichnung AS Raum
    FROM dbo.Geraet g
    JOIN dbo.Hersteller h
        ON g.hersteller_id = h.hersteller_id
    JOIN dbo.Schulungsraum r
        ON g.raum_id = r.raum_id
    WHERE r.raumbezeichnung = @Raumbezeichnung
    ORDER BY g.geraetenummer;
END;
GO
-- Test:
-- EXEC dbo.GetGeraeteNachRaum @Raumbezeichnung = 'Lager';

-- -------------------------------------------------------------
-- Auswertung 2. Welche Geräte sind derzeit defekt?
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetDefekteGeraete
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        g.geraetenummer AS Geraetenummer,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        z.bezeichnung AS Zustand,
        r.raumbezeichnung AS Raum
        FROM dbo.Geraet g
        JOIN dbo.Geraetezustand z ON g.zustand_id = z.zustand_id
        JOIN dbo.Hersteller h ON g.hersteller_id = h.hersteller_id
        LEFT JOIN dbo.Schulungsraum r ON g.raum_id = r.raum_id
        WHERE z.bezeichnung = 'defekt'
        ORDER BY g.geraetenummer;
END;
GO

-- Test:
-- EXEC dbo.GetDefekteGeraete;

-- -------------------------------------------------------------
-- Auswertung 3. Welche Geräte sind derzeit in Reparatur?
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetGeraeteInReparatur
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        g.geraetenummer AS Geraetenummer,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        z.bezeichnung AS Zustand,
        r.raumbezeichnung AS Raum
    FROM dbo.Geraet g
    JOIN dbo.Geraetezustand z 
        ON g.zustand_id = z.zustand_id
    JOIN dbo.Hersteller h 
        ON g.hersteller_id = h.hersteller_id
    LEFT JOIN dbo.Schulungsraum r 
        ON g.raum_id = r.raum_id
    WHERE z.bezeichnung = 'in Reparatur'
    ORDER BY g.geraetenummer;
END;
GO

--Test
EXEC dbo.GetGeraeteInReparatur;

-- -------------------------------------------------------------
-- Auswertung 4. Welche Geräte stammen von einem bestimmten Hersteller?
-- -------------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.GetGeraeteNachHersteller
@Herstellername VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        g.geraetenummer AS Geraetenummer,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        r.raumbezeichnung AS Raum
        FROM dbo.Geraet g
        JOIN dbo.Hersteller h ON g.hersteller_id = h.hersteller_id
        LEFT JOIN dbo.Schulungsraum r ON g.raum_id = r.raum_id
        WHERE h.herstellername = @Herstellername
        ORDER BY g.geraetenummer;
END;
GO

--Test 
--EXEC dbo.GetGeraeteNachHersteller @Herstellername = 'Dell';


-- -------------------------------------------------------------
-- Auswertung 5. Welche PCs befinden sich in einem bestimmten Schulungsraum?
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetPCsNachRaum
    @Raumbezeichnung VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        g.geraetenummer AS Geraetenummer,
        t.bezeichnung AS Geraetetyp,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        z.bezeichnung AS Zustand,
        r.raumbezeichnung AS Raum
    FROM dbo.Geraet g
    JOIN dbo.Hersteller h
        ON g.hersteller_id = h.hersteller_id
    JOIN dbo.Schulungsraum r
        ON g.raum_id = r.raum_id
    JOIN dbo.Geraetetyp t 
        ON g.geraetetyp_id = t.geraetetyp_id
    JOIN dbo.Geraetezustand z
        ON g.zustand_id = z.zustand_id
    WHERE r.raumbezeichnung = @Raumbezeichnung 
        AND t.bezeichnung = 'PC'
    ORDER BY g.geraetenummer;
END;
GO

--Test 
EXEC dbo.GetPCsNachRaum
    @Raumbezeichnung = 'Lager';
GO

-- -------------------------------------------------------------
-- Auswertung 6. Welche PCs befinden sich in einem bestimmten Schulungsraum?
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetAnzahlGeraeteJeRaum
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.raumbezeichnung AS Raum,
        COUNT(g.geraet_id) AS Anzahl_Geraete
        FROM dbo.Schulungsraum r
    LEFT JOIN dbo.Geraet g 
        ON g.raum_id = r.raum_id
    GROUP BY r.raumbezeichnung
    ORDER BY r.raumbezeichnung;
END;
GO

--Test 
EXEC dbo.GetAnzahlGeraeteJeRaum;
GO

-- -------------------------------------------------------------
-- Auswertung 7. Anzahl der Geräte je Gerätetyp
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetAnzahlGeraeteJeTyp
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.bezeichnung AS Geraetetyp,
        COUNT(g.geraet_id) AS Anzahl_Geraete
    FROM dbo.Geraetetyp t
    LEFT JOIN dbo.Geraet g
        ON t.geraetetyp_id = g.geraetetyp_id
    GROUP BY
        t.geraetetyp_id,
        t.bezeichnung
    ORDER BY
        t.bezeichnung;
END;
GO

--Test 
EXEC dbo.GetAnzahlGeraeteJeTyp;
GO

-- -------------------------------------------------------------
-- Auswertung 8. Anzahl defekter Geräte je Schulungsraum.
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetAnzahlDefekteGeraeteJeRaum
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.raumbezeichnung AS Raum,
        SUM(
            CASE
                WHEN z.bezeichnung = 'defekt' THEN 1
                ELSE 0
            END
        ) AS Anzahl_Defekte_Geraete
    FROM dbo.Schulungsraum r
    LEFT JOIN dbo.Geraet g
        ON g.raum_id = r.raum_id
    LEFT JOIN dbo.Geraetezustand z
        ON g.zustand_id = z.zustand_id
    GROUP BY
        r.raum_id,
        r.raumbezeichnung
    ORDER BY
        r.raumbezeichnung;
END;
GO

--Test 
EXEC dbo.GetAnzahlDefekteGeraeteJeRaum;
GO

-- -------------------------------------------------------------
-- Auswertung 9. Schulungsraum mit den meisten Geräten.
-- -------------------------------------------------------------

 CREATE OR ALTER PROCEDURE dbo.GetRaumMitMeistenGeraeten
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 WITH TIES
        r.raumbezeichnung AS Raum,
        COUNT(g.geraet_id) AS Anzahl_Geraete
    FROM dbo.Schulungsraum r
    LEFT JOIN dbo.Geraet g
        ON g.raum_id = r.raum_id
    GROUP BY
        r.raum_id,
        r.raumbezeichnung
    ORDER BY
        COUNT(g.geraet_id) DESC;
END;
GO

-- Test
EXEC dbo.GetRaumMitMeistenGeraeten;
GO

-- -------------------------------------------------------------
-- Auswertung 10: Hersteller mit den meisten Geräten.
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetHerstellerMitMeistenGeraeten
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 WITH TIES
        h.herstellername AS Hersteller,
        COUNT(g.geraet_id) AS Anzahl_Geraete
    FROM dbo.Hersteller h
    LEFT JOIN dbo.Geraet g
        ON h.hersteller_id = g.hersteller_id
    GROUP BY
        h.hersteller_id,
        h.herstellername
    ORDER BY
        COUNT(g.geraet_id) DESC;
END;
GO

-- Test
EXEC dbo.GetHerstellerMitMeistenGeraeten;
GO

-- -------------------------------------------------------------
-- Auswertung 11: Geräte, die vor einem bestimmten Datum angeschafft wurden.
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetGeraeteVorDatum
    @Stichtag DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @Stichtag IS NULL
    BEGIN
        ;THROW 50001, 'Der Stichtag darf nicht NULL sein.', 1;
    END;

    SELECT
        g.anschaffungsdatum AS Anschaffungsdatum,
        g.geraetenummer AS Geraetenummer,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        r.raumbezeichnung AS Raum
    FROM dbo.Geraet g
    JOIN dbo.Hersteller h
        ON g.hersteller_id = h.hersteller_id
    LEFT JOIN dbo.Schulungsraum r
        ON g.raum_id = r.raum_id
    WHERE g.anschaffungsdatum < @Stichtag
    ORDER BY
        g.anschaffungsdatum,
        g.geraetenummer;
END;
GO

-- Test
EXEC dbo.GetGeraeteVorDatum
    @Stichtag = '2020-01-01';
GO

-- -------------------------------------------------------------
-- Auswertung 12 — Räume, die keinen bestimmten Gerätetyp besitzen.
-- -------------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.GetRaeumeOhneGeraetetyp
    @Geraetetyp VARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @GeraetetypId INT;

    SELECT @GeraetetypId = geraetetyp_id
    FROM dbo.Geraetetyp
    WHERE bezeichnung = @Geraetetyp;

    IF @GeraetetypId IS NULL
    BEGIN
        ;THROW 50002, 'Der angegebene Gerätetyp existiert nicht.', 1;
    END;

    SELECT
        r.raumbezeichnung AS Raum
    FROM dbo.Schulungsraum r
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Geraet g
        WHERE g.raum_id = r.raum_id
          AND g.geraetetyp_id = @GeraetetypId
    )
    ORDER BY r.raumbezeichnung;
END;
GO

-- Test
EXEC dbo.GetRaeumeOhneGeraetetyp
    @Geraetetyp = 'PC';
GO

-- -------------------------------------------------------------
-- Auswertung 3.1 Welche Geräte sind derzeit in Reparatur?
-- -------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.GetGeraeteNachZustand
@Geraetezustand VARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        g.geraetenummer AS Geraetenummer,
        g.bezeichnung AS Geraet,
        h.herstellername AS Hersteller,
        g.modell AS Modell,
        z.bezeichnung AS Zustand,
        r.raumbezeichnung AS Raum
        FROM dbo.Geraet g
        JOIN dbo.Geraetezustand z ON g.zustand_id = z.zustand_id
        JOIN dbo.Hersteller h ON g.hersteller_id = h.hersteller_id
        LEFT JOIN dbo.Schulungsraum r ON g.raum_id = r.raum_id
        WHERE z.bezeichnung = @Geraetezustand
        ORDER BY g.geraetenummer;
END;
GO

--Test
--EXEC dbo.GetGeraeteNachZustand @Geraetezustand = 'in Reparatur';
