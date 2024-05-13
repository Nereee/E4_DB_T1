#--------------------------------------------------indizeak-------------------------------------------------------------------

create index idx_bezeroa on premium (IdBezeroa);

create index idx_playlist on playlist_abestiak (IdAudio);

create index idx_abestia on Abestia(IdAlbum);

create index idx_izenaPodcast on Audio(Izena);

create index idx_izenaAbestia on Audio(Izena);

create index idx_AbestiaNorena on Musikaria(IzenArtistikoa);

create index idx_PodcastNorena on Podcaster(IzenArtistikoa);

