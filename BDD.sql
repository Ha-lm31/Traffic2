CREATE DATABASE IF NOT EXISTS traffic_app;
USE traffic_app;

CREATE TABLE IF NOT EXISTS Roles (
    id_role      INT AUTO_INCREMENT PRIMARY KEY,
    role_name    VARCHAR(50) NOT NULL,
    permissions  TEXT
);

CREATE TABLE IF NOT EXISTS Users (
    id_user     INT AUTO_INCREMENT PRIMARY KEY,
    name_user   VARCHAR(100) NOT NULL,
    password    VARCHAR(255) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    role_id     INT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id_role)
);

CREATE TABLE IF NOT EXISTS Intersections (
    id_int      INT AUTO_INCREMENT PRIMARY KEY,
    address     VARCHAR(200) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Capteurs (
    id_cap      INT AUTO_INCREMENT PRIMARY KEY,
    direction   VARCHAR(10) NOT NULL,
    ip_address  VARCHAR(50),
    status      VARCHAR(20) NOT NULL,
    id_int      INT,
    FOREIGN KEY (id_int) REFERENCES Intersections(id_int)
);

CREATE TABLE IF NOT EXISTS traffic_data (
    id_traffic      INT AUTO_INCREMENT PRIMARY KEY,
    id_cap          INT,
    vehicle_count   INT NOT NULL,
    date_time       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cap) REFERENCES Capteurs(id_cap)
);

CREATE TABLE IF NOT EXISTS Logs (
    id_log      INT AUTO_INCREMENT PRIMARY KEY,
    id_user     INT,
    action      TEXT,
    date_time   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES Users(id_user)
);

CREATE TABLE IF NOT EXISTS Alerts (
    id_alert        INT AUTO_INCREMENT PRIMARY KEY,
    id_cap          INT,
    type_alert      VARCHAR(50),
    description     TEXT,
    date_time       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cap) REFERENCES Capteurs(id_cap)
);

-- Insertion des exemples de données
INSERT INTO Roles (id_role, role_name, permissions) VALUES
    (1, 'Admin',    '- Ajouter un utilisateur.\n- Supprimer un utilisateur.'),
    (2, 'Manager',  '- Ajouter un capteur.\n- Supprimer un capteur.\n- Modifier un capteur.'),
    (3, 'Analyst',  '- Analyser les données du traffic.')
    ON DUPLICATE KEY UPDATE id_role=id_role;

INSERT INTO Users (id_user, name_user, password, email, role_id, created_at) VALUES
    (0, 'Master1', 'admin', 'admin-master1@gmail.com', 1, NOW()),
    (1, 'Master2', 'manager', 'manager-master2@gmail.com', 2, NOW()),
    (2, 'Master3', 'analyst', 'analysr-master3@gmail.com', 3, NOW())
    ON DUPLICATE KEY UPDATE id_user=id_user;

INSERT INTO Intersections (id_int, address, created_at) VALUES
    (0, 'rue du port', NOW()),
    (1, 'rue centrale', NOW())
    ON DUPLICATE KEY UPDATE id_int=id_int;

INSERT INTO Capteurs (id_cap, direction, ip_address, status, id_int) VALUES
    (0, 'up', '', 'actif', 0),
    (1, 'left', '', 'inactif', 0),
    (2, 'down', '', 'panne', 0),
    (3, 'right', '', 'maintenance', 0),
    (4, 'up', '', 'actif', 1),
    (5, 'left', '', 'actif', 1),
    (6, 'down', '', 'actif', 1),
    (7, 'right', '', 'actif', 1)
    ON DUPLICATE KEY UPDATE id_cap=id_cap;

INSERT INTO Alerts (id_alert, id_cap, type_alert, description, date_time) VALUES
    (1, 3, 'panne', 'Le capteur en direction down de Rue du port ne répond plus', NOW())
    ON DUPLICATE KEY UPDATE id_alert=id_alert;

INSERT INTO traffic_data (id_cap, vehicle_count, date_time) VALUES
    (0, 12, NOW()),
    (1, 5, NOW()),
    (4, 20, NOW());

INSERT INTO Logs (id_user, action, date_time) VALUES
    (0, 'Connexion Admin', NOW()),
    (1, 'Ajout capteur', NOW()),
    (2, 'Analyse traffic', NOW());
