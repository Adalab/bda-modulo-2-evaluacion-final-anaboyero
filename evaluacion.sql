USE sakila;

/* EJERCICIO 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados*/ 

SELECT DISTINCT title AS "Título"
FROM film;

/* EJERCICIO 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"*/ 

-- Siendo estrictos, sería la siguiente consulta...

SELECT title 
FROM film
WHERE rating = "PG-13";


-- ... pero interpreto que si quieres saber todas las películas aptas para mayores de 13, 
-- habría que incluir películas aptas todos los públicos" ("G") y aptas para mayores de 7 ("PG").

SELECT title AS "Películas aptas para mayores de 13"
FROM film
WHERE rating IN ("PG-13", "G", "PG");

-- Carla, elijo esta segunda opción para la corrección.

 /*EJERCICIO 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/
 
 SELECT title AS "Título", description AS "Descripción"
 FROM film
 WHERE description LIKE "%amazing%";
 
 
 /* EJERCICIO 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos*/ 
 
 SELECT title AS peliculas_de_mas_de_120_min
 FROM film
 WHERE length > 120;
 

/*  EJERCICIO 5. Recupera los nombres de todos los actores*/ 

SELECT CONCAT(first_name, " ", last_name) AS Actores
FROM actor;
 

 /* EJERCICIO 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */
 
 SELECT first_name AS nombre, last_name AS apellido
 FROM actor
 WHERE last_name LIKE "%Gibson%";
 
   
 /* EJERCICIO 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */ 
 
SELECT CONCAT(first_name,  " ", last_name) AS "Nombre actor"
FROM actor
WHERE actor_id BETWEEN 10 AND 20;
 

 /* EJERCICIO 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/
 
 
SELECT title AS "Título", rating AS "Clasificación por edades"
FROM film
WHERE rating NOT IN ("R", "PG-13");
 
 -- Pero entiendo que si una persona quiere excluir películas que sean para mayores de 13 (PG-13) 
 -- y para mayores de 17 años (R= Restricted), entonces no tiene mucho sentido devolver una película que es solo para adultos (NC-17).
 -- Teniendo eso en cuenta, la consulta quedaría: 
 
SELECT title AS "Título", rating AS "Clasificación por edades"
FROM film
WHERE rating NOT IN ("R", "PG-13", "NC-17");
 
 
 -- Carla, elijo esta segunda opción para la corrección.
    
/* EJERCICIO 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
  y muestra la clasificación junto con el recuento.*/ 
 
 SELECT rating AS Clasificacion_por_edades, COUNT(film_id) AS total_peliculas
 FROM film
 GROUP BY rating;
 

 /* EJERCICIO 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
 apellido junto con la cantidad de películas alquiladas.*/ 

SELECT rental.customer_id AS id_cliente, customer.first_name AS nombre, customer.last_name AS apellido,  COUNT(rental.customer_id) AS peliculas_alquiladas
FROM rental 
JOIN customer
	ON rental.customer_id = customer.customer_id
GROUP BY rental.customer_id;

      
/* EJERCICIO 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría 
 junto con el recuento de alquileres.*/ 

--  La información de la categoría de la película no está en la tabla rental. 
-- Para conseguir esa información primeramente construyo, mediante join, una tabla que una las tablas: inventory, film_category y category. 

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


 /* EJERCICIO 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
 -- clasificación junto con el promedio de duración.*/ 
 
 SELECT 
	rating AS "Clasificación por edades", 
    AVG(length) AS "Duración promedio (minutos)"
 FROM film
 GROUP BY rating;
 


/* EJERCICIO 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/ 

-- Usamos subconsultas para filtrar por el título de la película. Usamos la tabla intermedia film_actor,
-- que sirve de puente para llegar a la tabla actor.


SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor
WHERE actor_id IN ( 
					SELECT actor_id
					FROM film_actor
					WHERE film_id = (
										SELECT film_id 
										FROM film
										WHERE title = "Indian Love") 
	) ;

/* EJERCICIO 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/

SELECT title AS 'Título película con perros/gatos'
FROM film 
WHERE description LIKE "%cat%" OR description LIKE "%dog%" ;
    
    
/* EJERCICIO 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.*/

-- Para poder responder, seleccionamos en la tabla de actores aquellos identificadores que no estén incluidos
-- en la subconsulta que me devuelve los identificadores de todos los actores que aparecen en mi tabla de películas.
-- La tabla sale vacía, así que la respuesta es no.

SELECT CONCAT(first_name, " ", last_name) AS nombre_actor, actor_id AS "ID_actor"
FROM actor
WHERE actor_id NOT IN (
						SELECT actor_id
						FROM film_actor
);

/*  EJERCICIO 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

SELECT title AS Titulo
FROM film
WHERE release_year BETWEEN 2005 AND 2010;
 
/* EJERCICIO 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".*/ 

-- Al no disponer en la tabla film de información sobre la categoría, lo haremos mediante la union de 
-- las tablas film y film_category y una subconsulta que me permite extraer el identificador de la categoría Family. 

SELECT f.title AS "Películas de categoría Family"
FROM film AS f
JOIN film_category AS fc
		ON f.film_id = fc.film_id
WHERE category_id = (
						SELECT category_id
						FROM category
                        WHERE name = "Family"
						);

-- Otra manera de hacerlo, sin join, sería encadenando subconsultas. 

-- Lo muestro a continuación, pero elijo que se evalúe mi primera opción. 
 
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
 
 
/* EJERCICIO 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas */

-- Propuesta 1. Hacemos un left join con la tabla intermedia film_actor. Agrupamos los resultados por actores y filtramos
-- para quedarnos con aquellos que tengan más de 10 películas.

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor AS a
LEFT JOIN film_actor AS fa
		ON fa.actor_id = a.actor_id
GROUP BY a.actor_id 
HAVING COUNT(fa.film_id) > 10 ;

-- Propuesta 2, mediante subconsulta, conseguimos los identificadores de todos los actores que han participado
-- en más de 10 películas y después usamos ese dato para filtrar en la lista de actores. Elijo esta segunda opción para corregir.

SELECT first_name, last_name 
FROM actor 
WHERE actor_id IN (
					SELECT actor_id
					FROM film_actor
					GROUP BY actor_id
					HAVING COUNT(film_id)  >= 5) ;
	
/* EJERCICIO 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film*/ 

-- NOTA: Dos horas equivalen a 120 minutos.

SELECT title AS "Películas para mayores de 17 años de más de 2 horas"
FROM film
WHERE rating = "R" AND length > 120;

			
/* EJERCICIO 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
 -- nombre de la categoría junto con el promedio de duración.*/
 
 -- Mediante el uso de joins, agrupo en una sola tabla toda la información que necesito y después
 -- agrupo los resultados por categoría y filtro por el promedio de duración. 
 
 
SELECT c.name AS "Categoría", AVG(f.length) AS "Promedio duración"
FROM film AS f
JOIN film_category AS fc
		ON f.film_id = fc.film_id
JOIN category AS c
		ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length)> 120;


/* EJERCICIO 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad
 -- de películas en las que han actuado.*/
 
 -- Mediante un left join consigo todos los actores y las películas en las que han participado.
 -- Agrupo por identificador de actores para obtener el recuento de películas en las que han participado
 -- y con ese dato filtro la selección de los nombres.
 
 
SELECT CONCAT(a.first_name, " ", a.last_name) AS 'Nombre intérprete', COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa
		ON fa.actor_id = a.actor_id
GROUP BY a.actor_id 
HAVING cantidad_peliculas >= 5 ;
 
  
/* EJERCICIO 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
 y luego selecciona las películas correspondientes.*/ 


-- La función fecha DATEDIFF, nos devuelve la diferencia entre dos fechas en días. 

SELECT title AS Peliculas_alquiladas_mas_de_5_dias
FROM film
WHERE film_id IN ( 
				SELECT DISTINCT film_id
				FROM inventory
				WHERE inventory_id IN (

										SELECT inventory_id
										FROM rental
										WHERE rental_id IN (
										
															SELECT rental_id
															FROM rental
															WHERE DATEDIFF(return_date, rental_date) > 5) ) ) ;



  /* EJERCICIO 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
 Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" 
 -- y luego exclúyelos de la lista de actores.*/ 
 

SELECT first_name AS nombre, last_name AS apellido
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
 -- EJERCICIO 24 : Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
 
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
 EJERCICIO 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
 La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos
*/

-- Mediante joins entre las tablas de actores y la tabla film_Actor puedo juntar los nombres de los actores con sus ids.
-- Importante: para no repetir datos, excluyo las filas de subconsultas donde aparece el actor que está en la consulta principal.
-- Después, agrupo los resultados por cada pareja de actores y contaré las películas en que coinciden

SELECT 
		a.first_name AS nombre_actor, 
		a.last_name AS apellido_actor, 
		asub.first_name AS nombre_actor_compañero, 
		asub.last_name AS apellido_actor_compañero,
        COUNT(fa.film_id) AS "Películas en que coinciden"
        
FROM film_actor AS fa
JOIN actor AS a
			ON fa.actor_id = a.actor_id
JOIN film_actor AS fasub
			ON fa.film_id = fasub.film_id
JOIN actor AS asub 
			ON asub.actor_id = fasub.actor_id
WHERE a.actor_id != asub.actor_id 
GROUP BY a.first_name, 
		a.last_name, 
		asub.first_name, 
		asub.last_name;

