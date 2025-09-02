<?php
session_start();

// Connexion à la base de données
$host = 'localhost';
$db = 'traffic_app';
$user = 'root';          // À adapter selon votre config
$pass = '';              // À adapter selon votre config
$error = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connexion échouée : " . $e->getMessage());
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['Username'] ?? '';
    $password = $_POST['Password'] ?? '';

    // Recherche de l'utilisateur
    $stmt = $pdo->prepare("SELECT * FROM Users WHERE name_user = ?");
    $stmt->execute([$username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        // Utilisateur inexistant
        $error = "Nom d’utilisateur inexistant.";
    } else {
        // Utilisateur trouvé, vérification du mot de passe
        if (password_verify($password, $user['password'])) {
            // Connexion réussie
            $_SESSION['id_user'] = $user['id_user'];
            header("Location: home.php");
            exit;
        } else {
            // Mot de passe incorrect
            $error = "Nom d’utilisateur ou mot de passe incorrect.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion</title>
</head>
<body>
    <div class="form">
        <?php if ($error): ?>
            <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
        <?php endif; ?>
        <form action="login.php" method="post">
            <input type="text" name="Username" id="user" placeholder="Nom d’utilisateur" required><br>
            <input type="password" name="Password" id="pass" placeholder="Mot de passe" required><br>
            <a href="forget-password1.html">Mot de passe oublié ?</a><br>
            <button type="submit">Se connecter</button>
        </form>
    </div>
</body>
</html>
