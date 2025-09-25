<?php include "../controllers/controller_login.php"; ?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Formulario de Login</title>
  <link rel="stylesheet" href="../assets/style.css">
</head>
<body>
  <div class="login-container">
    <h2>Iniciar Sesión</h2>
    
    

    <form method="post" action="">
      <label for="usuario">Usuario</label>
      <input type="text" id="usuario" name="usuario" placeholder="Tu usuario" required>

      <label for="password">Contraseña</label>
      <input type="password" id="password" name="password" placeholder="Tu contraseña" required>

      <button type="submit" name="ingresar" value="1">Ingresar</button>
    </form>
    <p>¿No tenés cuenta? <a href="#">Registrate</a></p>
  </div>
</body>
</html>