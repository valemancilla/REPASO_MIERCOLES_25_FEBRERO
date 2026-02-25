
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarPersonalMedico$$
CREATE PROCEDURE sp_InsertarPersonalMedico(
    IN p_cod_personal         VARCHAR(6),
    IN p_nom_personal_medico  VARCHAR(100),
    IN p_cod_area_medica      VARCHAR(6),
    IN p_cod_unidad_academica VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO PERSONAL_MEDICO (cod_personal, nom_personal_medico, cod_area_medica, cod_unidad_academica)
    VALUES (p_cod_personal, p_nom_personal_medico, p_cod_area_medica, p_cod_unidad_academica);
    SELECT 'Personal médico insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPersonalMedico$$
CREATE PROCEDURE sp_ObtenerPersonalMedico()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT pm.cod_personal,
           pm.nom_personal_medico,
           am.desc_area_medica,
           ua.nom_unidad_academica,
           ua.director_unidad
    FROM PERSONAL_MEDICO pm
    INNER JOIN AREA_MEDICA       am ON pm.cod_area_medica      = am.cod_area_medica
    INNER JOIN UNIDAD_ACADEMICA  ua ON pm.cod_unidad_academica = ua.cod_unidad_academica;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPersonalMedicoPorID$$
CREATE PROCEDURE sp_ObtenerPersonalMedicoPorID(
    IN p_cod_personal VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPersonalMedicoPorID', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT pm.cod_personal,
           pm.nom_personal_medico,
           am.desc_area_medica,
           ua.nom_unidad_academica,
           ua.director_unidad
    FROM PERSONAL_MEDICO pm
    INNER JOIN AREA_MEDICA       am ON pm.cod_area_medica      = am.cod_area_medica
    INNER JOIN UNIDAD_ACADEMICA  ua ON pm.cod_unidad_academica = ua.cod_unidad_academica
    WHERE pm.cod_personal = p_cod_personal;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarPersonalMedico$$
CREATE PROCEDURE sp_ActualizarPersonalMedico(
    IN p_cod_personal         VARCHAR(6),
    IN p_nom_personal_medico  VARCHAR(100),
    IN p_cod_area_medica      VARCHAR(6),
    IN p_cod_unidad_academica VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE PERSONAL_MEDICO
    SET nom_personal_medico  = p_nom_personal_medico,
        cod_area_medica      = p_cod_area_medica,
        cod_unidad_academica = p_cod_unidad_academica
    WHERE cod_personal = p_cod_personal;
    SELECT 'Personal médico actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarPersonalMedico$$
CREATE PROCEDURE sp_EliminarPersonalMedico(
    IN p_cod_personal VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPersonalMedico', 'PERSONAL_MEDICO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM PERSONAL_MEDICO WHERE cod_personal = p_cod_personal;
    SELECT 'Personal médico eliminado correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS PERSONAL_MEDICO
-- ============================================================

-- INSERT
CALL sp_InsertarPersonalMedico('M-10', 'Dr. House',   'E-01', 'F-01');
CALL sp_InsertarPersonalMedico('M-22', 'Dra. Grey',   'E-02', 'F-01');
CALL sp_InsertarPersonalMedico('M-30', 'Dr. Strange', 'E-03', 'F-02');

-- VER TODOS (con JOIN a AREA_MEDICA y UNIDAD_ACADEMICA)
CALL sp_ObtenerPersonalMedico();

-- VER UNO POR ID
CALL sp_ObtenerPersonalMedicoPorID('M-10');

-- ACTUALIZAR (cambia de área y unidad)
CALL sp_ActualizarPersonalMedico('M-10', 'Dr. House', 'E-03', 'F-02');

-- VER EL CAMBIO
CALL sp_ObtenerPersonalMedicoPorID('M-10');

-- ELIMINAR
CALL sp_EliminarPersonalMedico('M-10');

-- VER LOGS (si hubo errores quedarán registrados aquí)
SELECT * FROM LOGS_ERRORES;