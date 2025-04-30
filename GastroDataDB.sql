--tabla cliente
CREATE TABLE Cliente(
	id_cliente INT PRIMARY KEY, 
	nombre VARCHAR(45) NOT NULL,
	apellido VARCHAR(45) NOT NULL,
	observaciones VARCHAR(45) DEFAULT 'Sin observaciones'
);

--tabla mesero 
CREATE TABLE Mesero(
	id_mesero INT PRIMARY KEY,
	nombre VARCHAR(45) NOT NULL,
	apellido1 VARCHAR(45) NOT NULL,
	apellido2 VARCHAR(45)
);

--tabla mesa
CREATE TABLE Mesa(
	id_mesa INT PRIMARY KEY,
	num_comensales INT DEFAULT 0,
	ubicacion VARCHAR(45) NOT NULL
);

--tabla factura
CREATE TABLE Factura(
	id_factura INT PRIMARY KEY,
	fecha_factura DATE DEFAULT NOW(),
	id_cliente INT,
	id_mesero INT,
	id_mesa INT,
	FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY(id_mesero) REFERENCES Mesero(id_mesero)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY(id_mesa) REFERENCES Mesa(id_mesa)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);

--tabla platillo
CREATE TABLE Platillo(
	id_platillo INT PRIMARY KEY,
	nombre VARCHAR(45) NOT NULL,
	importe INT DEFAULT NULL
);

--tabla bebida
CREATE TABLE Bebida(
	id_bebida INT PRIMARY KEY,
	nombre VARCHAR(45) NOT NULL,
	importe INT DEFAULT NULL
);

-- tabla orden que relaciona una factura con los productos que incluye
CREATE TABLE Orden(
	id_orden SERIAL PRIMARY KEY,
	id_factura INT,
	id_platillo INT,
	id_bebida INT,
	FOREIGN KEY(id_factura) REFERENCES Factura(id_factura)
		ON DELETE SET NULL 
		ON UPDATE CASCADE,
	FOREIGN KEY(id_platillo) REFERENCES Platillo(id_platillo)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY(id_bebida) REFERENCES Bebida(id_bebida)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);

-- Inserción de datos
INSERT INTO Cliente VALUES
(1, 'Ana', 'López', 'Cliente frecuente'),
(2, 'Carlos', 'Martínez', 'Prefiere mesa cerca de la ventana'),
(3, 'María', 'Gómez', 'Sin observaciones'),
(4, 'Juan', 'Pérez', 'Vegetariano'),
(5, 'Lucía', 'Ramírez', 'Alérgica a mariscos'),
(6, 'Pedro', 'Sánchez', 'Sin observaciones'),
(7, 'Laura', 'Torres', 'Sin observaciones'),
(8, 'Manuel', 'Pedroza', 'Solicita cuenta separada'),
(9, 'Sofía', 'Castro', 'Visita cada viernes'),
(10, 'Hugo', 'Fernández', 'Amigo del gerente');

INSERT INTO Mesero VALUES
(1, 'Luis', 'García', 'Rodríguez'),
(2, 'Isabel', 'Luna', 'N/A'),
(3, 'Mario', 'Jiménez', 'Lopez'),
(4, 'Andrea', 'Vega', 'Hernández'),
(5, 'Tomás', 'Ramos', NULL),
(6, 'Eva', 'Delgado', 'Pérez'),
(7, 'David', 'Morales', 'Cruz'),
(8, 'Sandra', 'Ruiz', NULL),
(9, 'Felipe', 'Navarro', 'González'),
(10, 'Carla', 'Aguilar', 'Romero');

INSERT INTO Mesa VALUES
(1, 4, 'Terraza'),
(2, 2, 'Interior'),
(3, 6, 'Ventana'),
(4, 4, 'Patio'),
(5, 2, 'Segundo piso'),
(6, 8, 'VIP'),
(7, 3, 'Terraza'),
(8, 5, 'Ventana'),
(9, 2, 'Segundo piso'),
(10, 4, 'Ventana');

INSERT INTO Factura VALUES
(1, '2025-05-10', 1, 2, 1),
(2, '2025-05-11', 2, 2, 2),
(3, '2025-05-10', 3, 3, 3), 
(4, '2025-05-14', 4, 1, 4),
(5, '2025-05-13', 5, 5, 3),
(6, '2025-05-10', 6, 4, 6),
(7, '2025-05-12', 7, 3, 7),
(8, '2025-05-12', 8, 8, 8),
(9, '2025-05-15', 9, 9, 1),
(10, '2025-05-11', 10, 10, 10),
(11, '2025-05-18', 5, 1, 9);

INSERT INTO Platillo VALUES
(1, 'Ensalada César', 800000),
(2, 'Tacos al pastor', 100000),
(3, 'Pizza margarita', 120000),
(4, 'Spaghetti bolognesa', 110000),
(5, 'Hamburguesa clásica', 900000),
(6, 'Pollo a la plancha', 950000),
(7, 'Pescado empanizado', 130000),
(8, 'Sopa de verduras', 600000),
(9, 'Lasaña de carne', 115000),
(10, 'Arroz a la marinera', 700000);

INSERT INTO Bebida VALUES
(1, 'Agua natural', 200000),
(2, 'Refresco', 300000),
(3, 'Jugo de naranja', 350000),
(4, 'Café', 250000),
(5, 'Té helado', 300000),
(6, 'Cerveza', 400000),
(7, 'Vino tinto', 900000),
(8, 'Limonada', 300000),
(9, 'Chocolate caliente', 350000),
(10, 'Mojito', 800000);

INSERT INTO Orden (id_factura, id_platillo, id_bebida) VALUES
(1, 1, 1),
(1, 2, NULL),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, NULL, 6),
(7, 7, 7),
(8, 8, NULL),
(9, 2, 9),
(1, 1, 1),
(6, 10, 1);

-- Nombre y apellido de clientes que consumieron el platillo “Tacos al pastor”:
SELECT DISTINCT c.nombre, c.apellido
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
JOIN Platillo p ON o.id_platillo = p.id_platillo
WHERE p.nombre = 'Tacos al pastor';

-- Nombre y apellido de clientes que consumieron “Arroz a la marinera”:
SELECT DISTINCT c.nombre, c.apellido
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
JOIN Platillo p ON o.id_platillo = p.id_platillo
WHERE p.nombre = 'Arroz a la marinera';

-- Nombre del mesero y la fecha en la que atendió una mesa 9 que se encuentra ubicada en el segundo piso del restaurante:
SELECT m.nombre, m.apellido1, m.apellido2, f.fecha_factura
FROM Factura f
JOIN Mesero m ON f.id_mesero = m.id_mesero
JOIN Mesa me ON f.id_mesa = me.id_mesa
WHERE me.id_mesa = 9 AND me.ubicacion = 'Segundo piso';

-- Nombre de los clientes junto con los nombres de las bebidas que consumieron en sus facturas:
SELECT DISTINCT c.nombre AS nombre_cliente, c.apellido, b.nombre AS bebida
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
JOIN Bebida b ON o.id_bebida = b.id_bebida;

-- Todas las facturas que incluyan platillos con un importe mayor a $300000, incluyendo el nombre del cliente y del platillo:
SELECT f.id_factura, c.nombre, c.apellido, p.nombre AS platillo, p.importe
FROM Factura f
JOIN Cliente c ON f.id_cliente = c.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
JOIN Platillo p ON o.id_platillo = p.id_platillo
WHERE p.importe > 300000;

-- Consumo total (importe de platillos y bebidas) del cliente llamado Manuel Pedroza:
SELECT 
  c.nombre, c.apellido,
  SUM(COALESCE(p.importe, 0) + COALESCE(b.importe, 0)) AS total_consumo
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
LEFT JOIN Platillo p ON o.id_platillo = p.id_platillo
LEFT JOIN Bebida b ON o.id_bebida = b.id_bebida
WHERE c.nombre = 'Manuel' AND c.apellido = 'Pedroza'
GROUP BY c.nombre, c.apellido;

-- Mesas que han sido utilizadas al menos una vez, indicando su ubicación y el número de comensales:
SELECT DISTINCT me.id_mesa, me.ubicacion, me.num_comensales
FROM Mesa me
JOIN Factura f ON me.id_mesa = f.id_mesa;

-- Vistas

-- Vista del consumo de cada cliente (nombre, bebida, platillo, fecha y montos)
CREATE VIEW vista_consumo_cliente AS
SELECT 
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    b.nombre AS bebida,
    p.nombre AS platillo,
    f.fecha_factura,
    b.importe AS importe_bebida,
    p.importe AS importe_platillo
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
LEFT JOIN Bebida b ON o.id_bebida = b.id_bebida
LEFT JOIN Platillo p ON o.id_platillo = p.id_platillo;

-- Vista del mesero, el número de factura que atendió, la fecha y la mesa
CREATE VIEW vista_mesero_factura AS
SELECT 
    m.nombre AS nombre_mesero,
    m.apellido1 AS apellido1_mesero,
    m.apellido2 AS apellido2_mesero,
    f.id_factura,
    f.fecha_factura,
    me.id_mesa,
    me.ubicacion
FROM Mesero m
JOIN Factura f ON m.id_mesero = f.id_mesero
JOIN Mesa me ON f.id_mesa = me.id_mesa;

-- Vista del total de compra por cliente (sumatoria platillo + bebida)
CREATE VIEW vista_total_cliente AS
SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.apellido AS apellido_cliente,
    SUM(COALESCE(p.importe, 0) + COALESCE(b.importe, 0)) AS total_consumo
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
LEFT JOIN Platillo p ON o.id_platillo = p.id_platillo
LEFT JOIN Bebida b ON o.id_bebida = b.id_bebida
GROUP BY c.id_cliente, c.nombre, c.apellido;

-- Vista consulta 6
CREATE VIEW vista_consumo_manuel_pedroza AS
SELECT 
    c.nombre, c.apellido,
    SUM(COALESCE(p.importe, 0) + COALESCE(b.importe, 0)) AS total_consumo
FROM Cliente c
JOIN Factura f ON c.id_cliente = f.id_cliente
JOIN Orden o ON f.id_factura = o.id_factura
LEFT JOIN Platillo p ON o.id_platillo = p.id_platillo
LEFT JOIN Bebida b ON o.id_bebida = b.id_bebida
WHERE c.nombre = 'Manuel' AND c.apellido = 'Pedroza'
GROUP BY c.nombre, c.apellido;

-- Vista consulta 7
CREATE VIEW vista_mesas_utilizadas AS
SELECT 
    me.id_mesa,
    me.ubicacion,
    me.num_comensales
FROM Mesa me
WHERE me.id_mesa IN (
    SELECT DISTINCT f.id_mesa
    FROM Factura f
    WHERE f.id_mesa IS NOT NULL
);
