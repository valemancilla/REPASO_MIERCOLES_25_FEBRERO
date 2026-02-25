
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarPrescripcionMedica$$
CREATE PROCEDURE sp_InsertarPrescripcionMedica(
    IN p_cod_prescripcion VARCHAR(6),
    IN p_cod_consulta     VARCHAR(6),
    IN p_cod_farmaco      VARCHAR(6),
    IN p_dosis_prescrita  VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO PRESCRIPCION_MEDICA (cod_prescripcion, cod_consulta, cod_farmaco, dosis_prescrita)
    VALUES (p_cod_prescripcion, p_cod_consulta, p_cod_farmaco, p_dosis_prescrita);
    SELECT 'Prescripción médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPrescripcionesMedicas$$
CREATE PROCEDURE sp_ObtenerPrescripcionesMedicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPrescripcionesMedicas', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT pm.cod_prescripcion,
           pm.dosis_prescrita,
           f.nom_farmaco,
           cm.cod_consulta,
           cm.fec_consulta,
           cc.desc_condicion
    FROM PRESCRIPCION_MEDICA pm
    INNER JOIN FARMACO         f  ON pm.cod_farmaco  = f.cod_farmaco
    INNER JOIN CONSULTA_MEDICA cm ON pm.cod_consulta = cm.cod_consulta
    INNER JOIN CONDICION_CLINICA cc ON cm.cod_condicion = cc.cod_condicion;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerPrescripcionesPorConsulta$$
CREATE PROCEDURE sp_ObtenerPrescripcionesPorConsulta(
    IN p_cod_consulta VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerPrescripcionesPorConsulta', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT pm.cod_prescripcion,
           f.nom_farmaco,
           pm.dosis_prescrita
    FROM PRESCRIPCION_MEDICA pm
    INNER JOIN FARMACO f ON pm.cod_farmaco = f.cod_farmaco
    WHERE pm.cod_consulta = p_cod_consulta;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarPrescripcionMedica$$
CREATE PROCEDURE sp_ActualizarPrescripcionMedica(
    IN p_cod_prescripcion VARCHAR(6),
    IN p_cod_farmaco      VARCHAR(6),
    IN p_dosis_prescrita  VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE PRESCRIPCION_MEDICA
    SET cod_farmaco     = p_cod_farmaco,
        dosis_prescrita = p_dosis_prescrita
    WHERE cod_prescripcion = p_cod_prescripcion;
    SELECT 'Prescripción médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarPrescripcionMedica$$
CREATE PROCEDURE sp_EliminarPrescripcionMedica(
    IN p_cod_prescripcion VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarPrescripcionMedica', 'PRESCRIPCION_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM PRESCRIPCION_MEDICA
    WHERE cod_prescripcion = p_cod_prescripcion;
    SELECT 'Prescripción médica eliminada correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS PRESCRIPCION_MEDICA
-- ============================================================

-- INSERT
CALL sp_InsertarPrescripcionMedica('R-001', 'C-001', 'MED-01', '500mg');
CALL sp_InsertarPrescripcionMedica('R-002', 'C-001', 'MED-02', '400mg');
CALL sp_InsertarPrescripcionMedica('R-003', 'C-002', 'MED-03', '875mg');
CALL sp_InsertarPrescripcionMedica('R-004', 'C-003', 'MED-04', '100mg');
CALL sp_InsertarPrescripcionMedica('R-005', 'C-004', 'MED-05', '1mg');

-- VER TODOS (con JOIN a CONSULTA_MEDICA, FARMACO y CONDICION_CLINICA)
CALL sp_ObtenerPrescripcionesMedicas();

-- VER PRESCRIPCIONES DE UNA CONSULTA ESPECIFICA
CALL sp_ObtenerPrescripcionesPorConsulta('C-001');

-- ACTUALIZAR DOSIS
CALL sp_ActualizarPrescripcionMedica('R-001', 'MED-01', '1000mg');

-- VER EL CAMBIO
CALL sp_ObtenerPrescripcionesPorConsulta('C-001');

-- ELIMINAR
CALL sp_EliminarPrescripcionMedica('R-001');

-- VER LOGS (si hubo errores quedarán registrados aquí)
SELECT * FROM LOGS_ERRORES;