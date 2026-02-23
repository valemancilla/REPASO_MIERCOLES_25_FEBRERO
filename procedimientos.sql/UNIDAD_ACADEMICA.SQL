-- ============================================================
-- UNIDAD_ACADEMICA - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarUnidadAcademica$$
CREATE PROCEDURE sp_InsertarUnidadAcademica(
    IN p_cod_unidad_academica VARCHAR(6), IN p_nom_unidad_academica VARCHAR(45), IN p_director_unidad VARCHAR(100)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarUnidadAcademica', 'UNIDAD_ACADEMICA', '23000', 'El código de unidad académica ya existe');
        SELECT 'ERROR: El código de unidad académica ya existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO UNIDAD_ACADEMICA (cod_unidad_academica, nom_unidad_academica, director_unidad) VALUES (?, ?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_unidad_academica; SET @p2 = p_nom_unidad_academica; SET @p3 = p_director_unidad;
    EXECUTE stmt USING @p1, @p2, @p3;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Unidad académica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerUnidadesAcademicas$$
CREATE PROCEDURE sp_ObtenerUnidadesAcademicas()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron unidades académicas registradas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerUnidadesAcademicas', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM UNIDAD_ACADEMICA';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerUnidadAcademicaPorID$$
CREATE PROCEDURE sp_ObtenerUnidadAcademicaPorID(IN p_cod_unidad_academica VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró unidad académica con código: ', p_cod_unidad_academica) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerUnidadAcademicaPorID', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM UNIDAD_ACADEMICA WHERE cod_unidad_academica = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_unidad_academica;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarUnidadAcademica$$
CREATE PROCEDURE sp_ActualizarUnidadAcademica(
    IN p_cod_unidad_academica VARCHAR(6), IN p_nom_unidad_academica VARCHAR(45), IN p_director_unidad VARCHAR(100)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE UNIDAD_ACADEMICA SET nom_unidad_academica = ?, director_unidad = ? WHERE cod_unidad_academica = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_nom_unidad_academica; SET @p2 = p_director_unidad; SET @p3 = p_cod_unidad_academica;
    EXECUTE stmt USING @p1, @p2, @p3;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Unidad académica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarUnidadAcademica$$
CREATE PROCEDURE sp_EliminarUnidadAcademica(IN p_cod_unidad_academica VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarUnidadAcademica', 'UNIDAD_ACADEMICA', '23000', 'No se puede eliminar: la unidad tiene personal médico asociado');
        SELECT 'ERROR: No se puede eliminar, la unidad tiene personal médico asociado' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM UNIDAD_ACADEMICA WHERE cod_unidad_academica = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_unidad_academica;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Unidad académica eliminada correctamente' AS Resultado;
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
CALL sp_InsertarUnidadAcademica('F-02', 'Ciencias', 'Dr. Palmer');
CALL sp_ObtenerUnidadesAcademicas();
CALL sp_ObtenerUnidadAcademicaPorID('F-01');
CALL sp_ActualizarUnidadAcademica('F-01', 'Medicina', 'Dr. House');
CALL sp_ObtenerUnidadesAcademicas();
CALL sp_EliminarUnidadAcademica('F-01');
CALL sp_InsertarUnidadAcademica('F-02', 'Duplicado', 'X');
SELECT * FROM LOGS_ERRORES;