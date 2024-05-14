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
show events;
select * from information_schema.events where event_name = 'eguneropremiummugaevent';
