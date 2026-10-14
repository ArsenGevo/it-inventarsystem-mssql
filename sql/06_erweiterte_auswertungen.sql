-- =====================================================
-- Projektphase 7: Erweiterte Auswertungen
-- =====================================================

USE IT_Inventarsystem;
GO 

-- =====================================================
-- 1. Geräte mit unvollständigen Gerätedaten
-- =====================================================

SELECT 
    g.geraetenummer AS Geraetenummer,
    t.bezeichnung AS Geraetetyp,
    h.herstellername AS Hersteller,
    g.modell AS Modell,
    g.seriennummer AS Seriennummer,   
    g.anschaffungsdatum AS Anschaffungsdatum,
    r.raumbezeichnung AS Raum
FROM dbo.Geraet g
JOIN dbo.Hersteller h 
    ON g.hersteller_id = h.hersteller_id
JOIN dbo.Geraetetyp t 
    ON g.geraetetyp_id = t.geraetetyp_id
LEFT JOIN dbo.Schulungsraum r 
    ON g.raum_id = r.raum_id
WHERE g.modell IS NULL 
    OR g.seriennummer IS NULL 
    OR g.anschaffungsdatum IS NULL
ORDER BY g.geraetenummer;
GO

-- =====================================================
-- 2. Arbeitsplatzausstattung je Schulungsraum
-- =====================================================

SELECT 
r.raumbezeichnung AS Raum,
r.anzahl_arbeitsplaetze AS Arbeitsplaetze,

SUM(
    CASE
        WHEN t.bezeichnung = 'Notebook' THEN 1
        ELSE 0
    END
) AS Anzahl_Notebooks,

r.anzahl_arbeitsplaetze -
SUM(
    CASE
        WHEN t.bezeichnung = 'Notebook' THEN 1
        ELSE 0
    END
) AS Differenz

FROM dbo.Schulungsraum r

LEFT JOIN dbo.Geraet g
    ON r.raum_id = g.raum_id

LEFT JOIN dbo.Geraetetyp t
    ON g.geraetetyp_id = t.geraetetyp_id

WHERE r.raumbezeichnung <> 'Lager'

GROUP BY 
    r.raum_id,
    r.raumbezeichnung,
    r.anzahl_arbeitsplaetze

ORDER BY r.raumbezeichnung;
GO

-- =====================================================
-- 3. Defekte und in Reparatur befindliche Geräte je Gerätetyp
-- =====================================================

SELECT 
    t.bezeichnung AS Geraetetyp,

    SUM(
        CASE
            WHEN z.bezeichnung = 'defekt' THEN 1
            ELSE 0
        END
    ) AS Defekt,

    SUM(
        CASE
            WHEN z.bezeichnung = 'in Reparatur' THEN 1
            ELSE 0
        END
    ) AS In_Reparatur,

    SUM(
        CASE
            WHEN z.bezeichnung IN ('defekt', 'in Reparatur') THEN 1
            ELSE 0
        END
    ) AS Gesamt

FROM dbo.Geraetetyp t
LEFT JOIN dbo.Geraet g
    ON t.geraetetyp_id = g.geraetetyp_id
LEFT JOIN dbo.Geraetezustand z
    ON g.zustand_id = z.zustand_id

GROUP BY
    t.geraetetyp_id,
    t.bezeichnung

ORDER BY
    t.bezeichnung;
GO
