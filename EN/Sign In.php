<?php
session_start();

// Database connection
$host = 'localhost';
$db = 'traffic_app';
$user = 'root';          // Change according to your config
$pass = '';              // Change according to your config
$error = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['Username'] ?? '';
    $password = $_POST['Password'] ?? '';

    // Search for the user
    $stmt = $pdo->prepare("SELECT * FROM Users WHERE name_user = ?");
    $stmt->execute([$username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        // User does not exist
        $error = "Username does not exist.";
    } else {
        // User found, check password
        if (password_verify($password, $user['password'])) {
            // Successful login
            $_SESSION['id_user'] = $user['id_user'];
            header("Location: home.php");
            exit;
        } else {
            // Incorrect password
            $error = "Incorrect username or password.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign In</title>
</head>
<body>
    <div class="form">
        <?php if ($error): ?>
            <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
        <?php endif; ?>
        <form action="login.php" method="post">
            <input type="text" name="Username" id="user" placeholder="Username" required><br>
            <input type="password" name="Password" id="pass" placeholder="Password" required><br>
            <a href="forget-password1.html">Forgot password?</a><br>
            <button type="submit">Sign In</button>
        </form>
    </div>
</body>
</html>
