/* DAY_28_Lab1 Stored procedures
In this lab, we will continue working on the Sakila database of movie rentals.
Instructions: Write queries, stored procedures to answer the following questions:

Q1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers
who rented Action movies. Convert the query into a simple stored procedure. Use the following query:*/
use sakila;

drop procedure if exists action_customer_details_proc;

delimiter //
create procedure action_customer_details_proc ()
begin
select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end;
//
delimiter ;

call action_customer_details_proc();



/*Q2. Now keep working on the previous stored procedure to make it more dynamic.
Update the stored procedure in a such manner that it can take a string argument for the category
name and return the results for all customers that rented movie of that category/genre.
For eg., it could be action, animation, children, classics, etc.*/

drop procedure if exists action_customer_details_proc;

delimiter //
create procedure action_customer_details_proc (in paramIN varchar(20))
begin
select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = paramIN
  group by first_name, last_name, email;
end;
//
delimiter ;

call action_customer_details_proc("Action");



/*Q3. Write a query to check the number of movies released in each movie category.
Convert the query in to a stored procedure to filter only those categories that have movies
released greater than a certain number. Pass that number as an argument in the stored procedure.*/

drop procedure if exists cat_filter_num_proc;

delimiter //
create procedure cat_filter_num_proc (in paramIN int)
begin
SELECT fc.category_id, c.name, count(fc.film_id) AS n_films FROM film_category as fc
join category as c
on c.category_id = fc.category_id
GROUP BY category_id
HAVING n_films >  paramIN;
end;
//
delimiter ;

call cat_filter_num_proc(5);