create database Steve_Car_Showroom;

use Steve_Car_Showroom;

CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);
--------------------
INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);
--------------------
CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);
--------------------
INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');
--------------------
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);
--------------------
INSERT INTO sales (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, 2, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');


select * from cars;
select * from sales;
select * from salespersons;


1. What are the details of all cars purchased in the year 2022?

select c.*,s.purchase_date
from cars c
join sales s
on c.car_id = s.car_id
where extract(year from purchase_date) = 2022;


select *
from cars
where car_id in (select car_id
				 from sales
                 where extract(year from purchase_date) = 2022);


2. What is the total number of cars sold by each salesperson?

select s.salesman_id as id ,sp.name,count(*) as total_cars_sold
from sales s
join salespersons sp
on s.salesman_id = sp.salesman_id
group by s.salesman_id,sp.name;

SELECT sp.name AS salesperson_name, COUNT(s.sale_id) AS total_cars_sold
FROM salespersons sp
LEFT JOIN sales s ON sp.salesman_id = s.salesman_id
GROUP BY sp.name;

3. What is the total revenue generated by each salesperson?

select sp.salesman_id as id,sp.name,sum(c.cost_$) as total_revenue
from cars c
join sales s
on c.car_id = s.car_id
join salespersons sp
on s.salesman_id = sp.salesman_id
group by sp.salesman_id,sp.name;


4. What are the details of the cars sold by each salesperson?

select sp.salesman_id as id,sp.name,c.*
from cars c
join sales s
on c.car_id = s.car_id
join salespersons sp
on s.salesman_id = sp.salesman_id
order by sp.salesman_id,sp.name;

SELECT sp.name AS salesperson_name, c.make, c.type, c.style
FROM salespersons sp
JOIN sales s ON sp.salesman_id = s.salesman_id
JOIN cars c ON s.car_id = c.car_id
ORDER BY sp.name;

5. What is the total revenue generated by each car type?

SELECT c.type, SUM(c.cost_$) AS total_revenue_generated
FROM cars c
JOIN sales s ON c.car_id = s.car_id
GROUP BY c.type;

6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?

select C.*
from cars c
join sales s
on c.car_id = s.car_id
join salespersons sp
on s.salesman_id = sp.salesman_id
where year(purchase_date) = 2021 AND sp.name = "Emily Wong";


7. What is the total revenue generated by the sales of hatchback cars?

select c.style , sum(cost_$) total_revenue
from cars c
join sales s
on c.car_id = s.car_id
where c.style = "hatchback"
group by c.type;


8. What is the total revenue generated by the sales of SUV cars in the year 2022?

select c.style,sum(cost_$) as total_revenue
from cars c
join sales s
on c.car_id = s.car_id
where c.style = "SUV" and year(purchase_date) = 2022
group by c.style;


9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?

select sp.name,sp.city,count(car_id) no_of_cars
from salespersons sp
join sales s
on sp.salesman_id = s.salesman_id
where year(purchase_date) = 2023
group by sp.name,sp.city
order by count(car_id) desc
limit 1;

10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?

select sp.name as salesman_name , sp.age as salesman_age,sum(cost_$) as revenue
from salespersons sp
join sales s
on sp.salesman_id = s.salesman_id
join cars c
on s.car_id = c.car_id
where year(purchase_date) = 2022
group by sp.name,sp.age
order by sum(cost_$) desc
limit 1;


