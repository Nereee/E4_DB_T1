use MIMI;



-- Debug album iraupena insert
CREATE TABLE AlbumIraupenakInsert (
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
    INSERT INTO AlbumIraupenakInsert (Message) VALUES (CONCAT('Audio berri bat gehituta albumara, Iraupena : ', albumIraupena));

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
	if OLD.mota = "free" and new.mota = "premium" THEN 
    insert into premium (IdBezeroa, Iraungitzedata) values (NEW.IdBezeroa, DATE_ADD(CURRENT_DATE(), INTERVAL 1 YEAR));
    END IF;
end;
//

DELIMITER //
DROP TRIGGER IF EXISTS BezeroDesaktibatu//
CREATE TRIGGER BezeroDesaktibatu
Before DELETE ON premium
FOR EACH ROW
BEGIN

    DECLARE id_bezero VARCHAR(7);
    
    SELECT IdBezeroa INTO id_bezero FROM Bezeroa WHERE IdBezeroa = OLD.IdBezeroa;
    
    DELETE FROM premium WHERE IdBezeroa = OLD.IdBezeroa;
END;
//



