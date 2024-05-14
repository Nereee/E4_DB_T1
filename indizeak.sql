#--------------------------------------------------indizeak-------------------------------------------------------------------

create index idx_bezeroa on premium (idbezeroa);

create index idx_playlist on playlist_abestiak (idaudio);

create index idx_abestia on abestia(idalbum);

create index idx_izenapodcast on audio(izena);

create index idx_izenaabestia on audio(izena);

create index idx_abestianorena on musikaria(izenartistikoa);

create index idx_podcastnorena on podcaster(izenartistikoa);

