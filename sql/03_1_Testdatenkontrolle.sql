USE IT_Inventarsystem;
GO

SELECT COUNT(*) AS Anzahl_Geraete
FROM dbo.Geraet;
GO

SELECT
    gt.bezeichnung AS geraetetyp,
    COUNT(*) AS anzahl
FROM dbo.Geraet g
JOIN dbo.Geraetetyp gt
    ON g.geraetetyp_id = gt.geraetetyp_id
GROUP BY gt.bezeichnung
ORDER BY gt.bezeichnung;
GO

-- Verteilung nach Gerätezustand
SELECT
    gz.bezeichnung AS zustand,
    COUNT(*) AS anzahl
FROM dbo.Geraet g
JOIN dbo.Geraetezustand gz
    ON g.zustand_id = gz.zustand_id
GROUP BY gz.bezeichnung
ORDER BY gz.bezeichnung;
GO

-- Verteilung nach Schulungsraum

SELECT
    r.raumbezeichnung,
    COUNT(g.geraet_id) AS anzahl_geraete
FROM dbo.Schulungsraum r
LEFT JOIN dbo.Geraet g
    ON r.raum_id = g.raum_id
GROUP BY r.raum_id, r.raumbezeichnung
ORDER BY r.raum_id;
GO





