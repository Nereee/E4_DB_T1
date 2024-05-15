delimiter //

drop procedure if exists erreprodukzioagehitu//

create procedure erreprodukzioagehitu(idbezeroa varchar(7), idaudio varchar(7))
reads sql data
begin
   -- if length(idbezeroa) != 7 or length(idaudio) != 7 then
     --   signal sqlstate '45000' set message_text = 'Sartutako aldagaia ez da baliozkoa';
    -- end if;

    insert into erreprodukzioak values (idbezeroa, idaudio, NOW());
end;
//

delimiter ;
