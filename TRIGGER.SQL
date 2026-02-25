USE clinica_universitaria;

DELIMITER $$

-- ================================================
-- FUNCION 1: VALIDAR NOMBRE
-- Retorna el mensaje de error o NULL si es valido
-- ================================================

CREATE FUNCTION fn_validar_nombre(p_nombre VARCHAR(45), p_campo VARCHAR(20))
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN

    DECLARE v_mensaje VARCHAR(200) DEFAULT NULL;

    IF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        SET v_mensaje = CONCAT('ERROR: El ', p_campo, ' no puede estar vacío.');

    ELSEIF p_nombre REGEXP '[^a-zA-ZáéíóúÁÉÍÓÚñÑ ]' THEN
        SET v_mensaje = CONCAT('ERROR: El ', p_campo, ' solo debe contener letras.');

    END IF;

    RETURN v_mensaje;

END$$

-- ================================================
-- FUNCION 2: VALIDAR TELEFONO
-- Retorna el mensaje de error o NULL si es valido
-- ================================================

CREATE FUNCTION fn_validar_telefono(p_telefono VARCHAR(15))
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN

    DECLARE v_mensaje VARCHAR(200) DEFAULT NULL;

    IF p_telefono IS NULL OR TRIM(p_telefono) = '' THEN
        SET v_mensaje = 'ERROR: El número de contacto no puede estar vacío.';

    ELSEIF p_telefono NOT REGEXP '^[0-9]{7,15}$' THEN
        SET v_mensaje = 'ERROR: El teléfono debe tener entre 7 y 15 dígitos numéricos.';

    END IF;

    RETURN v_mensaje;

END$$

-- ================================================
-- FUNCION 3: VALIDAR FECHA DE CONSULTA
-- Retorna el mensaje de error o NULL si es valida
-- ================================================

CREATE FUNCTION fn_validar_fecha_consulta(p_fecha DATE)
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN

    DECLARE v_mensaje VARCHAR(200) DEFAULT NULL;

    IF p_fecha IS NULL THEN
        SET v_mensaje = 'ERROR: La fecha de consulta no puede ser NULL.';

    ELSEIF p_fecha > CURDATE() THEN
        SET v_mensaje = 'ERROR: La fecha de consulta no puede ser futura.';

    END IF;

    RETURN v_mensaje;

END$$

-- ================================================
-- PROCEDIMIENTO: EJECUTAR VALIDACION
-- Recibe el mensaje, si no es NULL lanza el error
-- ================================================

CREATE PROCEDURE sp_lanzar_error(IN p_mensaje VARCHAR(200))
BEGIN

    IF p_mensaje IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_mensaje;
    END IF;

END$$

-- ================================================
-- TRIGGER 1: BEFORE INSERT - registro_paciente
-- ================================================

CREATE TRIGGER trg_before_insert_paciente
BEFORE INSERT ON registro_paciente
FOR EACH ROW
BEGIN

    CALL sp_lanzar_error(fn_validar_nombre(NEW.primer_nombre,   'primer nombre'));
    CALL sp_lanzar_error(fn_validar_nombre(NEW.primer_apellido, 'primer apellido'));
    CALL sp_lanzar_error(fn_validar_telefono(NEW.num_contacto));

END$$

-- ================================================
-- TRIGGER 2: BEFORE UPDATE - registro_paciente
-- ================================================

CREATE TRIGGER trg_before_update_paciente
BEFORE UPDATE ON registro_paciente
FOR EACH ROW
BEGIN

    CALL sp_lanzar_error(fn_validar_nombre(NEW.primer_nombre,   'primer nombre'));
    CALL sp_lanzar_error(fn_validar_nombre(NEW.primer_apellido, 'primer apellido'));
    CALL sp_lanzar_error(fn_validar_telefono(NEW.num_contacto));

END$$

-- ================================================
-- TRIGGER 3: BEFORE INSERT - consulta_medica
-- ================================================

CREATE TRIGGER trg_before_insert_consulta
BEFORE INSERT ON consulta_medica
FOR EACH ROW
BEGIN

    CALL sp_lanzar_error(fn_validar_fecha_consulta(NEW.fec_consulta));

END$$

-- ================================================
-- TRIGGER 4: BEFORE UPDATE - consulta_medica
-- ================================================

CREATE TRIGGER trg_before_update_consulta
BEFORE UPDATE ON consulta_medica
FOR EACH ROW
BEGIN

    CALL sp_lanzar_error(fn_validar_fecha_consulta(NEW.fec_consulta));

END$$

DELIMITER ;