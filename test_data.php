<?php
require_once __DIR__ . '/config/database.php';

$pdo = getDB();

// Verificar si hay registros
$result = $pdo->query('SELECT COUNT(*) as total FROM registros')->fetch();
echo "Total de registros: " . $result['total'] . "\n";

// Verificar si hay usuarios
$result2 = $pdo->query('SELECT COUNT(*) as total FROM usuarios')->fetch();
echo "Total de usuarios: " . $result2['total'] . "\n";

// Listar usuarios
$users = $pdo->query('SELECT id, username, nombre FROM usuarios')->fetchAll();
echo "\nUsuarios en BD:\n";
foreach($users as $u) {
  echo "  - " . $u['username'] . " (" . $u['nombre'] . ")\n";
}

// Listar registros
$registros = $pdo->query('SELECT COUNT(*) as total, categoria FROM registros GROUP BY categoria')->fetchAll();
echo "\nRegistros por categoría:\n";
if(empty($registros)) {
  echo "  (No hay registros)\n";
} else {
  foreach($registros as $r) {
    echo "  - " . $r['categoria'] . ": " . $r['total'] . "\n";
  }
}
?>
