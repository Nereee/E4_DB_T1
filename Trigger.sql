-- Egin behar (Albumaren Iraupena ateratzeko)

DELIMITER //
drop trigger if exists IraupenakGehitu//
create trigger IraupenakGehitu
AFTER insert on algo
for each row
begin
-- Funtzio hau erabili eragiketa egiteko
SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(Iraupena))) AS TotalDuration
FROM Audio
INNER JOIN Abestia USING (IdAudio)
WHERE IdAlbum = 'ESAL1';

end;
