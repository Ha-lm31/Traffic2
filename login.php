<?php
session_start();
require 'db.php'; // Ce fichier doit contenir ta connexion PDO à la base de données

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['Username'] ?? '';
    $password = $_POST['Password'] ?? '';

    // Prépare et exécute la requête pour récupérer l'utilisateur
    $stmt = $pdo->prepare('SELECT id_user, username, password FROM users WHERE username = ?');
    $stmt->execute([$username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    // Vérifie le mot de passe (adapter si hashé en production)
    if ($user && $user['password'] === $password) {
        $_SESSION['id_user'] = $user['id_user'];
        header('Location: home.php');
        exit();
    } else {
        $error = "user ou password is incorrect";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Log In</title>
</head>
<body>
    <div class="form">
        <?php if ($error): ?>
            <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
        <?php endif; ?>
        <form action="login.php" method="post">
            <input type="text" name="Username" id="user" placeholder="username" required><br>
            <input type="password" name="Password" id="pass" placeholder="Password" required><br>
            <a href="forget-password1.html">Forget password?</a><br>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
