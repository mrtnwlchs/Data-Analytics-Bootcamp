###############################
# Esquema de la base de datos #
###############################
# 1. Identificar las entidades: 	Determinar que objetos principales necesita almacenar el sistema, ejemplo. Cliente, Producto, Pedido
# 2. Definir los atributos: 		Determinar que información se necesita guardar, ejemplo. Cliente -> id_cliente, nombre, apellido, correo
# 3. Definir las claves primarias: 	Cada tabla debe tener normalmente una clave primaria (PK) que identifique de forma única cada registro, ejemplo. Cliente -> id_cliente (PK)
# 4. Establecer las relaciones: 	Determinar como se realacionan las tablas, ejemplo. Un cliente puede realizar muchos pedidos -> 1:N
# 5. Definir las claves foráneas: 	Las relaciones se implementan mediante claves foráneas (FK), ejemplo. Pedido -> id_pedido (PK), id_cliente (FK). id_cliente referencia a Cliente.id_cliente
# 6. Llevar el esquema a SQL:		create table cliente(...);
# 7. Comprobar la normalización: 	Comprobar que el diseño no tenga información innecesariamente repetida. Las formas normales más habituales son:
	# - 1FN: datos atómicos, sin listas dentro de una columna
    # - 2FN: evitar dependencias parciales de una clave compuesta
    # - 3FN: evitar dependencias entre atributos que no sean claves

#####################
# DISCOTECA MUSICAL #
#####################
create database discoteca_metal;
use discoteca_metal;

create table generos(
	id int primary key auto_increment,
    nombre varchar(50) not null
);

create table bandas(
	id int primary key auto_increment,
    nombre varchar(100) not null,
    pais varchar(50),
    anio_formacion int
);

# tabla intermedia N-N (una banda puede tener varios generos, un genero varias bandas)
create table banda_genero(
	banda_id int,
    genero_id int,
    primary key (banda_id, genero_id),
    foreign key (banda_id) references bandas(id),
    foreign key (genero_id) references generos(id)
);

create table integrantes(
	id int primary key auto_increment,
    banda_id int,
    nombre varchar(100),
    instrumento varchar(50),
    foreign key (banda_id) references bandas(id)
);

create table albumes(
	id int primary key auto_increment,
    banda_id int,
    titulo varchar(100),
    anio_lanzamiento int,
    precion decimal(10,2),
    foreign key (banda_id) references bandas(id)
);

insert into generos(nombre) values('Thrash Metal'), ('Heavy Metal');
insert into bandas(nombre, pais, anio_formacion) values('Metallica', 'USA', 1981), ('Iron Maiden', 'UK', 1975);