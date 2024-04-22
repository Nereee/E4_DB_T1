drop database if exists MIMI;
create database MIMI
collate utf8mb4_spanish_ci;

use MIMI;

create table Musikaria (
Idmusikaria varchar(7) primary key,
IzenArtistikoa varchar(50) unique not null,
Irudia longblob not null,
Ezaugarria ENUM("barkalia","taldea") not null,
Deskribapena longtext not null 
);

create table Podcaster (
IdPodcaster varchar(7) primary key,
IzenArtistikoa varchar(50) unique not null,
Irudia longblob not null,
Deskribapena longtext not null 
);

create table Audio (
IdAudio varchar(7) primary key,
Izena varchar(40) not null,
Iraupena time not null,
mota enum("podcast","abestia") not null,
Irudia longblob not null
);

create table Podcast (
IdAudio varchar(7) primary key,
Kolaboratzaileak varchar(100),
IdPodcaster varchar(7) not null,
Deskribapena longtext not null,
foreign key (IdAudio) references Audio(IdAudio) on delete cascade on update cascade,
foreign key (IdPodcaster) references Podcaster(IdPodcaster) on delete cascade on update cascade
);

create table Album (
IdAlbum varchar(7) primary key,
Izenburua varchar(20) not null,
urtea date not null,
generoa varchar(20) not null,
Idmusikaria varchar(7) not null,
Kolaboratzaileak varchar(100),
foreign key (Idmusikaria) references Musikaria (Idmusikaria) on update cascade on delete cascade
);

create table Abestia (
IdAudio varchar(7) primary key,
IdAlbum varchar(7) not null,
foreign key (IdAudio) references Audio(IdAudio) on delete cascade on update cascade,
foreign key (IdALbum) references Album(IdAlbum) on delete cascade on update cascade
);

create table Hizkuntza (
IdHizkuntza enum("ES", "EU", "EN", "FR", "DE", "CA", "GA", "AR") primary key,
Deskribapena varchar(50) not null
);

create table Bezeroa (
IdBezeroa varchar(7) primary key,
Izena varchar(10) not null,
Abizena varchar(15) not null,
Hizkuntza enum("ES", "EU", "EN", "FR", "DE", "CA", "GA", "AR") not null,
erabiltzailea varchar(10) not null unique,
pasahitza varchar(10) not null,
jaiotzedata date not null,
Erregistrodata date not null,
mota enum("premium","free"),
constraint v_idBezero foreign key (Hizkuntza) references Hizkuntza(IdHizkuntza)
);

create table Playlist (
IdList varchar(7) primary key,
Izenburua varchar(15) not null,
Sorreradata date not null,
IdBezeroa varchar(7) not null,
 foreign key (IdBezeroa) references Bezeroa (IdBezeroa)on delete cascade on update cascade
);

create table playlist_abestiak (
IdAudio varchar(7),
IdList varchar(7),
data date,
primary key (IdAudio,IdList, data),
foreign key (IdAudio) references Abestia(IdAudio) on delete cascade on update cascade,
foreign key (IdList) references Playlist(IdList) on delete cascade on update cascade
);

create table premium (
IdBezeroa varchar(7) primary key,
Iraungitzedata date not null,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa) on delete cascade on update cascade
);

create table gustukoak (
IdBezeroa varchar(7),
IdAudio varchar(7),
primary key (IdBezeroa,IdAudio),
foreign key (IdBezeroa) references Bezeroa(IdBezeroa) on delete cascade on update cascade,
foreign key (IdAudio) references Audio(IdAudio) on delete cascade on update cascade
);

create table Erreprodukzioak (
IdBezeroa varchar(7),
IdAudio varchar(7),
data date,
primary key (IdBezeroa,IdAudio, data),
foreign key (IdBezeroa) references Bezeroa(IdBezeroa) on delete cascade on update cascade,
foreign key (IdAudio) references Audio(IdAudio) on delete cascade on update cascade
);

create table Estatistikak (
IdAudio varchar(7) primary key,
GustukoAbestiak int not null,
GustokoPodcaster int not null,
Entzundakoa int not null,
playlist int not null,
foreign key (IdAudio) references Audio(IdAudio)
);
