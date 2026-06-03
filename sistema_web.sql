-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-06-2026 a las 17:19:14
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_web`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id` int(10) UNSIGNED NOT NULL,
  `clave` varchar(80) NOT NULL,
  `descripcion` varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`id`, `clave`, `descripcion`) VALUES
(1, 'dashboard.ver', 'Ver el dashboard principal'),
(2, 'registros.crear', 'Crear nuevos registros'),
(3, 'registros.ver_propios', 'Ver sus propios registros'),
(4, 'registros.ver_todos', 'Ver registros de todos los usuarios'),
(5, 'registros.editar', 'Editar cualquier registro'),
(6, 'registros.eliminar', 'Eliminar registros'),
(7, 'registros.cambiar_estado', 'Cambiar estado de registros'),
(8, 'usuarios.ver', 'Ver lista de usuarios'),
(9, 'usuarios.crear', 'Crear nuevos usuarios'),
(10, 'usuarios.editar', 'Editar usuarios'),
(11, 'usuarios.eliminar', 'Eliminar usuarios'),
(12, 'reportes.ver', 'Ver reportes y estadísticas'),
(13, 'reportes.exportar', 'Exportar reportes');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registros`
--

CREATE TABLE `registros` (
  `id` int(10) UNSIGNED NOT NULL,
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `nombre_completo` varchar(200) NOT NULL,
  `edad` tinyint(3) UNSIGNED NOT NULL,
  `sexo` enum('M','F','Otro') NOT NULL,
  `email` varchar(150) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `departamento` varchar(100) NOT NULL,
  `municipio` varchar(100) NOT NULL,
  `categoria` enum('Educacion','Salud','Vivienda','Empleo','Otro') NOT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` enum('Pendiente','En Proceso','Resuelto','Rechazado') NOT NULL DEFAULT 'Pendiente',
  `prioridad` enum('Baja','Media','Alta','Critica') NOT NULL DEFAULT 'Media',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `registros`
--

INSERT INTO `registros` (`id`, `usuario_id`, `nombre_completo`, `edad`, `sexo`, `email`, `telefono`, `departamento`, `municipio`, `categoria`, `descripcion`, `estado`, `prioridad`, `fecha_registro`, `actualizado_en`) VALUES
(1, 3, 'Juan Carlos López', 28, 'M', 'juan@example.com', '9901-2345', 'Francisco Morazán', 'Tegucigalpa', 'Educacion', 'Solicitud de beca universitaria', 'Pendiente', 'Alta', '2025-01-05 15:00:00', '2026-06-03 15:10:06'),
(2, 3, 'Ana Sofía Martínez', 35, 'F', 'ana@example.com', '9912-3456', 'Cortés', 'San Pedro Sula', 'Salud', 'Acceso a medicamentos esenciales', 'En Proceso', 'Media', '2025-01-08 16:30:00', '2026-06-03 15:10:06'),
(3, 3, 'Pedro Ramírez', 45, 'M', 'pedro@example.com', '9823-4567', 'Choluteca', 'Choluteca', 'Vivienda', 'Programa de vivienda social', 'Resuelto', 'Baja', '2025-01-10 20:00:00', '2026-06-03 15:10:06'),
(4, 2, 'Lucía Herrera', 22, 'F', 'lucia@example.com', '9734-5678', 'El Paraíso', 'Danlí', 'Empleo', 'Capacitación vocacional', 'Pendiente', 'Media', '2025-01-12 14:45:00', '2026-06-03 15:10:06'),
(5, 2, 'Roberto Flores', 50, 'M', 'rob@example.com', '9645-6789', 'Atlántida', 'La Ceiba', 'Salud', 'Brigada médica rural', 'Resuelto', 'Alta', '2025-01-15 17:00:00', '2026-06-03 15:10:06'),
(6, 3, 'Carmen Soto', 31, 'F', 'car@example.com', '9556-7890', 'Olancho', 'Juticalpa', 'Educacion', 'Dotación de útiles escolares', 'En Proceso', 'Media', '2025-02-01 15:30:00', '2026-06-03 15:10:06'),
(7, 3, 'Miguel Torres', 27, 'M', 'mig@example.com', '9467-8901', 'Copán', 'Santa Rosa', 'Otro', 'Infraestructura vial comunitaria', 'Rechazado', 'Baja', '2025-02-03 21:00:00', '2026-06-03 15:10:06'),
(8, 2, 'Diana Castro', 38, 'F', 'dia@example.com', '9378-9012', 'Comayagua', 'Comayagua', 'Empleo', 'Feria de empleo departamental', 'Pendiente', 'Alta', '2025-02-10 16:00:00', '2026-06-03 15:10:06'),
(9, 3, 'Luis Vásquez', 42, 'M', 'luis@example.com', '9289-0123', 'Santa Bárbara', 'Santa Bárbara', 'Vivienda', 'Mejoramiento de vivienda rural', 'En Proceso', 'Media', '2025-02-15 19:30:00', '2026-06-03 15:10:06'),
(10, 3, 'Rosa Méndez', 29, 'F', 'rosa@example.com', '9190-1234', 'Yoro', 'Yoro', 'Salud', 'Centro de salud comunitario', 'Pendiente', 'Critica', '2025-03-01 14:00:00', '2026-06-03 15:10:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(200) NOT NULL DEFAULT '',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `creado_en`) VALUES
(1, 'admin', 'Acceso total al sistema, gestión de usuarios y configuración', '2026-06-03 15:10:05'),
(2, 'supervisor', 'Puede ver todos los registros, aprobar/rechazar y ver reportes', '2026-06-03 15:10:05'),
(3, 'usuario', 'Solo puede crear y ver sus propios registros', '2026-06-03 15:10:05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permisos`
--

CREATE TABLE `roles_permisos` (
  `rol_id` int(10) UNSIGNED NOT NULL,
  `permiso_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles_permisos`
--

INSERT INTO `roles_permisos` (`rol_id`, `permiso_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 7),
(2, 8),
(2, 12),
(2, 13),
(3, 1),
(3, 2),
(3, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_log`
--

CREATE TABLE `sesiones_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `usuario_id` int(10) UNSIGNED NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` varchar(300) NOT NULL DEFAULT '',
  `accion` enum('login','logout','login_fallido') NOT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(10) UNSIGNED NOT NULL,
  `rol_id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `username` varchar(60) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `ultimo_acceso` datetime DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `actualizado_en` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `rol_id`, `nombre`, `apellido`, `email`, `username`, `password_hash`, `activo`, `ultimo_acceso`, `creado_en`, `actualizado_en`) VALUES
(1, 1, 'Andy', 'Sistema', 'andy@sistema.local', 'Andy', '$2a$12$TkJ7XWjWvQ.2tVpKjzn/gOsC7UZwxsfFNQVKObELmK0P.A7OwFzc2', 1, NULL, '2026-06-03 15:10:06', '2026-06-03 15:10:06'),
(2, 2, 'Carlos', 'Supervisión', 'supervisor@sistema.local', 'supervisor', '$2y$12$7Q.sgkMDAhyv9jmEg5mM.uwYxdt4FoCAuqL9a8Z2TkXJsH9eFIiGu', 1, NULL, '2026-06-03 15:10:06', '2026-06-03 15:10:06'),
(3, 3, 'María', 'Usuario', 'usuario@sistema.local', 'usuario', '$2y$12$bnFExJmkSRXMMnDI3M/ffORurkitij.7rt8BM6u/25Q6mX/GcSBPG', 1, NULL, '2026-06-03 15:10:06', '2026-06-03 15:10:06');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_resumen_registros`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_resumen_registros` (
`id` int(10) unsigned
,`nombre_completo` varchar(200)
,`categoria` enum('Educacion','Salud','Vivienda','Empleo','Otro')
,`estado` enum('Pendiente','En Proceso','Resuelto','Rechazado')
,`prioridad` enum('Baja','Media','Alta','Critica')
,`fecha_registro` timestamp
,`capturado_por` varchar(60)
,`nombre_usuario` varchar(100)
,`rol_usuario` varchar(50)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_resumen_registros`
--
DROP TABLE IF EXISTS `vista_resumen_registros`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_resumen_registros`  AS SELECT `r`.`id` AS `id`, `r`.`nombre_completo` AS `nombre_completo`, `r`.`categoria` AS `categoria`, `r`.`estado` AS `estado`, `r`.`prioridad` AS `prioridad`, `r`.`fecha_registro` AS `fecha_registro`, `u`.`username` AS `capturado_por`, `u`.`nombre` AS `nombre_usuario`, `ro`.`nombre` AS `rol_usuario` FROM ((`registros` `r` join `usuarios` `u` on(`r`.`usuario_id` = `u`.`id`)) join `roles` `ro` on(`u`.`rol_id` = `ro`.`id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clave` (`clave`);

--
-- Indices de la tabla `registros`
--
ALTER TABLE `registros`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_registros_estado` (`estado`),
  ADD KEY `idx_registros_categoria` (`categoria`),
  ADD KEY `idx_registros_fecha` (`fecha_registro`),
  ADD KEY `idx_registros_usuario` (`usuario_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD PRIMARY KEY (`rol_id`,`permiso_id`),
  ADD KEY `fk_rp_permiso` (`permiso_id`);

--
-- Indices de la tabla `sesiones_log`
--
ALTER TABLE `sesiones_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sesiones_usuario` (`usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_usuarios_rol` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `registros`
--
ALTER TABLE `registros`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `sesiones_log`
--
ALTER TABLE `sesiones_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `registros`
--
ALTER TABLE `registros`
  ADD CONSTRAINT `fk_registros_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD CONSTRAINT `fk_rp_permiso` FOREIGN KEY (`permiso_id`) REFERENCES `permisos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rp_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `sesiones_log`
--
ALTER TABLE `sesiones_log`
  ADD CONSTRAINT `fk_log_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_rol` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
