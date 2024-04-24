CREATE VIEW generokoGustokoenak AS
SELECT a.IdAudio, a.Izena, a.mota, al.generoa, m.IzenArtistikoa AS Abeslari,
       COUNT(*) AS "Erreprodukzioak"
FROM Audio a
join Abestia ab on a.idAudio = ab.idAudio
JOIN Album al ON ab.IdAlbum = al.IdAlbum
JOIN Musikaria m ON al.Idmusikaria = m.Idmusikaria
LEFT JOIN Erreprodukzioak e ON a.IdAudio = e.IdAudio
GROUP BY 1,2,3,4,5;


-- Gaur ze ordutan entzun den musika gehiago

CREATE VIEW GaurZeOrdutanErreprodukzioGehiago AS
SELECT HOUR(e.data) AS "Ordua", IdAudio, COUNT(*) AS "Erreprodukzioak"
FROM Erreprodukzioak e
WHERE date(data) = CURDATE()
GROUP BY 1,2
ORDER BY "Erreprodukzioak"
limit 1;

-- Gaurko, asteko eta hileko erreprodukzio datuak (ze ordutan entzuten diren musika)

CREATE VIEW GaurkoErreprodukzioOrduak AS
SELECT HOUR(e.data) AS "Ordua", IdAudio, COUNT(*) AS "Erreprodukzioak"
FROM Erreprodukzioak e
WHERE date(data) = CURDATE()
GROUP BY Ordua
ORDER BY Ordua;

CREATE VIEW AstekoErreprodukzioOrduak AS
SELECT HOUR(e.data) AS "Ordua" ,day(e.data) AS "Eguna", IdAudio, COUNT(*) AS "Erreprodukzioak"
FROM Erreprodukzioak e
WHERE data >= CURDATE() - INTERVAL 1 WEEK
GROUP BY Ordua , Eguna, IdAudio
ORDER BY Ordua , Eguna;

CREATE VIEW HilekoErreprodukzioOrduak AS
SELECT HOUR(e.data) AS "Ordua", day(e.data) AS "Eguna", IdAudio, COUNT(*) AS "Erreprodukzioak"
FROM Erreprodukzioak e
WHERE data >= CURDATE() - INTERVAL 1 MONTH
GROUP BY Ordua , Eguna, IdAudio
ORDER BY Ordua , Eguna;

CREATE VIEW UrtekoErreprodukzioOrduak AS
SELECT HOUR(e.data) AS "Ordua", day(e.data) AS "Eguna", IdAudio, COUNT(*) AS "Erreprodukzioak"
FROM Erreprodukzioak e
WHERE data >= CURDATE() - INTERVAL 1 year
GROUP BY Ordua , Eguna, IdAudio
ORDER BY Ordua , Eguna;



-- Premiun Bezeroak:
-- Funciona
CREATE VIEW PremiunEstadistikak AS
SELECT b.IdBezeroa AS "idBezero", concat( b.Izena ," ", b.Abizena ) AS "Bezero", e.data AS "Erreprodukzio data",
COUNT(e.IdAudio) AS "Erreprodukzio kantitatea", COUNT(p.IdList) AS "PlayList Kantitate"
FROM Bezeroa b
LEFT JOIN Erreprodukzioak e ON b.IdBezeroa = e.IdBezeroa
LEFT JOIN Playlist p ON b.IdBezeroa = p.IdBezeroa
WHERE b.mota = 'premium'
GROUP BY 1,2,3;

-- Free Bezeroak:
-- Funciona
CREATE VIEW FreeEstadistikak AS
SELECT b.IdBezeroa AS "idBezero", concat( b.Izena ," ", b.Abizena ) AS "Bezero", e.data AS "Erreprodukzio data",
COUNT(e.IdAudio) AS "Erreprodukzio kantitatea", COUNT(p.IdList) AS "PlayList Kantitate"
FROM Bezeroa b
LEFT JOIN Erreprodukzioak e ON b.IdBezeroa = e.IdBezeroa
LEFT JOIN Playlist p ON b.IdBezeroa = p.IdBezeroa
WHERE b.mota = 'free'
GROUP BY 1,2,3;