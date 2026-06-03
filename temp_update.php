<?php
require_once __DIR__ . '/config/database.php';
$pdo = getDB();
$pairs = [
    ['supervisor', 'supervisor01'],
    ['usuario', 'usuario01'],
];
foreach ($pairs as $pair) {
    $hash = password_hash($pair[1], PASSWORD_BCRYPT, ['cost' => 12]);
    $stmt = $pdo->prepare('UPDATE usuarios SET password_hash = ? WHERE username = ?');
    $stmt->execute([$hash, $pair[0]]);
    echo $pair[0] . ': rows=' . $stmt->rowCount() . ' hash=' . $hash . "\n";
}
?>
