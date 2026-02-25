-- ============================================================
-- LOGS_ERRORES - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerLogs$$
CREATE PROCEDURE sp_ObtenerLogs()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron logs registrados' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerLogs', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT Log_ID, Nombre_Rutina,
        CASE WHEN Nombre_Rutina LIKE ''sp_%'' THEN ''Procedimiento''
             WHEN Nombre_Rutina LIKE ''fn_%'' THEN ''Funcion''
             ELSE ''Desconocido'' END AS Tipo_Rutina,
        Nombre_Tabla, Codigo_Error, Mensaje_Error, Fecha_Hora
    FROM LOGS_ERRORES ORDER BY Fecha_Hora DESC';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerLogsPorTabla$$
CREATE PROCEDURE sp_ObtenerLogsPorTabla(IN p_Nombre_Tabla VARCHAR(100))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontraron logs para la tabla: ', p_Nombre_Tabla) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerLogsPorTabla', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT Log_ID, Nombre_Rutina,
        CASE WHEN Nombre_Rutina LIKE ''sp_%'' THEN ''Procedimiento''
             WHEN Nombre_Rutina LIKE ''fn_%'' THEN ''Funcion''
             ELSE ''Desconocido'' END AS Tipo_Rutina,
        Nombre_Tabla, Codigo_Error, Mensaje_Error, Fecha_Hora
    FROM LOGS_ERRORES WHERE Nombre_Tabla = ? ORDER BY Fecha_Hora DESC';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_Nombre_Tabla;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerLogsPorFecha$$
CREATE PROCEDURE sp_ObtenerLogsPorFecha(IN p_Fecha_Inicio DATETIME, IN p_Fecha_Fin DATETIME)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron logs en el rango de fechas indicado' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerLogsPorFecha', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT Log_ID, Nombre_Rutina,
        CASE WHEN Nombre_Rutina LIKE ''sp_%'' THEN ''Procedimiento''
             WHEN Nombre_Rutina LIKE ''fn_%'' THEN ''Funcion''
             ELSE ''Desconocido'' END AS Tipo_Rutina,
        Nombre_Tabla, Codigo_Error, Mensaje_Error, Fecha_Hora
    FROM LOGS_ERRORES WHERE Fecha_Hora BETWEEN ? AND ? ORDER BY Fecha_Hora DESC';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_Fecha_Inicio; SET @p2 = p_Fecha_Fin;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarLogs$$
CREATE PROCEDURE sp_EliminarLogs()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarLogs', 'LOGS_ERRORES', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarLogs', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM LOGS_ERRORES';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Todos los logs eliminados correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarLogPorID$$
CREATE PROCEDURE sp_EliminarLogPorID(IN p_Log_ID INT)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarLogPorID', 'LOGS_ERRORES', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarLogPorID', 'LOGS_ERRORES', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM LOGS_ERRORES WHERE Log_ID = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_Log_ID;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Log eliminado correctamente' AS Resultado;
END$$
DELIMITER ;
-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarUnidadAcademica('F-01', 'Medicina', 'Dr. Wilson');
CALL sp_InsertarPersonalMedico('M-99', 'Dr. Prueba', 'E-99', 'F-99');
CALL sp_ObtenerLogs();
CALL sp_ObtenerLogsPorTabla('UNIDAD_ACADEMICA');
CALL sp_ObtenerLogsPorFecha('2024-01-01 00:00:00', '2026-12-31 23:59:59');
CALL sp_EliminarLogPorID(1);
CALL sp_EliminarLogs();
CALL sp_ObtenerLogs();