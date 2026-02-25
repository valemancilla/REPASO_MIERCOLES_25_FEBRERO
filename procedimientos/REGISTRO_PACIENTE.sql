
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarRegistroPaciente$$
CREATE PROCEDURE sp_InsertarRegistroPaciente(
    IN p_cod_paciente    VARCHAR(6),
    IN p_primer_nombre   VARCHAR(45),
    IN p_primer_apellido VARCHAR(45),
    IN p_num_contacto    VARCHAR(15)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO REGISTRO_PACIENTE (cod_paciente, primer_nombre, primer_apellido, num_contacto)
    VALUES (p_cod_paciente, p_primer_nombre, p_primer_apellido, p_num_contacto);
    SELECT 'Paciente insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerRegistroPacientes$$
CREATE PROCEDURE sp_ObtenerRegistroPacientes()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerRegistroPacientes', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM REGISTRO_PACIENTE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerRegistroPacientePorID$$
CREATE PROCEDURE sp_ObtenerRegistroPacientePorID(
    IN p_cod_paciente VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerRegistroPacientePorID', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM REGISTRO_PACIENTE WHERE cod_paciente = p_cod_paciente;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarRegistroPaciente$$
CREATE PROCEDURE sp_ActualizarRegistroPaciente(
    IN p_cod_paciente    VARCHAR(6),
    IN p_primer_nombre   VARCHAR(45),
    IN p_primer_apellido VARCHAR(45),
    IN p_num_contacto    VARCHAR(15)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE REGISTRO_PACIENTE
    SET primer_nombre   = p_primer_nombre,
        primer_apellido = p_primer_apellido,
        num_contacto    = p_num_contacto
    WHERE cod_paciente = p_cod_paciente;
    SELECT 'Paciente actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarRegistroPaciente$$
CREATE PROCEDURE sp_EliminarRegistroPaciente(
    IN p_cod_paciente VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarRegistroPaciente', 'REGISTRO_PACIENTE', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM REGISTRO_PACIENTE WHERE cod_paciente = p_cod_paciente;
    SELECT 'Paciente eliminado correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS REGISTRO_PACIENTE
-- ============================================================

-- INSERT
CALL sp_InsertarRegistroPaciente('P-501', 'Juan', 'Rivas', '600-111');
CALL sp_InsertarRegistroPaciente('P-502', 'Ana',  'Soto',  '600-222');
CALL sp_InsertarRegistroPaciente('P-503', 'Luis', 'Paz',   '600-333');

-- VER TODOS
CALL sp_ObtenerRegistroPacientes();

-- VER UNO POR ID
CALL sp_ObtenerRegistroPacientePorID('P-501');

-- ACTUALIZAR
CALL sp_ActualizarRegistroPaciente('P-501', 'Juan Carlos', 'Rivas', '600-999');

-- VER EL CAMBIO
CALL sp_ObtenerRegistroPacientePorID('P-501');

-- ELIMINAR
CALL sp_EliminarRegistroPaciente('P-501');

-- VER LOGS (si hubo errores quedarán registrados aquí)
SELECT * FROM LOGS_ERRORES;