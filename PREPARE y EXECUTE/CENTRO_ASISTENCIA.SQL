-- ============================================================
-- CENTRO_ASISTENCIAL - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarCentroAsistencial$$
CREATE PROCEDURE sp_InsertarCentroAsistencial(
    IN p_cod_centro       VARCHAR(6),
    IN p_nom_centro       VARCHAR(100),
    IN p_ubicacion_centro VARCHAR(150)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCentroAsistencial', 'CENTRO_ASISTENCIAL', '23000', 'El código de centro asistencial ya existe');
        SELECT 'ERROR: El código de centro asistencial ya existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO CENTRO_ASISTENCIAL (cod_centro, nom_centro, ubicacion_centro) VALUES (?, ?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_centro; SET @p2 = p_nom_centro; SET @p3 = p_ubicacion_centro;
    EXECUTE stmt USING @p1, @p2, @p3;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Centro asistencial insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCentrosAsistenciales$$
CREATE PROCEDURE sp_ObtenerCentrosAsistenciales()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron centros asistenciales registrados' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCentrosAsistenciales', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM CENTRO_ASISTENCIAL';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCentroAsistencialPorID$$
CREATE PROCEDURE sp_ObtenerCentroAsistencialPorID(IN p_cod_centro VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró centro asistencial con código: ', p_cod_centro) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCentroAsistencialPorID', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM CENTRO_ASISTENCIAL WHERE cod_centro = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_centro;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarCentroAsistencial$$
CREATE PROCEDURE sp_ActualizarCentroAsistencial(
    IN p_cod_centro VARCHAR(6), IN p_nom_centro VARCHAR(100), IN p_ubicacion_centro VARCHAR(150)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE CENTRO_ASISTENCIAL SET nom_centro = ?, ubicacion_centro = ? WHERE cod_centro = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_nom_centro; SET @p2 = p_ubicacion_centro; SET @p3 = p_cod_centro;
    EXECUTE stmt USING @p1, @p2, @p3;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Centro asistencial actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarCentroAsistencial$$
CREATE PROCEDURE sp_EliminarCentroAsistencial(IN p_cod_centro VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCentroAsistencial', 'CENTRO_ASISTENCIAL', '23000', 'No se puede eliminar: el centro tiene consultas asociadas');
        SELECT 'ERROR: No se puede eliminar, el centro tiene consultas asociadas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM CENTRO_ASISTENCIAL WHERE cod_centro = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_centro;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Centro asistencial eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarCentroAsistencial('H-01', 'Centro Médico', 'Calle 5 #10');
CALL sp_InsertarCentroAsistencial('H-02', 'Clínica Norte', 'Av. Libertador');
CALL sp_ObtenerCentrosAsistenciales();
CALL sp_ObtenerCentroAsistencialPorID('H-01');
CALL sp_ActualizarCentroAsistencial('H-01', 'Centro Médico', 'Calle 10 #20');
CALL sp_ObtenerCentrosAsistenciales();
CALL sp_EliminarCentroAsistencial('H-01');
CALL sp_InsertarCentroAsistencial('H-02', 'Duplicado', 'X');
SELECT * FROM LOGS_ERRORES;