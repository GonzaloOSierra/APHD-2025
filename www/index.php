<?php
require_once __DIR__ . "/models/bd_connection.php";

try {
    $db = new Database();
    $pdo = $db->getConnection();

    // Probar una consulta simple
    $stmt = $pdo->query("SELECT NOW() as fecha");
    $row = $stmt->fetch();

    echo "✅ Conexión exitosa a la base de datos.<br>";
    echo "Servidor respondió con fecha/hora: " . $row['fecha'];
} catch (Exception $e) {
    echo "❌ Error: " . $e->getMessage();
}
