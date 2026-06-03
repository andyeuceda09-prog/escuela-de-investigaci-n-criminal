<?php
/**
 * logout.php
 * Cierra la sesión del usuario y redirige al login.
 */
require_once __DIR__ . '/config/app.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/includes/session.php';
require_once __DIR__ . '/includes/functions.php';

if (estaAutenticado()) {
    registrarLog((int) $_SESSION['user_id'], 'logout');
    cerrarSesion();
}

redirigir(BASE_URL . '/index.php?msg=logout');