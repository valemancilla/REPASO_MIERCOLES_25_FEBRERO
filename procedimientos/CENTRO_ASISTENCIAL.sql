
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarCentroAsistencial$$
CREATE PROCEDURE sp_InsertarCentroAsistencial(
    IN p_cod_centro       VARCHAR(6),
    IN p_nom_centro       VARCHAR(100),
    IN p_ubicacion_centro VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO CENTRO_ASISTENCIAL (cod_centro, nom_centro, ubicacion_centro)
    VALUES (p_cod_centro, p_nom_centro, p_ubicacion_centro);
    SELECT 'Centro asistencial insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCentrosAsistenciales$$
CREATE PROCEDURE sp_ObtenerCentrosAsistenciales()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCentrosAsistenciales', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM CENTRO_ASISTENCIAL;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerCentroAsistencialPorID$$
CREATE PROCEDURE sp_ObtenerCentroAsistencialPorID(
    IN p_cod_centro VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerCentroAsistencialPorID', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM CENTRO_ASISTENCIAL WHERE cod_centro = p_cod_centro;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarCentroAsistencial$$
CREATE PROCEDURE sp_ActualizarCentroAsistencial(
    IN p_cod_centro       VARCHAR(6),
    IN p_nom_centro       VARCHAR(100),
    IN p_ubicacion_centro VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE CENTRO_ASISTENCIAL
    SET nom_centro       = p_nom_centro,
        ubicacion_centro = p_ubicacion_centro
    WHERE cod_centro = p_cod_centro;
    SELECT 'Centro asistencial actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarCentroAsistencial$$
CREATE PROCEDURE sp_EliminarCentroAsistencial(
    IN p_cod_centro VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarCentroAsistencial', 'CENTRO_ASISTENCIAL', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM CENTRO_ASISTENCIAL WHERE cod_centro = p_cod_centro;
    SELECT 'Centro asistencial eliminado correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS CENTRO_ASISTENCIAL
-- ============================================================

-- INSERT
CALL sp_InsertarCentroAsistencial('H-01', 'Centro Médico', 'Calle 5 #10');
CALL sp_InsertarCentroAsistencial('H-02', 'Clínica Norte', 'Av. Libertador');

-- VER TODOS
CALL sp_ObtenerCentrosAsistenciales();

-- VER UNO POR ID
CALL sp_ObtenerCentroAsistencialPorID('H-01');

-- ACTUALIZAR
CALL sp_ActualizarCentroAsistencial('H-01', 'Centro Médico', 'Calle 10 #20');

-- VER EL CAMBIO
CALL sp_ObtenerCentrosAsistenciales();

-- ELIMINAR
CALL sp_EliminarCentroAsistencial('H-01');

-- VER LOGS (si hubo errores quedarán registrados aquí)
SELECT * FROM LOGS_ERRORES;