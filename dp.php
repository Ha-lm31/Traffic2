<?php
// Paramètres de connexion à la base de données
$host = 'localhost';        // Adresse du serveur MySQL
$db   = 'traffic_app';      // Nom de la base de données
$user = 'root';             // Nom d'utilisateur MySQL (à adapter)
$pass = '';                 // Mot de passe MySQL (à adapter)
$charset = 'utf8mb4';       // Jeu de caractères

// DSN = Data Source Name, chaîne de connexion pour PDO
$dsn = "mysql:host=$host;dbname=$db;charset=$charset";

// Options pour la connexion PDO
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, // Afficher les erreurs sous forme d'exceptions
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC, // Renvoyer les résultats sous forme de tableau associatif
    PDO::ATTR_EMULATE_PREPARES => false, // Désactiver l'émulation des requêtes préparées pour plus de sécurité
];

try {
    // Création de la connexion PDO
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    // En cas d'erreur de connexion, afficher un message
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
?>
