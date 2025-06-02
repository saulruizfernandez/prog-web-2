<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Configuración de conexión
$host = "127.0.0.1";
$user = "root";
$pass = ""; // cambia si tienes contraseña
$dbname = "my_arsahosting";

// Crear conexión (CORREGIDO)
$conn = new mysqli($host, $user, $pass, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Error de conexión: " . $conn->connect_error]);
    exit();
}

// Consulta
$sql = "SELECT * FROM Utente";
$result = $conn->query($sql);

$datos = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $datos[] = $row;
    }
    echo json_encode($datos);
} else {
    echo json_encode([]);
}

$conn->close();
?>