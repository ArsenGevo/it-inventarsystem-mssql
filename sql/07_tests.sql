USE IT_Inventarsystem;
GO 

-- =====================================================
-- Testfall 1: Neues Gerät korrekt speichern
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


BEGIN TRY
    BEGIN TRANSACTION;

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
        'TEST-001',
        'Testnotebook',
        'Testmodell',
        'TEST-SN-001',
        '2026-10-01',
        @HerstellerId,
        @GeraetetypId,
        @ZustandId,
        @RaumId
    );

    IF EXISTS (
        SELECT 1
        FROM dbo.Geraet
        WHERE geraetenummer = 'TEST-001'
          AND hersteller_id = @HerstellerId
          AND geraetetyp_id = @GeraetetypId
          AND zustand_id = @ZustandId
          AND raum_id = @RaumId
    )
    BEGIN
        PRINT 'TEST 1 BESTANDEN: Gerät wurde korrekt gespeichert.';
    END
    ELSE
    BEGIN
        ;THROW 51001,
            'TEST 1 FEHLGESCHLAGEN: Gerät wurde nicht korrekt gespeichert.',
            1;
    END;

    ROLLBACK TRANSACTION;
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

-- =====================================================
-- Testfall 2:
-- Fremdschlüsselbeziehung beim Löschen prüfen
-- =====================================================

BEGIN TRY
    BEGIN TRANSACTION;

    DELETE FROM dbo.Hersteller
    WHERE herstellername = 'Dell';

    -- Falls das DELETE unerwartet funktioniert:
    PRINT 'TEST 2 FEHLGESCHLAGEN: Referenzierter Hersteller konnte gelöscht werden.';

    ROLLBACK TRANSACTION;
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF ERROR_NUMBER() = 547
    BEGIN
        PRINT 'TEST 2 BESTANDEN: Fremdschlüssel verhindert das Löschen eines referenzierten Herstellers.';
    END
    ELSE
    BEGIN
        ;THROW;
    END;
END CATCH;
GO

-- =====================================================
-- Testfall 3:
-- Ungültige Raumzuordnung verhindern
-- =====================================================

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Geraet
    SET raum_id = 9999
    WHERE geraetenummer = 'CDT-331';

    PRINT 'TEST 3 FEHLGESCHLAGEN: Ungültige Raumzuordnung wurde akzeptiert.';

    ROLLBACK TRANSACTION;
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF ERROR_NUMBER() = 547
    BEGIN
        PRINT 'TEST 3 BESTANDEN: Ungültige Raumzuordnung wurde durch den Fremdschlüssel verhindert.';
    END
    ELSE
    BEGIN
        ;THROW;
    END;
END CATCH;
GO

-- =====================================================
-- Testfall 4:
-- Änderung eines vorhandenen Gerätes prüfen
-- =====================================================

DECLARE @AltesDatum DATE;

SELECT @AltesDatum = anschaffungsdatum
FROM dbo.Geraet
WHERE geraetenummer = 'SW-004';

IF @AltesDatum IS NULL
BEGIN
    ;THROW 51004,
        'TEST 4 kann nicht durchgeführt werden: Gerät wurde nicht gefunden oder Anschaffungsdatum ist NULL.',
        1;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Geraet
    SET anschaffungsdatum = '2000-01-01'
    WHERE geraetenummer = 'SW-004';

    IF EXISTS (
        SELECT 1
        FROM dbo.Geraet
        WHERE geraetenummer = 'SW-004'
          AND anschaffungsdatum = '2000-01-01'
    )
    BEGIN
        PRINT 'TEST 4 BESTANDEN: Änderung wurde korrekt übernommen.';
    END
    ELSE
    BEGIN
        ;THROW 51005,
            'TEST 4 FEHLGESCHLAGEN: Änderung wurde nicht korrekt übernommen.',
            1;
    END;

    ROLLBACK TRANSACTION;
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

-- =====================================================
-- Testfall 5:
-- Ergebnis der Stored Procedure GetDefekteGeraete prüfen
-- =====================================================
DROP TABLE IF EXISTS #TestDefekteGeraete;

CREATE TABLE #TestDefekteGeraete (
    Geraetenummer VARCHAR(30),
    Geraet VARCHAR(100),
    Hersteller VARCHAR(60),
    Modell VARCHAR(100),
    Zustand VARCHAR(60),
    Raum VARCHAR(20)
);

INSERT INTO #TestDefekteGeraete
EXEC dbo.GetDefekteGeraete;


-- Prüfen, ob Ergebnisse vorhanden sind
IF NOT EXISTS (
    SELECT 1
    FROM #TestDefekteGeraete
)
BEGIN
    ;THROW 51006,
        'TEST 5 FEHLGESCHLAGEN: Die Abfrage lieferte keine Ergebnisse.',
        1;
END;


-- Prüfen, ob ausschließlich defekte Geräte ausgegeben werden
IF EXISTS (
    SELECT 1
    FROM #TestDefekteGeraete
    WHERE Zustand <> 'defekt'
       OR Zustand IS NULL
)
BEGIN
    ;THROW 51007,
        'TEST 5 FEHLGESCHLAGEN: Die Abfrage enthält Geräte mit einem falschen Zustand.',
        1;
END;

PRINT 'TEST 5 BESTANDEN: Die Abfrage liefert ausschließlich Geräte mit dem Zustand "defekt".';

DROP TABLE #TestDefekteGeraete;
GO

-- =====================================================
-- Testfall 6:
-- Änderung des Gerätezustands prüfen
-- =====================================================

DECLARE @Geraetenummer VARCHAR(30) = 'CDT-323';
DECLARE @OriginalZustandId INT;
DECLARE @DefektZustandId INT;

-- Aktuellen Zustand des Gerätes ermitteln
SELECT @OriginalZustandId = zustand_id
FROM dbo.Geraet
WHERE geraetenummer = @Geraetenummer;

-- Zielzustand ermitteln
SELECT @DefektZustandId = zustand_id
FROM dbo.Geraetezustand
WHERE bezeichnung = 'defekt';


-- Testvoraussetzungen prüfen
IF @OriginalZustandId IS NULL
BEGIN
    ;THROW 51008,
        'TEST 6 kann nicht durchgeführt werden: Das Gerät wurde nicht gefunden.',
        1;
END;

IF @DefektZustandId IS NULL
BEGIN
    ;THROW 51009,
        'TEST 6 kann nicht durchgeführt werden: Der Gerätezustand "defekt" existiert nicht.',
        1;
END;

IF @OriginalZustandId = @DefektZustandId
BEGIN
    ;THROW 51010,
        'TEST 6 kann nicht durchgeführt werden: Das Gerät ist bereits defekt.',
        1;
END;


BEGIN TRY
    BEGIN TRANSACTION;

    -- Zustand ändern
    UPDATE dbo.Geraet
    SET zustand_id = @DefektZustandId
    WHERE geraetenummer = @Geraetenummer;

    -- Änderung prüfen
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Geraet g
        JOIN dbo.Geraetezustand z
            ON g.zustand_id = z.zustand_id
        WHERE g.geraetenummer = @Geraetenummer
          AND z.bezeichnung = 'defekt'
    )
    BEGIN
        ;THROW 51011,
            'TEST 6 FEHLGESCHLAGEN: Der Gerätezustand wurde nicht korrekt geändert.',
            1;
    END;

    -- Teständerung zurücksetzen
    ROLLBACK TRANSACTION;

    -- Prüfen, ob der ursprüngliche Zustand wiederhergestellt wurde
    IF EXISTS (
        SELECT 1
        FROM dbo.Geraet
        WHERE geraetenummer = @Geraetenummer
          AND zustand_id = @OriginalZustandId
    )
    BEGIN
        PRINT 'TEST 6 BESTANDEN: Gerätezustand wurde korrekt geändert und anschließend zurückgesetzt.';
    END
    ELSE
    BEGIN
        ;THROW 51012,
            'TEST 6 FEHLGESCHLAGEN: Der ursprüngliche Zustand wurde nicht wiederhergestellt.',
            1;
    END;
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
----------------------------------------------------------------------------------------------------







