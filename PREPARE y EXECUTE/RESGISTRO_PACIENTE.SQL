-- ============================================================
-- REGISTRO_PACIENTE - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarRegistroPaciente$$
CREATE PROCEDURE sp_InsertarRegistroPaciente(
    IN p_cod_paciente VARCHAR(6), IN p_primer_nombre VARCHAR(45),
    IN p_primer_apellido VARCHAR(45), IN p_num_contacto VARCHAR(15)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarRegistroPaciente', 'REGISTRO_PACIENTE', '23000', 'El código de paciente ya existe');
        SELECT 'ERROR: El código de paciente ya existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO REGISTRO_PACIENTE (cod_paciente, primer_nombre, primer_apellido, num_contacto) VALUES (?, ?, ?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_paciente; SET @p2 = p_primer_nombre; SET @p3 = p_primer_apellido; SET @p4 = p_num_contacto;
    EXECUTE stmt USING @p1, @p2, @p3, @p4;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Paciente insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerRegistroPacientes$$
CREATE PROCEDURE sp_ObtenerRegistroPacientes()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron pacientes registrados' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerRegistroPacientes', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM REGISTRO_PACIENTE';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerRegistroPacientePorID$$
CREATE PROCEDURE sp_ObtenerRegistroPacientePorID(IN p_cod_paciente VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró paciente con código: ', p_cod_paciente) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerRegistroPacientePorID', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM REGISTRO_PACIENTE WHERE cod_paciente = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_paciente;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarRegistroPaciente$$
CREATE PROCEDURE sp_ActualizarRegistroPaciente(
    IN p_cod_paciente VARCHAR(6), IN p_primer_nombre VARCHAR(45),
    IN p_primer_apellido VARCHAR(45), IN p_num_contacto VARCHAR(15)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE REGISTRO_PACIENTE SET primer_nombre = ?, primer_apellido = ?, num_contacto = ? WHERE cod_paciente = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_primer_nombre; SET @p2 = p_primer_apellido; SET @p3 = p_num_contacto; SET @p4 = p_cod_paciente;
    EXECUTE stmt USING @p1, @p2, @p3, @p4;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Paciente actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarRegistroPaciente$$
CREATE PROCEDURE sp_EliminarRegistroPaciente(IN p_cod_paciente VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarRegistroPaciente', 'REGISTRO_PACIENTE', '23000', 'No se puede eliminar: el paciente tiene consultas asociadas');
        SELECT 'ERROR: No se puede eliminar, el paciente tiene consultas asociadas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM REGISTRO_PACIENTE WHERE cod_paciente = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_paciente;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Paciente eliminado correctamente' AS Resultado;
END$$
DELIMITER ;
-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarRegistroPaciente('P-501', 'Juan', 'Rivas', '600-111');
CALL sp_InsertarRegistroPaciente('P-502', 'Ana',  'Soto',  '600-222');
CALL sp_InsertarRegistroPaciente('P-503', 'Luis', 'Paz',   '600-333');
CALL sp_ObtenerRegistroPacientes();
CALL sp_ObtenerRegistroPacientePorID('P-501');
CALL sp_ActualizarRegistroPaciente('P-501', 'Juan Carlos', 'Rivas', '600-999');
CALL sp_ObtenerRegistroPacientePorID('P-501');
CALL sp_EliminarRegistroPaciente('P-501');
CALL sp_InsertarRegistroPaciente('P-502', 'Duplicado', 'X', '000');
SELECT * FROM LOGS_ERRORES;