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
delimiter;

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
delimiter;

-- función para calcular la edad de un usuario
delimiter //
drop function if exists bezeroarenadina//
create function bezeroarenadina(jaio_data date) returns int
reads sql data
begin
    declare adina int;
    set adina = (current_date()) - (jaio_data);
    return adina;
end;
 //
delimiter;


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
delimiter;

-- insert erreprodukzioak procedure:

delimiter //
drop procedure if exists erreprodukzioagehitu//
create procedure erreprodukzioagehitu(idbezeroa varchar(7),idaudio varchar(7))
reads sql data

begin
    insert into erreprodukzioak values (idbezeroa,idaudio,now());
end;
//
delimiter;

-- insert erreprodukzioak procedure:

delimiter //
drop procedure if exists Musikariagehitu//
create procedure Musikariagehitu(idmusikaria varchar(7), izenartistikoa varchar(50), ezaugarria enum("bakarlaria","taldea"), deskribapena longtext)
reads sql data

begin
    insert into musikaria values (idmusikaria,izenartistikoa,from_base64('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'),ezaugarria, deskribapena);
end;
//
delimiter;

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
delimiter;






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
DELIMITER ;

delimiter //
drop procedure if exists premiumberrezari//
create procedure premiumberrezari(idbezero varchar(7))
begin

  if length(idbezero) != 7 then
        signal sqlstate '45000' set message_text = 'Sartutako aldagaia ez da baliozkoa';
		end if;
    if exists (select * from bezerodesaktibatuak where idbezeroa = id) then
        if exists (select * from bezeroa where idbezeroa = id and mota = 'premium') then
            delete from bezerodesaktibatuak
            where idbezeroa = idbezero;
        end if;
    end if;
end //
delimiter ;


