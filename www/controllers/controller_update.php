<?php
require_once __DIR__ . "/../models/functions.php";


$func = new Functions();

if (isset($_FILES['archivo'])) {
    $ruta = $_FILES['archivo']['tmp_name'];
    try {
        $func->procesarArchivo($ruta);
        
        echo "Archivo procesado correctamente.";
    } catch (Exception $e) {
        echo "Error al procesar el archivo: " . $e->getMessage();
    }
}
