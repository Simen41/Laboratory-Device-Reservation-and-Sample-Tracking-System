<?php

require_once __DIR__ . '/../config/database.php';

$stmt = $pdo->query("SELECT * FROM roles");
$roles = $stmt->fetchAll();

echo "<pre>";
print_r($roles);
echo "</pre>";