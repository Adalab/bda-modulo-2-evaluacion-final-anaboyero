USE sakila;

-- EJERCICIO 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

--  EJERCICIO 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

-- Siendo estrictos, sería la siguiente consulta...

SELECT title
FROM film
WHERE rating = "PG-13";


-- ... pero interpreto que en realidad podríamos estar interesados en saber todas las películas aptas para mayores de 13.
-- En ese caso, nos interesaría incluir películas calificadas para "todos los públicos" ("G") y aptas para mayores de 7 ("PG"):

SELECT title
FROM film
WHERE rating IN ("PG-13", "G", "PG");

 -- EJERCICIO 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
 
 SELECT title, description
 FROM film
 WHERE description LIKE "%amazing%";
 
 
 -- EJERCICIO 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
 
 SELECT title AS peliculas_de_mas_de_120_min
 FROM film
 WHERE length > 120;
 

-- EJERCICIO 5. Recupera los nombres de todos los actores.

SELECT CONCAT(first_name,  " ", last_name) AS nombre_completo
FROM actor;
 

 -- EJERCICIO 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
 
 SELECT first_name AS nombre, last_name AS apellido
 FROM actor
 WHERE last_name LIKE "%Gibson%";
 
   
 -- EJERCICIO 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
 
SELECT CONCAT(first_name,  " ", last_name) AS nombre_completo
FROM actor
WHERE actor_id BETWEEN 10 AND 20;
 

 -- EJERCICIO 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
 
 -- La consulta literal del enunciado sería...
 
 SELECT title, rating
 FROM film
 WHERE rating NOT IN ("R", "PG-13");
 
 
 -- Pero interpreto que si una persona está interesada en filtrar por películas no aptas para menores de 13 y 17 años, 
 -- entonces no tendría sentido dejarse fuera la clasificación "no apta para niños pequeños" (PG). 
 -- Teniendo eso en cuenta, la consulta quedaría: 
 
SELECT title, rating
FROM film
WHERE rating NOT IN ("R", "PG-13", "PG");
 
    
 -- EJERCICIO 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
 -- y muestra la clasificación junto con el recuento.
 
 SELECT rating AS Clasificacion_por_edades, COUNT(film_id) AS total_peliculas
 FROM film
 GROUP BY rating;
 

 -- EJERCICIO 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
 -- apellido junto con la cantidad de películas alquiladas.

SELECT rental.customer_id AS "ID_cliente", customer.first_name, customer.last_name,  COUNT(rental.customer_id) AS "Peliculas_alquiladas"
FROM rental 
JOIN customer
	ON rental.customer_id = customer.customer_id
GROUP BY rental.customer_id;

      
-- EJERCICIO 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría 
-- junto con el recuento de alquileres.

-- INFO: La información de la categoría de la película no está en la tabla rental. 
-- Para llegar a esa información necesito pasar por las tablas: inventory, film_category y category. 

SELECT c.name AS "Categoría", COUNT(r.rental_id) AS "Peliculas_alquiladas_por_categoria"
FROM rental AS r
JOIN inventory AS i
					ON r.inventory_id = i.inventory_id
JOIN film_category AS fc
					ON i.film_id = fc.film_id
JOIN category AS c
					ON fc.category_id = c.category_id
GROUP BY c.name
;





 -- EJERCICIO 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
 -- clasificación junto con el promedio de duración.
 
 SELECT 
	rating AS "Clasificación", 
    AVG(length) AS "Duración promedio (minutos)"
 FROM film
 GROUP BY rating;
 


-- EJERCICIO 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

-- Usaremos subconsultas y la tabla intermedia film_actor


SELECT first_name AS "Nonbre", last_name AS "Apellido"
FROM actor
WHERE actor_id IN ( 
					SELECT actor_id
					FROM film_actor
					WHERE film_id = (
										SELECT film_id 
										FROM film
										WHERE title = "Indian Love") 
	) ;

-- EJERCICIO 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title AS 'Título película con perros/gatos'
FROM film 
WHERE description LIKE "%cat%" OR description LIKE "%dog%" ;
    
    
-- EJERCICIO 14. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

-- RESPUESTA: No.

SELECT CONCAT(first_name, " ", last_name) AS nombre_actor, actor_id AS "ID_actor"
FROM actor
WHERE actor_id NOT IN (
						SELECT actor_id
						FROM film_actor
);

--  EJERCICIO 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;
 
-- EJERCICIO 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

-- Al no disponer de la categoría en la tabla film, lo haremos mediante subconsultas 
 
 SELECT title AS "Películas de categoría Family"
 FROM film
 WHERE film_id IN (
 
	SELECT film_id
    FROM film_category
	WHERE category_id = (
						SELECT category_id
						FROM category
						WHERE name = "Family")
 );
 
 
-- EJERCICIO 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

-- Propuesta 1. Usamos la tabla intermedia film_actor. Empezamos averiguando en cuantas peliculas ha aparecido cada actor 
-- y después filtramos por aquellos que tengan más de 10.

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor AS a
LEFT JOIN film_actor AS fa
		ON fa.actor_id = a.actor_id
GROUP BY a.actor_id 
HAVING COUNT(fa.film_id) > 10 ;

-- Propuesta 2, mediante subconsulta.

SELECT first_name, last_name 
FROM actor 
WHERE actor_id IN (
					SELECT actor_id
					FROM film_actor
					GROUP BY actor_id
					HAVING COUNT(film_id)  >= 5) ;
	
-- EJERCICIO 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

-- NOTA: Dos horas equivalen a 120 minutos.

SELECT title AS "Películas para mayores de 17 años de más de 2 horas"
FROM film
WHERE rating = "R" AND length > 120;

			
-- EJERCICIO 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
 -- nombre de la categoría junto con el promedio de duración.
 
 
SELECT c.name AS "Categoría", AVG(f.length) AS "Promedio duración"
 FROM film AS f
 JOIN film_category AS fc
		ON f.film_id = fc.film_id
JOIN category AS c
		ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length)> 120;


-- EJERCICIO 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad
 -- de películas en las que han actuado.
 
 
SELECT CONCAT(a.first_name, " ", a.last_name) AS 'Nombre Actor', COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
		ON fa.actor_id = a.actor_id
GROUP BY a.actor_id 
HAVING cantidad_peliculas >= 5 ;
 
  
-- EJERCICIO 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
-- y luego selecciona las películas correspondientes.


-- Lo primero, la solución se puede obtener sin salir de la tabla film:

SELECT title
FROM film
WHERE rental_duration > 5;

-- Pero como nos pide hacerlo mediante subconsulta, lo intentamos.

SELECT rental_id
FROM rental
WHERE DATEDIFF(return_date, rental_date) > 5;

-- Uso de la función fecha DATEDIFF, que devuelve la diferencia entre dos fechas en días. 

-- La segunda parte del ejercicio 22 no la he conseguido resolver en tiempos. 

-- Intento 1. 
select title 
FROM film
JOIN inventory
		ON film.film_id = inventory.film_id
        
WHERE rental_id IN (
								SELECT rental_id
								FROM rental
								WHERE DATEDIFF(return_date, rental_date) > 5
);

-- Intento 2. 

select film_id
FROM film
WHERE rental_id IN (
								SELECT inventory_id
								FROM rental
								WHERE DATEDIFF(return_date, rental_date) > 5
);

-- Intento 3.

SELECT inventory_id
FROM inventory
WHERE rental_id IN (
								SELECT rental_id
								FROM rental
								WHERE DATEDIFF(return_date, rental_date) > 5
);
 
SELECT rental_id
FROM rental
WHERE DATEDIFF(return_date, rental_date) > 5;
 
 
 
  /* 
  EJERCICIO 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
 Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
 exclúyelos de la lista de actores.*/ 
 

SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
						SELECT actor_id
						FROM film_actor
						WHERE film_id IN (
										SELECT film_id
										FROM film_category
										WHERE category_id IN (
															SELECT category_id
															FROM category
															WHERE name = "Horror") ) ) ;
   
   
 -- BONUS
 -- EJERCICIO 24. BONUS: Encuentra el título de las películas que son comedias 
 -- y tienen una duración mayor a 180 minutos en la tabla film.
 
 SELECT title AS "Comedias de más de 3 horas"
 FROM film
 WHERE length > 180 AND film_id IN (
										SELECT film_id
                                        FROM film_category
                                        WHERE category_id = (
                                        
																SELECT category_id
																FROM category
                                                                WHERE name = "Comedy")
								
 );
 
 /*
 -- EJERCICIO 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
 -- La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos
*/

-- No terminado. Faltaría por llegar a los nombres de los actores.

SELECT main.actor_id AS "Id actor", sub.actor_id AS "Ha trabajado con (id_actor)", COUNT(main.film_id) AS "Num. películas en que han coincidido"  
FROM film_actor AS main
LEFT JOIN film_actor AS sub
	ON main.film_id = sub.film_id
WHERE sub.actor_id != main.actor_id 
GROUP BY main.actor_id, sub.actor_id ;

-- otro intento:


SELECT main.actor_id AS "Id actor", sub.actor_id AS "Ha trabajado con (id_actor)", COUNT(main.film_id) AS "Num. películas en que han coincidido"  
FROM (film_actor AS main
LEFT JOIN film_actor AS sub
	ON main.film_id = sub.film_id
WHERE sub.actor_id != main.actor_id 
)

GROUP BY main.actor_id
JOIN actor AS a
			ON main.actor_id = a.actor_id;



-- Otro intento con CTE

WITH te AS 
			(SELECT main.actor_id, sub.actor_id AS "Ha trabajado con", COUNT(main.film_id) AS "Num películas han coincidido"  
			FROM film_actor AS main
			JOIN film_actor AS sub
				ON main.film_id = sub.film_id
			WHERE sub.actor_id != main.actor_id 
			GROUP BY main.actor_id, sub.actor_id )
SELECT *
FROM te
NATURAL JOIN actor;


SELECT *
FROM film_actor AS main
JOIN film_actor AS sub
	ON main.film_id = sub.film_id
WHERE sub.actor_id != main.actor_id 
GROUP BY main.actor_id, sub.actor_id ;


            




SELECT main.actor_id AS "Id actor", sub.actor_id AS "Ha trabajado con (id_actor)", COUNT(main.film_id) AS "Num. películas en que han coincidido"  
FROM film_actor AS main
LEFT JOIN film_actor AS sub
	ON main.film_id = sub.film_id
WHERE sub.actor_id != main.actor_id 
GROUP BY main.actor_id, sub.actor_id ;





SELECT main.actor_id AS "Nombre actor", sub.actor_id AS "Ha trabajado con", COUNT(main.film_id) AS "Num. películas en que han coincidido"  
FROM film_actor AS main
JOIN film_actor AS sub
	ON main.film_id = sub.film_id
WHERE sub.actor_id != main.actor_id 
GROUP BY main.actor_id, sub.actor_id ;


-- Seguridad:

SELECT main.actor_id AS "Nombre actor", sub.actor_id AS "Ha trabajado con", COUNT(main.film_id) AS "Coincidieron en tantas películas"  
FROM film_actor AS main
JOIN film_actor AS sub
	ON main.film_id = sub.film_id
WHERE sub.actor_id != main.actor_id 
GROUP BY main.actor_id, sub.actor_id ;
 
 