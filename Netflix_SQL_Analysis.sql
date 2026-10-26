
USE shows_movies;

-- 1. Top 10 movies according to IMDb score
SELECT title, type, imdb_score
FROM shows_movies.titles
WHERE UPPER(type) = 'MOVIE'
  AND imdb_score >= 8.0
ORDER BY imdb_score DESC
LIMIT 10;

-- 2. Top 10 shows according to IMDb score
SELECT title, type, imdb_score
FROM shows_movies.titles
WHERE UPPER(type) = 'SHOW'
  AND imdb_score >= 8.0
ORDER BY imdb_score DESC
LIMIT 10;

-- 3. Bottom 10 movies according to IMDb score
SELECT title, type, imdb_score
FROM shows_movies.titles
WHERE UPPER(type) = 'MOVIE'
  AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;

-- 4. Bottom 10 shows according to IMDb score
SELECT title, type, imdb_score
FROM shows_movies.titles
WHERE UPPER(type) = 'SHOW'
  AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;

-- 5. Average IMDb and TMDB scores by content type
SELECT type,
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM shows_movies.titles
GROUP BY type;

-- 6. Count of movies and shows in each decade
SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
       COUNT(*) AS movies_shows_count
FROM shows_movies.titles
WHERE release_year >= 1940
GROUP BY CONCAT(FLOOR(release_year / 10) * 10, 's')
ORDER BY MIN(release_year);

-- 7. Average IMDb and TMDB scores by production country
SELECT production_countries,
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM shows_movies.titles
GROUP BY production_countries
ORDER BY avg_imdb_score DESC;

-- 8. Average scores by age certification
SELECT age_certification,
       ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
       ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score
FROM shows_movies.titles
GROUP BY age_certification
ORDER BY avg_imdb_score DESC;

-- 9. Five most common age certifications for movies
SELECT age_certification,
       COUNT(*) AS certification_count
FROM shows_movies.titles
WHERE UPPER(type) = 'MOVIE'
  AND age_certification IS NOT NULL
  AND age_certification <> 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC
LIMIT 5;

-- 10. Top 20 actors by appearances
SELECT name AS actor,
       COUNT(DISTINCT id) AS number_of_appearances
FROM shows_movies.credits
WHERE LOWER(role) = 'actor'
GROUP BY name
ORDER BY number_of_appearances DESC
LIMIT 20;

-- 11. Top 20 directors by number of titles directed
SELECT name AS director,
       COUNT(DISTINCT id) AS number_of_titles
FROM shows_movies.credits
WHERE LOWER(role) = 'director'
GROUP BY name
ORDER BY number_of_titles DESC
LIMIT 20;

-- 12. Average runtime of movies and shows
SELECT 'Movies' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM shows_movies.titles
WHERE UPPER(type) = 'MOVIE'

UNION ALL

SELECT 'Shows' AS content_type,
       ROUND(AVG(runtime), 2) AS avg_runtime_min
FROM shows_movies.titles
WHERE UPPER(type) = 'SHOW';

-- 13. Movies and directors from 2010 onwards
SELECT DISTINCT t.title,
       c.name AS director,
       t.release_year
FROM shows_movies.titles AS t
JOIN shows_movies.credits AS c
  ON t.id = c.id
WHERE UPPER(t.type) = 'MOVIE'
  AND t.release_year >= 2010
  AND LOWER(c.role) = 'director'
ORDER BY t.release_year DESC;

-- 14. Shows with the most seasons
SELECT title,
       seasons AS total_seasons
FROM shows_movies.titles
WHERE UPPER(type) = 'SHOW'
  AND seasons IS NOT NULL
ORDER BY seasons DESC
LIMIT 10;

-- 15. Genres associated with the most movies
SELECT genres,
       COUNT(*) AS title_count
FROM shows_movies.titles
WHERE UPPER(type) = 'MOVIE'
  AND genres IS NOT NULL
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- 16. Genres associated with the most shows
SELECT genres,
       COUNT(*) AS title_count
FROM shows_movies.titles
WHERE UPPER(type) = 'SHOW'
  AND genres IS NOT NULL
GROUP BY genres
ORDER BY title_count DESC
LIMIT 10;

-- 17. Highly rated and popular movies with their directors
SELECT DISTINCT t.title,
       c.name AS director
FROM shows_movies.titles AS t
JOIN shows_movies.credits AS c
  ON t.id = c.id
WHERE UPPER(t.type) = 'MOVIE'
  AND t.imdb_score > 7.5
  AND t.tmdb_popularity > 80
  AND LOWER(c.role) = 'director';

-- 18. Total number of titles released each year
SELECT release_year,
       COUNT(*) AS title_count
FROM shows_movies.titles
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year DESC;

-- 19. Actors in highly rated movies and shows
SELECT c.name AS actor,
       COUNT(DISTINCT t.id) AS num_highly_rated_titles
FROM shows_movies.credits AS c
JOIN shows_movies.titles AS t
  ON c.id = t.id
WHERE LOWER(c.role) = 'actor'
  AND UPPER(t.type) IN ('MOVIE', 'SHOW')
  AND t.imdb_score > 8.0
  AND t.tmdb_score > 8.0
GROUP BY c.name
ORDER BY num_highly_rated_titles DESC;

-- 20. Actors who played the same character in multiple titles
-- Assumes your credits table has a character_name column
-- Actors who played the same character in multiple titles
SELECT
    c.name AS actor,
    c.`character` AS character_name,
    COUNT(DISTINCT c.id) AS num_titles
FROM shows_movies.credits AS c
WHERE LOWER(c.role) = 'actor'
  AND c.`character` IS NOT NULL
  AND c.`character` <> ''
GROUP BY c.name, c.`character`
HAVING COUNT(DISTINCT c.id) > 1
ORDER BY num_titles DESC;
-- 21. Top 3 most common movie genre combinations
SELECT genres,
       COUNT(*) AS genre_count
FROM shows_movies.titles
WHERE UPPER(type) = 'MOVIE'
  AND genres IS NOT NULL
GROUP BY genres
ORDER BY genre_count DESC
LIMIT 3;

-- 22. Average IMDb score by actor
SELECT c.name AS actor,
       ROUND(AVG(t.imdb_score), 2) AS average_imdb_score
FROM shows_movies.credits AS 
JOIN shows_movies.titles AS t
  ON c.id = t.id
WHERE LOWER(c.role) = 'actor'
  AND t.imdb_score IS NOT NULL
GROUP BY c.name
ORDER BY average_imdb_score DESC;
