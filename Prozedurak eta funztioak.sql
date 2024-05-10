#---------------------------prozedurak/funtzioak---------------------------------------------

-- Función para Calcular la Duración Total de un Álbum
DELIMITER //
drop function if exists AlbumarenIraupena//
CREATE FUNCTION AlbumarenIraupena(id_album VARCHAR(7)) RETURNS TIME
reads sql data
BEGIN
    DECLARE IraupenaTotala TIME;
    SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(Iraupena))) INTO IraupenaTotala
    FROM Abestia
    WHERE IdAlbum = id_album;
    RETURN IraupenaTotala;
END;
//

-- Procedimiento para Actualizar Estadísticas
DELIMITER //
drop procedure if exists estadistikakEguneratu//
CREATE PROCEDURE estadistikakEguneratu(id_audio VARCHAR(7))
reads sql data
BEGIN
    UPDATE Estatistikak
    SET GustukoAbestiak = (SELECT COUNT(*) FROM gustukoak WHERE IdAudio = id_audio),
        GustokoPodcaster = (SELECT COUNT(*) FROM Podcast WHERE IdAudio = id_audio),
        Entzundakoa = (SELECT COUNT(*) FROM Erreprodukzioak WHERE IdAudio = id_audio),
        playlist = (SELECT COUNT(*) FROM playlist_abestiak WHERE IdAudio = id_audio);
END; 
//

-- Función para Calcular la Edad de un Usuario
drop function if exists BezeroarenAdina;
DELIMITER //
CREATE FUNCTION BezeroarenAdina(jaio_data DATE) RETURNS INT
reads sql data
BEGIN
    DECLARE adina INT;
    SET adina = (CURRENT_DATE()) - (jaio_data);
    RETURN adina;
END;
 //

-- Función para Obtener el Número de Canciones Favoritas de un Usuario
DELIMITER //
drop function if exists ZenbatAbestiGustuko//
CREATE FUNCTION ZenbatAbestiGustuko(IdBezeroa VARCHAR(7)) RETURNS INT
reads sql data
BEGIN
    DECLARE ZenbatAbestiGustuko INT;
    SELECT COUNT(*) INTO ZenbatAbestiGustuko
    FROM gustukoak
    WHERE IdBezeroa = id_usuario;
    RETURN ZenbatAbestiGustuko;
END; 
//

Delimiter //
drop procedure if exists BezeroaPremium//
create procedure  BezeroaPremium(IdBezeroa varchar(7)) begin
declare aurkitu boolean default 1;

declare continue handler for sqlstate '23000'
set aurkitu = 0;

select IdBezeroa 
from premium
where IdBezeroa = IdBezeroa;

if aurkitu = 0 then
select concat ('Hemen sartu da') ERROREA;
end if;
end;
//





--   PREMIUM TARTEA



DELIMITER //
DROP PROCEDURE IF EXISTS premiumMugaProcedure//
CREATE PROCEDURE premiumMugaProcedure(bezeroKant int)
BEGIN
	DECLARE IdBezeroa VARCHAR(7);
    DECLARE bukle INT;
    SET bukle = 0;
    
      WHILE bezeroKant > bukle DO
        
            SELECT 'IdBezeroa: ', IdBezeroa; -- Agregar este mensaje de depuración
            -- Deitu Premium muga procedure idbezeroarekin
            CALL premiumMuga(IdBezeroa);
           SET bukle = bukle + 1;
    END WHILE;

END//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS premiumMuga//
CREATE PROCEDURE premiumMuga(IdBezero VARCHAR(7))
BEGIN
    DECLARE gaur DATE;
    DECLARE premiumMugaData DATE;
    
    SET gaur = CURDATE();

    SELECT Iraungitzedata INTO premiumMugaData
    FROM premium
    WHERE IdBezeroa = IdBezero;

    IF premiumMugaData IS NOT NULL THEN
        SELECT 'Premium muga data: ', premiumMugaData;

        IF TIMESTAMPDIFF(DAY, gaur, premiumMugaData) < 0 THEN
            -- Cambiar el tipo de cliente a 'Free' en la tabla 'Bezeroa'
            UPDATE Bezeroa
            SET mota = 'Free'
            WHERE IdBezeroa = IdBezero; 
            
            -- Insertar el cliente desactivado en la tabla 'BezeroDesaktibatuak'
            INSERT INTO BezeroDesaktibatuak (IdBezeroa, Izena, Abizena, Hizkuntza, erabiltzailea, pasahitza, jaiotzedata, Erregistrodata, Iraungitzedata, mota)
            SELECT b.IdBezeroa, b.Izena, b.Abizena, b.Hizkuntza, b.erabiltzailea, b.pasahitza, b.jaiotzedata, b.Erregistrodata, p.Iraungitzedata, b.mota
            FROM Bezeroa b
            JOIN premium p ON b.IdBezeroa = p.IdBezeroa
            WHERE b.IdBezeroa = IdBezero;
        
            -- Eliminar al cliente premium llamando al procedimiento eliminarPremium
            CALL eliminarPremium(IdBezero);
        END IF;
    ELSE
        SELECT 'Error: No se encontró fecha de vencimiento para el cliente ', IdBezero;
    END IF;
END //

DELIMITER ;


 -- Eliminar al cliente premium llamando al procedimiento eliminarPremium
DELIMITER //
DROP PROCEDURE IF EXISTS eliminarPremium//
CREATE PROCEDURE eliminarPremium(IdBezero VARCHAR(7))
BEGIN
    -- Eliminar al cliente premium de la tabla 'premium'
    DELETE FROM premium
    WHERE IdBezeroa = IdBezero;
END //





DELIMITER //
drop procedure if exists premiumBezeroKant//
CREATE procedure premiumBezeroKant()
BEGIN
    declare bezeroKant bigint default 0;
    set bezeroKant = (SELECT COUNT(IdBezeroa) FROM premium);
    call premiumMugaProcedure(bezeroKant);
END;
//


-- 

















DELIMITER //
DROP PROCEDURE IF EXISTS premiumBerrezari//
CREATE PROCEDURE premiumBerrezari(Id VARCHAR(7))
BEGIN
    IF EXISTS (SELECT * FROM BezeroDesaktibatuak WHERE IdBezeroa = Id) THEN
        IF EXISTS (SELECT * FROM Bezeroa WHERE IdBezeroa = Id AND mota = 'premium') THEN
            DELETE FROM BezeroDesaktibatuak
            WHERE IdBezeroa = Id;
        END IF;
    END IF;
END //
DELIMITER ;


