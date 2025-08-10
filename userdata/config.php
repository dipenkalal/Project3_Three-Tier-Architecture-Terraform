<?php
function db_connect() {
    $servername = "${db_host}";
    $username = "${db_user}";
    $password = "${db_pass}";  // Replace with actual password
    $dbname = "${db_name}";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    return $conn;
}
?>