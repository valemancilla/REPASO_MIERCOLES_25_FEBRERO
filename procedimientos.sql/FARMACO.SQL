-- ============================================================
-- FARMACO - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarFarmaco$$
CREATE PROCEDURE sp_InsertarFarmaco(IN p_cod_farmaco VARCHAR(6), IN p_nom_farmaco VARCHAR(45))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarFarmaco', 'FARMACO', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarFarmaco', 'FARMACO', '23000', 'El código de fármaco ya existe');
        SELECT 'ERROR: El código de fármaco ya existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarFarmaco', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO FARMACO (cod_farmaco, nom_farmaco) VALUES (?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_farmaco; SET @p2 = p_nom_farmaco;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Fármaco insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerFarmacos$$
CREATE PROCEDURE sp_ObtenerFarmacos()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron fármacos registrados' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerFarmacos', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM FARMACO';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerFarmacoPorID$$
CREATE PROCEDURE sp_ObtenerFarmacoPorID(IN p_cod_farmaco VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró fármaco con código: ', p_cod_farmaco) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerFarmacoPorID', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM FARMACO WHERE cod_farmaco = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_farmaco;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarFarmaco$$
CREATE PROCEDURE sp_ActualizarFarmaco(IN p_cod_farmaco VARCHAR(6), IN p_nom_farmaco VARCHAR(45))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarFarmaco', 'FARMACO', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarFarmaco', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE FARMACO SET nom_farmaco = ? WHERE cod_farmaco = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_nom_farmaco; SET @p2 = p_cod_farmaco;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Fármaco actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarFarmaco$$
CREATE PROCEDURE sp_EliminarFarmaco(IN p_cod_farmaco VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarFarmaco', 'FARMACO', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarFarmaco', 'FARMACO', '23000', 'No se puede eliminar: el fármaco tiene prescripciones asociadas');
        SELECT 'ERROR: No se puede eliminar, el fármaco tiene prescripciones asociadas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarFarmaco', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM FARMACO WHERE cod_farmaco = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_farmaco;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Fármaco eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarFarmaco('MED-01', 'Paracetamol');
CALL sp_InsertarFarmaco('MED-02', 'Ibuprofeno');
CALL sp_InsertarFarmaco('MED-03', 'Amoxicilina');
CALL sp_InsertarFarmaco('MED-04', 'Aspirina');
CALL sp_InsertarFarmaco('MED-05', 'Ergotamina');
CALL sp_ObtenerFarmacos();
CALL sp_ObtenerFarmacoPorID('MED-01');
CALL sp_ActualizarFarmaco('MED-01', 'Paracetamol 500mg');
CALL sp_ObtenerFarmacoPorID('MED-01');
CALL sp_EliminarFarmaco('MED-01');
CALL sp_InsertarFarmaco('MED-02', 'Duplicado');
SELECT * FROM LOGS_ERRORES;