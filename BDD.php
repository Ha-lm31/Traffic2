
<?php
/*
Avant d'exécuter ce code,
créé la base de données au phpMyadmin, par la commande suivantes : 
'CREATE DATABASE traffic_app;
CREATE USER traffic_user WITH ENCRYPTED PASSWORD '1234';
GRANT ALL PRIVILEGES ON DATABASE traffic_app TO traffic_user;'
apés exécuter ce code une seule fois avant d'utiliser l'application dans la premier fois.
*/

// Connexion à PostgreSQL
$host = "localhost";
$dbname = "traffic_app";
$user = "traffic_user";
$password = "1234";

try {
    $pdo = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
} catch (PDOException $e) {
    die("Connexion échouée : " . $e->getMessage());
}

// Création des tables
$queries = [

"CREATE TABLE IF NOT EXISTS Roles (
    id_role      SERIAL PRIMARY KEY,
    role_name    VARCHAR(50) NOT NULL,
    permissions  TEXT
);",

"CREATE TABLE IF NOT EXISTS Users (
    id_user     SERIAL PRIMARY KEY,
    name_user   VARCHAR(100) NOT NULL,
    password    VARCHAR(255) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    role_id     INTEGER REFERENCES Roles(id_role),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);",

"CREATE TABLE IF NOT EXISTS Intersections (
    id_int      SERIAL PRIMARY KEY,
    address     VARCHAR(200) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);",

"CREATE TABLE IF NOT EXISTS Capteurs (
    id_cap      SERIAL PRIMARY KEY,
    direction   VARCHAR(10) NOT NULL,
    ip_address  VARCHAR(50),
    status      VARCHAR(20) NOT NULL,
    id_int      INTEGER REFERENCES Intersections(id_int)
);",

"CREATE TABLE IF NOT EXISTS traffic_data (
    id_traffic      SERIAL PRIMARY KEY,
    id_cap          INTEGER REFERENCES Capteurs(id_cap),
    vehicle_count   INTEGER NOT NULL,
    date_time       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);",

"CREATE TABLE IF NOT EXISTS Logs (
    id_log      SERIAL PRIMARY KEY,
    id_user     INTEGER REFERENCES Users(id_user),
    action      TEXT,
    date_time   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);",

"CREATE TABLE IF NOT EXISTS Alerts (
    id_alert        SERIAL PRIMARY KEY,
    id_cap          INTEGER REFERENCES Capteurs(id_cap),
    type_alert      VARCHAR(50),
    description     TEXT,
    date_time       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);",

// Insertion des données exemples pour Roles
"INSERT INTO Roles (id_role, role_name, permissions) VALUES
    (1, 'Admin',    '- Ajouter un utilisateur.\n- Supprimer un utilisateur.'),
    (2, 'Manager',  '- Ajouter un capteur.\n- Supprimer un capteur.\n- Modifier un capteur.'),
    (3, 'Analyst',  '- Analyser les données du traffic.')
    ON CONFLICT DO NOTHING;",

// Insertion des données exemples pour Intersections
"INSERT INTO Intersections (id_int, address, created_at) VALUES
    (0, 'rue du port', NOW()),
    (1, 'rue centrale', NOW())
    ON CONFLICT DO NOTHING;",

// Insertion des données exemples pour Capteurs
"INSERT INTO Capteurs (id_cap, direction, ip_address, status, id_int) VALUES
    (0, 'up', '', 'actif', 0),
    (1, 'left', '', 'inactif', 0),
    (2, 'down', '', 'panne', 0),
    (3, 'right', '', 'maintenance', 0),
    (4, 'up', '', 'actif', 1),
    (5, 'left', '', 'actif', 1),
    (6, 'down', '', 'actif', 1),
    (7, 'right', '', 'actif', 1)
    ON CONFLICT DO NOTHING;",

// Insertion des données exemples pour Alerts
"INSERT INTO Alerts (id_alert, id_cap, type_alert, description, date_time) VALUES
    (1, 3, 'panne', 'Le capteur en direction down de Rue du port ne répond plus', NOW())
    ON CONFLICT DO NOTHING;",

// Insertion des données exemples pour traffic_data
"INSERT INTO traffic_data (id_cap, vehicle_count, date_time) VALUES
    (0, 12, NOW()),
    (1, 5, NOW()),
    (4, 20, NOW());",

// Insertion des données exemples pour Logs
"INSERT INTO Logs (id_user, action, date_time) VALUES
    (0, 'Connexion Admin', NOW()),
    (1, 'Ajout capteur', NOW()),
    (2, 'Analyse traffic', NOW());"

];

// Exécution des requêtes de structure et d’insertion (hors Users)
foreach ($queries as $sql) {
    try {
        $pdo->exec($sql);
    } catch (PDOException $e) {
        if (strpos($e->getMessage(), 'duplicate key') === false) {
            echo "Erreur lors de l'exécution de la requête : " . $e->getMessage() . "\n";
        }
    }
}

// Insertion des utilisateurs avec mot de passe hashé
$users = [
    [
        'id_user' => 0,
        'name_user' => 'Master1',
        'password' => password_hash('admin', PASSWORD_DEFAULT),
        'email' => 'admin-master1@gmail.com',
        'role_id' => 1
    ],
    [
        'id_user' => 1,
        'name_user' => 'Master2',
        'password' => password_hash('manager', PASSWORD_DEFAULT),
        'email' => 'manager-master2@gmail.com',
        'role_id' => 2
    ],
    [
        'id_user' => 2,
        'name_user' => 'Master3',
        'password' => password_hash('analyst', PASSWORD_DEFAULT),
        'email' => 'analysr-master3@gmail.com',
        'role_id' => 3
    ]
];

foreach ($users as $user) {
    $sql = "INSERT INTO Users (id_user, name_user, password, email, role_id, created_at) 
            VALUES (:id_user, :name_user, :password, :email, :role_id, NOW())
            ON CONFLICT DO NOTHING;";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':id_user'   => $user['id_user'],
        ':name_user' => $user['name_user'],
        ':password'  => $user['password'],
        ':email'     => $user['email'],
        ':role_id'   => $user['role_id']
    ]);
}

echo "Base de données et tables créées avec succès, exemples insérés (mots de passe hashés).\n";
?>
