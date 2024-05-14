CREATE DATABASE tienda_ropa_db;

USE tienda_ropa_db;

CREATE TABLE clientes (
    id_cliente_client INT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion VARCHAR(255),
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20),
    PRIMARY KEY(id_cliente_client)
);

CREATE TABLE productos (
    id_producto_products INT,
    nombre VARCHAR(100),
    descripcion TEXT ,
    precio DECIMAL(10,2),
    categoria VARCHAR(50),
    stock INT NOT NULL,
    PRIMARY KEY(id_producto_products)
);

CREATE TABLE pedidos (
    id_pedido_pedidos INT,
    id_cliente_pedidos int,
    fecha DATE,
    estado ENUM('PENDIENTE', 'PROCESADO', 'ENVIADO', 'ENTREGADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente_pedidos) REFERENCES clientes(id_cliente_client),
    PRIMARY KEY(id_pedido_pedidos)
);

CREATE TABLE ventas (
    id_venta INT,
    id_pedido_venta INT,
    id_producto_venta INT,
    cantidad INT ,
    precio_venta DECIMAL(10,2),
    FOREIGN KEY (id_pedido_venta) REFERENCES pedidos(id_pedido_pedidos),
    FOREIGN KEY (id_producto_venta) REFERENCES productos(id_producto_products),
    PRIMARY KEY(id_venta)
);

INSERT INTO clientes (id_cliente_client, nombre, apellido, direccion, correo_electronico, telefono)values
(1, 'Juan', 'Pérez', 'Av. Principal 123', 'juan.perez@email.com', '04141234567'),
(2, 'María', 'González', 'Calle Secundaria 456', 'maria.gonzalez@email.com', '04241234568'),
(3, 'Carlos', 'Martínez', 'Urb. El Bosque 789', 'carlos.martinez@email.com', '04341234569'),
(4, 'Ana', 'Díaz', 'Av. Libertador 101', 'ana.diaz@email.com', '04441234560'),
(5, 'Luis', 'Rodríguez', 'Callejón Sin Salida 202', 'luis.rodriguez@email.com', '04541234561');

INSERT INTO productos (id_producto_products, nombre, descripcion, precio, categoria, stock)VALUES
(1, 'Camiseta', 'Camiseta de algodón color blanco', 19.99, 'Camisetas', 100),
(2, 'Pantalón', 'Pantalón de mezclilla azul', 39.99, 'Pantalones', 50),
(3, 'Vestido', 'Vestido de verano floral', 29.99, 'Vestidos', 30),
(4, 'Zapatos', 'Zapatos deportivos para correr', 49.99, 'Calzado', 75),
(5, 'Sombrero', 'Sombrero de paja', 14.99, 'Accesorios', 60);

INSERT INTO pedidos (id_pedido_pedidos, id_cliente_pedidos, fecha, estado, total)
VALUES
(1, 1, '2024-05-01', 'Enviado', 99.95),
(2, 2, '2024-05-02', 'Pendiente', 49.99),
(3, 3, '2024-02-03', 'Entregado', 89.97),
(4, 4, '2024-05-04', 'Pendiente',49.99),
(5, 5, '2024-02-05', 'Enviado', 19.99),
(6, 1, '2024-05-16', 'Enviado', 39.98),
(7, 2, '2024-05-17', 'Pendiente', 119.97), 
(8, 1, '2024-05-18', 'Entregado', 29.99), 
(9, 3, '2024-01-19', 'Pendiente', 99.98), 
(10, 4, '2024-04-20', 'Enviado', 14.99), 
(11, 5, '2024-05-21', 'Pendiente', 39.98), 
(12, 2, '2024-05-22', 'Entregado', 69.98), 
(13, 3, '2024-01-23', 'Enviado', 149.97),
(14, 4, '2024-05-24', 'Pendiente', 29.98),
(15, 5, '2024-01-25', 'Entregado', 44.98);

INSERT INTO ventas (id_venta, id_pedido_venta, id_producto_venta, cantidad, precio_venta)
VALUES
(1, 1, 1, 2, 39.98),
(2, 2, 2, 1, 39.99),
(3, 3, 3, 3, 89.97),
(4, 4, 4, 1, 49.99),
(5, 5, 5, 1, 14.99),
(6, 6, 1, 2, 39.98), 
(7, 7, 2, 3, 119.97),
(8, 8, 3, 1, 29.99),
(9, 9, 4, 2, 99.98), 
(10, 10, 5, 1, 14.99), 
(11, 11, 1, 2, 39.98),
(12, 12, 2, 1, 39.99),
(13, 13, 4, 3, 149.97);




-- Consulta 1
SELECT DISTINCT nombre, apellido, direccion, correo_electronico 
FROM clientes
INNER JOIN pedidos ON id_cliente_client = id_cliente_pedidos
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);


-- Consulta 2
SELECT nombre, SUM(cantidad * precio_venta) AS total_vendido FROM productos 
JOIN ventas ON id_producto_products = id_producto_venta
JOIN pedidos ON id_pedido_venta = id_pedido_pedidos
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY nombre
ORDER BY total_vendido DESC;

-- Consulta 3
SELECT nombre, apellido, COUNT(*) AS total_pedidos FROM clientes 
inner JOIN pedidos ON id_cliente_client = id_cliente_pedidos
WHERE fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 365 DAY) AND CURDATE()
GROUP BY id_cliente_client
ORDER BY total_pedidos DESC;


-- Actualización 1
UPDATE productos SET precio = precio * 1.1 WHERE categoria = "Camisetas";

-- Eliminación 1

DELETE FROM pedidos
WHERE NOT EXISTS (
  SELECT * FROM ventas
  WHERE id_pedido_venta = id_pedido_pedidos
);

-- Vista 1
CREATE VIEW vista_clientes_pedidos AS
SELECT id_cliente_client, CONCAT(nombre, ' ', apellido), direccion, correo_electronico, COUNT(*) AS total_pedidos
FROM clientes
JOIN pedidos ON id_cliente_client = id_cliente_pedidos
GROUP BY id_cliente_client;






























