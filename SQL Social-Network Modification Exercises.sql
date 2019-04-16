>Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 

delete from Highschooler
where grade = 12

>Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 

delete
from Likes
where ID1 in (
  select ID1
  from Likes L join Friend F using(ID1)
  where L.ID2 = F.ID2)
and not ID2 in (
  select ID1
  from Likes L join Friend F using(ID1)
  where L.ID2 = F.ID2)

>Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 

insert into Friend
select F1.ID1, F2.ID2
from Friend F1 join Friend F2 on F1.ID2 = F2.ID1
where F1.ID1 != F2.ID2
except 
select * from Friend
