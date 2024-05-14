use mimi;

set global event_scheduler = on;

drop event if exists eguneropremiummugaevent;

delimiter //
create event if not exists eguneropremiummugaevent
on schedule
    every 1 day
    starts current_timestamp
do
begin
    call premiummugaprocedure();
end //
delimiter ;

delimiter //
drop event if exists eguneratuestadistikak//
create event eguneratuestadistikak
on schedule every 1 day
starts current_timestamp
do
    begin
     update estatistikak
        set  entzundakoa = (
            select sum(entzundakoa)
            from estatistikak
            where data = curdate()
        )
        where data = curdate();
end;

delimiter //
drop event if exists bezerodesaktibatu//
create event bezerodesaktibatu
on schedule every 1 day
starts current_timestamp
do
begin
declare amaiera bool default 0;
declare v_idbezeroa varchar(7);
declare v_izena varchar(10);
declare v_abizena varchar(15);
declare v_hizkuntza enum("es", "eu", "en", "fr", "de", "ca", "ga", "ar");
declare v_erabiltzailea varchar(10);
declare v_pasahitza varchar(10);
declare v_jaiotzedata date;
declare v_erregistrodata date;
declare v_iraungitzedata date;
declare v_mota enum("premium","free");
declare c cursor for
    
    select * from bezeroa inner join premium using (idbezeroa);
    
    declare continue handler for not found

set amaiera = 1;

while amaiera = 0 do
	fetch c into v_idbezeroa, v_izena,v_abizena, v_hizkuntza,v_erabiltzailea,v_pasahitza,v_jaiotzedata,v_erregistrodata,v_iraungitzedata, v_mota;
	insert into bezerodesaktibatuak values (v_idbezeroa, v_izena,v_abizena, v_hizkuntza,v_erabiltzailea,v_pasahitza,v_jaiotzedata,v_erregistrodata,v_iraungitzedata, v_mota);
end while;

end;


delimiter //
create event eguneratupremiumkontuak
on schedule every 1 day
starts current_timestamp
do
begin
    declare idbezeroa varchar(7);
    declare done int default false;
    declare amaiera int default 0;

    declare c cursor for
        select idbezeroa
        from premium;

    declare continue handler for not found
        set done = true;
    open c;
    while amaiera = 0 do
        fetch c into idbezeroa;
        if done then
            set amaiera = 1;
        else
            call premiummuga(idbezeroa);
        end if;
    end while;
    close c;
end;
//
delimiter ;


