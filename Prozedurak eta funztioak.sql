#---------------------------prozedurak/funtzioak---------------------------------------------

-- función para calcular la duración total de un álbum
delimiter //
drop function if exists albumareniraupena//
create function albumareniraupena(id_album varchar(7)) returns time
reads sql data
begin
    declare iraupenatotala time;
    select sec_to_time(sum(time_to_sec(iraupena))) into iraupenatotala
    from abestia
    where idalbum = id_album;
    return iraupenatotala;
end;
//

-- procedimiento para actualizar estadísticas
delimiter //
drop procedure if exists estadistikakeguneratu//
create procedure estadistikakeguneratu(id_audio varchar(7))
reads sql data
begin
    update estatistikak
    set gustukoabestiak = (select count(*) from gustukoak where idaudio = id_audio),
        gustokopodcaster = (select count(*) from podcast where idaudio = id_audio),
        entzundakoa = (select count(*) from erreprodukzioak where idaudio = id_audio),
        playlist = (select count(*) from playlist_abestiak where idaudio = id_audio);
end; 
//

-- función para calcular la edad de un usuario
drop function if exists bezeroarenadina;
delimiter //
create function bezeroarenadina(jaio_data date) returns int
reads sql data
begin
    declare adina int;
    set adina = (current_date()) - (jaio_data);
    return adina;
end;
 //


-- función para obtener el número de canciones favoritas de un usuario
delimiter //
drop function if exists zenbatabestigustuko//
create function zenbatabestigustuko(idbezeroa varchar(7)) returns int
reads sql data
begin
    declare zenbatabestigustuko int;

  if length(idbezeroa) != 7 then
    
        signal sqlstate '45000' set message_text = 'Sartutako aldagaia ez da baliozkoa';
		end if;

		select count(*) into zenbatabestigustuko
		from gustukoak
		where idbezeroa = idbezeroa;
		return zenbatabestigustuko;
end; 
//

-- insert erreprodukzioak procedure:

delimiter //
drop procedure if exists erreprodukzioagehitu//
create procedure erreprodukzioagehitu(idbezeroa varchar(7),idaudio varchar(7))
reads sql data

  if length(idbezeroa) != 7 or length(idaudio) != 7 then
    
        signal sqlstate '45000' set message_text = 'Sartutako aldagaia ez da baliozkoa';
		end if;

begin
    insert into erreprodukzioak values (idbezeroa,idaudio, datetime );
end;
//

-- insert erreprodukzioak procedure:






-- 











--   premium tartea


delimiter //
drop procedure if exists bezeroapremium//
create procedure  bezeroapremium(idbezeroa varchar(7)) begin
declare aurkitu boolean default 1;


declare continue handler for sqlstate '23000'
set aurkitu = 0;

  if length(idbezeroa) != 7 then
       
        signal sqlstate '45000' set message_text = 'Sartutako aldagaia ez da baliozkoa';
		end if;

select idbezeroa 
from premium
where idbezeroa = idbezeroa;

if aurkitu = 0 then
select concat ('hemen sartu da') errorea;
end if;
end;
//






DELIMITER //
-- Bezeroen iraungitzedata gaur baino txikiagoa ba da, mota free jarri, premiun taulatik ezabatu eta bezero desaktibatuan sartu.
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
            call kendupremium(idbezero);
    
    
      END IF;
    END WHILE;

    CLOSE c;
END //

DELIMITER ;


 -- ezabatu bezeroa premiun taulatik
delimiter //
drop procedure if exists kendupremium//
create procedure kendupremium(idbezero varchar(7))
begin
    
    declare exit handler for 1329
	select ("Ez dago premium gaurko mugarekin") as ErroreMezua1;
    
    delete from premium
    where idbezeroa = idbezero;
end //

delimiter //
drop procedure if exists premiumberrezari//
create procedure premiumberrezari(id varchar(7))
begin

  if length(idbezeroa) != 7 then
        signal sqlstate '45000' set message_text = 'Sartutako aldagaia ez da baliozkoa';
		end if;
    if exists (select * from bezerodesaktibatuak where idbezeroa = id) then
        if exists (select * from bezeroa where idbezeroa = id and mota = 'premium') then
            delete from bezerodesaktibatuak
            where idbezeroa = id;
        end if;
    end if;
end //
delimiter ;


