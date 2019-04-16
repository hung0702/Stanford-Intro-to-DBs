/*Q1. Find the titles of all movies directed by Steven Spielberg. */

select title
from Movie
where director = "Steven Spielberg";

/*Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */

select distinct year
from Movie, Rating 
where Rating.stars >= 4 and Movie.mID = Rating.mID
order by year asc;

/*Q3. Find the titles of all movies that have no ratings. */

select title 
from Movie 
where mID not in (select mID from Rating);

/*Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */

select name 
from Reviewer
where rID in (select rID from Rating where ratingDate is null);

/*Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */

select name, title, stars, ratingDate
from Reviewer, Rating, Movie 
where Reviewer.rID = Rating.rID and Rating.mID = Movie.mID
order by name asc, title asc, stars asc;

/*Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */

select name, title
from Movie, Reviewer, Rating R1, Rating R2
where Movie.mID = R1.mID and Movie.mID = R2.mID and Reviewer.rID = R1.rID and Reviewer.rID = R2.rID /*match tables by mID & rID*/
    and R1.ratingDate < R2.ratingDate and R1.stars < R2.stars and R1.rID = R2.rID /*condition to find unique second ratings higher than original rating*/;

/*Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. */

select title, max(stars)
from Movie join Rating using(mID)
group by mID
order by title;

/*Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */

select title, (max(stars)-min(stars)) as spread
from Movie join Rating using(mID)
group by mID
order by spread desc, title asc;

/*Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */

select (pre80-post80) 
from (
    select avg(avgStars) as post80 from (
        select avg(stars) as avgStars
        from Movie join Rating using(mID)
        group by title
        having year >= 1980 and stars is not null
        )
      ),
    (
    select avg(avgStars) as pre80 from (
      select avg(stars) as avgStars
      from Movie join Rating using(mID)
      group by title
      having year < 1980 and stars is not null
      )
    );
