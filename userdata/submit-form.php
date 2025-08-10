<?php
header('Content-Type: text/plain');
require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo "Method Not Allowed";
  exit;
}

$name = trim($_POST['name'] ?? '');
if ($name === '') {
  http_response_code(400);
  echo "Name is required";
  exit;
}

$conn = db_connect();

$stmt = $conn->prepare("INSERT INTO employees(name) VALUES (?)");
if (!$stmt) {
  http_response_code(500);
  echo "Prepare failed";
  $conn->close();
  exit;
}

$stmt->bind_param("s", $name);
$ok = $stmt->execute();

if ($ok) {
  echo "Employee added successfully";
} else {
  http_response_code(500);
  echo "Insert failed";
}

$stmt->close();
$conn->close();
