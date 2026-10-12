USE IT_Inventarsystem;
GO

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