-- INSERT INTO Bezeroa (IdBezeroa, Izena, Abizena, Hizkuntza, erabiltzailea, pasahitza, jaiotzedata, Erregistrodata, mota)
-- VALUES 
 --   ('BZ009', 'g', 'g', 'EU', 'g', 'g', '1990-05-15', '2023-02-10', 'free');

-- update Bezeroa set mota = "premium" where IdBezeroa = "BZ006";

--  update premium set Iraungitzedata = "2024-05-09" where IdBezeroa = "BZ003";

call premiummuga();



DELIMITER //

DROP PROCEDURE IF EXISTS premiummuga//

CREATE PROCEDURE premiummuga()
BEGIN
    DECLARE gaur DATE;
    DECLARE idbezero VARCHAR(7);
    DECLARE iraungitzedat  DATE;
	declare amaiera bool default 1;
    
	declare c cursor for -- deklaratu kurtsorea
	SELECT idbezeroa, iraungitzedata
	FROM premium;

	declare exit handler for 1329
	select ("Ez dago premium gaurko mugarekin") as ErroreMezua1;
    
	declare continue handler for not found -- errorea, out of bounds (Array moduko estrukturatik irtetean)
	set amaiera = 0;
    SET gaur = CURDATE();
    
    open c; -- Ireki kurtsorea

    while amaiera = 1 do
	FETCH c INTO idbezero, iraungitzedat;
    select concat(idbezero, " idbezeroa ,  " , iraungitzedat ," iraungitze data ") as Info;
    
    
	IF TIMESTAMPDIFF(DAY, gaur, iraungitzedat) < 0 THEN
		
        select concat(idbezero, " idbezeroa ,  " , iraungitzedat ," iraungitze data, gaur baino txikiago da ") as Info2;

            -- aldatu bezero mota
            update bezeroa
            set mota = 'free'
            where idbezeroa = idbezero; 
            
            -- ezarri bezeroaren informazioa 'bezerodesaktibatuak' taulan
            insert into bezerodesaktibatuak (idbezeroa, izena, abizena, hizkuntza, erabiltzailea, pasahitza, jaiotzedata, erregistrodata, iraungitzedata, mota)
            select b.idbezeroa, b.izena, b.abizena, b.hizkuntza, b.erabiltzailea, b.pasahitza, b.jaiotzedata, b.erregistrodata, p.iraungitzedata, b.mota
            from bezeroa b
            join premium p on b.idbezeroa = p.idbezeroa
            where b.idbezeroa = idbezero;
        
            -- 
            call eliminarpremium(idbezero);
    
    
      END IF;
    END WHILE;

    CLOSE c;
END //

DELIMITER ;
    
    
