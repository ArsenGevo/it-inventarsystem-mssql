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
