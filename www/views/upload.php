<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Subir archivo de huellas</title>
</head>
<body>
    <h2>Cargar archivo de asistencia (.dat)</h2>
    <form action="../controllers/controller_update.php" method="post" enctype="multipart/form-data">
        <input type="file" name="archivo" accept=".dat" required>
        <button type="submit">Subir y procesar</button>
    </form>
</body>
</html>
