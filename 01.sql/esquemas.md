# Esquema de la base de datos

1. Identificar las entidades: Determinar que objetos principales necesita almacenar el sistema.

    - Ejemplo: Cliente, Producto, Pedido

2. Definir los atributos: Determinar que información se necesita guardar.

    - Ejemplo: Cliente -> id_cliente, nombre, apellido, correo

3. Definir las claves primarias: Cada tabla debe tener normalmente una clave primaria (PK) que identifique de forma única cada registro.

    - Ejemplo: Cliente -> id_cliente (PK)

4. Establecer las relaciones: Determinar como se realacionan las tablas.

    - Ejemplo: Un cliente puede realizar muchos pedidos -> 1:N

5. Definir las claves foráneas: Las relaciones se implementan mediante claves foráneas (FK).

    - Ejemplo: Pedido -> id_pedido (PK), id_cliente (FK). id_cliente referencia a Cliente.id_cliente

6. Llevar el esquema a SQL: `create table cliente(...);`

7. Comprobar la normalización: Comprobar que el diseño no tenga información innecesariamente repetida. Las formas normales más habituales son:

	- 1FN: datos atómicos, sin listas dentro de una columna
    - 2FN: evitar dependencias parciales de una clave compuesta
    - 3FN: evitar dependencias entre atributos que no sean claves

