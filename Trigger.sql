use mimi;

-- debug album iraupena insert
create table albumiraupenakinsert (
    id int auto_increment primary key,
    timestamp timestamp default current_timestamp,
    message text
);



-- egin behar (albumaren iraupena ateratzeko)



delimiter //
drop trigger if exists iraupenakgehitu// 
create trigger iraupenakgehitu after insert on abestia
for each row 
begin 
    declare albumiraupena time;

    -- obtener la duración total del álbum asociado al nuevo audio
    select sec_to_time(sum(time_to_sec(audio.iraupena))) into albumiraupena
    from audio
    inner join abestia on audio.idaudio = abestia.idaudio
    where abestia.idalbum = new.idalbum;

    -- registro del mensaje de depuración
    insert into albumiraupenakinsert (message) values (concat('audio berri bat gehituta albumara, iraupena : ', albumiraupena));

    -- actualizar la duración del álbum
    update album
    set iraupena = albumiraupena
    where idalbum = new.idalbum;
end;
//



delimiter //
drop trigger if exists abestiagehitu//
create trigger abestiagehitu
after insert on erreprodukzioak
for each row
begin
 update estatistikak
    set entzundakoa = entzundakoa + 1
    where idaudio = new.idaudio;
end;
//

delimiter //
drop trigger if exists bezeropremium//
create trigger bezeropremium
after update on bezeroa
for each row 
begin
	if old.mota = "free" and new.mota = "premium" then 
    insert into premium (idbezeroa, iraungitzedata) values (new.idbezeroa, date_add(current_date(), interval 1 year));
    end if;
end;
//

delimiter //
drop trigger if exists musikariadelete//
-- musikariadelete
create trigger musikariadelete
before delete on musikaria -- musikaria taulako errenkada bat ezabatu ondoren aktibatzen da
for each row -- DELETE errenkada bakoitza
begin
    -- Ezabatu ezazu kantari horrekin loturiko abestiak
		delete from audio where idaudio in (
        select abestia.idaudio from abestia 
        inner join album  on abestia.idalbum = album.idalbum
        where album.idmusikaria = OLD.idmusikaria
    );
end;
//
-- Variable OLD
-- OLD a diferencia de NEW, almacena el valor de las columnas que van a ser borradas o eliminadas. 
-- Al igual que pasa con NEW, OLD no está disponible en todas las instrucciones, más concretamente 
-- el valor no se puede recuperar cuando la instrucción es un INSERT.
-- Leheneratutako delimitatzailea berreskuratu







