-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: db:3306
-- Tiempo de generación: 24-09-2025 a las 17:03:01
-- Versión del servidor: 5.7.44
-- Versión de PHP: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `hackaton_db`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`hack_user`@`%` PROCEDURE `calcular_asistencia` (IN `p_id_asistencia` INT)   BEGIN
    DECLARE entrada TIME;
    DECLARE salida TIME;
    DECLARE inicio TIME;
    DECLARE fin TIME;

    SELECT hora_entrada, hora_salida, c.hora_inicio, c.hora_fin
    INTO entrada, salida, inicio, fin
    FROM asistencias a
    JOIN clases c ON a.id_clase = c.id_clase
    WHERE a.id_asistencia = p_id_asistencia;

    IF entrada IS NULL THEN
        UPDATE asistencias SET estado = 'ausente' WHERE id_asistencia = p_id_asistencia;
    ELSEIF entrada > ADDTIME(inicio, '00:15:00') THEN
        UPDATE asistencias SET estado = 'media falta' WHERE id_asistencia = p_id_asistencia;
    ELSEIF salida IS NOT NULL AND salida < SUBTIME(fin, '00:15:00') THEN
        UPDATE asistencias SET estado = 'media falta' WHERE id_asistencia = p_id_asistencia;
    ELSE
        UPDATE asistencias SET estado = 'presente' WHERE id_asistencia = p_id_asistencia;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencias`
--

CREATE TABLE `asistencias` (
  `id_asistencia` int(11) NOT NULL,
  `id_clase` int(11) NOT NULL,
  `id_alumno` int(11) NOT NULL,
  `hora_entrada` time DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `estado` enum('presente','media falta','ausente') DEFAULT 'ausente',
  `justificado` tinyint(4) DEFAULT '0',
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `años`
--

CREATE TABLE `años` (
  `id_anio` int(11) NOT NULL,
  `detalle` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `años`
--

INSERT INTO `años` (`id_anio`, `detalle`) VALUES
(1, 'primer año'),
(2, 'segundo año'),
(3, 'tercer año');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carreras`
--

CREATE TABLE `carreras` (
  `id_carrera` int(11) NOT NULL,
  `detalle` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `carreras`
--

INSERT INTO `carreras` (`id_carrera`, `detalle`) VALUES
(1, 'Tecnico superior de analisis de sistemas'),
(2, 'tecnico superior laboratorio de analisis clinico'),
(3, 'tecnico superior en administracion de empresas'),
(4, 'tecnico superior en gestion ambiental y salud');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clases`
--

CREATE TABLE `clases` (
  `id_clase` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `es_virtual` tinyint(4) DEFAULT '0',
  `es_feriado` tinyint(4) DEFAULT '0',
  `profesor_presente` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `clases`
--

INSERT INTO `clases` (`id_clase`, `id_materia`, `fecha`, `hora_inicio`, `hora_fin`, `es_virtual`, `es_feriado`, `profesor_presente`) VALUES
(1, 1, '2025-09-22', '18:10:00', '19:50:00', 0, 0, 1),
(2, 2, '2025-09-22', '17:00:00', '18:50:00', 0, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion_calendario`
--

CREATE TABLE `configuracion_calendario` (
  `id_config` int(11) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `tipo` enum('feriado','virtual') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `configuracion_calendario`
--

INSERT INTO `configuracion_calendario` (`id_config`, `descripcion`, `fecha_inicio`, `fecha_fin`, `tipo`) VALUES
(1, 'Semana virtual abril', '2025-04-21', '2025-04-25', 'virtual'),
(2, 'Semana virtual mayo', '2025-05-19', '2025-05-23', 'virtual'),
(3, 'Semana virtual junio', '2025-06-23', '2025-06-27', 'virtual'),
(4, 'Semana virtual septiembre', '2025-09-08', '2025-09-12', 'virtual'),
(5, 'Semana virtual octubre', '2025-10-06', '2025-10-10', 'virtual');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inscripciones_alumnos`
--

CREATE TABLE `inscripciones_alumnos` (
  `id_inscripcion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_legajo` int(11) NOT NULL,
  `id_materia` int(11) NOT NULL,
  `id_anio` int(11) NOT NULL,
  `id_carrera` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `inscripciones_alumnos`
--

INSERT INTO `inscripciones_alumnos` (`id_inscripcion`, `id_usuario`, `id_legajo`, `id_materia`, `id_anio`, `id_carrera`) VALUES
(1, 8, 1001, 2, 1, 1),
(2, 4433352, 1000, 2, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `legajos`
--

CREATE TABLE `legajos` (
  `id_legajo` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `legajos`
--

INSERT INTO `legajos` (`id_legajo`, `id_usuario`) VALUES
(1001, 8),
(1000, 4433352);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materias`
--

CREATE TABLE `materias` (
  `id_materia` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `profesor_id` int(11) NOT NULL,
  `clases_por_semana` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `materias`
--

INSERT INTO `materias` (`id_materia`, `nombre`, `profesor_id`, `clases_por_semana`) VALUES
(1, 'Matemática I', 3, 2),
(2, 'Historia', 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `id_legajo` int(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `rol` enum('alumno','profesor','preceptor','admin') NOT NULL,
  `huella_id` int(11) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `dni`, `id_legajo`, `email`, `password`, `rol`, `huella_id`, `activo`) VALUES
(1, 'Juan', 'Pérez', '40111222', 902, 'juanperez@mail.com', NULL, 'alumno', NULL, 1),
(2, 'Ana', 'Gómez', '40222333', 901, 'anagomez@mail.com', NULL, 'alumno', NULL, 1),
(3, 'Carlos', 'López', '30111444', 0, 'carloslopez@mail.com', NULL, 'profesor', NULL, 1),
(4, 'María', 'Fernández', '50111555', 0, 'mariafernandez@mail.com', NULL, 'preceptor', NULL, 1),
(5, 'Admin', 'Sistema', '11111111', 0, 'admin@mail.com', NULL, 'admin', NULL, 1),
(8, 'Mateo', 'Macino', '52525252', 905, 'mateo@example.com', 'mateo', 'alumno', NULL, 1),
(4433352, 'alfonso', 'perro', '99898989', 900, 'alfonso@example.com', 'alfonso', 'alumno', NULL, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asistencias`
--
ALTER TABLE `asistencias`
  ADD PRIMARY KEY (`id_asistencia`),
  ADD KEY `id_clase` (`id_clase`),
  ADD KEY `id_alumno` (`id_alumno`);

--
-- Indices de la tabla `años`
--
ALTER TABLE `años`
  ADD PRIMARY KEY (`id_anio`);

--
-- Indices de la tabla `carreras`
--
ALTER TABLE `carreras`
  ADD PRIMARY KEY (`id_carrera`);

--
-- Indices de la tabla `clases`
--
ALTER TABLE `clases`
  ADD PRIMARY KEY (`id_clase`),
  ADD KEY `id_materia` (`id_materia`);

--
-- Indices de la tabla `configuracion_calendario`
--
ALTER TABLE `configuracion_calendario`
  ADD PRIMARY KEY (`id_config`);

--
-- Indices de la tabla `inscripciones_alumnos`
--
ALTER TABLE `inscripciones_alumnos`
  ADD PRIMARY KEY (`id_inscripcion`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_materia` (`id_materia`,`id_anio`,`id_carrera`),
  ADD KEY `id_legajo` (`id_legajo`),
  ADD KEY `id_carrera` (`id_carrera`),
  ADD KEY `id_anio` (`id_anio`);

--
-- Indices de la tabla `legajos`
--
ALTER TABLE `legajos`
  ADD PRIMARY KEY (`id_legajo`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `materias`
--
ALTER TABLE `materias`
  ADD PRIMARY KEY (`id_materia`),
  ADD KEY `profesor_id` (`profesor_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `huella_id` (`huella_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asistencias`
--
ALTER TABLE `asistencias`
  MODIFY `id_asistencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=261;

--
-- AUTO_INCREMENT de la tabla `años`
--
ALTER TABLE `años`
  MODIFY `id_anio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id_carrera` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `clases`
--
ALTER TABLE `clases`
  MODIFY `id_clase` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `configuracion_calendario`
--
ALTER TABLE `configuracion_calendario`
  MODIFY `id_config` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `inscripciones_alumnos`
--
ALTER TABLE `inscripciones_alumnos`
  MODIFY `id_inscripcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `legajos`
--
ALTER TABLE `legajos`
  MODIFY `id_legajo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1002;

--
-- AUTO_INCREMENT de la tabla `materias`
--
ALTER TABLE `materias`
  MODIFY `id_materia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4433353;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asistencias`
--
ALTER TABLE `asistencias`
  ADD CONSTRAINT `asistencias_ibfk_1` FOREIGN KEY (`id_clase`) REFERENCES `clases` (`id_clase`),
  ADD CONSTRAINT `asistencias_ibfk_2` FOREIGN KEY (`id_alumno`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `clases`
--
ALTER TABLE `clases`
  ADD CONSTRAINT `clases_ibfk_1` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`);

--
-- Filtros para la tabla `inscripciones_alumnos`
--
ALTER TABLE `inscripciones_alumnos`
  ADD CONSTRAINT `inscripciones_alumnos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `inscripciones_alumnos_ibfk_2` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`) ON UPDATE CASCADE,
  ADD CONSTRAINT `inscripciones_alumnos_ibfk_3` FOREIGN KEY (`id_anio`) REFERENCES `años` (`id_anio`) ON UPDATE CASCADE,
  ADD CONSTRAINT `inscripciones_alumnos_ibfk_4` FOREIGN KEY (`id_materia`) REFERENCES `materias` (`id_materia`) ON UPDATE CASCADE,
  ADD CONSTRAINT `inscripciones_alumnos_ibfk_5` FOREIGN KEY (`id_legajo`) REFERENCES `legajos` (`id_legajo`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `materias`
--
ALTER TABLE `materias`
  ADD CONSTRAINT `materias_ibfk_1` FOREIGN KEY (`profesor_id`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
