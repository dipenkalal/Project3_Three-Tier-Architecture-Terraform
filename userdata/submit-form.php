<?php
\$conn = new mysqli("mysql-db-project3.cjc8e2a8elx5.us-east-2.rds.amazonaws.com:3306", "admin", "90166Dipen", "mydb1");
if (\$_SERVER["REQUEST_METHOD"] == "POST") {
    \$name = \$_POST["name"];
    \$sql = "INSERT INTO employees (name) VALUES ('\$name')";
    if (\$conn->query(\$sql) === TRUE) {
        echo "Employee added successfully";
    } else {
        echo "Error: " . \$conn->error;
    }
}
\$conn->close();
?>