/* Найти  количество неактивных клиентов с балансом > 100000 */

SELECT count(*) FROM clients
WHERE activity = 'False' and balance > 100000

/* Средний кредитный рейтинг в разрезе стран */

SELECT name_country, AVG(credit_rating) FROM clients
JOIN countries ON country_id = id_country
GROUP BY name_country

/* Посчитать процент ушедших клиентов в разрезе типов карт */

SELECT (SUM(CASE WHEN activity = FALSE THEN 1 ELSE 0 END) * 100/COUNT(last_name)) AS percent_who_left, 
name_card_type FROM client_card
JOIN clients ON id_client = client_id
JOIN card_types ON id_card_type = card_type_id
GROUP BY name_card_type

/* Сравнить зарплату клиента со средней зарплатой по его стране */

SELECT first_name, last_name, name_country, salary - average_salary AS salary_difference  FROM clients
JOIN countries ON country_id = id_country


/* Найти страны, в которых в топ-10 по зарплатам женщин больше , чем мужчин */

SELECT name_country AS country_top_women
FROM (
    SELECT 
        country_id, 
		COUNT(*) FILTER (WHERE gender = 'Женский') AS women, 
		COUNT(*) FILTER (WHERE gender = 'Мужской') AS men
    FROM (
        SELECT country_id, gender, RANK() OVER (PARTITION BY country_id ORDER BY salary DESC) AS rank
		FROM clients ) WHERE rank <= 10 GROUP BY country_id )
JOIN countries ON country_id = id_country
WHERE women > men;

/* Найти страны, в которых используются не все возможные типы карт */

SELECT name_country AS country_not_all_types
FROM countries
WHERE id_country NOT IN (
    SELECT DISTINCT country_id
    FROM clients
    JOIN client_card cc ON client_id = id_client
    GROUP BY country_id
    HAVING COUNT(DISTINCT card_type_id) = (SELECT COUNT(*) FROM card_types)
);
