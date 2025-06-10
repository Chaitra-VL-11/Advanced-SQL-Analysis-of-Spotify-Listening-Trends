CREATE DATABASE music;
USE music;
CREATE TABLE spotify(
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(255),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comment BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(255)
    );
    
SELECT * from music.spotify;

select count(*) from music.spotify;

SELECT COUNT(DISTINCT artist) from music.spotify;

select MAX(duration_min) from music.spotify;

select min(duration_min) from music.spotify;

select distinct channel from music.spotify;

select distinct most_playedon from music.spotify;
-------------------------------------------------------------------------------------------------------------------------------
-- Q.1 Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM music.spotify
WHERE stream > 1000000000;
    
-- Q.2 List all albums along with their respective artists.

SELECT COUNT(DISTINCT Album) from music.spotify;
SELECT distinct album, Artist FROM music.spotify;

-- Q.3 Get the total number of comments for tracks where licenced = TRUE.

SELECT sum(comments) as Total_numberof_comments
FROM music.spotify
where Licensed = 'TRUE';

-- Q.4 Find all tracks that belong to the album type single.

SELECT track FROM music.spotify
WHERE album_type = 'single';

-- Q.5 Count the total number of tracks by each artist.

SELECT artist,
count(track) as total_no_songs 
FROM music.spotify
GROUP BY artist
ORDER BY 2
-------------------------------------------------------------------------------------------------------------------
-- Q.6 Calculate the average danceability of tracks in each album.

SELECT 
album, 
avg(danceability) as avg_danceability
FROM music.spotify
GROUP BY 1
ORDER BY 2 DESC;
    
-- Q.7 Find the top 5 tracks with the highest energy values.

SELECT distinct track, MAX(Energy)
FROM music.spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.8 List all tracks along with their views and likes where official_video=TRUE.

SELECT track,views, likes FROM music.spotify
WHERE official_video = 'TRUE';

-- Q.9 For each album, calculate the total views of all associated tracks.

SELECT album ,track,  sum(views) 
FROM music.spotify
GROUP BY 1,2 
order by 3 desc;
    
-- Q.10 Retrieve the track name that have been streamed on spotify more than youtube.

SELECT * FROM
(SELECT track,
coalesce(sum(case when most_playedon='youtube' then stream end),0) as streamed_on_youtube,
coalesce(sum(case when most_playedon='spotify' then stream end),0) as streamed_on_spotify
FROM music.spotify
GROUP BY 1) as t1
WHERE 
streamed_on_spotify > streamed_on_youtube
AND 
streamed_on_youtube <> 0

------------------------------------------------------------------------------------------------------------------
-- Q.11 Find the top 3 most viewed tracks for each artist using window function.

WITH ranking_artist
as
(SELECT
Artist, 
Track,
sum(views) as Total_View,
DENSE_RANK() OVER(PARTITION BY artist ORDER BY sum(views) DESC) AS RANKING
FROM music.spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE RANKING <=3

-- Q.12 write a query to find tracks where the liveness score is above the average.

SELECT 
track,
artist,
liveness
FROM music.spotify
WHERE liveness > (SELECT AVG(Liveness) FROM music.spotify)
    
-- Use a with clause to calculate the difference between the highest and lowest energy values for tracks in each album. 

with cte
as
(select 
album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from music.spotify
group by 1
)
select 
album,
highest_energy-lowest_energy as energy_diff
from cte
order by 2 desc
    
    
    
    
    
    
    
    
    