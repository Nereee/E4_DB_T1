delimiter //
drop event if exists EguneratuEstadistikak//
CREATE EVENT EguneratuEstadistikak
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
    BEGIN
     UPDATE Estatistikak
        SET  Entzundakoa = (
            SELECT SUM(Entzundakoa)
            FROM Estatistikak
            WHERE data = CURDATE()
        )
        WHERE data = CURDATE();
END;

DELIMITER //
drop event if exists BezeroDesaktibatu//
create event BezeroDesaktibatu
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
begin
declare amaiera bool default 0;
declare v_IdBezeroa varchar(7);
declare v_Izena varchar(10);
declare v_Abizena varchar(15);
declare v_Hizkuntza enum("ES", "EU", "EN", "FR", "DE", "CA", "GA", "AR");
declare v_erabiltzailea varchar(10);
declare v_pasahitza varchar(10);
declare v_jaiotzedata date;
declare v_Erregistrodata date;
declare v_Iraungitzedata date;
declare v_mota enum("premium","free");
declare c cursor for
    
    select * from Bezeroa inner join premium using (IdBezeroa);
    
    declare continue handler for not found

set amaiera = 1;

while amaiera = 0 do
	fetch c into v_IdBezeroa, v_Izena,v_Abizena, v_Hizkuntza,v_erabiltzailea,v_pasahitza,v_jaiotzedata,v_Erregistrodata,v_Iraungitzedata, v_mota;
	insert into BezeroDesaktibatuak values (v_IdBezeroa, v_Izena,v_Abizena, v_Hizkuntza,v_erabiltzailea,v_pasahitza,v_jaiotzedata,v_Erregistrodata,v_Iraungitzedata, v_mota);
end while;

end;



