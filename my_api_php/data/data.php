<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$host = "127.0.0.1";
$user = "root";
$pass = "";
$dbname = "my_arsahosting";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Error de conexión: " . $conn->connect_error]);
    exit();
}

$databaseDump = [];

// Obtener todas las tablas de la base de datos
$tablesResult = $conn->query("SHOW TABLES");
if ($tablesResult) {
    while ($row = $tablesResult->fetch_array()) {
        $tableName = $row[0];

        // Obtener todos los datos de cada tabla
        $tableData = [];
        $dataResult = $conn->query("SELECT * FROM `$tableName`");

        if ($dataResult) {
            while ($dataRow = $dataResult->fetch_assoc()) {
                $tableData[] = $dataRow;
            }
        }

        $databaseDump[$tableName] = $tableData;
    }

    echo json_encode($databaseDump);
} else {
    echo json_encode(["error" => "No se pudieron obtener las tablas"]);
}

$conn->close();
?>