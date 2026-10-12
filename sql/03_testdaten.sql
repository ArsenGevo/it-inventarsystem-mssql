USE IT_Inventarsystem;
GO

INSERT INTO dbo.Hersteller(herstellername) 
VALUES 
('HP'),
('Dell'),
('Lenovo'),
('Cisco'),
('Epson'),
('Advantouch Pro');
GO

SELECT * FROM dbo.Hersteller;
GO

INSERT INTO dbo.Geraetetyp(bezeichnung)
VALUES 
('PC'),
('Monitor'),
('Notebook'),
('Drucker'),
('Switch'),
('Digitaltafel');
GO

SELECT *
FROM dbo.Geraetetyp;
GO

INSERT INTO dbo.Geraetezustand(bezeichnung, beschreibung)
VALUES 
('einsatzbereit', 'Gerät ist funktionsfähig und kann regulär verwendet werden.'),
('defekt', 'Gerät weist einen Fehler auf und ist aktuell nicht einsatzbereit.'),
('in Reparatur', 'Gerät befindet sich in interner oder externer Reparatur.'),
('ausgesondert', 'Gerät wird nicht mehr regulär verwendet und ist zur Aussonderung vorgesehen.');
GO

SELECT *
FROM dbo.Geraetezustand;
GO

INSERT INTO dbo.Schulungsraum(raumbezeichnung, anzahl_arbeitsplaetze)
VALUES
('E.1', 30),
('E.2', 20),
('1.1', 12),
('1.2', 12),
('2.1', 30),
('2.2', 20),
('2.3', 20),
('2.4', 20),
('Lager', 0);
GO

SELECT *
FROM dbo.Schulungsraum;
GO

SELECT * FROM dbo.Hersteller;
SELECT * FROM dbo.Geraetetyp;
SELECT * FROM dbo.Geraetezustand;
SELECT * FROM dbo.Schulungsraum;
GO

USE IT_Inventarsystem;
GO

INSERT INTO dbo.Geraet
    (geraetenummer, bezeichnung, modell, seriennummer, anschaffungsdatum,
     hersteller_id, geraetetyp_id, zustand_id, raum_id)
VALUES
-- E.1 / Dell Latitude 5420
('CDT-301', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT301', '2021-08-16', 2, 3, 1, 1),
('CDT-302', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT302', '2021-08-16', 2, 3, 1, 1),
('CDT-303', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT303', '2021-08-16', 2, 3, 1, 1),
('CDT-304', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT304', '2021-08-16', 2, 3, 1, 1),
('CDT-305', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT305', '2021-08-16', 2, 3, 1, 1),
('CDT-306', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT306', '2021-08-16', 2, 3, 2, 1),
('CDT-307', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT307', '2021-08-16', 2, 3, 1, 1),

-- E.2 / Dell Latitude 5410
('CDT-309', 'Schulungsnotebook', 'Latitude 5410', 'DELL-CDT309', '2020-09-07', 2, 3, 1, 2),
('CDT-310', 'Schulungsnotebook', 'Latitude 5410', 'DELL-CDT310', '2020-09-07', 2, 3, 1, 2),
('CDT-311', 'Schulungsnotebook', 'Latitude 5410', 'DELL-CDT311', '2020-09-07', 2, 3, 1, 2),
('CDT-312', 'Schulungsnotebook', 'Latitude 5410', 'DELL-CDT312', '2020-09-07', 2, 3, 2, 2),

-- 1.1 / Dell Latitude 5400
('CDT-314', 'Schulungsnotebook', 'Latitude 5400', NULL, '2019-08-19', 2, 3, 1, 3),
('CDT-315', 'Schulungsnotebook', 'Latitude 5400', 'DELL-CDT315', '2019-08-19', 2, 3, 1, 3),
('CDT-316', 'Schulungsnotebook', 'Latitude 5400', 'DELL-CDT316', '2019-08-19', 2, 3, 1, 3),
('CDT-317', 'Schulungsnotebook', 'Latitude 5400', 'DELL-CDT317', '2019-08-19', 2, 3, 1, 3),

-- 1.2 / Lenovo ThinkPad E14 Gen 2
('CDT-318', 'Schulungsnotebook', 'ThinkPad E14 Gen 2', 'LNV-CDT318', '2021-09-13', 3, 3, 1, 4),
('CDT-319', 'Schulungsnotebook', 'ThinkPad E14 Gen 2', 'LNV-CDT319', '2021-09-13', 3, 3, 1, 4),
('CDT-320', 'Schulungsnotebook', 'ThinkPad E14 Gen 2', 'LNV-CDT320', '2021-09-13', 3, 3, 1, 4),
('CDT-321', 'Schulungsnotebook', 'ThinkPad E14 Gen 2', 'LNV-CDT321', '2021-09-13', 3, 3, 1, 4),

-- 2.1 / Lenovo ThinkPad E16 Gen 3
('CDT-322', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT322', '2025-08-18', 3, 3, 1, 5),
('CDT-323', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT323', '2025-08-18', 3, 3, 1, 5),
('CDT-324', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT324', '2025-08-18', 3, 3, 1, 5),
('CDT-325', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT325', '2025-08-18', 3, 3, 1, 5),
('CDT-326', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT326', '2025-08-18', 3, 3, 1, 5),
('CDT-327', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT327', '2025-08-18', 3, 3, 1, 5),
('CDT-328', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT328', '2025-08-18', 3, 3, 1, 5),
('CDT-329', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT329', '2025-08-18', 3, 3, 1, 5),
('CDT-330', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT330', '2025-08-18', 3, 3, 1, 5),
('CDT-331', 'Schulungsnotebook', 'ThinkPad E16 Gen 3', 'LNV-CDT331', '2025-08-18', 3, 3, 1, 5),

-- 2.2 / Dell Latitude 5430
('CDT-332', 'Schulungsnotebook', 'Latitude 5430', 'DELL-CDT332', '2022-09-05', 2, 3, 1, 6),
('CDT-333', 'Schulungsnotebook', 'Latitude 5430', 'DELL-CDT333', '2022-09-05', 2, 3, 1, 6),
('CDT-334', 'Schulungsnotebook', 'Latitude 5430', 'DELL-CDT334', '2022-09-05', 2, 3, 1, 6),

-- 2.3 / Dell Latitude 5420
('CDT-335', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT335', '2021-08-16', 2, 3, 1, 7),
('CDT-336', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT336', '2021-08-16', 2, 3, 1, 7),
('CDT-337', 'Schulungsnotebook', 'Latitude 5420', 'DELL-CDT337', '2021-08-16', 2, 3, 1, 7),

-- 2.4 / Lenovo ThinkPad T14 Gen 2
('CDT-338', 'Schulungsnotebook', 'ThinkPad T14 Gen 2', 'LNV-CDT338', '2021-10-04', 3, 3, 1, 8),
('CDT-339', 'Schulungsnotebook', 'ThinkPad T14 Gen 2', 'LNV-CDT339', '2021-10-04', 3, 3, 1, 8),
('CDT-353', 'Schulungsnotebook', 'ThinkPad T14 Gen 2', 'LNV-CDT353', '2021-10-04', 3, 3, 1, 8);
GO

INSERT INTO dbo.Geraet
    (geraetenummer, bezeichnung, modell, seriennummer, anschaffungsdatum,
     hersteller_id, geraetetyp_id, zustand_id, raum_id)
VALUES
('PC-001', 'Arbeitsplatz-PC', 'EliteDesk 800 G3', NULL, '2017-05-15', 1, 1, 1, 9),
('PC-002', 'Arbeitsplatz-PC', 'EliteDesk 800 G3', NULL, '2017-05-15', 1, 1, 4, 9);
GO

INSERT INTO dbo.Geraet
    (geraetenummer, bezeichnung, modell, seriennummer, anschaffungsdatum,
     hersteller_id, geraetetyp_id, zustand_id, raum_id)
VALUES
('MON-001', 'Monitor', 'P2422H', 'DELL-MON001', '2021-08-16', 2, 2, 1, 1),
('MON-002', 'Monitor', 'P2419H', 'DELL-MON002', '2020-09-07', 2, 2, 1, 2),
('MON-003', 'Monitor', 'P2419H', NULL, '2019-08-19', 2, 2, 1, 3),
('MON-004', 'Monitor', 'P2422H', 'DELL-MON004', '2021-09-13', 2, 2, 1, 4),
('MON-005', 'Monitor', 'P2422H', 'DELL-MON005', '2025-08-18', 2, 2, 1, 5),
('MON-006', 'Monitor', 'P2422H', 'DELL-MON006', '2022-09-05', 2, 2, 2, 6),
('MON-007', 'Monitor', 'P2422H', 'DELL-MON007', '2021-08-16', 2, 2, 1, 7),
('MON-008', 'Monitor', 'P2419H', 'DELL-MON008', '2021-10-04', 2, 2, 1, 8);
GO

INSERT INTO dbo.Geraet
    (geraetenummer, bezeichnung, modell, seriennummer, anschaffungsdatum,
     hersteller_id, geraetetyp_id, zustand_id, raum_id)
VALUES
('PRN-001', 'Raumdrucker', 'LaserJet P2055dn', 'HP-PRN001', '2017-06-12', 1, 4, 1, 1),
('PRN-002', 'Raumdrucker', 'LaserJet P2055dn', 'HP-PRN002', '2017-06-12', 1, 4, 1, 2),
('PRN-003', 'Raumdrucker', 'LaserJet P2055dn', NULL, '2016-09-05', 1, 4, 3, 3),
('PRN-004', 'Raumdrucker', 'LaserJet P2055dn', 'HP-PRN004', '2018-02-19', 1, 4, 1, 4),
('PRN-005', 'Raumdrucker', 'LaserJet P2055dn', 'HP-PRN005', '2019-04-08', 1, 4, 1, 5),
('PRN-006', 'Raumdrucker', 'LaserJet P2055dn', 'HP-PRN006', '2017-06-12', 1, 4, 1, 6),
('PRN-007', 'Raumdrucker', 'LaserJet P2055dn', 'HP-PRN007', '2017-06-12', 1, 4, 1, 7),
('PRN-008', 'Raumdrucker', 'WorkForce Pro WF-C5790', 'EPS-PRN008', '2022-11-14', 5, 4, 2, 8);
GO

INSERT INTO dbo.Geraet
    (geraetenummer, bezeichnung, modell, seriennummer, anschaffungsdatum,
     hersteller_id, geraetetyp_id, zustand_id, raum_id)
VALUES
('SW-001', 'Netzwerk-Switch', 'SG250-26', 'CSC-SW001', '2019-07-01', 4, 5, 1, 1),
('SW-002', 'Netzwerk-Switch', 'SG250-26', 'CSC-SW002', '2019-07-01', 4, 5, 1, 2),
('SW-003', 'Netzwerk-Switch', 'SG250-26', 'CSC-SW003', '2018-08-13', 4, 5, 1, 3),
('SW-004', 'Netzwerk-Switch', 'SG250-26', 'CSC-SW004', '2018-08-13', 4, 5, 1, 4),
('SW-005', 'Netzwerk-Switch', 'CBS250-24T-4G', 'CSC-SW005', '2024-07-22', 4, 5, 1, 5),
('SW-006', 'Netzwerk-Switch', 'CBS250-24T-4G', 'CSC-SW006', '2022-09-05', 4, 5, 1, 6),
('SW-007', 'Netzwerk-Switch', 'SG250-26', 'CSC-SW007', '2020-08-17', 4, 5, 1, 7),
('SW-008', 'Netzwerk-Switch', 'SG250-26', NULL, '2017-08-21', 4, 5, 4, 8);
GO

INSERT INTO dbo.Geraet
    (geraetenummer, bezeichnung, modell, seriennummer, anschaffungsdatum,
     hersteller_id, geraetetyp_id, zustand_id, raum_id)
VALUES
('DT-001', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT001', '2022-08-15', 6, 6, 1, 1),
('DT-002', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT002', '2022-08-15', 6, 6, 1, 1),

('DT-003', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT003', '2022-08-15', 6, 6, 1, 2),
('DT-004', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT004', '2022-08-15', 6, 6, 2, 2),

('DT-005', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT005', '2021-09-06', 6, 6, 1, 3),
('DT-006', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT006', '2021-09-06', 6, 6, 1, 3),

('DT-007', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT007', '2021-09-06', 6, 6, 1, 4),
('DT-008', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT008', '2021-09-06', 6, 6, 1, 4),

('DT-009', 'Digitale Tafel', 'Advantouch Pro 86', 'ATP-DT009', '2025-08-18', 6, 6, 1, 5),
('DT-010', 'Digitale Tafel', 'Advantouch Pro 86', 'ATP-DT010', '2025-08-18', 6, 6, 1, 5),

('DT-011', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT011', '2023-07-31', 6, 6, 1, 6),
('DT-012', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT012', '2023-07-31', 6, 6, 1, 6),

('DT-013', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT013', '2022-08-22', 6, 6, 1, 7),
('DT-014', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT014', '2022-08-22', 6, 6, 1, 7),

('DT-015', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT015', '2021-09-13', 6, 6, 3, 8),
('DT-016', 'Digitale Tafel', 'Advantouch Pro 75', 'ATP-DT016', '2021-09-13', 6, 6, 1, 8);
GO

