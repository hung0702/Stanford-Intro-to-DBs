/*Q1. Find the names of all reviewers who rated Gone with the Wind. */

select distinct name
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID /*match tuples by mID & rID*/
    and title = 'Gone with the Wind';

/*Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */

select name, title, stars
from Movie, Reviewer, Rating
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID /*match tuples by mID & rID*/
    and name = director;

/*Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */

select distinct name from Reviewer
union
select distinct title from Movie;

/*Q4. Find the titles of all movies not reviewed by Chris Jackson. */

select title 
from (
    select title, mID
    from Movie 
    except 
    select title, Movie.mID
    from Movie, Reviewer, Rating
        where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID /*match tuples by mID & rID*/
            and Reviewer.name = 'Chris Jackson');

/*Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */

select distinct RVL.name, RVR.name
from Reviewer RVL, Reviewer RVR, Rating RTL, Rating RTR
where RVL.name < RVR.name and RVL.rID = RTL.rID and RVR.rID = RTR.rID and RTL.mID = RTR.mID
order by RVL.name;

/*Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */

select distinct name, title, stars
from Rating, Movie, Reviewer
where Rating.mID = Movie.mID 
    and Rating.rID = Reviewer.rID 
    and stars = (select min(stars) from Rating)
order by title;

/*Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. */

select title, avg(stars)
from Movie join Rating using(mID)
group by Rating.mID
order by avg(stars) desc, title;

/*Q8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) */

select distinct name
from Reviewer, Rating R1, Rating R2, Rating R3
where Reviewer.rID = R1.rID 
    and Reviewer.rID = R2.rID and Reviewer.rID = R3.rID 
    and R1.stars < R2.stars and R1.stars < R3.stars and R2.stars < R3.stars
    or 
    Reviewer.rID = R1.rID and Reviewer.rID = R2.rID and Reviewer.rID = R3.rID 
    and R1.ratingDate < R2.ratingDate and R1.ratingDate < R3.ratingDate and R2.ratingDate < R3.ratingDate;

/*Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) */

select title, director
from (
    select M1.title, M1.director
    from Movie M1, Movie M2
    where M1.director = M2.director and M1.title <> M2.title
    )
order by director, title;

/*Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) */

select title, avg(stars)
from Movie, Rating
where Movie.mID = Rating.mID
group by Rating.mID
having avg(stars) = (
    select max(stars)
    from (
        select avg(Rating.stars) as stars
        from Rating
    group by Rating.mID
    )
);

/*Q11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) */

select title, avg(stars)
from Movie, Rating
where Movie.mID = Rating.mID
group by Rating.mID
having avg(stars) = (
    select min(S)
    from (
        select avg(Rating.stars) as S
        from Rating
        group by Rating.mID
    )
);

/*Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. */

select director, title, max(stars)
from Rating join Movie using(mID)
where director is not null
group by director;
