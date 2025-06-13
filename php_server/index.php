<?php
$servername = "localhost";
$username = "arsapi";
$password = "";
$dbname = "my_arsapi";

// Connection with mySQL database
try {
  $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $table_names = [];
  $stmt = $conn->query("SHOW TABLES");
  // Store all the table names from the SQL database
  while ($tN = $stmt->fetch(PDO::FETCH_NUM)) {
    $table_names[] = $tN[0];
  }
  // Select every attribute and every instance from each table
  foreach ($table_names as $table_name) {
    $data_for_table = [];
    $stmt = $conn->query("SELECT * FROM `$table_name`");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $data_for_table[] = $row;
    }
    $database_json[$table_name] = $data_for_table;
  }
  // Encode in json in human-readable format (debuging)
  $json_output = json_encode($database_json, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
  header('Content-Type: application/json');
  echo $json_output; // HTTP response
} catch(PDOException $e) {
  echo "Error: " . $e->getMessage();
}
?>