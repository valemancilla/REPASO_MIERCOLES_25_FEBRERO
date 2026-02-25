
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarConsultaMedica$$
CREATE PROCEDURE sp_InsertarConsultaMedica(
    IN p_cod_consulta  VARCHAR(6),
    IN p_fec_consulta  DATE,
    IN p_cod_paciente  VARCHAR(6),
    IN p_cod_personal  VARCHAR(6),
    IN p_cod_condicion VARCHAR(6),
    IN p_cod_centro    VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarConsultaMedica', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO CONSULTA_MEDICA (cod_consulta, fec_consulta, cod_paciente, cod_personal, cod_condicion, cod_centro)
    VALUES (p_cod_consulta, p_fec_consulta, p_cod_paciente, p_cod_personal, p_cod_condicion, p_cod_centro);
    SELECT 'Consulta médica insertada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerConsultasMedicas$$
CREATE PROCEDURE sp_ObtenerConsultasMedicas()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerConsultasMedicas', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT
        cm.cod_consulta,
        cm.fec_consulta,
        cm.cod_paciente,
        CONCAT(rp.primer_nombre, ' ', rp.primer_apellido) AS nombre_completo_paciente,
        cm.cod_personal,
        pm.nom_personal_medico,
        am.desc_area_medica,
        cc.desc_condicion,
        cm.cod_centro,
        ca.nom_centro,
        ca.ubicacion_centro
    FROM CONSULTA_MEDICA cm
    INNER JOIN REGISTRO_PACIENTE  rp ON cm.cod_paciente  = rp.cod_paciente
    INNER JOIN PERSONAL_MEDICO    pm ON cm.cod_personal  = pm.cod_personal
    INNER JOIN AREA_MEDICA        am ON pm.cod_area_medica = am.cod_area_medica
    INNER JOIN CONDICION_CLINICA  cc ON cm.cod_condicion = cc.cod_condicion
    INNER JOIN CENTRO_ASISTENCIAL ca ON cm.cod_centro    = ca.cod_centro;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerConsultaMedicaPorID$$
CREATE PROCEDURE sp_ObtenerConsultaMedicaPorID(
    IN p_cod_consulta VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerConsultaMedicaPorID', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT
        cm.cod_consulta,
        cm.fec_consulta,
        cm.cod_paciente,
        CONCAT(rp.primer_nombre, ' ', rp.primer_apellido) AS nombre_completo_paciente,
        cm.cod_personal,
        pm.nom_personal_medico,
        am.desc_area_medica,
        cc.desc_condicion,
        cm.cod_centro,
        ca.nom_centro,
        ca.ubicacion_centro
    FROM CONSULTA_MEDICA cm
    INNER JOIN REGISTRO_PACIENTE  rp ON cm.cod_paciente  = rp.cod_paciente
    INNER JOIN PERSONAL_MEDICO    pm ON cm.cod_personal  = pm.cod_personal
    INNER JOIN AREA_MEDICA        am ON pm.cod_area_medica = am.cod_area_medica
    INNER JOIN CONDICION_CLINICA  cc ON cm.cod_condicion = cc.cod_condicion
    INNER JOIN CENTRO_ASISTENCIAL ca ON cm.cod_centro    = ca.cod_centro
    WHERE cm.cod_consulta = p_cod_consulta;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarConsultaMedica$$
CREATE PROCEDURE sp_ActualizarConsultaMedica(
    IN p_cod_consulta  VARCHAR(6),
    IN p_fec_consulta  DATE,
    IN p_cod_paciente  VARCHAR(6),
    IN p_cod_personal  VARCHAR(6),
    IN p_cod_condicion VARCHAR(6),
    IN p_cod_centro    VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarConsultaMedica', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE CONSULTA_MEDICA
    SET fec_consulta  = p_fec_consulta,
        cod_paciente  = p_cod_paciente,
        cod_personal  = p_cod_personal,
        cod_condicion = p_cod_condicion,
        cod_centro    = p_cod_centro
    WHERE cod_consulta = p_cod_consulta;
    SELECT 'Consulta médica actualizada correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarConsultaMedica$$
CREATE PROCEDURE sp_EliminarConsultaMedica(
    IN p_cod_consulta VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarConsultaMedica', 'CONSULTA_MEDICA', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    -- Primero eliminar prescripciones asociadas (igual que el profesor eliminaba CITA_MEDICAMENTOS)
    DELETE FROM PRESCRIPCION_MEDICA WHERE cod_consulta = p_cod_consulta;
    DELETE FROM CONSULTA_MEDICA     WHERE cod_consulta = p_cod_consulta;
    SELECT 'Consulta médica y prescripciones eliminadas correctamente' AS Resultado;
END$$
DELIMITER ;


-- ============================================================
-- VERIFICAR QUE TODOS LOS SPs SE CREARON
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';


-- ============================================================
-- PRUEBAS CONSULTA_MEDICA
-- ============================================================

-- INSERT
CALL sp_InsertarConsultaMedica('C-001', '2024-05-10', 'P-501', 'M-10', 'D-01', 'H-01');
CALL sp_InsertarConsultaMedica('C-002', '2024-05-11', 'P-502', 'M-10', 'D-02', 'H-01');
CALL sp_InsertarConsultaMedica('C-003', '2024-05-12', 'P-501', 'M-22', 'D-03', 'H-02');
CALL sp_InsertarConsultaMedica('C-004', '2024-05-15', 'P-503', 'M-30', 'D-04', 'H-02');

-- VER TODOS (con JOIN a REGISTRO_PACIENTE, PERSONAL_MEDICO, AREA_MEDICA, CONDICION_CLINICA, CENTRO_ASISTENCIAL)
CALL sp_ObtenerConsultasMedicas();

-- VER UNO POR ID
CALL sp_ObtenerConsultaMedicaPorID('C-001');

-- ACTUALIZAR
CALL sp_ActualizarConsultaMedica('C-001', '2024-05-10', 'P-501', 'M-10', 'D-02', 'H-01');

-- VER EL CAMBIO
CALL sp_ObtenerConsultaMedicaPorID('C-001');

-- ELIMINAR (también elimina prescripciones asociadas)
CALL sp_EliminarConsultaMedica('C-001');

-- VER LOGS (si hubo errores quedarán registrados aquí)
SELECT * FROM LOGS_ERRORES;