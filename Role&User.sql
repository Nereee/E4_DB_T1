use mimi;

-- beharrezko rolak sortu --
drop role if exists DB_Administratzailea;
drop role if exists Departamentu_burua;
drop role if exists Analista1;
drop role if exists Analista2;
drop role if exists Langileak;
drop role if exists Bezeroa;

create role db_administratzailea;
create role departamentu_burua;
create role analista1;
-- create role analista2;
create role langileak;
create role bezeroa;

-- ------------------------------ baimenak esleitu ------------------------------ --
-- roleei beharrzeko baimenak esleitu, 
-- admin baimenak (guztia) --
grant all privileges on mimi.* to db_administratzailea;

-- dep-buruaren baimenak --
grant select, insert, update, delete on mimi.* to departamentu_burua;

-- analisten baimenak --
grant select on mimi.* to analista1;
-- grant select on mimi.* to analista2;

-- langileen baimenak --
-- ikusi guztia baina aldatu taula batzuk(adminean aldatu daitezke geratzen direnak) --
grant select on mimi.* to langileak;
grant update on mimi.abestia to langileak;
grant update on mimi.album to langileak;
grant update on mimi.audio to langileak;
grant update on mimi.bezeroa to langileak;
grant update on mimi.musikaria to langileak;
grant update on mimi.playlist to langileak;
grant update on mimi.playlist_abestiak to langileak;
grant update on mimi.podcast to langileak;
grant update on mimi.podcaster to langileak;
grant update on mimi.premium to langileak;
-- sentzuzkoa izango lirake insert batzuk egin 

-- bezeroen baimenak --
grant select on mimi.abestia to bezeroa;
grant select on mimi.album to bezeroa;
grant select on mimi.playlist to bezeroa;
grant select on mimi.playlist_abestiak to bezeroa;
grant select on mimi.podcaster to bezeroa;
grant select on mimi.podcast to bezeroa;

grant insert on mimi.playlist to bezeroa;
-- ------------------------------------------------------------------------------------ --
-- erabiltzaileak --
drop user if exists gizabaliabidea;
drop user if exists salmenta;
drop user if exists finantza;
drop user if exists tecestrategia;
drop user if exists legea;
drop user if exists it;
drop user if exists zuzendaria;

-- sorrera --
create user zuzendaria identified by "admin";
create user gizabaliabidea identified by "1234";
create user salmenta identified by "1234";
create user finantza identified by "1234";
create user tecestrategia identified by "1234";
create user legea identified by "1234";
create user it identified by "1234";

-- rolak esleitu erabiltzaileei --
grant db_administratzailea to zuzendaria;
grant departamentu_burua to gizabaliabidea;
grant analista1 to salmenta;
grant analista1 to finantza;
-- grant analista2 to finantza;
grant langileak to tecestrategia;
grant langileak to legea;
grant langileak to it;

select * from mysql.user;
show grants for zuzendaria;
show grants for gizabaliabidea;
show grants for salmenta;
show grants for finantza;
show grants for tecestrategia;
show grants for legea;
show grants for it;

select mimi.abestia;

select * from mysql.user;
show grants for bezeroa;