--Вывести к каждому самолету класс обслуживания и количество мест этого класса

Select air.aircraft_code, seats.fare_conditions, count(seats.fare_conditions)
from aircrafts_data as air
         join seats on air.aircraft_code = seats.aircraft_code
group by seats.fare_conditions, air.aircraft_code
order by 1;

--Найти 3 самых вместительных самолета (модель + кол-во мест)
SELECT aircrafts_data.model, count(seats) as c
from aircrafts_data
         join seats on aircrafts_data.aircraft_code = seats.aircraft_code
group by aircrafts_data.model
order by c DESC
limit 3;
--Вывести код,модель самолета и места не эконом класса для самолета 'Аэробус A321-200' с сортировкой по местам
SELECT air.aircraft_code, air.model, s.*
from aircrafts_data as air
         join seats s on air.aircraft_code = s.aircraft_code
where model ->> 'ru' = 'Аэробус A321-200'
  and s.fare_conditions != 'Economy'
order by s;
--Вывести города в которых больше 1 аэропорта ( код аэропорта, аэропорт, город)

SELECT air.city, a.airport_code, a.airport_name
from (SELECT city
      from airports_data
      group by city
      HAVING count(city) > 1
      order by city) air
         join airports_data a on a.city = air.city;

-- Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация

Select f.*, a.city
from flights f
         join airports_data a on a.airport_code = f.departure_airport
         join airports_data b on b.airport_code = f.arrival_airport
where (a.city ->> 'ru' = 'Екатеринбург' AND b.city ->> 'ru' = 'Москва')
  AND (f.status = 'Scheduled' OR f.status = 'On Time' OR f.status = 'Delayed')
order by f.scheduled_departure
limit 1;
--Вывести самый дешевый и дорогой билет и стоимость ( в одном результирующем ответе)
SELECT t.*, tf.amount
from ticket_flights tf
         join tickets t on t.ticket_no = tf.ticket_no
where tf.amount in ((SELECT max(amount) from ticket_flights),
                    (SELECT min(amount) from ticket_flights))
order by amount DESC;


SELECT tf.amount, t.*
from (SELECT amount, ticket_no
      from ticket_flights
      where (Select min(amount) from ticket_flights) = ticket_flights.amount
         OR (Select max(amount) from ticket_flights) = ticket_flights.amount) tf
         join tickets t on t.ticket_no = tf.ticket_no
order by amount DESC;

-- Написать DDL таблицы Customers , должны быть поля id , firstName, LastName, email , phone. Добавить ограничения на поля ( constraints) .
CREATE TABLE IF NOT EXISTS customers
(
    id         BIGSERIAL PRIMARY KEY,
    first_name varchar(64)         NOT NULL,
    last_name  varchar(64)         NOT NULL,
    email      varchar(128) UNIQUE NOT NULL,
    phone      varchar(128) UNIQUE NOT NULL
);

-- Написать DDL таблицы Orders , должен быть id, customerId,	quantity. Должен быть внешний ключ на таблицу customers + ограничения

CREATE TABLE IF NOT EXISTS orders
(
    id          BIGSERIAL PRIMARY KEY,
    customer_id BIGSERIAL NOT NULL,
    quantity    BIGINT,
    FOREIGN KEY (customer_id) REFERENCES customers (id)
);
-- Написать 5 insert в эти таблицы
INSERT into customers (first_name, last_name, email, phone)
VALUES ('bib', 'goga', 'bib@gmail.com', '+375290000001');
INSERT into customers (first_name, last_name, email, phone)
VALUES ('bob', 'gogi', 'bob@gmail.com', '+375290000002');
INSERT into customers (first_name, last_name, email, phone)
VALUES ('beb', 'goge', 'beb@gmail.com', '+375290000003');
INSERT into customers (first_name, last_name, email, phone)
VALUES ('bub', 'guga', 'bub@gmail.com', '+375290000004');
INSERT into customers (first_name, last_name, email, phone)
VALUES ('bab', 'gaga', 'bab@gmail.com', '+375290000005');
INSERT into orders (customer_id, quantity)
VALUES (1, 3);
INSERT into orders (customer_id, quantity)
VALUES (2, 4);
INSERT into orders (customer_id, quantity)
VALUES (3, 5);
INSERT into orders (customer_id, quantity)
VALUES (5, 2);
INSERT into orders (customer_id, quantity)
VALUES (4, 1);
-- удалить таблицы

Drop TABLE orders;
Drop TABLE customers;
-- Написать свой кастомный запрос ( rus + sql)

