## Taller Práctico de SQL: Gestión de Productos y Pedidos 🛒

¡Bienvenido/a a este taller práctico de SQL! Aquí pondrás a prueba tus habilidades en el manejo de bases de datos relacionales, específicamente en la creación de procedimientos almacenados y disparadores (triggers).

### Descripción del Problema 📋

Imagina que estás a cargo de la base de datos de una tienda. Necesitas gestionar la información de los productos (tabla `PRODUCTO`) y los pedidos que los clientes realizan (tabla `PEDIDO`). Tu misión es desarrollar soluciones SQL para:

* **Insertar productos de forma segura:** Verificar que no se dupliquen códigos o nombres.
* **Realizar pedidos con control de inventario:** Comprobar la existencia de productos y actualizar el stock.
* **Registrar cambios en los productos:** Crear un registro detallado de todas las modificaciones.

### Ejercicios 🛠️

1. **Procedimiento almacenado para insertar productos:**
   * **Input:** Código del producto, nombre del producto, existencia.
   * **Lógica:** Verificar si el código o el nombre ya existen. Si es así, mostrar un mensaje de error. Si no, insertar el producto.

2. **Procedimiento almacenado para realizar pedidos:**
   * **Input:** Código del producto, cantidad a pedir.
   * **Lógica:**
      * Verificar si el producto existe. Si no, mostrar un mensaje de error.
      * Verificar si hay suficiente stock. Si no, mostrar un mensaje de error.
      * Si todo está bien, insertar el pedido y actualizar la existencia del producto.

3. **Disparador (trigger) para registrar cambios en los productos:**
   * **Tabla `BITACORA`:** id, acción (INSERT, UPDATE, DELETE), fecha, usuario.
   * **Lógica:** Registrar cada inserción, modificación o eliminación en la tabla `PRODUCTO`.

### Ejercicio con la Base de Datos Northwind 🧭

Aplica tus conocimientos de SQL a la base de datos Northwind para resolver estas consultas:

1. **Cantidad de productos por categoría:** ¿Cuántos productos hay en cada categoría?
2. **Detalle de ventas por vendedor:** ¿Qué productos vendió cada vendedor, cuándo y en qué cantidad?
3. **Ventas totales por vendedor (filtro):** ¿Cuáles son los vendedores con ventas superiores a $100,000? Muestra su nombre y la inicial de su apellido junto con el total de ventas.

### ¡Manos a la obra! 💪

1. Clona este repositorio en tu máquina local.
2. Crea las tablas `PRODUCTO`, `PEDIDO` y `BITACORA`.
3. Resuelve los ejercicios, ¡no dudes en consultar la documentación y recursos en línea!
4. Comparte tus soluciones y aprende de los demás.
