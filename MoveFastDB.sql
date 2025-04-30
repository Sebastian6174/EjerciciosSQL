-- CREACIÓN DE TABLAS
CREATE TABLE Sucursal(
	sucursal_ID SERIAL PRIMARY KEY,
	nombre VARCHAR(20) NOT NULL,
	ciudad VARCHAR(10) DEFAULT 'Bogotá',
	direccion VARCHAR(50) NOT NULL,
	tel VARCHAR(7) CHECK(LENGTH(tel) = 7)
);

CREATE TABLE Cliente(
	no_cedula INT PRIMARY KEY,
	nombre VARCHAR(20) NOT NULL,
	apellido VARCHAR(20) NOT NULL,
	edad INT NOT NULL CHECK (edad > 0)
);

CREATE TABLE Vehiculo(
	placa VARCHAR(6) PRIMARY KEY CHECK (LENGTH(placa) = 6),
	marca VARCHAR(20),
	modelo INT CHECK (1990 < modelo AND modelo <= 2025),
	color VARCHAR(10) NOT NULL,
	disponible BOOLEAN DEFAULT TRUE,
	sucursal_ID INT,
	FOREIGN KEY(sucursal_ID) REFERENCES Sucursal(sucursal_ID)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE Alquiler(
	ID_alquiler SERIAL PRIMARY KEY,
	no_cedula INT,
	placa VARCHAR(6),
	FOREIGN KEY(no_cedula) REFERENCES Cliente(no_cedula)
		ON DELETE SET NULL,
	FOREIGN KEY(placa) REFERENCES Vehiculo(placa)
		ON DELETE SET NULL
);

CREATE TABLE Pagos(
	ID_alquiler INT PRIMARY KEY,
	fecha TIMESTAMP DEFAULT NOW(),
	precio FLOAT NOT NULL,
	FOREIGN KEY(ID_alquiler) REFERENCES Alquiler(ID_alquiler)
		ON DELETE CASCADE
);

-- INSERCIÓN DE DATOS:
INSERT INTO Sucursal (nombre, ciudad, direccion, tel) VALUES
('Sucursal Norte', 'Bogotá', 'Calle 123 #45-67', '1234567'),
('Sucursal Sur', 'Medellín', 'Carrera 10 #20-30', '7654321'),
('Sucursal Centro', 'Cali', 'Av. Siempre Viva 742', '1112223'),
('Sucursal Oeste', 'Bogotá', 'Diagonal 15 #33-44', '3456789'),
('Sucursal Este', 'Cali', 'Calle 50 #20-10', '9876543'),
('Sucursal Chapinero', 'Bogotá', 'Cra 7 #72-41', '2468101'),
('Sucursal Soacha', 'Soacha', 'Cra 1 #1-1', '1357913'),
('Sucursal Usaquén', 'Bogotá', 'Calle 140 #10-20', '1928374'),
('Sucursal Suroriente', 'Neiva', 'Cra 8 #12-15', '5647382'),
('Sucursal Kennedy', 'Bogotá', 'Av. 1 de Mayo #80-90', '6789012');

INSERT INTO Cliente (no_cedula, nombre, apellido, edad) VALUES
(1010, 'Juan', 'Pérez', 30),
(2020, 'Ana', 'Gómez', 25),
(3030, 'Luis', 'Martínez', 40),
(4040, 'María', 'Rodríguez', 35),
(5050, 'Carlos', 'Ramírez', 28),
(6060, 'Laura', 'Fernández', 22),
(7070, 'Pedro', 'García', 31),
(8080, 'Lucía', 'Díaz', 29),
(9090, 'Andrés', 'Sánchez', 38),
(1111, 'Sofía', 'Moreno', 26);

INSERT INTO Vehiculo (placa, marca, modelo, color, disponible, sucursal_ID) VALUES
('ABC123', 'Toyota', 2015, 'Rojo', TRUE, 1),
('DEF456', 'Chevrolet', 2018, 'Azul', TRUE, 2),
('GHI789', 'Kia', 2020, 'Negro', TRUE, 3),
('JKL012', 'Mazda', 2019, 'Blanco', TRUE, 4),
('MNO345', 'Renault', 2021, 'Gris', TRUE, 5),
('PQR678', 'Hyundai', 2023, 'Verde', TRUE, 6),
('STU901', 'Nissan', 2022, 'Amarillo', TRUE, 7),
('VWX234', 'Ford', 2017, 'Negro', TRUE, 8),
('YZA567', 'Volkswagen', 2016, 'Rojo', TRUE, 9),
('BCD890', 'Jeep', 2024, 'Azul', TRUE, 10);

INSERT INTO Alquiler (no_cedula, placa) VALUES
(1010, 'ABC123'),
(2020, 'DEF456'),
(3030, 'GHI789'),
(4040, 'JKL012'),
(5050, 'MNO345'),
(6060, 'PQR678'),
(7070, 'STU901'),
(8080, 'VWX234'),
(9090, 'YZA567'),
(1111, 'BCD890');

INSERT INTO Pagos (ID_alquiler, fecha, precio) VALUES
(1, NOW(), 150.50),
(2, NOW(), 200.00),
(3, NOW(), 175.25),
(4, NOW(), 300.75),
(5, NOW(), 100.00),
(6, NOW(), 220.40),
(7, NOW(), 185.80),
(8, NOW(), 195.60),
(9, NOW(), 160.90),
(10, NOW(), 250.00);

-- DATOS INVALIDOS
-- Edad negativa: debe fallar
INSERT INTO Cliente (no_cedula, nombre, apellido, edad)
VALUES (1212, 'Roberto', 'Negativo', -5);

-- Teléfono con 8 dígitos: debe fallar
INSERT INTO Sucursal (nombre, ciudad, direccion, tel)
VALUES ('Sucursal Falla', 'Bogotá', 'Calle Falsa', '12345678');

-- Placa con solo 5 caracteres: debe fallar
INSERT INTO Vehiculo (placa, marca, modelo, color, sucursal_ID)
VALUES ('AB123', 'Toyota', 2020, 'Negro', 1);

	-- Modelo menor a 1991: debe fallar
INSERT INTO Vehiculo (placa, marca, modelo, color, sucursal_ID)
VALUES ('ZZZ999', 'Kia', 1989, 'Azul', 1);

-- PRUEBAS DE INTEGRIDAD
-- Borra el cliente con cédula 1010
DELETE FROM Cliente WHERE no_cedula = 1010;

-- Borra el vehículo con placa 'ABC123'
DELETE FROM Vehiculo WHERE placa = 'ABC123';

-- Verificamos que los campos en Alquiler quedaron en NULL
SELECT * FROM Alquiler WHERE ID_alquiler = 1;

-- Borra el alquiler con ID 2
DELETE FROM Alquiler WHERE ID_alquiler = 2;

-- Verificamos que se haya eliminado también el pago
SELECT * FROM Pagos WHERE ID_alquiler = 2;

-- Cambiamos el ID de la sucursal 3 (esto solo tiene sentido si usamos IDs manuales)
UPDATE Sucursal SET sucursal_ID = 33 WHERE sucursal_ID = 3;

-- Verificamos que el vehículo con placa 'GHI789' ahora tenga sucursal_ID = 33
SELECT * FROM Vehiculo WHERE placa = 'GHI789';

-- CONSULTAS
-- Obtener los vehículos disponibles en una ciudad específica:
SELECT v.placa, v.marca, v.modelo, v.color, s.nombre AS sucursal, s.ciudad
FROM Vehiculo v
JOIN Sucursal s ON v.sucursal_ID = s.sucursal_ID
WHERE v.disponible = TRUE AND s.ciudad = 'Bogotá';  -- Cambia 'Bogotá' por la ciudad deseada

-- Listar los alquileres activos con información del cliente y vehículo:
SELECT a.ID_alquiler, c.no_cedula, c.nombre, c.apellido, v.placa, v.marca, v.modelo
FROM Alquiler a
JOIN Cliente c ON a.no_cedula = c.no_cedula
JOIN Vehiculo v ON a.placa = v.placa
LEFT JOIN Pagos p ON a.ID_alquiler = p.ID_alquiler

-- INSERCION de datos para ejemplificar las dos siguientes consultas:
-- Alquileres adicionales para el vehículo 'ABC123' (ahora tendrá más de 5 alquileres)
INSERT INTO Alquiler (no_cedula, placa) VALUES (2020, 'ABC123');
INSERT INTO Alquiler (no_cedula, placa) VALUES (3030, 'ABC123');
INSERT INTO Alquiler (no_cedula, placa) VALUES (4040, 'ABC123');
INSERT INTO Alquiler (no_cedula, placa) VALUES (5050, 'ABC123');
INSERT INTO Alquiler (no_cedula, placa) VALUES (6060, 'ABC123');

-- También aumentamos los alquileres de 'DEF456' (más de 3)
INSERT INTO Alquiler (no_cedula, placa) VALUES (7070, 'DEF456');
INSERT INTO Alquiler (no_cedula, placa) VALUES (8080, 'DEF456');
INSERT INTO Alquiler (no_cedula, placa) VALUES (9090, 'DEF456');

-- Pagos asociados a los nuevos alquileres
INSERT INTO Pagos (ID_alquiler, precio) VALUES (29, 160.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (30, 170.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (31, 180.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (32, 190.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (33, 200.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (34, 155.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (35, 165.00);
INSERT INTO Pagos (ID_alquiler, precio) VALUES (36, 175.00);

-- Calcular los ingresos totales por sucursal considerando solo vehículos con más de 3 alquileres:
SELECT s.nombre AS sucursal, SUM(p.precio) AS total_ingresos
FROM Vehiculo v
JOIN Alquiler a ON v.placa = a.placa
JOIN Pagos p ON a.ID_alquiler = p.ID_alquiler
JOIN Sucursal s ON v.sucursal_ID = s.sucursal_ID
WHERE v.placa IN (
    SELECT placa
    FROM Alquiler
    GROUP BY placa
    HAVING COUNT(*) > 3
)
GROUP BY s.nombre;

-- Filtrar solo vehículos con más de 5 alquileres (usar subconsulta):
SELECT v.placa, v.marca, v.modelo, v.color
FROM Vehiculo v
WHERE v.placa IN (
    SELECT placa
    FROM Alquiler
    GROUP BY placa
    HAVING COUNT(*) > 5
);

-- Sumar los montos de todos los pagos asociados:
SELECT SUM(precio) AS total_pagos
FROM Pagos;