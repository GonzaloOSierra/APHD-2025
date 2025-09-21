<?php
$host = 'db';
$db   = 'hackaton_db';
$user = 'hack_user';
$pass = 'develop2025';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
    echo "✅ Conexión exitosa a la base de datos.";
} catch (PDOException $e) {
    echo "❌ Error de conexión: " . $e->getMessage();
}
