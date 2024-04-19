drop database if exists MIMI;
create database MIMI
collate utf8mb4_spanish_ci;

use MIMI;

create table Musikaria (
Idmusikaria varchar(5) primary key,
IzenArtistikoa varchar(50) unique not null,
Irudia varchar(30) not null,
Ezaugarria ENUM("barkalia","taldea") not null,
Deskribapena varchar(600) not null 
);

create table Podcaster (
IdPodcaster varchar(5) primary key,
IzenArtistikoa varchar(50) unique not null,
Irudia varchar(300) not null,
Deskribapena varchar(400) not null 
);

create table Audio (
IdAudio varchar(5) primary key,
Izena varchar(40) not null,
Iraupena time not null,
mota enum("podcast","abestia") not null,
Irudia varchar(300) not null
);

create table Podcast (
IdAudio varchar(5) primary key,
Kolaboratzaileak varchar(100),
IdPodcaster varchar(5) not null,
Deskribapena varchar(300) not null,
foreign key (IdAudio) references Audio(IdAudio) on delete cascade on update cascade,
foreign key (IdPodcaster) references Podcaster(IdPodcaster) on delete cascade on update cascade
);

create table Album (
IdAlbum varchar(5) primary key,
Izenburua varchar(20) not null,
urtea date not null,
generoa varchar(20) not null,
Idmusikaria varchar(5) not null,
Kolaboratzaileak varchar(100),
foreign key (Idmusikaria) references Musikaria (Idmusikaria) on update cascade on delete cascade
);

create table Abestia (
IdAudio varchar(5) primary key,
IdAlbum varchar(5) not null,
foreign key (IdAudio) references Audio(IdAudio) on delete cascade on update cascade,
foreign key (IdALbum) references Album(IdAlbum) on delete cascade on update cascade
);

create table Hizkuntza (
IdHizkuntza enum("ES", "EU", "EN", "FR", "DE", "CA", "GA", "AR") primary key,
Deskribapena varchar(50)not null
);

create table Bezeroa (
IdBezeroa varchar(5) primary key,
Izena varchar(10) not null,
Abizena varchar(15) not null,
Hizkuntza enum("ES", "EU", "EN", "FR", "DE", "CA", "GA", "AR"),
erabiltzailea varchar(10) not null unique,
pasahitza varchar(10) not null,
jaiotzedata date not null,
Erregistrodata date not null,
mota enum("premium","free"),
foreign key (Hizkuntza) references Hizkuntza(IdHizkuntza)
);

create table Playlist (
IdList varchar(5) primary key,
Izenburua varchar(15) not null,
Sorreradata date not null,
IdBezeroa varchar(5) not null,
constraint v_idBezero foreign key (IdBezeroa) references Bezeroa (IdBezeroa)
);

create table playlist_abestiak (
IdAudio varchar(5),
IdList varchar(5),
data date,
primary key (IdAudio,IdList, data),
foreign key (IdAudio) references Abestia(IdAudio),
foreign key (IdList) references Playlist(IdList) on delete cascade on update cascade
);

create table premium (
IdBezeroa varchar(5) primary key,
Iraungitzedata date not null,
foreign key (IdBezeroa) references Bezeroa(IdBezeroa)
);

create table gustukoak (
IdBezeroa varchar(5),
IdAudio varchar(5),
primary key (IdBezeroa,IdAudio),
foreign key (IdBezeroa) references Bezeroa(IdBezeroa),
foreign key (IdAudio) references Audio(IdAudio)
);

create table Erreprodukzioak (
IdBezeroa varchar(5),
IdAudio varchar(5),
data date,
primary key (IdBezeroa,IdAudio, data),
foreign key (IdBezeroa) references Bezeroa(IdBezeroa),
foreign key (IdAudio) references Audio(IdAudio)
);

create table Estatistikak (
IdAudio varchar(5) primary key,
GustukoAbestiak int not null,
GustokoPodcaster int not null,
Entzundakoa int not null,
playlist int not null,
foreign key (IdAudio) references Audio(IdAudio)
);

-- Musikariaren tablako insert guztiak
INSERT INTO Musikaria (Idmusikaria, IzenArtistikoa, Irudia, Ezaugarria,Deskribapena)
VALUES 
    ('EST01', 'Estopa', 'estopa.jpg', 'taldea','Estopa taldeak (José y David Muñoz) Zaragozako abizenarekin ezaguna da. 
    Musika arloan ibilitako anaiak, folk rock, rumba eta flamencorekin uztartutako soinu berezia sortu dute. 
	Euren kantuek errealean bizitako esperientziak, sentimenduak eta bizitza-ikuspuntuak biltzen dituzte, eta horiek guztiak euren euskal jatorriak ikuspegi fresko eta harrigarri batekin uztartzen dituzte. 
	Euskarak inguruko kultura eta hizkuntzaren indarrak agertzen ditu, eta estilistika ezberdinak uztartzen ditu, musika arloan denbora luzean zabaltzen den ikuspegi berri eta fresko bat eskaintzen duela.'),
    
    ('EMI01', 'Eminem', 'eminem.jpg', 'barkalia','Marshall Mathers III izenekoak, Eminem bezala ezaguna, hip-hop munduan izan duen eragina izugarri handia da. 
    Bere kantuek, baita testuak ere, gai garrantzitsu eta gailenduak dituzte, harremanak, zailtasunak eta bizi-ibilbideko errealitateak aipatzen dituztenak. 
    Eminem, adierazpen askatasunaren aldeko aukera eta musika alorrean bere leialtasun eta ardura azpimarratzen dituen artistarik ikaragarrienetako bat da.'),
    
    ('TAS01', 'Taylor Swift', 'taylor_swift.jpg', 'barkalia', 'Taylor Swift, country eta pop musikaren arteko batasunak edo hibridoak dituen artistarik ospetsuenetakoa da. 
    Bere kantuek sentimendu zorrotzak eta esperientziak azaltzen dituzte, eta irudi publikoa dela-eta, harremanak eta bizitzako erronkak ere berariaz azaltzen ditu. 
    Swift-ek, bere musikarekin edo gizartean bizi diren gai sozial eta politikoetan adierazi beharrekoan, bere ahotsa eta agertzea ditu lehentasun.'),
    
    ('XII01', 'Roten XIII', 'xiii.jpg', 'taldea',' Euskal Herriko musika eszenaren icona eta erreferentea da. 
    Hurrengo izen berak hartzen dituen hiru musikari ezberdinak, Mikel Laboa, Benito Lertxundi eta Lourdes Iriondo, berezitasun eta talento berezia dituzte. 
    Euren kantuek euskal kulturaren loreak eta gai sozialak jorratzen dituzte, eta estilo politikoa eta sentibera izaten dute. 
    Roten Amairu, euskal musika eta kultura munduan zutik dituen lekua goraipatzeko, eta euren abesti klasikoek euskal herria eta bere jendea bereziki sentitu ohi dute.'),
    
    ('BUL01', 'Bulego', 'bulego.jpg', 'taldea','Euskal Herriko indie musika eskenean kokatzen den taldea da. Bere soinuak elektronika eta rock estiloak uztartzen ditu, eta testuak gehienbat euskara daude. 
    Bulegok, gai sozial eta politikoak jorratzen dituen kantak egin ditu, eta musika-ekintza sozial gisa ere jarduten du, bertako komunitatearekin harreman zuzenak izateko ahaleginak eginez. 
    Taldeak modernotasun eta tradizioak batzen ditu, eta euren musikak euskal kulturaren eta gizarteko errealitatearen ardatz nagusiak hartzen ditu.');


-- Podcaster taulan datuak txertatzea (artista horien podcastei buruzko informaziorik ez dagoenez, izena eta irudia soilik txertatzen dira)
INSERT INTO Podcaster (IdPodcaster, IzenArtistikoa, Irudia,Deskribapena)
VALUES 
    ('TRVL1', 'Territorio Revival', 'Territorio.jpg', 'Sentsazioak berpizteko podcasta. Lagunen hitzaldi bat oroitzapen onak ekartzen dizkiguten gauzei buruz (filmak, telesailak, bideojokoak, jostailuak...) 
    eta gonbidatu oso bereziekin.'),
    
    ('BNZB1', 'Benetan zabiz?', 'BenetanZabiz.jpg','Benetan zabiz?, Aitziber Grados eta Malen Altunak, umoretik, entretenimendurako podcasta da. 
    Gaien aldetik mugarik ez dago eta istorio pertsonaletik abiatuta, gonbidtauaren sekretu ilunenak argitara ateratzen dituzte bi kazetari gazteel. 
    Arrosaliren laguntza dute ez egokia galdetzeko. EITB podkasten eta Gazteako uhinetan topatuko duzue podcasta.'),
    
    ('QSMA1', 'QSMA', 'QSMA.jpg','Bi ezezagun lagun egiten saiatzen dira astero. 
    Mario eta Dane dibortzio festa batean elkartu ziren eta igandero elkartuko dira adiskidetasunaren benetako esanahia ezagutzeko. Edo ez.'),
    
    ('TWPJ1', 'TheWildProject', 'WildProject.jpg', 'ASTEARTE ETA OSTEGUNERO GERTAKARI BERRIAK. Ongi etorri Jordi Wilden THE WILD PROJECT podcastera. 
    Gonbidaturik interesgarrienekin solasaldiak, gaurkotasuna, zientzia, kirolak, filosofia, psikologia, misterioa, eztabaidak eta solasaldiak... eta askoz gehiago. 
    Astero gure inguruko munduari buruz ozen eta argi hitz egiten. Ez galdu!');


-- Txertatu datuak Audio taulan (abestiei dagozkien audioak soilik txertatzen dira, ez podcastei dagozkienak)
INSERT INTO Audio (IdAudio, Izena, Iraupena, mota, Irudia)
VALUES 
    ('ESAU1', 'Rumbapop', '00:02:38', 'abestia', 'estopa_song1.jpg'),
    ('ESAU2', 'camiseta de Rokanrol', '00:03:55', 'abestia', 'estopa_song2.jpg'),
    ('ESAU3', 'Fuente de Energia', '00:03:33', 'abestia', 'estopa_song3.jpg'),
    ('ESAU4', 'Por la raja de tu falda','00:03:23', 'abestia', 'estopa_song4.jpg'),
    ('EMAU1', 'Mockingbird', '00:04:10', 'abestia', 'eminem_song1.jpg'),
    ('EMAU2', ' Just Lose It', '00:04:08', 'abestia', 'eminem_song2.jpg'),
    ('EMAU3', 'So Bad', '00:05:25', 'abestia', 'eminem_song3.jpg'),
    ('EMAU4', 'Not Afraid', '00:04:08', 'abestia', 'eminem_song4.jpg'),
    ('TSAU1', 'Getaway car', '00:03:54', 'abestia', 'taylor_swift_song1.jpg'),
    ('TSAU2', 'Delicate', '00:03:53', 'abestia', 'taylor_swift_song2.jpg'),
    ('TSAU3', 'Sparks Fly', '00:04:22', 'abestia', 'taylor_swift_song3.jpg'),
    ('TSAU4', 'Long live', '00:05:18', 'abestia', 'taylor_swift_song4.jpg'),
    ('XIAU1', 'El Blues de Aranjuez', '00:04:03', 'abestia', 'xiii_song1.jpg'),
    ('XIAU2', 'Nire Amaren Etxea', '00:04:03', 'abestia', 'xiii_song2.jpg'),
    ('XIAU3', 'Azken Rokanrola', '00:02:46', 'abestia', 'xiii_song3.jpg'),
    ('XIAU4', 'Alkohol ta Barre Artean', '00:03:47', 'abestia', 'xiii_song4.jpg'),
    ('BUAU1', 'Zure begi horiek', '00:03:47', 'abestia', 'bulego_song1.jpg'),
    ('BUAU2', 'Zurekin', '00:02:55', 'abestia', 'bulego_song2.jpg'),
    ('BUAU3', 'Zuen alboan', '00:03:14', 'abestia', 'bulego_song3.jpg'),
    ('BUAU4', 'Entera daitezela', '00:03:01', 'abestia', 'bulego_song4.jpg'),
    ('WPAU1','Mia Skylar(chica Trans)','03:47:00','podcast','WildProject1.jpg'),
	('WPAU2','Cambio Climatico','03:09:00','podcast','WildProject2.jpg'),
    ('QMAU1','Sueños homoeroticos','00:07:25','podcast','QSMA1.jpg'),
    ('QMAU2','DANE YA ES PAPA','00:09:10','podcast','QSMA2.jpg'),
    ('TRAU1','E.T el extraterreste','02:12:00','podcast','TerritorioRevival1.jpg'),
    ('TRAU2','Naruto','02:06:00','podcast','TerritorioRevival2.jpg'),
    ('BZAU1','Merina Gris,gehiegi kexatzen gara?','01:09:00','podcast','BenetanZabiz1.jpg'),
    ('BZAU2','Neomak,sorginkerietan','01:16:00','podcast','BenetanZabiz2.jpg');

-- Insertatu album tablan
INSERT INTO Album (IdAlbum, Izenburua, urtea, generoa, Idmusikaria, kolaboratzaileak)
VALUES 
    ('ESAL1', 'Estopía', '2022-01-01', 'Pop/Rock', 'EST01','Pole eta Fito Fitipaldi'),
	('ESAL2', 'Destrangis', '2022-01-01', 'Pop/Rock', 'EST01',null),
    ('EMAL1', 'Encore', '2023-01-01', 'Hip Hop', 'EMI01', null),
    ('EMAL2', 'Recovery', '2023-01-01', 'Hip Hop', 'EMI01',null),
    ('TSAL1', 'Reputation', '2023-01-01', 'Pop', 'TAS01', null),
	('TSAL2', 'Speak Now', '2023-01-01', 'Pop', 'TAS01', null),
    ('XIAL1', 'Oi! Baldorba', '2021-01-01', 'Rock', 'XII01',null),
	('XIAl2', 'Aurrera', '2021-01-01', 'Rock', 'XII01',null),
    ('BLAL1', 'Aldatu Aurretik', '2022-01-01', 'Rock', 'BUL01',null),
	('BLAL2', 'Erdian Oraina', '2022-01-01', 'Rock', 'BUL01',null);

-- Insertatu datuakabestia tablan
INSERT INTO Abestia (IdAudio, IdAlbum)
VALUES 
    ('ESAU1', 'ESAL1'),
    ('ESAU2', 'ESAL1'),
    ('ESAU3', 'ESAL2'),
    ('ESAU4', 'ESAL2'),
    
    ('EMAU1', 'EMAL1'),
    ('EMAU2', 'EMAL1'),
    ('EMAU3', 'EMAL2'),
    ('EMAU4', 'EMAL2'),
    
    ('TSAU1', 'TSAL1'),
    ('TSAU2', 'TSAL1'),
    ('TSAU3', 'TSAL2'),
    ('TSAU4', 'TSAL2'),
    
    ('XIAU1', 'XIAl1'),
    ('XIAU2', 'XIAl1'),
	('XIAU3', 'XIAl2'),
	('XIAU4', 'XIAl2'),
    
    ('BUAU1', 'BLAL2'),
    ('BUAU2', 'BLAL2'),
	('BUAU3', 'BLAL2'),
	('BUAU4', 'BLAL2');
    
INSERT INTO podcast (IdAudio, Kolaboratzaileak, IdPodcaster, Deskribapena) values 
('WPAU1','Mia Skylar','TWPJ1','Mia Skylar neska transexualak Jordi Wild bisitatu du podcast baterako. Bertan, azken urteetako gai eztabaidagarri eta komentatuenetako batez hitz egingo da. 
Nolakoa da trans bizitzaren errealitatea? Nola funtzionatzen du zehazki berresleipen-kirurgiak? Trans Legeak aukera ematen die haurrei hormonatzeko edo bulo bat da? 
Gai horiek eta askoz gehiago, konpondu eta eztabaidatuko dira, galdu ezin duzun podcast interesgarri batean.'),

('WPAU2',null,'TWPJ1','Bi zientzialari aurrez aurre eta eztabaidagai handi bat: Klima Aldaketa. Benetan existitzen da? 
Horrela bada, gizakien errua al da? Gehiegikeriaz ari al gara berehalako hondamendiarekin? Ingurumenaz haraindiko interesik ba al dago? Zer eragin du 2030 Agendak? 
Iritsi al gara itzulerarik gabeko puntu batera? Energia berriztagarriak gure salbazioa dira? Galdera horiek guztiak eta beste asko, galdu behar ez duzuen goi-mailako eztabaida batean erantzungo dira.'),

('QMAU1',null,'QSMA1','Mariok suhiltzaileekin dituen ametsei buruz hitz egiten du, 
"KAIXO" misterioa argitzen da, eta Dane Neymarrekin pikatu eta birziklapenaren errege izendatzen da. 
Atal osoa https://go.podimo.com/es/qsmaBi ezezagun zuzeneko lagunak egiten astez aste. Mario eta Dane dibortzio festa batean elkartu ziren eta igandero elkartuko dira adiskidetasunaren esanahia ezagutzeko. Edo ez.'),

('QMAU2',NULL,'QSMA1', 'Los chicos hablan sobre el nacimiento de la hija de Dane, experiencias traumáticas en saunas y Dane se pica con Mario Casas.
Episodio completo en https://go.podimo.com/es/qsmaDos desconocidos se hacen amigos en directo semana tras semana. 
Mario y Dane coincidieron en una fiesta de divorcio y se juntarán cada domingo para descubrir el significado de la amistad. O no.'),

('TRAU1','Ernesto Sevilla','TRVL1','NIRE CAAAASA! Garai guztietako estralurtar ospetsuena gure programan lurreratzen da bere ontziarekin, eta zinemaren historiako film ikonikoenetako bat gogoratzen laguntzen digu, 
E.T. EL EXTRATERRESTRE. Denok hunkitu gintuen istorio horrek, eta haren unerik mitikoenak, pertsonaiak, gauzarik bitxienak eta erokeria asko gogoratuz gozatu genuen, ERNESTO SEVILLA zuzendari, 
aktore eta umoristak ederki lagunduta. Ez itxaron gehiago aireratzen garelako. Hementxe egongo gara!'),

('TRAU2','Rubentonces','TRVL1','Konoha-ra goaz! NARUTOren unibertso liluragarria zain dugu garai guztietako animerik handienetako bati eskainitako atal sinestezin honetan. 
Nork ez du nahi izan ninja bat izatea edo Hokage bihurtzea? Une, pertsonaia eta era guztietako erokeriak errepasatuko ditugu bidelagun bikain batekin, RUBENTONCES umorista eta eduki-sortzaile bikainarekin. 
Ez beldurtu, programa hau gustatuko zaizu eta. Bai horixe!'),

('BZAU1',null,'BNZB1','Benetan Zabizen  atal honetan…Neomak taldea! Amets Ormaetxea eta Alaitz Eskudero gonbidatu dituzte Aitziber eta Malenek eta gipuzkoarrez osatutako taldearen inguruan aritu dira.
Nola ezagutu zuten elkar? Nolakoa da Kepa Junkerarekin lan egitea? Euskal "Tanxugueiras"-ak dira? Haien burua sorgintzat dute? Garrantzitsua al da haientzat taldearen eta emanaldien estetika? Zer dago bizitzaren ostean? Zaila al da musikaren profesioa eta aparteko lana uztartzea? Proiektu berririk dute?
Esklusiba harrigarri bat kontatu digute eta taldearen merchandising-arekin lotura zuzena du. Japonian biran egon zireneko anekdota eta pasadizo ugari kontatudizkigute gainera!
Benetan zabiz galduko duzula? Entzun eta ai oi ai!'),

('BZAU2','Merina Gris','BNZB1', 'Merina Gris musika taldeko Julen eta Sara izan dira Benetan Zabizen! Aitziber eta Malen haien fan sutsuak dira, taldearen orijinaltasunak arreta pizten die. Zergatik ote dira anonimoak? Zein da aurpegia ez erakustearen arrazoia? Funtzionatzen ote die? Nola lortzen dute magia mantentzea?
Horrez gain, tarotari eta adikzioei buruz jardun dira. Zeren menpeko dira? Horoskopoarekin obsesionatuta daude? Mezuak azkar erantzutekoak dira? Sentiberak kontsideratzen al dira? Zer dago lilili abestiaren atzean? Atal honetako bonba, ordea, amaieran lehertu da: anonimotasunarekin amaitzea erabaki dute eta maskarak kendu dituzte.
Benetan Zabiz galduko duzula?
Podcast hau On:time-k ekoitzen du EITB Podkasterako.');



INSERT INTO Bezeroa (IdBezeroa, Izena, Abizena, Hizkuntza, erabiltzailea, pasahitza, jaiotzedata, Erregistrodata, mota)
VALUES 
    ('BZ001', 'Jon', 'Etxeberria', 'EU', 'jon12', 'jon123', '1990-05-15', '2023-02-10', 'premium'),
    ('BZ002', 'Ane', 'Lopez', 'ES', 'anelop', 'ane123', '1995-10-20', '2023-02-12', 'free'),
    ('BZ003', 'Mark', 'Smith', 'EN', 'mark123', 'mark456', '1988-07-30', '2023-02-15', 'premium'),
    ('BZ004', 'María', 'García', 'ES', 'maria12', 'maria456', '1998-03-25', '2023-02-20', 'free');

INSERT INTO Hizkuntza (IdHizkuntza, Deskribapena)
VALUES 
    ('ES', 'Gaztelania'),
    ('EU', 'Euskera'),
    ('EN', 'Ingelesa'),
    ('FR', 'Frantzesa'),
    ('DE', 'Alemana'),
    ('CA', 'Catalan'),
    ('GA', 'Gallego'),
    ('AR', 'Árabe');
    
    INSERT INTO Playlist (IdList, Izenburua, Sorreradata, IdBezeroa)
VALUES 
    ('PL001', 'Rock Hits', '2023-02-12', 'BZ001'),
    ('PL002', 'Chillout Vibes', '2023-02-15', 'BZ002'),
    ('PL003', 'Party Time', '2023-02-20', 'BZ003'),
    ('PL004', 'Road Trip', '2023-02-25', 'BZ004');

INSERT INTO playlist_abestiak (IdAudio, IdList, data)
VALUES 
    ('ESAU1', 'PL001', '2023-02-12'),
    ('ESAU2', 'PL001', '2023-02-12'),
    ('TSAU3', 'PL002', '2023-02-15'),
    ('EMAU1', 'PL003', '2023-02-20'),
    ('XIAU4', 'PL004', '2023-02-25');

INSERT INTO premium (IdBezeroa, Iraungitzedata)
VALUES 
    ('BZ001', '2024-02-10'),
    ('BZ003', '2024-03-15');

INSERT INTO gustukoak (IdBezeroa, IdAudio)
VALUES 
    ('BZ001', 'ESAU1'),
    ('BZ001', 'EMAU1'),
    ('BZ002', 'TSAU2'),
    ('BZ004', 'XIAU3'),
    ('BZ004', 'BUAU2');

INSERT INTO Erreprodukzioak (IdBezeroa, IdAudio, data)
VALUES 
    ('BZ001', 'ESAU1', '2023-02-10'),
    ('BZ002', 'EMAU1', '2023-02-12'),
    ('BZ003', 'TSAU3', '2023-02-15'),
    ('BZ004', 'XIAU4', '2023-02-20'),
    ('BZ001', 'BUAU1', '2023-02-25');

INSERT INTO Estatistikak (IdAudio, GustukoAbestiak, GustokoPodcaster, Entzundakoa, playlist)
VALUES 
    ('ESAU1', 10000, 5000, 20000, 1500),
    ('EMAU1', 15000, 7000, 25000, 2000),
    ('TSAU3', 12000, 6000, 22000, 1800),
    ('XIAU4', 8000, 4000, 18000, 1200),
    ('BUAU2', 9000, 4500, 19000, 1300);
    