
-- ------------------------------------------------------------
-- SP 1: INSERTAR
-- CONTINUE  → SQLWARNING   (advertencia menor, sigue)
-- EXIT      → SQLSTATE     (clave duplicada, sale)
-- EXIT+ROLLBACK → SQLEXCEPTION (error grave, revierte y sale)
-- ------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarAreaMedica$$
CREATE PROCEDURE sp_InsertarAreaMedica(
    IN p_cod_area_medica  VARCHAR(6),
    IN p_desc_area_medica VARCHAR(45)
)
BEGIN
    DECLARE v_sql TEXT;

    -- CONTINUE: advertencia, registra y sigue ejecutando
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarAreaMedica', 'AREA_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;

    -- EXIT: clave duplicada (SQLSTATE 23000), sale del bloque
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarAreaMedica', 'AREA_MEDICA', '23000', 'El código de área médica ya existe');
        SELECT 'ERROR: El código de área médica ya existe' AS Resultado;
    END;

    -- EXIT + ROLLBACK: error grave, revierte cambios y sale
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarAreaMedica', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'INSERT INTO AREA_MEDICA (cod_area_medica, desc_area_medica) VALUES (?, ?)';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_area_medica;
    SET @p2 = p_desc_area_medica;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
    COMMIT;

    SELECT 'Área médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;


-- ------------------------------------------------------------
-- SP 2: OBTENER TODOS
-- CONTINUE → NOT FOUND    (sin datos, avisa y sigue)
-- EXIT     → SQLEXCEPTION (error grave, sale)
-- ------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerAreasMedicas$$
CREATE PROCEDURE sp_ObtenerAreasMedicas()
BEGIN
    DECLARE v_sql TEXT;

    -- CONTINUE: no hay filas, avisa y sigue
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron áreas médicas registradas' AS Resultado;
    END;

    -- EXIT: error grave, sale del bloque
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerAreasMedicas', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM AREA_MEDICA';
    PREPARE stmt FROM v_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;


-- ------------------------------------------------------------
-- SP 3: OBTENER POR ID
-- CONTINUE → NOT FOUND    (no encuentra ese ID, avisa y sigue)
-- EXIT     → SQLEXCEPTION (error grave, sale)
-- ------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerAreaMedicaPorID$$
CREATE PROCEDURE sp_ObtenerAreaMedicaPorID(
    IN p_cod_area_medica VARCHAR(6)
)
BEGIN
    DECLARE v_sql TEXT;

    -- CONTINUE: no encuentra el registro, avisa y sigue
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT CONCAT('No se encontró área médica con código: ', p_cod_area_medica) AS Resultado;
    END;

    -- EXIT: error grave, sale del bloque
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerAreaMedicaPorID', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    SET v_sql = 'SELECT * FROM AREA_MEDICA WHERE cod_area_medica = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_area_medica;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;


-- ------------------------------------------------------------
-- SP 4: ACTUALIZAR
-- CONTINUE  → SQLWARNING   (advertencia menor, sigue)
-- EXIT+ROLLBACK → SQLEXCEPTION (error grave, revierte y sale)
-- ------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarAreaMedica$$
CREATE PROCEDURE sp_ActualizarAreaMedica(
    IN p_cod_area_medica  VARCHAR(6),
    IN p_desc_area_medica VARCHAR(45)
)
BEGIN
    DECLARE v_sql TEXT;

    -- CONTINUE: advertencia, registra y sigue ejecutando
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarAreaMedica', 'AREA_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;

    -- EXIT + ROLLBACK: error grave, revierte cambios y sale
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarAreaMedica', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'UPDATE AREA_MEDICA SET desc_area_medica = ? WHERE cod_area_medica = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_desc_area_medica;
    SET @p2 = p_cod_area_medica;
    EXECUTE stmt USING @p1, @p2;
    DEALLOCATE PREPARE stmt;
    COMMIT;

    SELECT 'Área médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;


-- ------------------------------------------------------------
-- SP 5: ELIMINAR
-- CONTINUE  → SQLWARNING   (advertencia menor, sigue)
-- EXIT      → SQLSTATE     (viola integridad referencial, sale)
-- EXIT+ROLLBACK → SQLEXCEPTION (error grave, revierte y sale)
-- ------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarAreaMedica$$
CREATE PROCEDURE sp_EliminarAreaMedica(
    IN p_cod_area_medica VARCHAR(6)
)
BEGIN
    DECLARE v_sql TEXT;

    -- CONTINUE: advertencia, registra y sigue ejecutando
    DECLARE CONTINUE HANDLER FOR SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarAreaMedica', 'AREA_MEDICA', @cod, CONCAT('WARNING: ', @msg));
    END;

    -- EXIT: viola integridad referencial (área tiene personal asociado)
    DECLARE EXIT HANDLER FOR SQLSTATE '23000'
    BEGIN
        ROLLBACK;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarAreaMedica', 'AREA_MEDICA', '23000', 'No se puede eliminar: el área tiene personal médico asociado');
        SELECT 'ERROR: No se puede eliminar, el área tiene personal médico asociado' AS Resultado;
    END;

    -- EXIT + ROLLBACK: error grave, revierte cambios y sale
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarAreaMedica', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;

    START TRANSACTION;
    SET v_sql = 'DELETE FROM AREA_MEDICA WHERE cod_area_medica = ?';
    PREPARE stmt FROM v_sql;
    SET @p1 = p_cod_area_medica;
    EXECUTE stmt USING @p1;
    DEALLOCATE PREPARE stmt;
    COMMIT;

    SELECT 'Área médica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR SPs
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';

-- ============================================================
-- PRUEBAS
-- ============================================================
CALL sp_InsertarAreaMedica('E-01', 'Infectología');
CALL sp_InsertarAreaMedica('E-02', 'Cardiología');
CALL sp_InsertarAreaMedica('E-03', 'Neurocirugía');
CALL sp_ObtenerAreasMedicas();
CALL sp_ObtenerAreaMedicaPorID('E-01');
CALL sp_ActualizarAreaMedica('E-01', 'Infectología General');
CALL sp_ObtenerAreaMedicaPorID('E-01');
CALL sp_EliminarAreaMedica('E-01');
-- Prueba SQLSTATE 23000 (duplicado)
CALL sp_InsertarAreaMedica('E-02', 'Duplicado');
SELECT * FROM LOGS_ERRORES;