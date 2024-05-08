use MIMI;

-- Beharrezko Rolak Sortu --
drop role if exists DB_Administratzailea;
drop role if exists Departamentu_burua;
drop role if exists Analista1;
drop role if exists Analista2;
drop role if exists Langileak;
drop role if exists Bezeroa;

create role DB_Administratzailea;
create role Departamentu_burua;
create role Analista1;
-- create role Analista2;
create role Langileak;
create role Bezeroa;

-- ------------------------------ Baimenak esleitu ------------------------------ --
-- Roleei beharrzeko baimenak esleitu, 
-- Admin baimenak (Guztia) --
grant all privileges on MIMI.* to DB_Administratzailea;

-- Dep-Buruaren baimenak --
grant select, insert, update, delete on MIMI.* to Departamentu_burua;

-- Analisten baimenak --
grant select on MIMI.* to Analista1;
-- grant select on MIMI.* to Analista2;

-- Langileen baimenak --
-- ikusi guztia baina aldatu taula batzuk(adminean aldatu daitezke geratzen direnak) --
grant select on MIMI.* to Langileak;
GRANT UPDATE ON MIMI.abestia TO Langileak;
GRANT UPDATE ON MIMI.album TO Langileak;
GRANT UPDATE ON MIMI.audio TO Langileak;
GRANT UPDATE ON MIMI.bezeroa TO Langileak;
GRANT UPDATE ON MIMI.musikaria TO Langileak;
GRANT UPDATE ON MIMI.playlist TO Langileak;
GRANT UPDATE ON MIMI.playlist_abestiak TO Langileak;
GRANT UPDATE ON MIMI.podcast TO Langileak;
GRANT UPDATE ON MIMI.podcaster TO Langileak;
GRANT UPDATE ON MIMI.premium TO Langileak;
-- Sentzuzkoa izango lirake insert batzuk egin 

-- Bezeroen baimenak --
grant select on MIMI.abestia to Bezeroa;
grant select on MIMI.album to Bezeroa;
grant select on MIMI.playlist to Bezeroa;
grant select on MIMI.playlist_abestiak to Bezeroa;
grant select on MIMI.podcaster to Bezeroa;
grant select on MIMI.podcast to Bezeroa;

grant insert on MIMI.playlist to Bezeroa;
-- ------------------------------------------------------------------------------------ --
-- Erabiltzaileak --
drop user if exists GizaBaliabidea;
drop user if exists Salmenta;
drop user if exists Finantza;
drop user if exists TecEstrategia;
drop user if exists Legea;
drop user if exists IT;
drop user if exists Zuzendaria;

-- Sorrera --
create user Zuzendaria identified by "admin";
create user GizaBaliabidea identified by "1234";
create user Salmenta identified by "1234";
create user Finantza identified by "1234";
create user TecEstrategia identified by "1234";
create user Legea identified by "1234";
create user IT identified by "1234";

-- Rolak esleitu erabiltzaileei --
grant DB_Administratzailea to Zuzendaria;
grant Departamentu_burua to GizaBaliabidea;
grant Analista1 to Salmenta;
grant Analista1 to Finantza;
-- grant Analista2 to Finantza;
grant Langileak to TecEstrategia;
grant Langileak to Legea;
grant Langileak to IT;

select * from mysql.user;
show grants for Zuzendaria;
show grants for GizaBaliabidea;
show grants for Salmenta;
show grants for Finantza;
show grants for TecEstrategia;
show grants for Legea;
show grants for IT;

select MIMI.abestia;

select * from mysql.user;
SHOW GRANTS FOR Bezeroa;