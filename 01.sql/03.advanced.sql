---------------------------------
# CTE (Common Table Expression) #
---------------------------------

# definir una subsonsulta que luego puede ser referenciada dentro de una consulta principal
# las CTE se deben utilizar de forma inmediata posterior a su definición
with CTE_EXAMPLE as (
	select avg(salary) avg_sal, max(salary) max_sal, min(salary) min_sal, count(*) per_gender, gender from employee_demographics dem
	left join employee_salary sal on sal.employee_id = dem.employee_id
	group by gender
)
select avg(avg_sal) from CTE_EXAMPLE;

# definir nombres de las columnas por defecto en lugar de usar alias dentro de la subconsulta
WITH CTE_EXAMPLE2(Gender, First_Name, Salary) as (
	select gender, dem.first_name, sal.salary from employee_demographics dem
    left join employee_salary sal on dem.employee_id = sal.employee_id 
)
select * from CTE_EXAMPLE2;

---------------------
# Tablas temporales #
---------------------

# crear una tabla temporal y posteriormente insertar nuevos datos en esta
create temporary table temp_table(
	first_name varchar(50),
 	last_name varchar(50),
	favorite_movie varchar(100)
);
insert into temp_table values('Martin', 'Wilches', 'Spiderman');

# crear una tabla temporal a partir de una tabla ya existente
create temporary table salary_over_50k
select * from employee_salary where salary >= 50000;

------------------------------
# Procedimientos almacenados #
------------------------------

# crear un prodedimiento almacenado
create procedure large_salary()
select * from employee_salary where salary >= 50000;

# invocar la logica del procedimiento almacenado
call large_salary();

# crear un procedimiento de multiples declaraciones
delimiter $$ -- especificar que el delimitador de las consultas no va a ser ; para no interrumpir el llamado del procedimiento
create procedure large_salary2()	
begin
	select * from employee_salary where salary >= 50000;
    select * from employee_salary where salary > 10000;
end $$
delimiter ; -- restaurar el delimitador por defecto

call large_salary2()