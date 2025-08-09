<?php
\$conn = new mysqli("mysql-db-project3.cjc8e2a8elx5.us-east-2.rds.amazonaws.com:3306", "admin", "90166Dipen", "mydb1");
\$result = \$conn->query("SELECT * FROM employees");
\$rows = [];
while (\$row = \$result->fetch_assoc()) {
    \$rows[] = \$row;
}
header('Content-Type: application/json');
echo json_encode(\$rows);
\$conn->close();
?>