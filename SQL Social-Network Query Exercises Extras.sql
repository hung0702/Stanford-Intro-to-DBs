>Q1. For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Likes L2, Highschooler H1, Highschooler H2, Highschooler H3
where L1.ID2 = L2.ID1 and L1.ID1 != L2.ID2
  and L1.ID1 = H1.ID and L1.ID2 = H2.ID and L2.ID2 = H3.ID

>Q2. Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 

select H3.name, H3.grade
from Highschooler H3
except
select H1.name, H1.grade
from Friend F1, Highschooler H1, Highschooler H2
where F1.ID1 = H1.ID and F1.ID2 = H2.ID and H1.grade = H2.grade

>Q3. What is the average number of friends per student? (Your result should be just one number.) 

select avg(FC)
from (select ID1, count(*) as FC
from Friend
group by ID1)

>Q4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 

select count(*)
from Friend F1, Friend F2
where F1.ID2 = F2.ID1
  and F1.ID1 in (
    select ID
    from Highschooler
    where name = 'Cassandra'
  )

>Q5. Find the name and grade of the student(s) with the greatest number of friends. 

select name, grade
from Highschooler join Friend on ID = ID1
group by ID
having count(*) = (
  select max(FC)
  from (
    select count(*) as FC
    from Friend
    group by ID1
  )
)
