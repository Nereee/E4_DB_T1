-- Egin behar (Albumaren Iraupena ateratzeko)

DELIMITER //
drop trigger if exists IraupenakGehitu//
create trigger IraupenakGehitu
AFTER insert on Audio
for each row
begin
-- Funtzio hau erabili eragiketa egiteko
SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(Iraupena))) AS TotalDuration
FROM Audio
INNER JOIN Abestia USING (IdAudio)
where IdAudio = new.IdAudio;
end;

DELIMITER //
drop trigger if exists AbestiaGehitu//
create trigger AbestiaGehitu
after insert on Erreprodukzioak
for each row
begin
 UPDATE Estatistikak
    SET Entzundakoa = Entzundakoa + 1
    WHERE IdAudio = NEW.IdAudio;
end;

DELIMITER //
DROP TRIGGER IF exists BezeroPremium//
create trigger BezeroPremium
after insert on Bezeroa
for each row 
begin
	if new.mota = "premium" THEN 
    insert into premium (IdBezeroa, Iraungitzedata) values (NEW.IdBezeroa, DATE_ADD(CURRENT_DATE(), INTERVAL 1 YEAR));
    END IF;
end;


create table BezeroDesaktibatuak (
IdBezeroa varchar(7) primary key,
Izena varchar(10) not null,
Abizena varchar(15) not null,
Hizkuntza enum("ES", "EU", "EN", "FR", "DE", "CA", "GA", "AR") not null,
erabiltzailea varchar(10) not null unique,
pasahitza varchar(10) not null,
jaiotzedata date not null,
Erregistrodata date not null,
Iraungitzedata date not null,
mota enum("premium","free"),
foreign key (Hizkuntza) references Hizkuntza(IdHizkuntza) on delete cascade on update cascade,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa) on delete cascade on update cascade
);

DELIMITER //
DROP TRIGGER IF EXISTS BezeroDesaktibatu//
CREATE TRIGGER BezeroDesaktibatu
AFTER DELETE ON premium
FOR EACH ROW
BEGIN
    DECLARE id_bezero VARCHAR(7);
    
    SELECT IdBezeroa INTO id_bezero FROM Bezeroa WHERE IdBezeroa = OLD.IdBezeroa;
    
    DELETE FROM premium WHERE IdBezeroa = OLD.IdBezeroa;
END;
//


