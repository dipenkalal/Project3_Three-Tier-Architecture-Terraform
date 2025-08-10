<?php
header('Content-Type: application/json');
require_once __DIR__ . '/config.php';

$conn = db_connect();

$sql = "SELECT id, name FROM employees ORDER BY id DESC";
$result = $conn->query($sql);

$rows = [];
if ($result) {
  while ($row = $result->fetch_assoc()) {
    $rows[] = $row;
  }
}

echo json_encode($rows);
$conn->close();
