-- ============================================================
-- PRESCRIPCION_MEDICA - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarPrescripcionMedica$$
CREATE PROCEDURE sp_InsertarPrescripcionMedica(
    IN p_cod_prescripcion VARCHAR(6), IN p_cod_consulta VARCHAR(6),
    IN p_cod_farmaco VARCHAR(6), IN p_dosis_prescrita VARCHAR(45)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPrescripcionMedica', 'PRESCRIPCION_MEDICA', '23000', 'El código de prescripción ya existe o la consulta/fármaco no existe');
        SELECT 'ERROR: El código de prescripción ya existe o la consulta/fármaco referenciado no existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO PRESCRIPCION_MEDICA (cod_prescripcion, cod_consulta, cod_farmaco, dosis_prescrita) VALUES (?, ?, ?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_prescripcion; SET @p2 = p_cod_consulta; SET @p3 = p_cod_farmaco; SET @p4 = p_dosis_prescrita;
    EXECUTE stmt USING @p1, @p2, @p3, @p4;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Prescripción médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPrescripcionesMedicas$$
CREATE PROCEDURE sp_ObtenerPrescripcionesMedicas()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron prescripciones médicas registradas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPrescripcionesMedicas', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT pm.cod_prescripcion, pm.dosis_prescrita, f.nom_farmaco,
           cm.cod_consulta, cm.fec_consulta, cc.desc_condicion
    FROM PRESCRIPCION_MEDICA pm
    INNER JOIN FARMACO f ON pm.cod_farmaco = f.cod_farmaco
    INNER JOIN CONSULTA_MEDICA cm ON pm.cod_consulta = cm.cod_consulta
    INNER JOIN CONDICION_CLINICA cc ON cm.cod_condicion = cc.cod_condicion';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPrescripcionesPorConsulta$$
CREATE PROCEDURE sp_ObtenerPrescripcionesPorConsulta(IN p_cod_consulta VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontraron prescripciones para la consulta: ', p_cod_consulta) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPrescripcionesPorConsulta', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT pm.cod_prescripcion, f.nom_farmaco, pm.dosis_prescrita
    FROM PRESCRIPCION_MEDICA pm
    INNER JOIN FARMACO f ON pm.cod_farmaco = f.cod_farmaco
    WHERE pm.cod_consulta = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_consulta;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarPrescripcionMedica$$
CREATE PROCEDURE sp_ActualizarPrescripcionMedica(
    IN p_cod_prescripcion VARCHAR(6), IN p_cod_farmaco VARCHAR(6), IN p_dosis_prescrita VARCHAR(45)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE PRESCRIPCION_MEDICA SET cod_farmaco = ?, dosis_prescrita = ? WHERE cod_prescripcion = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_farmaco; SET @p2 = p_dosis_prescrita; SET @p3 = p_cod_prescripcion;
    EXECUTE stmt USING @p1, @p2, @p3;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Prescripción médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarPrescripcionMedica$$
CREATE PROCEDURE sp_EliminarPrescripcionMedica(IN p_cod_prescripcion VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM PRESCRIPCION_MEDICA WHERE cod_prescripcion = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_prescripcion;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Prescripción médica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;
-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarPrescripcionMedica('R-001', 'C-001', 'MED-01', '500mg');
CALL sp_InsertarPrescripcionMedica('R-002', 'C-001', 'MED-02', '400mg');
CALL sp_InsertarPrescripcionMedica('R-003', 'C-002', 'MED-03', '875mg');
CALL sp_InsertarPrescripcionMedica('R-004', 'C-003', 'MED-04', '100mg');
CALL sp_InsertarPrescripcionMedica('R-005', 'C-004', 'MED-05', '1mg');
CALL sp_ObtenerPrescripcionesMedicas();
CALL sp_ObtenerPrescripcionesPorConsulta('C-001');
CALL sp_ActualizarPrescripcionMedica('R-001', 'MED-01', '1000mg');
CALL sp_ObtenerPrescripcionesPorConsulta('C-001');
CALL sp_EliminarPrescripcionMedica('R-001');
CALL sp_InsertarPrescripcionMedica('R-002', 'C-999', 'MED-99', '500mg');
SELECT * FROM LOGS_ERRORES;