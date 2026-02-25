
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarUnidadAcademica$$
CREATE PROCEDURE sp_InsertarUnidadAcademica(
    IN p_cod_unidad_academica VARCHAR(6),
    IN p_nom_unidad_academica VARCHAR(45),
    IN p_director_unidad      VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO UNIDAD_ACADEMICA (cod_unidad_academica, nom_unidad_academica, director_unidad)
    VALUES (p_cod_unidad_academica, p_nom_unidad_academica, p_director_unidad);
    SELECT 'Unidad académica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerUnidadesAcademicas$$
CREATE PROCEDURE sp_ObtenerUnidadesAcademicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerUnidadesAcademicas', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM UNIDAD_ACADEMICA;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerUnidadAcademicaPorID$$
CREATE PROCEDURE sp_ObtenerUnidadAcademicaPorID(
    IN p_cod_unidad_academica VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerUnidadAcademicaPorID', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM UNIDAD_ACADEMICA
    WHERE cod_unidad_academica = p_cod_unidad_academica;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarUnidadAcademica$$
CREATE PROCEDURE sp_ActualizarUnidadAcademica(
    IN p_cod_unidad_academica VARCHAR(6),
    IN p_nom_unidad_academica VARCHAR(45),
    IN p_director_unidad      VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE UNIDAD_ACADEMICA
    SET nom_unidad_academica = p_nom_unidad_academica,
        director_unidad      = p_director_unidad
    WHERE cod_unidad_academica = p_cod_unidad_academica;
    SELECT 'Unidad académica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarUnidadAcademica$$
CREATE PROCEDURE sp_EliminarUnidadAcademica(
    IN p_cod_unidad_academica VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarUnidadAcademica', 'UNIDAD_ACADEMICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM UNIDAD_ACADEMICA
    WHERE cod_unidad_academica = p_cod_unidad_academica;
    SELECT 'Unidad académica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS UNIDAD_ACADEMICA
-- ============================================================

-- INSERT
CALL sp_InsertarUnidadAcademica('F-01', 'Medicina', 'Dr. Wilson');
CALL sp_InsertarUnidadAcademica('F-02', 'Ciencias', 'Dr. Palmer');

-- VER TODOS
CALL sp_ObtenerUnidadesAcademicas();

-- VER UNO POR ID
CALL sp_ObtenerUnidadAcademicaPorID('F-01');

-- ACTUALIZAR
CALL sp_ActualizarUnidadAcademica('F-01', 'Medicina', 'Dr. House');

-- VER EL CAMBIO
CALL sp_ObtenerUnidadesAcademicas();

-- ELIMINAR
CALL sp_EliminarUnidadAcademica('F-01');

-- VER LOGS (si hubo errores quedarán registrados aquí)
SELECT * FROM LOGS_ERRORES;