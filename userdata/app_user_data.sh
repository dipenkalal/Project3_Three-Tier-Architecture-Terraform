#!/bin/bash
yum update -y
yum install -y httpd php php-mysqlnd
sudo su
systemctl start httpd
systemctl enable httpd

# Optional: Add backend files (replace with your logic or S3 pull)
echo "<?php echo 'Web Tier Working'; ?>" > /var/www/html/index.php

# create submit-form.php
cat <<EOF > /var/www/html/submit-form.php
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
EOF

# create get-employees.php
cat <<EOF > /var/www/html/get-employees.php
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
EOF


systemctl restart httpd