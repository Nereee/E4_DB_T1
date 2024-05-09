use MIMI;



-- Debug album iraupena insert
CREATE TABLE DebugLog (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Message TEXT
);



-- Egin behar (Albumaren Iraupena ateratzeko)

DROP TRIGGER IF EXISTS IraupenakGehitu 


DELIMITER //

CREATE TRIGGER IraupenakGehitu AFTER INSERT ON Abestia
FOR EACH ROW 
BEGIN 
    DECLARE albumIraupena TIME;

    -- Obtener la duración total del álbum asociado al nuevo audio
    SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(Audio.Iraupena))) INTO albumIraupena
    FROM Audio
    INNER JOIN Abestia ON Audio.IdAudio = Abestia.IdAudio
    WHERE Abestia.IdAlbum = NEW.IdAlbum;

    -- Registro del mensaje de depuración
    INSERT INTO DebugLog (Message) VALUES (CONCAT('Nuevo audio insertado en Abestia. Duración del álbum: ', albumIraupena));

    -- Actualizar la duración del álbum
    UPDATE Album
    SET Iraupena = albumIraupena
    WHERE IdAlbum = NEW.IdAlbum;
END;
//



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
//

DELIMITER //
DROP TRIGGER IF exists BezeroPremium//
create trigger BezeroPremium
after update on Bezeroa
for each row 
begin
	if new.mota = "premium" THEN 
    insert into premium (IdBezeroa, Iraungitzedata) values (NEW.IdBezeroa, DATE_ADD(CURRENT_DATE(), INTERVAL 1 YEAR));
    END IF;
end;
//

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


