
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerLogs$$
CREATE PROCEDURE sp_ObtenerLogs()
BEGIN
    SELECT
        Log_ID,
        Nombre_Rutina,
        CASE
            WHEN Nombre_Rutina LIKE 'sp_%' THEN 'Procedimiento'
            WHEN Nombre_Rutina LIKE 'fn_%' THEN 'Función'
            ELSE 'Desconocido'
        END AS Tipo_Rutina,
        Nombre_Tabla,
        Codigo_Error,
        Mensaje_Error,
        Fecha_Hora
    FROM LOGS_ERRORES
    ORDER BY Fecha_Hora DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerLogsPorTabla$$
CREATE PROCEDURE sp_ObtenerLogsPorTabla(
    IN p_Nombre_Tabla VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerLogsPorTabla', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT
        Log_ID,
        Nombre_Rutina,
        CASE
            WHEN Nombre_Rutina LIKE 'sp_%' THEN 'Procedimiento'
            WHEN Nombre_Rutina LIKE 'fn_%' THEN 'Función'
            ELSE 'Desconocido'
        END AS Tipo_Rutina,
        Nombre_Tabla,
        Codigo_Error,
        Mensaje_Error,
        Fecha_Hora
    FROM LOGS_ERRORES
    WHERE Nombre_Tabla = p_Nombre_Tabla
    ORDER BY Fecha_Hora DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerLogsPorFecha$$
CREATE PROCEDURE sp_ObtenerLogsPorFecha(
    IN p_Fecha_Inicio DATETIME,
    IN p_Fecha_Fin    DATETIME
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerLogsPorFecha', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT
        Log_ID,
        Nombre_Rutina,
        CASE
            WHEN Nombre_Rutina LIKE 'sp_%' THEN 'Procedimiento'
            WHEN Nombre_Rutina LIKE 'fn_%' THEN 'Función'
            ELSE 'Desconocido'
        END AS Tipo_Rutina,
        Nombre_Tabla,
        Codigo_Error,
        Mensaje_Error,
        Fecha_Hora
    FROM LOGS_ERRORES
    WHERE Fecha_Hora BETWEEN p_Fecha_Inicio AND p_Fecha_Fin
    ORDER BY Fecha_Hora DESC;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarLogs$$
CREATE PROCEDURE sp_EliminarLogs()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarLogs', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM LOGS_ERRORES;
    SELECT 'Todos los logs eliminados correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarLogPorID$$
CREATE PROCEDURE sp_EliminarLogPorID(
    IN p_Log_ID INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarLogPorID', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM LOGS_ERRORES WHERE Log_ID = p_Log_ID;
    SELECT 'Log eliminado correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR TODOS LOS SPs Y FUNCIONES CREADOS
-- ============================================================

SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
SHOW FUNCTION  STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS DE ELIMINACION
-- ============================================================

-- ELIMINAR UNA PRESCRIPCION ESPECIFICA
CALL sp_EliminarPrescripcionMedica('R-002');
CALL sp_ObtenerPrescripcionesPorConsulta('C-001');

-- ELIMINAR UNA CONSULTA COMPLETA (borra sus prescripciones automáticamente)
CALL sp_EliminarConsultaMedica('C-004');
CALL sp_ObtenerConsultasMedicas();

-- ELIMINAR UN PERSONAL MEDICO
CALL sp_EliminarPersonalMedico('M-30');
CALL sp_ObtenerPersonalMedico();

-- ELIMINAR UN PACIENTE
CALL sp_EliminarRegistroPaciente('P-503');
CALL sp_ObtenerRegistroPacientes();

-- ELIMINAR UN CENTRO ASISTENCIAL
CALL sp_EliminarCentroAsistencial('H-02');
CALL sp_ObtenerCentrosAsistenciales();

-- ELIMINAR UNA UNIDAD ACADEMICA
CALL sp_EliminarUnidadAcademica('F-02');
CALL sp_ObtenerUnidadesAcademicas();

-- ELIMINAR UN AREA MEDICA
CALL sp_EliminarAreaMedica('E-03');
CALL sp_ObtenerAreasMedicas();

-- ELIMINAR UNA CONDICION CLINICA
CALL sp_EliminarCondicionClinica('D-04');
CALL sp_ObtenerCondicionesClinicas();

-- ELIMINAR UN FARMACO
CALL sp_EliminarFarmaco('MED-05');
CALL sp_ObtenerFarmacos();


-- ============================================================
-- PRUEBA DE LOGS (errores registrados automáticamente)
-- ============================================================

-- Provocar error a propósito (ID duplicado)
CALL sp_InsertarUnidadAcademica('F-01', 'Medicina', 'Dr. Wilson');

-- Provocar otro error (FK inexistente)
CALL sp_InsertarPersonalMedico('M-99', 'Dr. Prueba', 'E-99', 'F-99');

-- VER TODOS LOS LOGS
CALL sp_ObtenerLogs();

-- VER LOGS POR TABLA ESPECIFICA
CALL sp_ObtenerLogsPorTabla('UNIDAD_ACADEMICA');

-- VER LOGS POR RANGO DE FECHA
CALL sp_ObtenerLogsPorFecha('2024-01-01 00:00:00', '2026-12-31 23:59:59');

-- ELIMINAR UN LOG ESPECIFICO
CALL sp_EliminarLogPorID(1);

-- ELIMINAR TODOS LOS LOGS
CALL sp_EliminarLogs();

-- VERIFICAR QUE SE LIMPIARON
CALL sp_ObtenerLogs();