-- löscht alle vorhandenen Tabellen!!!
BEGIN
   FOR c IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || c.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/

CREATE TABLE Land (
    name_ VARCHAR2(100) PRIMARY KEY
);

CREATE TABLE Adresse (
    adressNr INTEGER PRIMARY KEY,
    landName VARCHAR2(100) NOT NULL,
    ort VARCHAR2(100) NOT NULL,
    plz INTEGER NOT NULL,
        CHECK (plz >= 0),
    strasse VARCHAR2(100) NOT NULL,
    hausNr INTEGER NOT NULL,
        CHECK (hausNr > 0)
);

CREATE TABLE Ferienwohnung (
    feWoNr INTEGER PRIMARY KEY,
    adressNr INTEGER NOT NULL,
    preisPT INTEGER NOT NULL,
        CHECK (preisPT > 0),
    anzahlZimmer INTEGER NOT NULL,
        CHECK (anzahlZimmer > 0),
    name_ VARCHAR2(100) NOT NULL,
    groesse INTEGER NOT NULL,
        CHECK (groesse > 0)
);

CREATE TABLE Bild (
    url VARCHAR2(255) PRIMARY KEY,
    feWoNr INTEGER NOT NULL
);

CREATE TABLE Ausstattung (
    name_ VARCHAR2(100) PRIMARY KEY
);

CREATE TABLE WohnungsAusstattung (
    feWoNr INTEGER NOT NULL, 
    ausstName VARCHAR2(100) NOT NULL,
    PRIMARY KEY (feWoNr, ausstName)
);

CREATE TABLE Attraktion (
    name_ VARCHAR2(100) PRIMARY KEY,
    adressNr INTEGER NOT NULL,
    beschreibung VARCHAR2(2000)
);

CREATE TABLE AttraktionsAusstattung (
    attraktionsName VARCHAR2(100) NOT NULL,
    ausstattungsName VARCHAR2(100) NOT NULL,
    entfernung INTEGER NOT NULL,
        CHECK (entfernung > 0),
    PRIMARY KEY (attraktionsName, ausstattungsName)
);

CREATE TABLE Kunde (
    email VARCHAR2(100) PRIMARY KEY,
    adressNr INTEGER NOT NULL,
    name_ VARCHAR2(100) NOT NULL,
    vorname VARCHAR2(100) NOT NULL,
    istNewsletter CHAR(1) NOT NULL,
        CHECK (istNewsletter = 't' OR istNewsletter = 'f'),
    passwort VARCHAR2(100) NOT NULL,
        CHECK (LENGTH(passwort) >= 5),
    iban VARCHAR2(34)
);

CREATE TABLE Buchung (
    buchungsNr INTEGER PRIMARY KEY,
    feWoNr INTEGER NOT NULL,
    kundenEmail VARCHAR2(100) NOT NULL,
    buchungsZeit DATE NOT NULL,
    startTag DATE NOT NULL,
        CHECK (startTag > buchungsZeit),
    endTag DATE NOT NULL,
        CHECK (endTag > startTag + 2),
    stornoZeit DATE,
        CHECK (stornoZeit > buchungsZeit),
    rechnungsNr INTEGER UNIQUE,
    rechnungsDatum DATE,
        CHECK (rechnungsDatum > buchungsZeit),
    betrag INTEGER NOT NULL,
        CHECK (betrag > 0),
    bewertText VARCHAR2(2000),
    bewertDatum DATE,
        CHECK (bewertDatum > endTag),
    bewertSterne INTEGER,
        CHECK (bewertSterne > 0 AND bewertSterne <= 5)
);

CREATE TABLE Anzahlung (
    anzahlungsNr INTEGER PRIMARY KEY,
    buchungsNr INTEGER NOT NULL,
    zahlungsDatum DATE NOT NULL,
    betrag INTEGER NOT NULL,
        CHECK (betrag > 0)
);

-- Fremdschlüssel:

ALTER TABLE Adresse
ADD CONSTRAINT fk_adresse_land FOREIGN KEY (landName) REFERENCES Land(name_);

ALTER TABLE Ferienwohnung
ADD CONSTRAINT fk_fewo_adresse FOREIGN KEY (adressNr) REFERENCES Adresse(adressNr);

ALTER TABLE Bild
ADD CONSTRAINT fk_bild_fewo FOREIGN KEY (feWoNr) REFERENCES Ferienwohnung(feWoNr) ON DELETE CASCADE;

ALTER TABLE WohnungsAusstattung
ADD CONSTRAINT fk_wa_fewo FOREIGN KEY (feWoNr) REFERENCES Ferienwohnung(feWoNr) ON DELETE CASCADE;

ALTER TABLE WohnungsAusstattung
ADD CONSTRAINT fk_wa_ausst FOREIGN KEY (ausstName) REFERENCES Ausstattung(name_) ON DELETE CASCADE;

ALTER TABLE Attraktion
ADD CONSTRAINT fk_attr_adresse FOREIGN KEY (adressNr) REFERENCES Adresse(adressNr);


ALTER TABLE AttraktionsAusstattung
    ADD CONSTRAINT fk_aa_attr FOREIGN KEY (attraktionsName) REFERENCES Attraktion(name_) ON DELETE CASCADE;

ALTER TABLE AttraktionsAusstattung
    ADD CONSTRAINT fk_aa_ausst FOREIGN KEY (ausstattungsName) REFERENCES Ausstattung(name_) ON DELETE CASCADE;


ALTER TABLE Kunde
    ADD CONSTRAINT fk_kunde_adresse FOREIGN KEY (adressNr) REFERENCES Adresse(adressNr);


ALTER TABLE Buchung
    ADD CONSTRAINT fk_buchung_fewo FOREIGN KEY (feWoNr) REFERENCES Ferienwohnung(feWoNr); 

ALTER TABLE Buchung
    ADD CONSTRAINT fk_buchung_kunde FOREIGN KEY (kundenEmail) REFERENCES Kunde(email);


ALTER TABLE Anzahlung
    ADD CONSTRAINT fk_anz_buchung FOREIGN KEY (buchungsNr) REFERENCES Buchung(buchungsNr);
    
-- Zugriffsrechte
GRANT INSERT, DELETE, SELECT, UPDATE ON Ausstattung TO dbsys08;
GRANT ALL ON Kunde TO dbsys70;
GRANT SELECT, UPDATE, DELETE ON Kunde to dbsys08;

GRANT INSERT, SELECT, UPDATE ON Buchung to dbsys70;
GRANT INSERT, SELECT, UPDATE ON Buchung TO dbsys08;

GRANT SELECT ON Anzahlung TO dbsys70;
GRANT SELECT, INSERT, UPDATE ON Anzahlung TO dbsys08;

GRANT SELECT ON Attraktion TO dbsys70;
GRANT SELECT, INSERT, UPDATE, DELETE ON Attraktion TO dbsys08;

GRANT SELECT ON Wohnungsausstattung TO dbsys70;
GRANT ALL ON Wohnungsausstattung TO dbsys08;

GRANT SELECT ON Attraktionsausstattung TO dbsys70;
GRANT ALL ON Attraktionsausstattung TO dbsys08;

GRANT SELECT ON Ausstattung TO dbsys70;
GRANT ALL ON Ausstattung TO dbsys08;

GRANT SELECT ON Land TO dbsys70;
GRANT SELECT, INSERT, UPDATE ON Land TO dbsys08;

GRANT SELECT, INSERT, UPDATE ON Adresse TO dbsys70;
GRANT SELECT, INSERT, UPDATE ON Adresse TO dbsys08;

GRANT SELECT ON Ferienwohnung TO dbsys70;
GRANT ALL ON Ferienwohnung TO dbsys08;

GRANT SELECT ON Bild TO dbsys70;
GRANT ALL ON Bild TO dbsys08;

-- Insert
-- Daten für Land
INSERT INTO Land (name_) VALUES ('Deutschland');
INSERT INTO Land (name_) VALUES ('Österreich');
INSERT INTO Land (name_) VALUES ('Schweiz');
INSERT INTO Land (name_) VALUES ('Spanien');
-- Daten für Adresse
INSERT INTO Adresse (adressNr, landName, ort, plz, strasse, hausNr) 
VALUES (1, 'Deutschland', 'Berlin', 10115, 'Musterstraße', 5);

INSERT INTO Adresse (adressNr, landName, ort, plz, strasse, hausNr) 
VALUES (2, 'Österreich', 'Wien', 1010, 'Ringstraße', 10);

INSERT INTO Adresse (adressNr, landName, ort, plz, strasse, hausNr) 
VALUES (3, 'Schweiz', 'Zürich', 8001, 'Bahnhofstrasse', 20);

INSERT INTO Adresse (adressNr, landName, ort, plz, strasse, hausNr) 
VALUES (4, 'Schweiz', 'Zürich', 8001, 'Opernweg', 12);

INSERT INTO Adresse (adressNr, landName, ort, plz, strasse, hausNr) 
VALUES (6, 'Spanien', 'Barcelona', 8001, 'strasse', 2);

-- Daten für Ferienwohnung
INSERT INTO Ferienwohnung (feWoNr, adressNr, preisPT, anzahlZimmer, name_, groesse) 
VALUES (1, 1, 80, 3, 'Ferienwohnung Berlin Mitte', 70);

INSERT INTO Ferienwohnung (feWoNr, adressNr, preisPT, anzahlZimmer, name_, groesse) 
VALUES (2, 2, 120, 4, 'Ferienwohnung Wien Zentrum', 85);

INSERT INTO Ferienwohnung (feWoNr, adressNr, preisPT, anzahlZimmer, name_, groesse) 
VALUES (3, 3, 150, 5, 'Ferienwohnung Zürich Altstadt', 100);

INSERT INTO Ferienwohnung (feWoNr, adressNr, preisPT, anzahlZimmer, name_, groesse) 
VALUES (4, 4, 100, 5, 'Ferienwohnung Zürich Oper', 90);


INSERT INTO Ferienwohnung (feWoNr, adressNr, preisPT, anzahlZimmer, name_, groesse) 
VALUES (6, 6, 100, 5, 'Ferienwohnung Barcelona', 90);

-- Daten für Bild
INSERT INTO Bild (url, feWoNr) 
VALUES ('http://example.com/images/berlin_mitte.jpg', 1);

INSERT INTO Bild (url, feWoNr) 
VALUES ('http://example.com/images/wien_zentrum.jpg', 2);

INSERT INTO Bild (url, feWoNr) 
VALUES ('http://example.com/images/zurich_altstadt.jpg', 3);

-- Daten für Ausstattung
INSERT INTO Ausstattung (name_) 
VALUES ('WLAN');

INSERT INTO Ausstattung (name_) 
VALUES ('Klimaanlage');

INSERT INTO Ausstattung (name_) 
VALUES ('Fahrradverleih');

INSERT INTO Ausstattung (name_) 
VALUES ('Sauna');

-- Daten für WohnungsAusstattung
INSERT INTO WohnungsAusstattung (feWoNr, ausstName) 
VALUES (1, 'WLAN');

INSERT INTO WohnungsAusstattung (feWoNr, ausstName) 
VALUES (1, 'Klimaanlage');

INSERT INTO WohnungsAusstattung (feWoNr, ausstName) 
VALUES (2, 'WLAN');

INSERT INTO WohnungsAusstattung (feWoNr, ausstName) 
VALUES (3, 'Fahrradverleih');

INSERT INTO WohnungsAusstattung (feWoNr, ausstName) 
VALUES (6, 'Sauna');

-- Daten für Attraktion
INSERT INTO Attraktion (name_, adressNr, beschreibung) 
VALUES ('Brandenburger Tor', 1, 'Das Brandenburger Tor ist eines der bekanntesten Wahrzeichen Berlins.');

INSERT INTO Attraktion (name_, adressNr, beschreibung) 
VALUES ('Stephansdom', 2, 'Der Stephansdom ist eine der bekanntesten Sehenswürdigkeiten Wiens.');

INSERT INTO Attraktion (name_, adressNr, beschreibung) 
VALUES ('Zürcher Zoo', 3, 'Der Zürcher Zoo ist einer der ältesten und bekanntesten Zoos der Schweiz.');

-- Neue Adresse für die Ferienwohnung
INSERT INTO Adresse (adressNr, landName, ort, plz, strasse, hausNr)
VALUES (5, 'Deutschland', 'Freiburg', 79098, 'Schwarzwaldstraße', 88);

-- Neue Ferienwohnung mit Adresse 4
INSERT INTO Ferienwohnung (feWoNr, adressNr, preisPT, anzahlZimmer, name_, groesse)
VALUES (5, 5, 110, 3, 'Ferienwohnung Schwarzwaldblick', 75);

-- Optional: Bilder zur neuen Ferienwohnung
INSERT INTO Bild (url, feWoNr)
VALUES ('http://example.com/images/schwarzwaldblick.jpg', 4);

-- Optional: Ausstattung hinzufügen, falls noch nicht vorhanden
INSERT INTO Ausstattung (name_) VALUES ('Pool') ;

-- Ausstattung zur Wohnung zuordnen
INSERT INTO WohnungsAusstattung (feWoNr, ausstName)
VALUES (4, 'WLAN');

INSERT INTO WohnungsAusstattung (feWoNr, ausstName)
VALUES (4, 'Pool');

-- Daten für AttraktionsAusstattung
INSERT INTO AttraktionsAusstattung (attraktionsName, ausstattungsName, entfernung) 
VALUES ('Brandenburger Tor', 'WLAN', 100);

INSERT INTO AttraktionsAusstattung (attraktionsName, ausstattungsName, entfernung) 
VALUES ('Stephansdom', 'Klimaanlage', 50);

INSERT INTO AttraktionsAusstattung (attraktionsName, ausstattungsName, entfernung) 
VALUES ('Zürcher Zoo', 'Fahrradverleih', 200);

-- Daten für Kunde
INSERT INTO Kunde (email, adressNr, name_, vorname, istNewsletter, passwort, iban) 
VALUES ('max.mustermann@example.com', 1, 'Mustermann', 'Max', 't', 'geheim123', 'DE89370400440532013000');

INSERT INTO Kunde (email, adressNr, name_, vorname, istNewsletter, passwort, iban) 
VALUES ('anna.schmidt@example.com', 2, 'Schmidt', 'Anna', 'f', 'sicher456', 'AT611904300234573201');

INSERT INTO Kunde (email, adressNr, name_, vorname, istNewsletter, passwort, iban) 
VALUES ('peter.meyer@example.com', 3, 'Meyer', 'Peter', 't', 'meinpasswort789', 'CH9300762011623852955');

-- Daten für Buchung
INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (1, 1, 'max.mustermann@example.com', TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_DATE('2025-06-01', 'YYYY-MM-DD'), TO_DATE('2025-06-07', 'YYYY-MM-DD'), NULL, 12345, TO_DATE('2025-06-08', 'YYYY-MM-DD'), 560, 'Sehr schöne Wohnung, top Lage!', TO_DATE('2025-06-10', 'YYYY-MM-DD'), 5);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (2, 2, 'anna.schmidt@example.com', TO_DATE('2025-05-05', 'YYYY-MM-DD'), TO_DATE('2025-06-10', 'YYYY-MM-DD'), TO_DATE('2025-06-15', 'YYYY-MM-DD'), NULL, 12346, TO_DATE('2025-06-16', 'YYYY-MM-DD'), 720, 'Tolle Wohnung, gerne wieder!', TO_DATE('2025-06-20', 'YYYY-MM-DD'), 4);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (3, 2, 'anna.schmidt@example.com', TO_DATE('2026-05-05', 'YYYY-MM-DD'), TO_DATE('2026-06-10', 'YYYY-MM-DD'), TO_DATE('2026-06-15', 'YYYY-MM-DD'), NULL, NULL, NULL, 720, NULL, TO_DATE('2026-06-20', 'YYYY-MM-DD'), 4);

-- Zusätzliche Buchungen
INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (4, 3, 'peter.meyer@example.com', TO_DATE('2025-04-10', 'YYYY-MM-DD'), TO_DATE('2025-07-01', 'YYYY-MM-DD'), TO_DATE('2025-07-10', 'YYYY-MM-DD'), NULL, 12347, TO_DATE('2025-07-11', 'YYYY-MM-DD'), 1350, 'Perfekte Unterkunft für unseren Sommerurlaub!', TO_DATE('2025-07-15', 'YYYY-MM-DD'), 5);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (5, 1, 'anna.schmidt@example.com', TO_DATE('2025-03-15', 'YYYY-MM-DD'), TO_DATE('2025-04-01', 'YYYY-MM-DD'), TO_DATE('2025-04-06', 'YYYY-MM-DD'), NULL, 12348, TO_DATE('2025-04-07', 'YYYY-MM-DD'), 400, 'Etwas laut, aber gute Ausstattung.', TO_DATE('2025-04-10', 'YYYY-MM-DD'), 3);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (6, 2, 'max.mustermann@example.com', TO_DATE('2025-02-20', 'YYYY-MM-DD'), TO_DATE('2025-03-10', 'YYYY-MM-DD'), TO_DATE('2025-03-17', 'YYYY-MM-DD'), TO_DATE('2025-03-01', 'YYYY-MM-DD'), 12349, TO_DATE('2025-03-18', 'YYYY-MM-DD'), 840, NULL, NULL, NULL);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (7, 3, 'anna.schmidt@example.com', TO_DATE('2025-06-01', 'YYYY-MM-DD'), TO_DATE('2025-07-20', 'YYYY-MM-DD'), TO_DATE('2025-07-25', 'YYYY-MM-DD'), NULL, 12350, TO_DATE('2025-07-26', 'YYYY-MM-DD'), 750, 'Sehr sauber und gute Lage!', TO_DATE('2025-07-28', 'YYYY-MM-DD'), 5);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne) 
VALUES (8, 1, 'peter.meyer@example.com', TO_DATE('2025-01-10', 'YYYY-MM-DD'), TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-02-10', 'YYYY-MM-DD'), NULL, 12351, TO_DATE('2025-02-11', 'YYYY-MM-DD'), 720, 'Gemütlich und günstig!', TO_DATE('2025-02-13', 'YYYY-MM-DD'), 4);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne)
VALUES (9, 3, 'max.mustermann@example.com', TO_DATE('2025-09-01', 'YYYY-MM-DD'), TO_DATE('2025-10-01', 'YYYY-MM-DD'), TO_DATE('2025-10-07', 'YYYY-MM-DD'), NULL, 12352, TO_DATE('2025-10-08', 'YYYY-MM-DD'), 900, 'Ruhige Lage, ideal zum Entspannen.', TO_DATE('2025-10-10', 'YYYY-MM-DD'), 5);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne)
VALUES (10, 2, 'peter.meyer@example.com', TO_DATE('2025-11-10', 'YYYY-MM-DD'), TO_DATE('2025-12-01', 'YYYY-MM-DD'), TO_DATE('2025-12-08', 'YYYY-MM-DD'), NULL, 12353, TO_DATE('2025-12-09', 'YYYY-MM-DD'), 840, 'Etwas veraltet, aber sauber.', TO_DATE('2025-12-12', 'YYYY-MM-DD'), 3);

INSERT INTO Buchung (buchungsNr, feWoNr, kundenEmail, buchungsZeit, startTag, endTag, stornoZeit, rechnungsNr, rechnungsDatum, betrag, bewertText, bewertDatum, bewertSterne)
VALUES (11, 4, 'peter.meyer@example.com', TO_DATE('2025-11-10', 'YYYY-MM-DD'), TO_DATE('2025-12-01', 'YYYY-MM-DD'), TO_DATE('2025-12-08', 'YYYY-MM-DD'), NULL, 9, TO_DATE('2025-12-09', 'YYYY-MM-DD'), 840, '...', TO_DATE('2025-12-12', 'YYYY-MM-DD'), 1);

-- Daten für Anzahlung
INSERT INTO Anzahlung (anzahlungsNr, buchungsNr, zahlungsDatum, betrag) 
VALUES (1, 1, TO_DATE('2025-05-01', 'YYYY-MM-DD'), 200);

INSERT INTO Anzahlung (anzahlungsNr, buchungsNr, zahlungsDatum, betrag) 
VALUES (2, 2, TO_DATE('2025-05-10', 'YYYY-MM-DD'), 300);

/*SELECT *
FROM dbsys08.Ferienwohnung
WHERE anzahlZimmer > 3;

SELECT *
FROM dbsys08.Kunde
WHERE istNewsletter = 't';

SELECT *
FROM dbsys08.Kunde, dbsys08.Buchung
WHERE email = kundenEmail;*/
COMMIT;

