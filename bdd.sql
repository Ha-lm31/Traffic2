-- Création de la base
CREATE DATABASE IF NOT EXISTS traffic_app;
USE traffic_app;

-- =============================
-- Table : Roles
-- =============================
CREATE TABLE Roles (
    id_role INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL,
    permissions TEXT
);

-- Insertion des rôles
INSERT INTO Roles (role_name, permissions) VALUES
('Admin', 'ajouter/supprimer utilisateurs'),
('Manager', 'ajouter/supprimer intersections ou capteurs'),
('Analyst', 'consulter données de trafic');

-- =============================
-- Table : Users
-- =============================
CREATE TABLE Users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    name_user VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    role_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id_role)
);

-- Insertion des utilisateurs (⚠️ mots de passe ici sont en clair pour l'exemple, en pratique -> hash)
INSERT INTO Users (name_user, password, email, role_id) VALUES
('Master1', 'master1', 'master1@gmail.com', 1),
('Master2', 'master2', 'master2@gmail.com', 2);

-- =============================
-- Table : Intersections
-- =============================
CREATE TABLE Intersections (
    id_int INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(150) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion des intersections
INSERT INTO Intersections (address) VALUES
('Rue du port'),
('Rue centrale');

-- =============================
-- Table : Capteurs
-- =============================
CREATE TABLE Capteurs (
    id_cap INT AUTO_INCREMENT PRIMARY KEY,
    direction ENUM('up','down','left','right') NOT NULL,
    address_ip VARCHAR(50),
    etat ENUM('actif','inactif','panne','maintenance') DEFAULT 'actif',
    id_int INT,
    FOREIGN KEY (id_int) REFERENCES Intersections(id_int)
);

-- Insertion des capteurs
INSERT INTO Capteurs (direction, address_ip, etat, id_int) VALUES
('up', '192.168.0.10', 'actif', 1),
('left', '192.168.0.11', 'inactif', 1),
('down', '192.168.0.12', 'panne', 1),
('right', '192.168.0.13', 'maintenance', 1),
('up', '192.168.0.20', 'actif', 2),
('left', '192.168.0.21', 'actif', 2),
('down', '192.168.0.22', 'actif', 2),
('right', '192.168.0.23', 'actif', 2);

-- =============================
-- Table : Traffic_Data
-- =============================
CREATE TABLE Traffic_Data (
    id_traffic INT AUTO_INCREMENT PRIMARY KEY,
    id_cap INT,
    nbr_vehicules INT NOT NULL,
    date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cap) REFERENCES Capteurs(id_cap)
);

-- Insertion des données de trafic
INSERT INTO Traffic_Data (id_cap, nbr_vehicules, date_time) VALUES
(1, 12, '2025-08-28 08:00:00'),
(2, 5, '2025-08-28 08:00:00'),
(5, 20, '2025-08-28 08:05:00'),
(7, 18, '2025-08-28 08:10:00');

-- =============================
-- Table : Logs (historique actions)
-- =============================
CREATE TABLE Logs (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT,
    action VARCHAR(255),
    date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES Users(id_user)
);

-- Exemple de logs
INSERT INTO Logs (id_user, action) VALUES
(1, 'Ajout de l\'intersection Rue du port'),
(2, 'Ajout du capteur 192.168.0.20');

-- =============================
-- Table : Alerts (pannes ou anomalies)
-- =============================
CREATE TABLE Alerts (
    id_alert INT AUTO_INCREMENT PRIMARY KEY,
    id_cap INT,
    type_alert VARCHAR(100),
    description TEXT,
    date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cap) REFERENCES Capteurs(id_cap)
);

-- Exemple d'alerte
INSERT INTO Alerts (id_cap, type_alert, description) VALUES
(3, 'panne', 'Le capteur en direction down de Rue du port ne répond plus');
