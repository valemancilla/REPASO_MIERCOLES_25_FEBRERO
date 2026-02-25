-- ============================================================
-- PERSONAL_MEDICO - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarPersonalMedico$$
CREATE PROCEDURE sp_InsertarPersonalMedico(
    IN p_cod_personal VARCHAR(6), IN p_nom_personal_medico VARCHAR(100),
    IN p_cod_area_medica VARCHAR(6), IN p_cod_unidad_academica VARCHAR(6)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPersonalMedico', 'PERSONAL_MEDICO', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPersonalMedico', 'PERSONAL_MEDICO', '23000', 'El código de personal ya existe o el área/unidad no existe');
        SELECT 'ERROR: El código de personal ya existe o el área/unidad referenciada no existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO PERSONAL_MEDICO (cod_personal, nom_personal_medico, cod_area_medica, cod_unidad_academica) VALUES (?, ?, ?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_personal; SET @p2 = p_nom_personal_medico; SET @p3 = p_cod_area_medica; SET @p4 = p_cod_unidad_academica;
    EXECUTE stmt USING @p1, @p2, @p3, @p4;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Personal médico insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPersonalMedico$$
CREATE PROCEDURE sp_ObtenerPersonalMedico()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontró personal médico registrado' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT pm.cod_personal, pm.nom_personal_medico, am.desc_area_medica, ua.nom_unidad_academica, ua.director_unidad
    FROM PERSONAL_MEDICO pm
    INNER JOIN AREA_MEDICA am ON pm.cod_area_medica = am.cod_area_medica
    INNER JOIN UNIDAD_ACADEMICA ua ON pm.cod_unidad_academica = ua.cod_unidad_academica';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPersonalMedicoPorID$$
CREATE PROCEDURE sp_ObtenerPersonalMedicoPorID(IN p_cod_personal VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró personal médico con código: ', p_cod_personal) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPersonalMedicoPorID', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT pm.cod_personal, pm.nom_personal_medico, am.desc_area_medica, ua.nom_unidad_academica, ua.director_unidad
    FROM PERSONAL_MEDICO pm
    INNER JOIN AREA_MEDICA am ON pm.cod_area_medica = am.cod_area_medica
    INNER JOIN UNIDAD_ACADEMICA ua ON pm.cod_unidad_academica = ua.cod_unidad_academica
    WHERE pm.cod_personal = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_personal;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarPersonalMedico$$
CREATE PROCEDURE sp_ActualizarPersonalMedico(
    IN p_cod_personal VARCHAR(6), IN p_nom_personal_medico VARCHAR(100),
    IN p_cod_area_medica VARCHAR(6), IN p_cod_unidad_academica VARCHAR(6)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarPersonalMedico', 'PERSONAL_MEDICO', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE PERSONAL_MEDICO SET nom_personal_medico = ?, cod_area_medica = ?, cod_unidad_academica = ? WHERE cod_personal = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_nom_personal_medico; SET @p2 = p_cod_area_medica; SET @p3 = p_cod_unidad_academica; SET @p4 = p_cod_personal;
    EXECUTE stmt USING @p1, @p2, @p3, @p4;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Personal médico actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarPersonalMedico$$
CREATE PROCEDURE sp_EliminarPersonalMedico(IN p_cod_personal VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPersonalMedico', 'PERSONAL_MEDICO', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPersonalMedico', 'PERSONAL_MEDICO', '23000', 'No se puede eliminar: el médico tiene consultas asociadas');
        SELECT 'ERROR: No se puede eliminar, el médico tiene consultas asociadas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM PERSONAL_MEDICO WHERE cod_personal = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_personal;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Personal médico eliminado correctamente' AS Resultado;
END$$
DELIMITER ;
-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarPersonalMedico('M-10', 'Dr. House',   'E-01', 'F-01');
CALL sp_InsertarPersonalMedico('M-22', 'Dra. Grey',   'E-02', 'F-01');
CALL sp_InsertarPersonalMedico('M-30', 'Dr. Strange', 'E-03', 'F-02');
CALL sp_ObtenerPersonalMedico();
CALL sp_ObtenerPersonalMedicoPorID('M-10');
CALL sp_ActualizarPersonalMedico('M-10', 'Dr. House', 'E-03', 'F-02');
CALL sp_ObtenerPersonalMedicoPorID('M-10');
CALL sp_EliminarPersonalMedico('M-10');
CALL sp_InsertarPersonalMedico('M-99', 'Dr. Prueba', 'E-99', 'F-99');
SELECT * FROM LOGS_ERRORES;