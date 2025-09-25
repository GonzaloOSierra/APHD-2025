<?php
session_start();
if (empty($_SESSION["id"])) {
    header("Location: login.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>APHD-2025</title>
    <link rel="stylesheet" href="../assets/style.css">
</head>
<body>
    <header>
        <h1>Bienvenido, <?= htmlspecialchars($_SESSION["nombre"]) ?> 👋</h1>
    </header>
    <main>
        <p>Sistema para la toma de asistencia digitalizada</p><br>
        <a href="../controllers/controller_logout.php"><button>Salir</button></a>
    </main>
</body>
</html>
