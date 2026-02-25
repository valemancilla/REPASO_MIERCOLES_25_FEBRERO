-- ============================================================
-- CONSULTA_MEDICA - Procedimientos Almacenados
-- PREPARE + EXECUTE
-- SQLSTATE | SQLWARNING | NOT FOUND | SQLEXCEPTION
-- CONTINUE | EXIT | ROLLBACK
-- ============================================================

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarConsultaMedica$$
CREATE PROCEDURE sp_InsertarConsultaMedica(
    IN p_cod_consulta VARCHAR(6), IN p_fec_consulta DATE,
    IN p_cod_paciente VARCHAR(6), IN p_cod_personal VARCHAR(6),
    IN p_cod_condicion VARCHAR(6), IN p_cod_centro VARCHAR(6)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarConsultaMedica', 'CONSULTA_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarConsultaMedica', 'CONSULTA_MEDICA', '23000', 'El código de consulta ya existe o alguna FK referenciada no existe');
        SELECT 'ERROR: El código de consulta ya existe o alguna FK referenciada no existe' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarConsultaMedica', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO CONSULTA_MEDICA (cod_consulta, fec_consulta, cod_paciente, cod_personal, cod_condicion, cod_centro) VALUES (?, ?, ?, ?, ?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_consulta; SET @p2 = p_fec_consulta; SET @p3 = p_cod_paciente;
    SET @p4 = p_cod_personal; SET @p5 = p_cod_condicion; SET @p6 = p_cod_centro;
    EXECUTE stmt USING @p1, @p2, @p3, @p4, @p5, @p6;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Consulta médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerConsultasMedicas$$
CREATE PROCEDURE sp_ObtenerConsultasMedicas()
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron consultas médicas registradas' AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerConsultasMedicas', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT cm.cod_consulta, cm.fec_consulta, cm.cod_paciente,
        CONCAT(rp.primer_nombre, '' '', rp.primer_apellido) AS nombre_completo_paciente,
        cm.cod_personal, pm.nom_personal_medico, am.desc_area_medica,
        cc.desc_condicion, cm.cod_centro, ca.nom_centro, ca.ubicacion_centro
    FROM CONSULTA_MEDICA cm
    INNER JOIN REGISTRO_PACIENTE rp ON cm.cod_paciente = rp.cod_paciente
    INNER JOIN PERSONAL_MEDICO pm ON cm.cod_personal = pm.cod_personal
    INNER JOIN AREA_MEDICA am ON pm.cod_area_medica = am.cod_area_medica
    INNER JOIN CONDICION_CLINICA cc ON cm.cod_condicion = cc.cod_condicion
    INNER JOIN CENTRO_ASISTENCIAL ca ON cm.cod_centro = ca.cod_centro';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerConsultaMedicaPorID$$
CREATE PROCEDURE sp_ObtenerConsultaMedicaPorID(IN p_cod_consulta VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró consulta médica con código: ', p_cod_consulta) AS Resultado;
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerConsultaMedicaPorID', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT cm.cod_consulta, cm.fec_consulta, cm.cod_paciente,
        CONCAT(rp.primer_nombre, '' '', rp.primer_apellido) AS nombre_completo_paciente,
        cm.cod_personal, pm.nom_personal_medico, am.desc_area_medica,
        cc.desc_condicion, cm.cod_centro, ca.nom_centro, ca.ubicacion_centro
    FROM CONSULTA_MEDICA cm
    INNER JOIN REGISTRO_PACIENTE rp ON cm.cod_paciente = rp.cod_paciente
    INNER JOIN PERSONAL_MEDICO pm ON cm.cod_personal = pm.cod_personal
    INNER JOIN AREA_MEDICA am ON pm.cod_area_medica = am.cod_area_medica
    INNER JOIN CONDICION_CLINICA cc ON cm.cod_condicion = cc.cod_condicion
    INNER JOIN CENTRO_ASISTENCIAL ca ON cm.cod_centro = ca.cod_centro
    WHERE cm.cod_consulta = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_consulta;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarConsultaMedica$$
CREATE PROCEDURE sp_ActualizarConsultaMedica(
    IN p_cod_consulta VARCHAR(6), IN p_fec_consulta DATE,
    IN p_cod_paciente VARCHAR(6), IN p_cod_personal VARCHAR(6),
    IN p_cod_condicion VARCHAR(6), IN p_cod_centro VARCHAR(6)
)
BEGIN
    DECLARE v_sql TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarConsultaMedica', 'CONSULTA_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarConsultaMedica', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE CONSULTA_MEDICA SET fec_consulta = ?, cod_paciente = ?, cod_personal = ?, cod_condicion = ?, cod_centro = ? WHERE cod_consulta = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_fec_consulta; SET @p2 = p_cod_paciente; SET @p3 = p_cod_personal;
    SET @p4 = p_cod_condicion; SET @p5 = p_cod_centro; SET @p6 = p_cod_consulta;
    EXECUTE stmt USING @p1, @p2, @p3, @p4, @p5, @p6;
    DEALLOCATE PREPARE stmt;
    COMMIT;
    SELECT 'Consulta médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarConsultaMedica$$
CREATE PROCEDURE sp_EliminarConsultaMedica(IN p_cod_consulta VARCHAR(6))
BEGIN
    DECLARE v_sql TEXT;
    DECLARE v_sql2 TEXT;
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarConsultaMedica', 'CONSULTA_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1 @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarConsultaMedica', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    -- Primero eliminar prescripciones asociadas
    SET v_sql = 'DELETE FROM PRESCRIPCION_MEDICA WHERE cod_consulta = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_consulta;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    -- Luego eliminar la consulta
    SET v_sql2 = 'DELETE FROM CONSULTA_MEDICA WHERE cod_consulta = ?';
    PREPARE stmt2 FROM v_sql2;
    SET @p1 = p_cod_consulta;
    EXECUTE stmt2 USING @p1;
    DEALLOCATE PREPARE stmt2;
    COMMIT;
    SELECT 'Consulta médica y prescripciones eliminadas correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';
-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarConsultaMedica('C-001', '2024-05-10', 'P-501', 'M-10', 'D-01', 'H-01');
CALL sp_InsertarConsultaMedica('C-002', '2024-05-11', 'P-502', 'M-10', 'D-02', 'H-01');
CALL sp_InsertarConsultaMedica('C-003', '2024-05-12', 'P-501', 'M-22', 'D-03', 'H-02');
CALL sp_InsertarConsultaMedica('C-004', '2024-05-15', 'P-503', 'M-30', 'D-04', 'H-02');
CALL sp_ObtenerConsultasMedicas();
CALL sp_ObtenerConsultaMedicaPorID('C-001');
CALL sp_ActualizarConsultaMedica('C-001', '2024-05-10', 'P-501', 'M-10', 'D-02', 'H-01');
CALL sp_ObtenerConsultaMedicaPorID('C-001');
CALL sp_EliminarConsultaMedica('C-001');
CALL sp_InsertarConsultaMedica('C-001', '2024-05-10', 'P-999', 'M-999', 'D-999', 'H-999');
SELECT * FROM LOGS_ERRORES;