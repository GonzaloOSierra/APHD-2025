<?php
/**
 * Clase Database para manejar la conexión a MySQL usando PDO y variables de entorno
 */
class Database {
    private $host;
    private $dbname;
    private $username;
    private $password;
    private $charset = "utf8mb4";
    private $pdo;

    public function __construct() {
        
        $this->host = getenv("MYSQL_SERVER") ?: "db";
        $this->dbname = getenv("MYSQL_DATABASE") ?: "hackaton_db";
        $this->username = getenv("MYSQL_USER") ?: "hack_2025";
        $this->password = getenv("MYSQL_PASSWORD") ?: "develop2025";
    }

    public function getConnection() {
        if ($this->pdo === null) {
            try {
                $dsn = "mysql:host={$this->host};dbname={$this->dbname};charset={$this->charset}";
                $this->pdo = new PDO($dsn, $this->username, $this->password, [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
                ]);
            } catch (PDOException $e) {
                error_log("[" . date("Y-m-d H:i:s") . "] DB Error: " . $e->getMessage());
            throw new RuntimeException("Error de conexión a la base de datos. Ver logs para más detalle.");
            }
        }
        return $this->pdo;
    }
}
