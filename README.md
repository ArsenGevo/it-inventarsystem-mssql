# IT-Inventarsystem

Datenbankgestütztes IT-Inventarsystem zur Verwaltung von Geräten,
Herstellern, Gerätetypen, Gerätezuständen und Schulungsräumen.

Das Projekt wurde im Rahmen einer praxisorientierten Projektphase
der Umschulung zum Fachinformatiker für Anwendungsentwicklung erstellt.

## Technologien

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)
- Git / GitHub

## Funktionen

- Verwaltung von Herstellern
- Verwaltung von Gerätetypen
- Verwaltung von Gerätezuständen
- Verwaltung von Schulungsräumen
- Verwaltung einzelner IT-Geräte
- Zuordnung von Geräten zu Räumen
- Stored Procedures für häufige Abfragen
- Auswertungen nach Zustand, Hersteller, Raum und Gerätetyp

## Datenbankstruktur

Die Datenbank besteht unter anderem aus folgenden Tabellen:

- Hersteller
- Geraetetyp
- Geraetezustand
- Schulungsraum
- Geraet

## Installation

SQL-Skripte in folgender Reihenfolge ausführen:

1. `01_create_database.sql`
2. `02_create_tables.sql`
3. `03_testdaten.sql`
4. `04_stored_procedures.sql`
5. `05_abfragen.sql`

## Projektstatus

In Entwicklung.