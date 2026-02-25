
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarAreaMedica$$
CREATE PROCEDURE sp_InsertarAreaMedica(
    IN p_cod_area_medica  VARCHAR(6),
    IN p_desc_area_medica VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarAreaMedica', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO AREA_MEDICA (cod_area_medica, desc_area_medica)
    VALUES (p_cod_area_medica, p_desc_area_medica);
    SELECT 'Área médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerAreasMedicas$$
CREATE PROCEDURE sp_ObtenerAreasMedicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerAreasMedicas', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM AREA_MEDICA;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerAreaMedicaPorID$$
CREATE PROCEDURE sp_ObtenerAreaMedicaPorID(
    IN p_cod_area_medica VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerAreaMedicaPorID', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM AREA_MEDICA WHERE cod_area_medica = p_cod_area_medica;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarAreaMedica$$
CREATE PROCEDURE sp_ActualizarAreaMedica(
    IN p_cod_area_medica  VARCHAR(6),
    IN p_desc_area_medica VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarAreaMedica', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE AREA_MEDICA
    SET desc_area_medica = p_desc_area_medica
    WHERE cod_area_medica = p_cod_area_medica;
    SELECT 'Área médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarAreaMedica$$
CREATE PROCEDURE sp_EliminarAreaMedica(
    IN p_cod_area_medica VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarAreaMedica', 'AREA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM AREA_MEDICA WHERE cod_area_medica = p_cod_area_medica;
    SELECT 'Área médica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs AREA_MEDICA
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';

-- ============================================================
-- PRUEBAS AREA_MEDICA
-- ============================================================

-- INSERT
CALL sp_InsertarAreaMedica('E-01', 'Infectología');
CALL sp_InsertarAreaMedica('E-02', 'Cardiología');
CALL sp_InsertarAreaMedica('E-03', 'Neurocirugía');

-- VER TODOS
CALL sp_ObtenerAreasMedicas();

-- VER UNO POR ID
CALL sp_ObtenerAreaMedicaPorID('E-01');

-- ACTUALIZAR
CALL sp_ActualizarAreaMedica('E-01', 'Infectología General');

-- VER EL CAMBIO
CALL sp_ObtenerAreaMedicaPorID('E-01');

-- ELIMINAR
CALL sp_EliminarAreaMedica('E-01');

-- VER LOGS
SELECT * FROM LOGS_ERRORES;