create view generokogustokoenak as
select a.idaudio, a.izena, a.mota, al.generoa, m.izenartistikoa as abeslari,
       count(*) as "erreprodukzioak"
from audio a
join abestia ab on a.idaudio = ab.idaudio
join album al on ab.idalbum = al.idalbum
join musikaria m on al.idmusikaria = m.idmusikaria
left join erreprodukzioak e on a.idaudio = e.idaudio
group by 1,2,3,4,5;


-- gaur ze ordutan entzun den musika gehiago

create view gaurzeordutanerreprodukziogehiago as
select hour(e.data) as "ordua", idaudio, count(*) as "erreprodukzioak"
from erreprodukzioak e
where date(data) = curdate()
group by 1,2
order by "erreprodukzioak"
limit 1;

-- gaurko, asteko eta hileko erreprodukzio datuak (ze ordutan entzuten diren musika)

create view gaurkoerreprodukzioorduak as
select hour(e.data) as "ordua", idaudio, count(*) as "erreprodukzioak"
from erreprodukzioak e
where date(data) = curdate()
group by ordua
order by ordua;

create view astekoerreprodukzioorduak as
select hour(e.data) as "ordua" ,day(e.data) as "eguna", idaudio, count(*) as "erreprodukzioak"
from erreprodukzioak e
where data >= curdate() - interval 1 week
group by ordua , eguna, idaudio
order by ordua , eguna;

create view hilekoerreprodukzioorduak as
select hour(e.data) as "ordua", day(e.data) as "eguna", idaudio, count(*) as "erreprodukzioak"
from erreprodukzioak e
where data >= curdate() - interval 1 month
group by ordua , eguna, idaudio
order by ordua , eguna;

create view urtekoerreprodukzioorduak as
select hour(e.data) as "ordua", day(e.data) as "eguna", idaudio, count(*) as "erreprodukzioak"
from erreprodukzioak e
where data >= curdate() - interval 1 year
group by ordua , eguna, idaudio
order by ordua , eguna;



-- premiun bezeroak:
-- funciona
create view premiunestadistikak as
select b.idbezeroa as "idbezero", concat( b.izena ," ", b.abizena ) as "bezero", e.data as "erreprodukzio data",
count(e.idaudio) as "erreprodukzio kantitatea", count(p.idlist) as "playlist kantitate"
from bezeroa b
left join erreprodukzioak e on b.idbezeroa = e.idbezeroa
left join playlist p on b.idbezeroa = p.idbezeroa
where b.mota = 'premium'
group by 1,2,3;

-- free bezeroak:
-- funciona
create view freeestadistikak as
select b.idbezeroa as "idbezero", concat( b.izena ," ", b.abizena ) as "bezero", e.data as "erreprodukzio data",
count(e.idaudio) as "erreprodukzio kantitatea", count(p.idlist) as "playlist kantitate"
from bezeroa b
left join erreprodukzioak e on b.idbezeroa = e.idbezeroa
left join playlist p on b.idbezeroa = p.idbezeroa
where b.mota = 'free'
group by 1,2,3;