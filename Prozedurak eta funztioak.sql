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
    select count(*) into zenbatabestigustuko
    from gustukoak
    where idbezeroa = id_usuario;
    return zenbatabestigustuko;
end; 
//

delimiter //
drop procedure if exists bezeroapremium//
create procedure  bezeroapremium(idbezeroa varchar(7)) begin
declare aurkitu boolean default 1;

declare continue handler for sqlstate '23000'
set aurkitu = 0;

select idbezeroa 
from premium
where idbezeroa = idbezeroa;

if aurkitu = 0 then
select concat ('hemen sartu da') errorea;
end if;
end;
//





--   premium tartea



delimiter //
drop procedure if exists premiummugaprocedure//
create procedure premiummugaprocedure(bezerokant int)
begin
	declare idbezeroa varchar(7);
    declare bukle int;
    set bukle = 0;
    
      while bezerokant > bukle do
        
            select 'idbezeroa: ', idbezeroa; -- agregar este mensaje de depuración
            -- deitu premium muga procedure idbezeroarekin
            call premiummuga(idbezeroa);
           set bukle = bukle + 1;
    end while;

end//
delimiter ;

delimiter //
drop procedure if exists premiummuga//
create procedure premiummuga(idbezero varchar(7))
begin
    declare gaur date;
    declare premiummugadata date;
    
    set gaur = curdate();

    select iraungitzedata into premiummugadata
    from premium
    where idbezeroa = idbezero;

    if premiummugadata is not null then
        select 'premium muga data: ', premiummugadata;

        if timestampdiff(day, gaur, premiummugadata) < 0 then
            -- cambiar el tipo de cliente a 'free' en la tabla 'bezeroa'
            update bezeroa
            set mota = 'free'
            where idbezeroa = idbezero; 
            
            -- insertar el cliente desactivado en la tabla 'bezerodesaktibatuak'
            insert into bezerodesaktibatuak (idbezeroa, izena, abizena, hizkuntza, erabiltzailea, pasahitza, jaiotzedata, erregistrodata, iraungitzedata, mota)
            select b.idbezeroa, b.izena, b.abizena, b.hizkuntza, b.erabiltzailea, b.pasahitza, b.jaiotzedata, b.erregistrodata, p.iraungitzedata, b.mota
            from bezeroa b
            join premium p on b.idbezeroa = p.idbezeroa
            where b.idbezeroa = idbezero;
        
            -- eliminar al cliente premium llamando al procedimiento eliminarpremium
            call eliminarpremium(idbezero);
        end if;
    else
        select 'error: no se encontró fecha de vencimiento para el cliente ', idbezero;
    end if;
end //

delimiter ;


 -- eliminar al cliente premium llamando al procedimiento eliminarpremium
delimiter //
drop procedure if exists eliminarpremium//
create procedure eliminarpremium(idbezero varchar(7))
begin
    -- eliminar al cliente premium de la tabla 'premium'
    delete from premium
    where idbezeroa = idbezero;
end //





delimiter //
drop procedure if exists premiumbezerokant//
create procedure premiumbezerokant()
begin
    declare bezerokant bigint default 0;
    set bezerokant = (select count(idbezeroa) from premium);
    call premiummugaprocedure(bezerokant);
end;
//


-- 

















delimiter //
drop procedure if exists premiumberrezari//
create procedure premiumberrezari(id varchar(7))
begin
    if exists (select * from bezerodesaktibatuak where idbezeroa = id) then
        if exists (select * from bezeroa where idbezeroa = id and mota = 'premium') then
            delete from bezerodesaktibatuak
            where idbezeroa = id;
        end if;
    end if;
end //
delimiter ;


