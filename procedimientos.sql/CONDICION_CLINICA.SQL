-- ============================================================
-- CONDICION_CLINICA - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarCondicionClinica$$
CREATE PROCEDURE sp_InsertarCondicionClinica(
    IN p_cod_condicion VARCHAR(6), IN p_desc_condicion VARCHAR(255)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCondicionClinica', 'CONDICION_CLINICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCondicionClinica', 'CONDICION_CLINICA', '23000', 'El código de condición clínica ya existe');
        SELECT 'ERROR: El código de condición clínica ya existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCondicionClinica', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO CONDICION_CLINICA (cod_condicion, desc_condicion) VALUES (?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_condicion; SET @p2 = p_desc_condicion;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Condición clínica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCondicionesClinicas$$
CREATE PROCEDURE sp_ObtenerCondicionesClinicas()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron condiciones clínicas registradas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCondicionesClinicas', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM CONDICION_CLINICA';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCondicionClinicaPorID$$
CREATE PROCEDURE sp_ObtenerCondicionClinicaPorID(IN p_cod_condicion VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró condición clínica con código: ', p_cod_condicion) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCondicionClinicaPorID', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM CONDICION_CLINICA WHERE cod_condicion = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_condicion;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarCondicionClinica$$
CREATE PROCEDURE sp_ActualizarCondicionClinica(
    IN p_cod_condicion VARCHAR(6), IN p_desc_condicion VARCHAR(255)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarCondicionClinica', 'CONDICION_CLINICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarCondicionClinica', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE CONDICION_CLINICA SET desc_condicion = ? WHERE cod_condicion = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_desc_condicion; SET @p2 = p_cod_condicion;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Condición clínica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarCondicionClinica$$
CREATE PROCEDURE sp_EliminarCondicionClinica(IN p_cod_condicion VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCondicionClinica', 'CONDICION_CLINICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCondicionClinica', 'CONDICION_CLINICA', '23000', 'No se puede eliminar: la condición tiene consultas asociadas');
        SELECT 'ERROR: No se puede eliminar, la condición tiene consultas asociadas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCondicionClinica', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM CONDICION_CLINICA WHERE cod_condicion = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_condicion;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Condición clínica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarCondicionClinica('D-01', 'Gripe Fuerte');
CALL sp_InsertarCondicionClinica('D-02', 'Infección');
CALL sp_InsertarCondicionClinica('D-03', 'Arritmia');
CALL sp_InsertarCondicionClinica('D-04', 'Migraña');
CALL sp_ObtenerCondicionesClinicas();
CALL sp_ObtenerCondicionClinicaPorID('D-01');
CALL sp_ActualizarCondicionClinica('D-01', 'Gripe Severa');
CALL sp_ObtenerCondicionClinicaPorID('D-01');
CALL sp_EliminarCondicionClinica('D-01');
CALL sp_InsertarCondicionClinica('D-02', 'Duplicado');
SELECT * FROM LOGS_ERRORES;