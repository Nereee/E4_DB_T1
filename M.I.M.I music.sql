drop database if exists mimi;
create database mimi
collate utf8mb4_spanish_ci;

use mimi;

create table musikaria (
idmusikaria varchar(7) primary key,
izenartistikoa varchar(50) unique not null,
irudia longblob not null,
ezaugarria enum("bakarlaria","taldea") not null,
deskribapena longtext not null 
);

create table podcaster (
idpodcaster varchar(7) primary key,
izenartistikoa varchar(50) unique not null,
irudia longblob not null,
deskribapena longtext not null 
);

create table audio (
idaudio varchar(7) primary key,
izena varchar(40) not null,
iraupena time not null,
mota enum("podcast","abestia") not null,
irudia longblob not null
);

create table podcast (
idaudio varchar(7) primary key,
kolaboratzaileak varchar(100),
idpodcaster varchar(7) not null,
deskribapena longtext not null,
foreign key (idaudio) references audio(idaudio) on delete cascade on update cascade,
foreign key (idpodcaster) references podcaster(idpodcaster) on delete cascade on update cascade
);

create table album (
idalbum varchar(7) primary key,
izenburua varchar(20) not null,
urtea date not null,
generoa varchar(20) not null,
idmusikaria varchar(7) not null,
kolaboratzaileak varchar(100),
iraupena time not null,
foreign key (idmusikaria) references musikaria (idmusikaria) on update cascade on delete cascade
);

create table abestia (
idaudio varchar(7) primary key,
idalbum varchar(7) not null,
foreign key (idaudio) references audio(idaudio) on delete cascade on update cascade,
foreign key (idalbum) references album(idalbum) on delete cascade on update cascade
);

create table hizkuntza (
idhizkuntza enum("es", "eu", "en", "fr", "de", "ca", "ga", "ar") primary key,
deskribapena varchar(50) not null
);

create table bezeroa (
idbezeroa varchar(7) primary key,
izena varchar(10) not null,
abizena varchar(15) not null,
hizkuntza enum("es", "eu", "en", "fr", "de", "ca", "ga", "ar") not null,
erabiltzailea varchar(10) not null unique,
pasahitza varchar(10) not null,
jaiotzedata date not null,
erregistrodata date not null,
mota enum("premium","free"),
constraint v_idbezero foreign key (hizkuntza) references hizkuntza(idhizkuntza) on delete cascade on update cascade
);

create table playlist (
idlist varchar(7) primary key,
izenburua varchar(60) not null,
sorreradata date not null,
idbezeroa varchar(7) not null,
 foreign key (idbezeroa) references bezeroa (idbezeroa)on delete cascade on update cascade
);

create table playlist_abestiak (
idaudio varchar(7),
idlist varchar(7),
data date,
primary key (idaudio,idlist, data),
foreign key (idaudio) references abestia(idaudio) on delete cascade on update cascade,
foreign key (idlist) references playlist(idlist) on delete cascade on update cascade
);

create table premium (
idbezeroa varchar(7) primary key,
iraungitzedata date not null,
foreign key (idbezeroa) references bezeroa(idbezeroa) on delete cascade on update cascade
);

create table gustukoak (
idbezeroa varchar(7),
idaudio varchar(7),
primary key (idbezeroa,idaudio),
foreign key (idbezeroa) references bezeroa(idbezeroa) on delete cascade on update cascade,
foreign key (idaudio) references audio(idaudio) on delete cascade on update cascade
);

create table erreprodukzioak (
idbezeroa varchar(7),
idaudio varchar(7),
data datetime,
primary key (idbezeroa,idaudio, data),
foreign key (idbezeroa) references bezeroa(idbezeroa) on delete cascade on update cascade,
foreign key (idaudio) references audio(idaudio) on delete cascade on update cascade
);

create table estatistikak (
idaudio varchar(7) primary key,
gustukoabestiak int not null,
gustokopodcaster int not null,
entzundakoa int not null,
playlist int not null,
foreign key (idaudio) references audio(idaudio) on delete cascade on update cascade
);


create table bezerodesaktibatuak (
idbezeroa varchar(7) primary key,
izena varchar(10) not null,
abizena varchar(15) not null,
hizkuntza enum("es", "eu", "en", "fr", "de", "ca", "ga", "ar") not null,
erabiltzailea varchar(10) not null unique,
pasahitza varchar(10) not null,
jaiotzedata date not null,
erregistrodata date not null,
iraungitzedata date not null,
mota enum("premium","free"),
foreign key (hizkuntza) references hizkuntza(idhizkuntza) on delete cascade on update cascade,
foreign key (idbezeroa) references bezeroa(idbezeroa) on delete cascade on update cascade
);

create table admintaula(
idbezeroa varchar(7) primary key,
hizkuntza enum("es", "eu", "en", "fr", "de", "ca", "ga", "ar") not null,
erabiltzailea varchar(10) not null unique,
pasahitza varchar(10) not null,
erregistrodata date not null,
constraint v_idbezero2 foreign key (hizkuntza) references hizkuntza(idhizkuntza) on delete cascade on update cascade
);

