<?php
require_once __DIR__ . '/bd_connection.php';

class Functions {
    private $db;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
    }

    // Obtener clase del usuario en la fecha dada
    function obtenerClase($db, $id_usuario, $fechaCompleta) {
        $fecha = date("Y-m-d", strtotime($fechaCompleta));
        $hora  = date("H:i:s", strtotime($fechaCompleta));

        $sql = "SELECT c.id_clase, c.id_materia, c.fecha, c.hora_inicio, c.hora_fin
                FROM clases c
                INNER JOIN inscripciones_alumnos i ON i.id_materia = c.id_materia
                WHERE i.id_usuario = :id_usuario
                  AND c.fecha = :fecha
                  AND :hora BETWEEN c.hora_inicio AND c.hora_fin
                LIMIT 1";
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':id_usuario' => $id_usuario,
            ':fecha' => $fecha,
            ':hora' => $hora
        ]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Guardar asistencia en la base de datos
    function guardarAsistencia($db, $id_usuario, $id_clase, $estado, $fechaHora) {
        $sql = "INSERT INTO asistencias (id_usuario, id_clase, fecha_hora, estado)
                VALUES (:id_usuario, :id_clase, :fecha_hora, :estado)";
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':id_usuario' => $id_usuario,
            ':id_clase' => $id_clase,
            ':fecha_hora' => $fechaHora,
            ':estado' => $estado
        ]);
    }

    // Procesar archivo .dat de asistencia
    function procesarArchivo($rutaArchivo) {
        $archivo = fopen($rutaArchivo, "r");
        if (!$archivo) {
            echo "No se pudo abrir el archivo.<br>";
            return;
        }

        while (($linea = fgets($archivo)) !== false) {
            $partes = preg_split('/\s+/', trim($linea));

            if (count($partes) < 2) {
                continue;
            }

            $idUsuario = $partes[0];
            $fechaHora = $partes[1];

            // Buscar clase correspondiente
            $clase = $this->obtenerClase($this->db, $idUsuario, $fechaHora);

            if ($clase) {
                $horaHuella = date("H:i:s", strtotime($fechaHora));
                $horaInicio = $clase['hora_inicio'];
                $horaFin    = $clase['hora_fin'];

                // Determinar asistencia
                if ($horaHuella <= $horaInicio) {
                    $estado = "Presente";
                } elseif ($horaHuella > $horaInicio && $horaHuella <= date("H:i:s", strtotime($horaInicio) + 900)) {
                    $estado = "Media falta";
                } elseif ($horaHuella < $horaFin) {
                    $estado = "Media falta";
                } else {
                    $estado = "Ausente";
                }

                echo "Alumno $idUsuario  $estado en la Clase {$clase['id_clase']} ($horaInicio - $horaFin) <br>";

                // Guardar en DB
                $this->guardarAsistencia($this->db, $idUsuario, $clase['id_clase'], $estado, $fechaHora);

            } else {
                echo "Alumno $idUsuario No se encontró clase para la fecha $fechaHora<br>";
            }
        }

        fclose($archivo);
    }
}
