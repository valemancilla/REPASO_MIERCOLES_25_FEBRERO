DELIMITER $$
DROP PROCEDURE IF EXISTS sp_InsertarFarmaco$$
CREATE PROCEDURE sp_InsertarFarmaco(
    IN p_cod_farmaco VARCHAR(6),
    IN p_nom_farmaco VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_InsertarFarmaco', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    INSERT INTO FARMACO (cod_farmaco, nom_farmaco)
    VALUES (p_cod_farmaco, p_nom_farmaco);
    SELECT 'Fármaco insertado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerFarmacos$$
CREATE PROCEDURE sp_ObtenerFarmacos()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerFarmacos', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM FARMACO;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ObtenerFarmacoPorID$$
CREATE PROCEDURE sp_ObtenerFarmacoPorID(
    IN p_cod_farmaco VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ObtenerFarmacoPorID', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    SELECT * FROM FARMACO WHERE cod_farmaco = p_cod_farmaco;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ActualizarFarmaco$$
CREATE PROCEDURE sp_ActualizarFarmaco(
    IN p_cod_farmaco VARCHAR(6),
    IN p_nom_farmaco VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_ActualizarFarmaco', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    UPDATE FARMACO
    SET nom_farmaco = p_nom_farmaco
    WHERE cod_farmaco = p_cod_farmaco;
    SELECT 'Fármaco actualizado correctamente' AS Resultado;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_EliminarFarmaco$$
CREATE PROCEDURE sp_EliminarFarmaco(
    IN p_cod_farmaco VARCHAR(6)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            @cod = RETURNED_SQLSTATE, @msg = MESSAGE_TEXT;
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('sp_EliminarFarmaco', 'FARMACO', @cod, @msg);
        SELECT CONCAT('ERROR: ', @msg) AS Resultado;
    END;
    DELETE FROM FARMACO WHERE cod_farmaco = p_cod_farmaco;
    SELECT 'Fármaco eliminado correctamente' AS Resultado;
END$$
DELIMITER ;

-- ============================================================
-- VERIFICAR SPs FARMACO
-- ============================================================
SHOW PROCEDURE STATUS WHERE Db = 'clinica_universitaria';

-- ============================================================
-- PRUEBAS FARMACO
-- ============================================================

-- INSERT
CALL sp_InsertarFarmaco('MED-01', 'Paracetamol');
CALL sp_InsertarFarmaco('MED-02', 'Ibuprofeno');
CALL sp_InsertarFarmaco('MED-03', 'Amoxicilina');
CALL sp_InsertarFarmaco('MED-04', 'Aspirina');
CALL sp_InsertarFarmaco('MED-05', 'Ergotamina');

-- VER TODOS
CALL sp_ObtenerFarmacos();

-- VER UNO POR ID
CALL sp_ObtenerFarmacoPorID('MED-01');

-- ACTUALIZAR
CALL sp_ActualizarFarmaco('MED-01', 'Paracetamol 500mg');

-- VER EL CAMBIO
CALL sp_ObtenerFarmacoPorID('MED-01');

-- ELIMINAR
CALL sp_EliminarFarmaco('MED-01');

-- VER LOGS
SELECT * FROM LOGS_ERRORES;