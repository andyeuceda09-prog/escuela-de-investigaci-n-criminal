<?php
/**
 * index.php  (raíz del proyecto)
 * Página de login. Si el usuario ya está autenticado, redirige al dashboard.
 */
require_once __DIR__ . '/config/app.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/includes/session.php';
require_once __DIR__ . '/includes/functions.php';

// Si ya está autenticado, ir al dashboard según rol
if (estaAutenticado()) {
    if ($_SESSION['user_rol'] === ROL_USUARIO) {
        redirigir(BASE_URL . '/pages/registro_form.php');
    }
    redirigir(BASE_URL . '/dashboard/index.php');
}

$error   = '';
$success = '';

// Mensajes flash por querystring
$msg = $_GET['msg'] ?? '';
if ($msg === 'sesion_expirada') $error   = 'Tu sesión expiró. Por favor inicia sesión nuevamente.';
if ($msg === 'logout')          $success = 'Sesión cerrada correctamente.';

// ── Procesar formulario de login ──────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Verificar CSRF
    if (!verificarCSRF($_POST['csrf_token'] ?? null)) {
        $error = 'Token de seguridad inválido. Recarga la página.';
    } else {
        $username = trim($_POST['username'] ?? '');
        $password = $_POST['password']      ?? '';

        if ($username === '' || $password === '') {
            $error = 'Usuario y contraseña son obligatorios.';
        } else {
            $pdo  = getDB();
            $stmt = $pdo->prepare(
                'SELECT u.*, r.nombre AS rol_nombre
                   FROM usuarios u
                   JOIN roles r ON u.rol_id = r.id
                  WHERE u.username = ? AND u.activo = 1
                  LIMIT 1'
            );
            $stmt->execute([$username]);
            $user = $stmt->fetch();

            if ($user && password_verify($password, $user['password_hash'])) {
                // Login exitoso
                iniciarSesion($user);
                registrarLog($user['id'], 'login');

                // Actualizar último acceso
                $pdo->prepare('UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = ?')
                    ->execute([$user['id']]);

                if ($user['rol_nombre'] === ROL_USUARIO) {
                    redirigir(BASE_URL . '/pages/registro_form.php');
                }

                redirigir(BASE_URL . '/dashboard/index.php');
            } else {
                // Login fallido — intentar loguear si el usuario existe
                if ($user) registrarLog($user['id'], 'login_fallido');
                $error = 'Usuario o contraseña incorrectos.';
            }
        }
    }
}

$csrfToken = generarCSRF();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión — <?= APP_NAME ?></title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Space+Grotesk:wght@700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="<?= BASE_URL ?>/css/style.css">
</head>
<body class="login-page d-flex align-items-center justify-content-center min-vh-100">

<div id="loginOverlay" class="login-overlay d-none">
    <div class="login-overlay-content text-center px-4">
        <img src="<?= BASE_URL ?>/img/logo.png" alt="Escuela de Investigación Criminal" class="login-overlay-logo mb-4">
        <div class="progress mb-4" style="height: .8rem;">
            <div id="loginProgress" class="progress-bar progress-bar-striped progress-bar-animated bg-white"
                 role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 0%"></div>
        </div>
        <h2 class="text-white mb-2">Bienvenido a la Escuela de Investigación Criminal</h2>
        <p class="text-white-50 mb-4">Estamos preparando tu acceso. Por favor espera...</p>
        <div class="spinner-border text-white" role="status">
            <span class="visually-hidden">Cargando...</span>
        </div>
    </div>
</div>

<div class="login-wrapper">

    <!-- Logo / Título -->
    <div class="text-center mb-4">
        <div class="login-icon mb-3">
            <img src="<?= BASE_URL ?>/img/logo.png" alt="<?= esc(APP_NAME) ?>" class="login-logo">
        </div>
        <h1 class="login-title"><?= APP_NAME ?></h1>
        <p class="text-muted login-subtitle">Bienvenido al portal de la Escuela de Investigación Criminal</p>
    </div>

    <!-- Card de login -->
    <div class="card shadow-lg border-0 login-card">
        <div class="card-body p-4 p-md-5">

            <h5 class="card-title mb-4 fw-semibold">
                <i class="bi bi-lock-fill me-2 text-primary"></i>Iniciar Sesión
            </h5>

            <?php if ($error): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <?= esc($error) ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <?php endif; ?>

            <?php if ($success): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <?= esc($success) ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <?php endif; ?>

            <form method="POST" id="loginForm" novalidate>
                <input type="hidden" name="csrf_token" value="<?= esc($csrfToken) ?>">

                <!-- Usuario -->
                <div class="mb-3">
                    <label for="username" class="form-label fw-medium">Usuario</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                        <input type="text"
                               class="form-control"
                               id="username"
                               name="username"
                               placeholder="Ingresa tu usuario"
                               value="<?= esc($_POST['username'] ?? '') ?>"
                               required
                               autocomplete="username">
                        <div class="invalid-feedback">Campo obligatorio.</div>
                    </div>
                </div>

                <!-- Contraseña -->
                <div class="mb-4">
                    <label for="password" class="form-label fw-medium">Contraseña</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key-fill"></i></span>
                        <input type="password"
                               class="form-control"
                               id="password"
                               name="password"
                               placeholder="Ingresa tu contraseña"
                               required
                               autocomplete="current-password">
                        <button class="btn btn-outline-secondary" type="button" id="togglePass"
                                title="Mostrar / ocultar contraseña">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                        <div class="invalid-feedback">Campo obligatorio.</div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 btn-lg fw-semibold">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Entrar
                </button>
            </form>

            <!-- Información sobre roles -->
            <hr class="my-4">
            <div class="roles-info">
                <p class="text-muted small mb-3 fw-semibold">
                    <i class="bi bi-info-circle me-1"></i>Información sobre roles:
                </p>
                <ul class="nav nav-tabs nav-fill" role="tablist" style="border-bottom: 2px solid #e9ecef;">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="tab-usuario" data-bs-toggle="tab" 
                                data-bs-target="#content-usuario" type="button" role="tab">
                            <i class="bi bi-person me-1"></i>Usuario
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-supervisor" data-bs-toggle="tab" 
                                data-bs-target="#content-supervisor" type="button" role="tab">
                            <i class="bi bi-shield-check me-1"></i>Supervisor
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="tab-admin" data-bs-toggle="tab" 
                                data-bs-target="#content-admin" type="button" role="tab">
                            <i class="bi bi-key me-1"></i>Admin
                        </button>
                    </li>
                </ul>

                <div class="tab-content mt-3">
                    <!-- Tab Usuario -->
                    <div class="tab-pane fade show active" id="content-usuario" role="tabpanel">
                        <div class="small">
                            <h6 class="text-primary fw-semibold mb-2">
                                <i class="bi bi-person-fill me-1"></i>Usuario
                            </h6>
                            <p class="text-muted mb-2">Acceso para ciudadanos y gestores de base</p>
                            <ul class="text-muted ps-3 mb-0">
                                <li>Crear y gestionar sus propios registros</li>
                                <li>Ver historial de sus casos</li>
                                <li>Seguimiento de estado en tiempo real</li>
                                <li>Editar información de sus registros</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Tab Supervisor -->
                    <div class="tab-pane fade" id="content-supervisor" role="tabpanel">
                        <div class="small">
                            <h6 class="text-warning fw-semibold mb-2">
                                <i class="bi bi-shield-check me-1"></i>Supervisor
                            </h6>
                            <p class="text-muted mb-2">Acceso para coordinadores y revisores</p>
                            <ul class="text-muted ps-3 mb-0">
                                <li>Ver todos los registros del sistema</li>
                                <li>Aprobar o rechazar registros</li>
                                <li>Cambiar estado y prioridad de casos</li>
                                <li>Generar reportes de actividad</li>
                                <li>No puede eliminar usuarios</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Tab Admin -->
                    <div class="tab-pane fade" id="content-admin" role="tabpanel">
                        <div class="small">
                            <h6 class="text-danger fw-semibold mb-2">
                                <i class="bi bi-key me-1"></i>Administrador
                            </h6>
                            <p class="text-muted mb-2">Acceso total al sistema</p>
                            <ul class="text-muted ps-3 mb-0">
                                <li>Acceso completo a todas las funciones</li>
                                <li>Gestión de usuarios y roles</li>
                                <li>Creación de nuevos usuarios</li>
                                <li>Reseteo de contraseñas</li>
                                <li>Reportes avanzados y auditoría</li>
                                <li>Configuración del sistema</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <p class="text-center text-muted small mt-3">
        &copy; <?= date('Y') ?> <?= APP_NAME ?> &mdash; Acceso protegido
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
<script>
// Mostrar/ocultar contraseña
document.getElementById('togglePass').addEventListener('click', function () {
    const inp = document.getElementById('password');
    const ico = this.querySelector('i');
    if (inp.type === 'password') {
        inp.type = 'text';
        ico.className = 'bi bi-eye-slash-fill';
    } else {
        inp.type = 'password';
        ico.className = 'bi bi-eye-fill';
    }
});

// Validación Bootstrap
const loginOverlay = document.getElementById('loginOverlay');
const loginProgress = document.getElementById('loginProgress');

const loginFormElement = document.getElementById('loginForm');
loginFormElement.addEventListener('submit', function (e) {
    if (!this.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
        this.classList.add('was-validated');
        return;
    }

    e.preventDefault();
    e.stopPropagation();
    this.classList.add('was-validated');

    document.querySelector('.login-wrapper').classList.add('d-none');
    loginOverlay.classList.remove('d-none');
    loginOverlay.style.display = 'flex';
    loginOverlay.style.visibility = 'visible';
    loginOverlay.style.opacity = '1';
    loginOverlay.style.pointerEvents = 'auto';

    loginProgress.style.width = '0%';
    loginProgress.style.backgroundColor = '#ffffff';
    loginProgress.style.opacity = '1';

    setTimeout(() => {
        loginProgress.style.width = '100%';
    }, 50);

    setTimeout(() => {
        loginFormElement.submit();
    }, 3000);
});
</script>
</body>
</html>