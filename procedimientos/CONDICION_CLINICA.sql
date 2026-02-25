
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarCondicionClinica$$
CREATE PROCEDURE sp_InsertarCondicionClinica(
    IN p_cod_condicion  VARCHAR(6),
    IN p_desc_condicion VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCondicionClinica', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO CONDICION_CLINICA (cod_condicion, desc_condicion)
    VALUES (p_cod_condicion, p_desc_condicion);
    SELECT 'Condición clínica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCondicionesClinicas$$
CREATE PROCEDURE sp_ObtenerCondicionesClinicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCondicionesClinicas', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM CONDICION_CLINICA;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCondicionClinicaPorID$$
CREATE PROCEDURE sp_ObtenerCondicionClinicaPorID(
    IN p_cod_condicion VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCondicionClinicaPorID', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM CONDICION_CLINICA WHERE cod_condicion = p_cod_condicion;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarCondicionClinica$$
CREATE PROCEDURE sp_ActualizarCondicionClinica(
    IN p_cod_condicion  VARCHAR(6),
    IN p_desc_condicion VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarCondicionClinica', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE CONDICION_CLINICA
    SET desc_condicion = p_desc_condicion
    WHERE cod_condicion = p_cod_condicion;
    SELECT 'Condición clínica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarCondicionClinica$$
CREATE PROCEDURE sp_EliminarCondicionClinica(
    IN p_cod_condicion VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCondicionClinica', 'CONDICION_CLINICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM CONDICION_CLINICA WHERE cod_condicion = p_cod_condicion;
    SELECT 'Condición clínica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs CONDICION_CLINICA
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';

-- ============================================================
-- PRUEBAS CONDICION_CLINICA
-- ============================================================

-- INSERT
CALL sp_InsertarCondicionClinica('D-01', 'Gripe Fuerte');
CALL sp_InsertarCondicionClinica('D-02', 'Infección');
CALL sp_InsertarCondicionClinica('D-03', 'Arritmia');
CALL sp_InsertarCondicionClinica('D-04', 'Migraña');

-- VER TODOS
CALL sp_ObtenerCondicionesClinicas();

-- VER UNO POR ID
CALL sp_ObtenerCondicionClinicaPorID('D-01');

-- ACTUALIZAR
CALL sp_ActualizarCondicionClinica('D-01', 'Gripe Severa');

-- VER EL CAMBIO
CALL sp_ObtenerCondicionClinicaPorID('D-01');

-- ELIMINAR
CALL sp_EliminarCondicionClinica('D-01');

-- VER LOGS
SELECT * FROM LOGS_ERRORES;