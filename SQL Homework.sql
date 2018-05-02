Create database Homework; 
use Homework;
  
use sakila;

'Question 1a. Display the first and last names of all actors from the table `actor`. '

create table Actor select*from sakila.actor;
alter table Actor drop column last_update;

'Question 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.'

alter table Actor add `Actor Name` varchar (40);

update Actor
set `Actor Name` = concat(first_name," ", last_name);

'Question 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information?'

select*from Actor
where first_name = "JOE";

'Question 2b. Find all actors whose last name contain the letters `GEN`:'

select*from Actor
where last_name like '%GEN%';

'Question 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:'

select*from Actor
where last_name like '%LI%'
order by last_name, first_name ASC;

'Question 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:'

select*from sakila.country
where country in ("Afghanistan", "Bangladesh", "China");

'Question 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. '

alter table Actor
ADD `Middle Name` varchar(30);

'Question 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.'

alter table Actor
modify Column `Middle Name` BLOB;

'Question 3c. Now delete the `middle_name` column'

alter table Actor
drop Column `Middle Name`;

'Question 4a. List the last names of actors, as well as how many actors have that last name.'

select count(actor_id), last_name
from actor
group by last_name;

'Question 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors'

create table LastName select count(actor_id), last_name
from actor
group by last_name;

alter table LastName
change column `count(actor_id)` `Actor_ID` int(3);

delete from LastName
where Actor_ID = 1;

select*from LastName;

'Question 4c.'

update Actor
set first_name = "HARPO"
where `Actor Name` = "GROUCHO WILLIAMS";

'Question 4d.'

update Actor
set first_name = "GROUCHO"
where `first_name` = "HARPO";

select*from Actor;    

'Question 5a.'

show create table sakila.address;

select*from sakila.address;

'Question 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:'

create table HWaddress select*from sakila.address;
create table HWstaff select*from sakila.staff;

SELECT HWaddress.address_id, HWaddress.address, HWstaff.first_name, HWstaff.last_name
FROM HWaddress
INNER JOIN HWstaff ON HWaddress.address_id= HWstaff.address_id; 

select*from HWaddress
select*from HWstaff


'Question 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. '

create table HWpayment select*from sakila.payment;

SELECT p.payment_id, p.staff_id, p.payment_date, hwstaff.first_name, hwstaff.last_name, sum(amount) as gross
FROM HWpayment p
JOIN HWstaff ON p.staff_id = HWstaff.staff_id
where payment_date like '%2005-08%'
group by staff_id ;

'Question 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join. '

create table HWfilm_actor select*from sakila.film_actor;
create table HWfilm select*from sakila.film;

'select film_id, title, actor_id
from HWfilm f
join HWfilm_actor a
using(film_id);'

select
	a. title, b. NumActor
from
	HWfilm a join
    (select film_id, count(*) as NumActor
	from HWfilm_actor
	group by film_id) b
on
	a. film_id = b. film_id;

select*from HWfilm;
select*from HWfilm_actor;

'Question 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?'
create table HW_Inventory select*from sakila.inventory;

select count(*)
from HW_Inventory
where film_id in 
(select film_id
from hwfilm 
where title = "Hunchback Impossible"
);

select*from HW_Inventory;

'Question 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:'

create table HW_Customer select*from sakila.customer;

select customer_id, first_name, last_name, sum(amount) as gross
from hw_customer c
join hwpayment p
using (customer_id)
group by customer_id
order by last_name ASC;

select*from hwpayment;

'Question 7a. The music of Queen and Kris Kristofferson '

create table HW_Language select*from sakila.language;
select*from HW_Language;

select*from hwfilm
where title like 'K%' or title like 'Q%' and
language_id = ( 
select language_id from HW_Language
where name = "English");

'Question 7b.  Use subqueries to display all actors who appear in the film `Alone Trip`.'

select actor_id, first_name, last_name
from actor
where actor_id in
	(select actor_id from hwfilm_actor
		where film_id = (
		select film_id from hwfilm
		where title = "Alone Trip"));

'Question 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
 Use joins to retrieve this information.' 
create table HW_City select*from sakila.city;
create table HW_Country select*from sakila.country;

'select*from hw_customer; address_id
select*from hwaddress; city id
select*from HW_city; city 
select*from HW_Country;'

'Solution using subqueries'
select address_id, first_name, last_name, email
from hw_customer
where address_id in
(select address_id
from hwaddress
where city_id in 
	(select city_id 
	from HW_City
		where country_id = (
		select country_id
		from HW_Country
		where country = "Canada")));

'Solution using joins'
select first_name, last_name, email
from hw_customer c
join hwaddress a
on (c.address_id = a.address_id)
join HW_city 
on (a.city_id = HW_city.city_id)
join HW_Country
on (HW_City.country_id = HW_Country.country_id)
where country = "Canada";

'Question 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.'
'Assumed ratings that are G, PG, PG-13 are family friendly'

select*from hwfilm
where rating = "G" or rating = "PG" or rating = "PG-13";

'Question 7e. Display the most frequently rented movies in descending order.'
select*from sakila.rental

select title, count(rental_id) as NumRentals
from sakila.rental r
join hw_inventory i
on r.inventory_id = i.inventory_id
join hwfilm f
on i.film_id = f.film_id
group by title
order by count(rental_id) desc;

' Question 7f. Write a query to display how much business, in dollars, each store brought in.'

select*from hwpayment;
select*from sakila.staff;

select store_id, sum(amount) as Gross_Revenue
from hwpayment p
join sakila.staff
on p.staff_id = sakila.staff.staff_id
group by store_id;

'Question 7g. Write a query to display for each store its store ID, city, and country'

select store_id, city, country 
from sakila.store s
join hwaddress a
on s.address_id = a. address_id
join hw_city c
on a.city_id = c.city_id
join hw_country y
on c.country_id = y.country_id;

'Question 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category,
 film_category, inventory, payment, and rental.)'
 
 select*from hwpayment; 
 select*from hw_inventory; 'using inventory_id get film id'
 select*from sakila.category; 'using category_id get name'
 select*from sakila.film_category; 'using film_id get category_id'
 select*from sakila.rental; 'using rental_id get inventory_id'
 
 select name, sum(amount) as Gross_Revenue
 from hwpayment p
 join sakila.rental r
 on p.rental_id = r.rental_id
 join hw_inventory i
 on r.inventory_id = i.inventory_id
 join sakila.film_category f
 on i.film_id = f.film_id
 join sakila.category c
 on f.category_id = c.category_id
 group by name
 order by Gross_Revenue desc
 limit 5;
 
 'Question 8a. Create a View'
 
 create view top_five_genres as
 select name, sum(amount) as Gross_Revenue
 from hwpayment p
 join sakila.rental r
 on p.rental_id = r.rental_id
 join hw_inventory i
 on r.inventory_id = i.inventory_id
 join sakila.film_category f
 on i.film_id = f.film_id
 join sakila.category c
 on f.category_id = c.category_id
 group by name
 order by Gross_Revenue desc
 limit 5;
 
  'Question 8b. Display View'
  
  select*from top_five_genres;
  
  'Question 8c. Delete View'
  
  drop view top_five_genres;