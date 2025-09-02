
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

