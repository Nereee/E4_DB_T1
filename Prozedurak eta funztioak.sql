#---------------------------prozedurak/funtzioak---------------------------------------------

-- Función para Calcular la Duración Total de un Álbum
drop function if exists AlbumarenIraupena;
DELIMITER //
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
drop procedure if exists estadistikakEguneratu;
DELIMITER //
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
drop function if exists ZenbatAbestiGustuko;
DELIMITER //
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

drop procedure if exists BezeroaPremium;
delimiter //
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
