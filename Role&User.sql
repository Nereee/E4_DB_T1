use mimi;

-- Rolak --
drop role if exists DB_Administratzailea;
drop role if exists Departamentu_burua;
drop role if exists Analistak;
drop role if exists Langileak;
drop role if exists Bezeroa;

create role DB_Administratzailea;
create role Departamentu_burua;
create role Analistak;
create role Langileak;
create role Bezeroa;

-- Baimenak esleitu --
grant all privileges on MIMI.* to DB_Administratzailea;
grant select, insert, update, delete on MIMI.* to Departamentu_burua;
grant select on MIMI.* to Analistak;
grant select, update on MIMI.* to Langileak;
grant select on MIMI.* to Bezeroa;

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
grant Analistak to Salmenta, Finantza;
grant Langileak to TecEstrategia;
grant Bezeroa to Legea;

select * from mysql.user;
show grants for Zuzendaria;
show grants for GizaBaliabidea;
show grants for Salmenta;
show grants for Finantza;
show grants for TecEstrategia;
show grants for Legea;
show grants for IT;