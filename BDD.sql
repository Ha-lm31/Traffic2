-- Création de la base de données et de l'utilisateur (PostgreSQL)
CREATE DATABASE traffic_app;

-- Créer l'utilisateur avec mot de passe (adapter selon SGBD si besoin)
CREATE USER traffic_user WITH ENCRYPTED PASSWORD '1234';
GRANT ALL PRIVILEGES ON DATABASE traffic_app TO traffic_user;

-- Se connecter à la base traffic_app
\c traffic_app

-- Table Roles
CREATE TABLE Roles (
    id_role      SERIAL PRIMARY KEY,
    role_name    VARCHAR(50) NOT NULL,
    permissions  TEXT
);

-- Table Users
CREATE TABLE Users (
    id_user     SERIAL PRIMARY KEY,
    name_user   VARCHAR(100) NOT NULL,
    password    VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    role_id     INTEGER REFERENCES Roles(id_role),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Intersections
CREATE TABLE Intersections (
    id_int      SERIAL PRIMARY KEY,
    address     VARCHAR(200) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Capteurs
CREATE TABLE Capteurs (
    id_cap      SERIAL PRIMARY KEY,
    direction   VARCHAR(10) NOT NULL,
    ip_address  VARCHAR(50),
    status      VARCHAR(20) NOT NULL,
    id_int      INTEGER REFERENCES Intersections(id_int)
);

-- Table traffic_data
CREATE TABLE traffic_data (
    id_traffic      SERIAL PRIMARY KEY,
    id_cap          INTEGER REFERENCES Capteurs(id_cap),
    vehicle_count   INTEGER NOT NULL,
    date_time       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Logs
CREATE TABLE Logs (
    id_log      SERIAL PRIMARY KEY,
    id_user     INTEGER REFERENCES Users(id_user),
    action      TEXT,
    date_time   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Alerts
CREATE TABLE Alerts (
    id_alert        SERIAL PRIMARY KEY,
    id_cap          INTEGER REFERENCES Capteurs(id_cap),
    type_alert      VARCHAR(50),
    description     TEXT,
    date_time       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion des exemples de données

-- Table Roles
INSERT INTO Roles (id_role, role_name, permissions) VALUES
(1, 'Admin',    '- Ajouter un utilisateur.\n- Supprimer un utilisateur.'),
(2, 'Manager',  '- Ajouter un capteur.\n- Supprimer un capteur.\n- Modifier un capteur.'),
(3, 'Analyst',  '- Analyser les données du traffic.');

-- Table Users
INSERT INTO Users (id_user, name_user, password, email, role_id, created_at) VALUES
(0, 'Master1', 'admin', 'admin-master1@gmail.com', 1, NOW()),
(1, 'Master2', 'manager', 'manager-master2@gmail.com', 2, NOW()),
(2, 'Master3', 'analyst', 'analysr-master3@gmail.com', 3, NOW());

-- Table Intersections
INSERT INTO Intersections (id_int, address, created_at) VALUES
(0, 'rue du port', NOW()),
(1, 'rue centrale', NOW());

-- Table Capteurs
INSERT INTO Capteurs (id_cap, direction, ip_address, status, id_int) VALUES
(0, 'up', '', 'actif', 0),
(1, 'left', '', 'inactif', 0),
(2, 'down', '', 'panne', 0),
(3, 'right', '', 'maintenance', 0),
(4, 'up', '', 'actif', 1),
(5, 'left', '', 'actif', 1),
(6, 'down', '', 'actif', 1),
(7, 'right', '', 'actif', 1);

-- Table Alerts (exemple)
INSERT INTO Alerts (id_alert, id_cap, type_alert, description, date_time) VALUES
(1, 3, 'panne', 'Le capteur en direction down de Rue du port ne répond plus', NOW());

-- Table traffic_data (exemples)
INSERT INTO traffic_data (id_cap, vehicle_count, date_time) VALUES
(0, 12, NOW()),
(1, 5, NOW()),
(4, 20, NOW());

-- Table Logs (exemples)
INSERT INTO Logs (id_user, action, date_time) VALUES
(0, 'Connexion Admin', NOW()),
(1, 'Ajout capteur', NOW()),
(2, 'Analyse traffic', NOW());
