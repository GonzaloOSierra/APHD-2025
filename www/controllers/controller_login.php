<?php
session_start();
require_once __DIR__ . "/../models/bd_connection.php";

// Si se presionó el botón de ingresar
if (!empty($_POST["ingresar"])) {
    if (!empty($_POST["usuario"]) && !empty($_POST["password"])) {
        $usuario = trim($_POST["usuario"]);
        $password = trim($_POST["password"]);

        try {
            $db = new Database();
            $conn = $db->getConnection();

            // Consulta segura con parámetros
            $stmt = $conn->prepare("SELECT id_usuario, nombre, password_hash FROM usuarios WHERE email = :usuario LIMIT 1");
            $stmt->bindParam(":usuario", $usuario, PDO::PARAM_STR);
            $stmt->execute();
            $user = $stmt->fetch();

            

            if ($user && $password === $user["password_hash"]) {
                    $_SESSION["id"] = $user["id_usuario"];
                    $_SESSION["nombre"] = $user["nombre"];

                    header("Location: ../views/home.php");
                    exit;
        } else {
                echo "<div style='color:red;'>❌ Usuario o contraseña incorrectos</div>";
            }
        } catch (Exception $e) {
            echo "<div style='color:red;'>Error: " . $e->getMessage() . "</div>";
        }
    } else {
        echo "<div style='color:red;'>⚠️ Campos vacíos</div>";
    }
}
?>
