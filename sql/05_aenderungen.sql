-- =====================================================
-- Projektphase 6: Änderungen am Gerätebestand
-- =====================================================

USE IT_Inventarsystem;
GO

-- =====================================================
-- 1. Ein Neues Geraet aufnehmen
-- =====================================================

DECLARE @HerstellerId INT;
DECLARE @GeraetetypId INT;
DECLARE @ZustandId INT;
DECLARE @RaumId INT;

SELECT @HerstellerId = hersteller_id
FROM dbo.Hersteller
WHERE herstellername = 'Dell';

SELECT @GeraetetypId = geraetetyp_id
FROM dbo.Geraetetyp
WHERE bezeichnung = 'Notebook';

SELECT @ZustandId = zustand_id
FROM dbo.Geraetezustand
WHERE bezeichnung = 'einsatzbereit';

SELECT @RaumId = raum_id
FROM dbo.Schulungsraum
WHERE raumbezeichnung = 'E.1';

-- Benötigte Fremdschlüssel prüfen
IF @HerstellerId IS NULL
BEGIN
    ;THROW 50013, 
        'Der Hersteller "Dell" existiert nicht.', 
        1;
END;

IF @GeraetetypId IS NULL
BEGIN
    ;THROW 50014, 
        'Der Gerätetyp "Notebook" existiert nicht.', 
        1;
END;

IF @ZustandId IS NULL
BEGIN
    ;THROW 50015, 
        'Der Gerätezustand "einsatzbereit" existiert nicht.', 
        1;
END;

IF @RaumId IS NULL
BEGIN
    ;THROW 50016, 
        'Der Schulungsraum "E.1" existiert nicht.', 
        1;
END;


INSERT INTO dbo.Geraet (
    geraetenummer,
    bezeichnung,
    modell,
    seriennummer,
    anschaffungsdatum,
    hersteller_id,
    geraetetyp_id,
    zustand_id,
    raum_id
)
VALUES (
    'CDT-400',
    'Schulungsnotebook',
    'Latitude 5440',
    'DELL-CDT400',
    '2026-09-01',
    @HerstellerId,
    @GeraetetypId,
    @ZustandId,
    @RaumId
);
GO

--Test:
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    h.herstellername,
    t.bezeichnung AS Geraetetyp,
    z.bezeichnung AS Zustand,
    r.raumbezeichnung AS Raum
FROM dbo.Geraet g
JOIN dbo.Hersteller h
    ON g.hersteller_id = h.hersteller_id
JOIN dbo.Geraetetyp t
    ON g.geraetetyp_id = t.geraetetyp_id
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
LEFT JOIN dbo.Schulungsraum r
    ON g.raum_id = r.raum_id
WHERE g.geraetenummer = 'CDT-400';
GO

-- =====================================================
-- 2. Daten eines vorhandenen Gerätes ändern
-- Beispiel: Anschaffungsdatum von SW-004 korrigieren
-- =====================================================

-- Aktuellen Datensatz prüfen (Ausgangssituation)
SELECT
    geraetenummer,
    bezeichnung,
    modell,
    anschaffungsdatum
FROM dbo.Geraet
WHERE geraetenummer = 'SW-004';
GO

-- Anschaffungsdatum ändern
UPDATE dbo.Geraet
SET anschaffungsdatum = '2019-01-15'
WHERE geraetenummer = 'SW-004';

IF @@ROWCOUNT = 0
BEGIN
    ;THROW 50017,
        'Das Gerät mit der eingegebene Gerätenummer wurde nicht gefunden.',
        1;
END;
GO

-- Änderung kontrollieren
SELECT
    geraetenummer,
    bezeichnung,
    modell,
    anschaffungsdatum
FROM dbo.Geraet
WHERE geraetenummer = 'SW-004';
GO

-- =====================================================
-- 3. Gerät in einen anderen Schulungsraum verschieben
-- Beispiel: CDT-331 nach E.2 verschieben
-- =====================================================


-- Aktuellen Datensatz prüfen
SELECT
    geraetenummer,
    bezeichnung,
    modell,
    r.raumbezeichnung AS raum
FROM dbo.Geraet g
LEFT JOIN dbo.Schulungsraum r
    ON g.raum_id = r.raum_id
WHERE geraetenummer = 'CDT-331';
GO

-- Zielraum ermitteln und prüfen
DECLARE @ZielRaumId INT;

SELECT @ZielRaumId = raum_id
FROM dbo.Schulungsraum
WHERE raumbezeichnung = 'E.2';

IF @ZielRaumId IS NULL
BEGIN
    ;THROW 50003, 'Der angegebene Zielraum existiert nicht.', 1;
END;

-- Gerät in einen anderen Schulungsraum verschieben
UPDATE dbo.Geraet
SET raum_id = @ZielRaumId
WHERE geraetenummer = 'CDT-331';

IF @@ROWCOUNT = 0
BEGIN
    ;THROW 50018,
        'Das Gerät mit der angegebenen Gerätenummer wurde nicht gefunden.',
        1;
END;
GO

-- Änderung kontrollieren
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    r.raumbezeichnung AS raum
FROM dbo.Geraet g
LEFT JOIN dbo.Schulungsraum r
    ON g.raum_id = r.raum_id
WHERE geraetenummer = 'CDT-331';
GO

-- =====================================================
-- 4. Zustand eines Gerätes auf "defekt" setzen
-- Beispiel: CDT-301
-- =====================================================

-- Aktuellen Datensatz prüfen
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    g.seriennummer,
    z.bezeichnung AS Zustand
FROM dbo.Geraet g
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
WHERE g.geraetenummer = 'CDT-301';
GO


-- Zielzustand ermitteln
DECLARE @ZielZustandId INT;

SELECT @ZielZustandId = zustand_id
FROM dbo.Geraetezustand
WHERE bezeichnung = 'defekt';

-- Prüfen, ob der Zielzustand existiert
IF @ZielZustandId IS NULL
BEGIN
    ;THROW 50005, 
        'Der angegebenen Gerätezustand existiert nicht.', 
        1;
END;

-- Zustand ändern
UPDATE dbo.Geraet
SET zustand_id = @ZielZustandId
WHERE geraetenummer = 'CDT-301';

-- Prüfen, ob das Gerät gefunden wurde
IF @@ROWCOUNT = 0
BEGIN
    ;THROW 50006, 
        'Das Gerät mit der angegebenen Gerätenummer wurde nicht gefunden.', 
        1;
END;

-- Änderung kontrollieren
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    g.seriennummer,
    z.bezeichnung AS Zustand
FROM dbo.Geraet g
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
WHERE g.geraetenummer = 'CDT-301';
GO

-- =====================================================
-- 5. Repariertes Gerät wieder als "einsatzbereit"
--    kennzeichnen
-- Beispiel: PRN-003
-- =====================================================

-- Aktuellen Datensatz prüfen
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    g.seriennummer,
    z.bezeichnung AS Zustand
FROM dbo.Geraet g
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
WHERE g.geraetenummer = 'PRN-003';
GO


-- Benötigte Zustände ermitteln
DECLARE @ZielZustandId INT;
DECLARE @InReparaturZustandId INT;

SELECT @ZielZustandId = zustand_id
FROM dbo.Geraetezustand
WHERE bezeichnung = 'einsatzbereit';

SELECT @InReparaturZustandId = zustand_id
FROM dbo.Geraetezustand
WHERE bezeichnung = 'in Reparatur';


-- Prüfen, ob die benötigten Zustände existieren
IF @ZielZustandId IS NULL
BEGIN
    ;THROW 50007,
        'Der Gerätezustand "einsatzbereit" existiert nicht.',
        1;
END;

IF @InReparaturZustandId IS NULL
BEGIN
    ;THROW 50008,
        'Der Gerätezustand "in Reparatur" existiert nicht.',
        1;
END;


-- Zustand ändern
UPDATE dbo.Geraet
SET zustand_id = @ZielZustandId
WHERE geraetenummer = 'PRN-003'
  AND zustand_id = @InReparaturZustandId;


-- Prüfen, ob die Änderung durchgeführt wurde
IF @@ROWCOUNT = 0
BEGIN
    ;THROW 50009,
        'Das angegebene Gerät wurde nicht gefunden oder befindet sich nicht in Reparatur.',
        1;
END;


-- Änderung kontrollieren
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    g.seriennummer,
    z.bezeichnung AS Zustand
FROM dbo.Geraet g
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
WHERE g.geraetenummer = 'PRN-003';
GO

-- =====================================================
-- 6. Gerät als "ausgesondert" kennzeichnen
--    und ins Lager verschieben
-- Beispiel: CDT-322
-- =====================================================

-- Aktuellen Datensatz prüfen
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    g.seriennummer,
    z.bezeichnung AS Zustand,
    r.raumbezeichnung AS Raum
FROM dbo.Geraet g
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
LEFT JOIN dbo.Schulungsraum r
    ON g.raum_id = r.raum_id
WHERE g.geraetenummer = 'CDT-322';
GO


-- Benötigte Fremdschlüssel ermitteln
DECLARE @ZielZustandId INT;
DECLARE @LagerRaumId INT;

SELECT @ZielZustandId = zustand_id
FROM dbo.Geraetezustand
WHERE bezeichnung = 'ausgesondert';

SELECT @LagerRaumId = raum_id
FROM dbo.Schulungsraum
WHERE raumbezeichnung = 'Lager';


-- Prüfen, ob der benötigte Zustand existiert
IF @ZielZustandId IS NULL
BEGIN
    ;THROW 50010,
        'Der Gerätezustand "ausgesondert" existiert nicht.',
        1;
END;

-- Prüfen, ob der Lagerraum existiert
IF @LagerRaumId IS NULL
BEGIN
    ;THROW 50011,
        'Der Schulungsraum "Lager" existiert nicht.',
        1;
END;


-- Gerät als ausgesondert kennzeichnen
-- und ins Lager verschieben
UPDATE dbo.Geraet
SET
    zustand_id = @ZielZustandId,
    raum_id = @LagerRaumId
WHERE geraetenummer = 'CDT-322';


-- Prüfen, ob das Gerät gefunden wurde
IF @@ROWCOUNT = 0
BEGIN
    ;THROW 50012,
        'Das Gerät mit der angegebenen Gerätenummer wurde nicht gefunden.',
        1;
END;


-- Änderung kontrollieren
SELECT
    g.geraetenummer,
    g.bezeichnung,
    g.modell,
    g.seriennummer,
    z.bezeichnung AS Zustand,
    r.raumbezeichnung AS Raum
FROM dbo.Geraet g
JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id
LEFT JOIN dbo.Schulungsraum r
    ON g.raum_id = r.raum_id
WHERE g.geraetenummer = 'CDT-322';
GO


