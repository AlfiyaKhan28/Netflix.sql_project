------- NETFLIX PROJECT ------

CREATE TABLE netflix
(
    show_id VARCHAR(6),
    types VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(150),
    descriptions VARCHAR(250)
);

SELECT * FROM netflix;

--- 15 Business Problems & Solutions -----

--1. Count the Number of Movies vs TV Shows
   
SELECT types, Count(*) as total_content
FROM netflix
GROUP BY types;

--2. Find the most common rating for movies and TV Shows

SELECT types, rating
FROM 
(

      SELECT types, rating, COUNT(*),
	         RANK() OVER(PARTITION BY types ORDER BY COUNT(*) DESC) AS Ranking
      FROM netflix
      GROUP BY 1, 2
      Order BY 1, 3 DESC
) as t1
WHERE ranking = 1;

--3. List all the movies released in the specific year (e.g. 2020)
 
 SELECT * FROM netflix
 WHERE 
      types = 'Movie'
      AND
	  release_year = 2020;

--4. Find the top 5 countries with th most content on Netflix

SELECT
     UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
     Count(show_id) as Total_content
FROM netflix
Group BY country
ORDER BY Total_content DESC
LIMIT 5;

--5. Identify the longest Movie 

SELECT * FROM netflix
WHERE 
     types = "Movies"
     AND
	 duration = ( SELECT MAX(duration) FROM netfix)
	 
--6. Find content added in the last 5 years 

SELECT *
FROM netflix
WHERE 
   TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

--7. Find all the movies /TV Shows by director 'Rajiv Chilaka'

SELECT * 
FROM netflix
WHERE
    director LIKE '%Rajiv Chilaka%';

--8. List all the movies with more than 5 seasons

SELECT *
FROM netflix
WHERE 
     types = 'TV Show'
	 AND
	 SPLIT_PART(duration, ' ',1) ::numeric > 5
    
--9. Count the number of content items in each genre	
 
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(Show_id) as total_content
FROM netflix 
GROUP BY 1	
		
--10. Find each year and the average number of content release in India on Netflix. return to 5 year with highest avg content release 

---Total content 333/972

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as Year,
	  COUNT(*) as yearly_content,
	  ROUND(
	  COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix WHERE country ='India')::numeric * 100
	   , 2)as yearly_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1  

---11. List all the movies that are documentries

SELECT * FROM netflix
WHERE 
     listed_in ILIKE '%documentaries%';

--12. Show all the content without a director

SELECT * FROM netflix
WHERE 
     director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT * FROM netflix
WHERE 
     casts ILIKE '%Salman Khan%'
     AND
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE)	- 10
	 
--14. Find the Top 10 actors who have appeared in the highest number of movies produced in India

SELECT
---- show_id,
-----casts,
	 UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	 COUNT(*) as Total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--15. Categorize the content based on the presence of keywords "kill" and "violence" in the description
--    field. Label a content containing these keywords as 'Bad' and all the other content as 'good'
--    .Count how many items fall into each category.

WITH new_table
AS
(
SELECT 
*,
  CASE
  WHEN
      descriptions ILIKE '%kill%'
	  OR
	  descriptions ILIKE '%violence%' THEN 'Bad_content'
	  ELSE 'Good_content'
  END category
FROM netflix
)
SELECT category,
       count(*) as total_content
FROM new_table
GROUP BY 1
















