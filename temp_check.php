<?php
require_once __DIR__ . '/config/database.php';
$pdo = getDB();
foreach(['supervisor','usuario'] as $u) {
    $stmt = $pdo->prepare('SELECT username,password_hash FROM usuarios WHERE username = ?');
    $stmt->execute([$u]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($row) {
        echo $u . ': FOUND' . PHP_EOL;
        echo $row['password_hash'] . PHP_EOL . PHP_EOL;
    } else {
        echo $u . ': MISSING' . PHP_EOL;
    }
}
