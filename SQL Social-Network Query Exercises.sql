/*Q1. Find the names of all students who are friends with someone named Gabriel.*/

select H2.name
from Highschooler H1, Highschooler H2, Friend
where H1.name = 'Gabriel' and H2.name != 'Gabriel'
    and H1.ID = Friend.ID1 and H2.ID = Friend.ID2;

/*Q2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. */

select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes
where H1.ID = Likes.ID1 and H2.ID = Likes.ID2
    and H1.grade >= 2 + H2.grade;

/*Q3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */

select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes L1, Likes L2
where (H1.ID = L1.ID1 and H1.ID = L2.ID2) and (H2.ID = L1.ID2 and H2.ID = L2.ID1) /*match names & grades to who likes who*/
     and L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1 /*check if they like each other*/
     and H1.name < H2.name; /*order them alphabetically and eliminate doubles*/

/*Q4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */

select name, grade
from Highschooler
except
    select name, grade
    from Highschooler, Likes
    where Highschooler.ID = Likes.ID1 or Highschooler.ID = Likes.ID2
order by grade, name;

/*Q5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. */

select distinct H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Likes L1, Likes L2
where H1.ID = L1.ID1 and H2.ID = L1.ID2
    and L1.ID2 not in (
        select ID1
        from Likes)
order by H2.grade, H2.name;

/*Q6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. */

select distinct H1.name, H1.grade
from Highschooler H1, Highschooler H2, Friend
where H1.ID = Friend.ID1 and H2.ID = Friend.ID2 and H1.grade = H2.grade  /*make sure student has friend in same grade*/
  and H1.ID not in (          /*exclude IDs from students with friends in other grades*/
    select H1.ID
    from Highschooler H1, Highschooler H2, Friend
    where H1.ID = Friend.ID1 and H2.ID = Friend.ID2
        and H1.ID != H2.ID
        and H1.grade != H2.grade
)
order by H1.grade, H1.name;

/*Q7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */

select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, Likes L
where H1.ID = L.ID1 and H2.ID = L.ID2 /*name & ID who likes who*/
  and H1.ID = F1.ID1 and H2.ID = F2.ID1 and H3.ID = F1.ID2 and H3.ID = F2.ID2 /*find mutual friend*/
  and H2.ID not in (select ID2 from Friend where ID1 = H1.ID); /*exclude Likes pairs who are friends*/

/*Q8. Find the difference between the number of students in the school and the number of different first names. */

select count(ID) - count(distinct name) 
from Highschooler;

/*Q9. Find the name and grade of all students who are liked by more than one other student. */

select name, grade
from Likes L join Highschooler H on L.ID2 = H.ID
group by ID2
having count(*) > 1;
