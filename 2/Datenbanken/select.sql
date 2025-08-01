SElECT fw.* FROM dbsys08.Ferienwohnung fw
    WHERE fw.feWoNr NOT IN (
        SELECT b.fewoNr FROM dbsys08.Buchung b); --a

-- b: Kunden, welche min. 1 Ferienwohnung mehrmals gebucht haben
SELECT DISTINCT k.* FROM dbsys08.Kunde k, dbsys08.Buchung b1, dbsys08.Buchung b2
    WHERE k.email = b1.kundenEmail AND k.email = b2.KUNDENEMAIL
        AND b1.BUCHUNGSNR != b2.BUCHUNGSNR AND b1.FEWONR = b2.FEWONR; --b

-- c: spanische Ferienwohnungen mit durchschn. Bewertung > 4.0
SELECT fw.* FROM dbsys08.Ferienwohnung fw WHERE FEWONR IN (
    SELECT b.FEWONR FROM dbsys08.Buchung b, dbsys08.FERIENWOHNUNG fewo, dbsys08.Adresse ad 
        WHERE b.fewoNr = fewo.FEWONR AND fewo.ADRESSNR = ad.adressNr AND ad.LANDNAME = 'Spanien' 
            GROUP BY b.FEWONR HAVING AVG(b.BEWERTSTERNE) > 4);

-- d: Ferienwohnung(en) mit den meisten Ausstattungen
SELECT wa.fewoNr FROM dbsys08.Wohnungsausstattung wa 
    GROUP BY FEWONR HAVING COUNT(*) = (
        SELECT MAX(COUNT(*)) FROM dbsys08.Wohnungsausstattung w GROUP BY w.FEWONR); --d

-- e: Anzahl fewo-Buchungen pro Land
SELECT ad.Landname, NVL(COUNT(b.BUCHUNGSNR),0) AS Anzahl_buchung FROM dbsys08.Adresse ad 
    LEFT OUTER JOIN dbsys08.FERIENWOHNUNG fw ON ad.adressNr = fw.ADRESSNR
    LEFT OUTER JOIN dbsys08.Buchung b ON fw.FEWONR = b.FEWONR
    GROUP BY ad.LANDNAME ORDER BY Anzahl_buchung DESC;

-- f: Anzahl fewo pro Stadt
SELECT ad.ort, COUNT(*) FROM dbsys08.FERIENWOHNUNG fw, dbsys08.ADRESSE ad WHERE fw.ADRESSNR = ad.ADRESSNR GROUP BY ad.ORT;

-- g: fewo nur mit 1 oder 2 Sterne - Bewertungen
SELECT fewoNr FROM dbsys08.Buchung b WHERE fewoNR NOT IN (
    SELECT FEWONR FROM dbsys08.Buchung bu WHERE bu.BEWERTSTERNE > 2);

-- h: spanische fewos mit Sauna, welche zwischen 01.05.2024 - 21.05.2024 frei sind, sortiert nach Bewertung
SELECT fw.name_, fw.preisPT, AVG(b.BEWERTSTERNE) AS Durchschnitt 
    FROM dbsys08.Ferienwohnung fw
    INNER JOIN dbsys08.WOHNUNGSAUSSTATTUNG wa ON fw.FEWONR = wa.FEWONR
    INNER JOIN dbsys08.ADRESSE ad ON fw.adressNr = ad.ADRESSNR
    LEFT OUTER JOIN dbsys08.BUCHUNG b ON b.FEWONR = fw.FEWONR
    WHERE ad.LANDNAME = 'Spanien' AND wa.AUSSTNAME = 'Sauna' AND fw.FEWONR NOT IN (
        SELECT b1.fewoNR FROM dbsys08.Buchung b1
            WHERE NOT(endtag < TO_DATE('2024-05-01', 'YYYY-MM-DD') OR b1.STARTTAG > (TO_DATE('2024-05-21', 'YYYY-MM-DD'))))
    GROUP BY fw.name_ ORDER BY NVL(Durchschnitt, 0) DESC;
    -- start = TO_DATE('2025-05-01', 'YYYY-MM-DD'), ende = TO_DATE('2025-05-21', 'YYYY-MM-DD')

-- AB HIER Aufgabe6:
-- Anwendung Trigger siehe tables.sql (setup) (A)
DELETE FROM Buchung b WHERE b.BUCHUNGSNR = 1;
SELECt * FROM stornoBuchung b;

-- B: Anwendung kundenstatistik siehe tables.sql
SELECT * FROM KUNDENSTATISTIK;

-- C: Ferienwohnungen welche von einem Nutzer 5 Sterne bekommen hat, mit dem du min. 1mal dasselbe mit 5 Sternen gegeben hast
SELECT b1.kundenemail AS Kunde, b2.kundenemail AS Empfehler, fewo.NAME_ AS passende_fewo, b1.FEWONR
    FROM Ferienwohnung fewo, Buchung b1, Buchung b2, Buchung b3
    WHERE b1.kundenemail != b2.KUNDENEMAIL AND b2.kundenEmail = b3.kundenEmail ANd b3.feWoNr = fewo.fewoNR
    AND b1.BEWERTSTERNE = 5 AND b2.bewertSterne = 5 AND b3.bewertSterne = 5
    AND b1.fewoNR = b2.fewoNR AND b2.fewoNr != b3.fewoNr;

SELECT b.KUNDENEMAIL, b.FEWONR, b.BEWERTSTERNE FROM BUCHUNG b WHERE Bewertsterne = 5; -- zeigt alle 5 Sterne bewertungen an

