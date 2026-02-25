
-- ============================================================
-- FUNCION 1
-- Número de doctores dada una especialidad
-- ============================================================

DROP FUNCTION IF EXISTS fn_ContarDoctoresPorEspecialidad;

DELIMITER $$
CREATE FUNCTION fn_ContarDoctoresPorEspecialidad(
    p_Especialidad VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total      INT DEFAULT 0;
    DECLARE msg_error  VARCHAR(500);
    DECLARE cod_error  VARCHAR(10);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            cod_error = RETURNED_SQLSTATE,
            msg_error = MESSAGE_TEXT;
    
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('fn_ContarDoctoresPorEspecialidad', 'MEDICOS', cod_error, msg_error);
        SET total = -1;
    END;

    SELECT COUNT(*) INTO total
    FROM MEDICOS
    WHERE Especialidad = p_Especialidad;

    RETURN total;
END$$
DELIMITER ;

-- ============================================================
-- FUNCION 2
-- Total de pacientes atendidos por un médico
-- ============================================================

DROP FUNCTION IF EXISTS fn_TotalPacientesPorMedico;

DELIMITER $$
CREATE FUNCTION fn_TotalPacientesPorMedico(
    p_Medico_ID VARCHAR(10)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total      INT DEFAULT 0;
    DECLARE msg_error  VARCHAR(500);
    DECLARE cod_error  VARCHAR(10);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            cod_error = RETURNED_SQLSTATE,
            msg_error = MESSAGE_TEXT;
        
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('fn_TotalPacientesPorMedico', 'CITAS', cod_error, msg_error);
        SET total = -1;
    END;

    SELECT COUNT(DISTINCT Paciente_ID) INTO total
    FROM CITAS
    WHERE Medico_ID = p_Medico_ID;

    RETURN total;
END$$
DELIMITER ;

-- ============================================================
-- FUNCION 3
-- Cantidad de pacientes atendidos dada una sede
-- ============================================================

DROP FUNCTION IF EXISTS fn_TotalPacientesPorSede;

DELIMITER $$
CREATE FUNCTION fn_TotalPacientesPorSede(
    p_Hospital_Sede VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total      INT DEFAULT 0;
    DECLARE msg_error  VARCHAR(500);
    DECLARE cod_error  VARCHAR(10);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            cod_error = RETURNED_SQLSTATE,
            msg_error = MESSAGE_TEXT;
       
        INSERT INTO LOGS_ERRORES (Nombre_Rutina, Nombre_Tabla, Codigo_Error, Mensaje_Error)
        VALUES ('fn_TotalPacientesPorSede', 'CITAS', cod_error, msg_error);
        SET total = -1;
    END;

    SELECT COUNT(DISTINCT Paciente_ID) INTO total
    FROM CITAS
    WHERE Hospital_Sede = p_Hospital_Sede;

    RETURN total;
END$$
DELIMITER ;

-- ============================================================
-- PRUEBAS DE LAS 3 FUNCIONES
-- ============================================================

-- FUNCION 1: Doctores por especialidad
SELECT fn_ContarDoctoresPorEspecialidad('Infectología') AS Doctores_Infectologia;
SELECT fn_ContarDoctoresPorEspecialidad('Cardiología')  AS Doctores_Cardiologia;
SELECT fn_ContarDoctoresPorEspecialidad('Neurocirugía') AS Doctores_Neurocirugia;
-- Especialidad que no existe (retorna 0)
SELECT fn_ContarDoctoresPorEspecialidad('Pediatría')    AS Doctores_Pediatria;

-- FUNCION 2: Pacientes por médico
SELECT fn_TotalPacientesPorMedico('M-10') AS Pacientes_DrHouse;
SELECT fn_TotalPacientesPorMedico('M-22') AS Pacientes_DraGrey;
SELECT fn_TotalPacientesPorMedico('M-30') AS Pacientes_DrStrange;
-- Médico que no existe (retorna 0)
SELECT fn_TotalPacientesPorMedico('M-99') AS Pacientes_MedicoInexistente;

-- FUNCION 3: Pacientes por sede
SELECT fn_TotalPacientesPorSede('Centro Médico') AS Pacientes_CentroMedico;
SELECT fn_TotalPacientesPorSede('Clínica Norte') AS Pacientes_ClinicaNorte;
-- Sede que no existe (retorna 0)
SELECT fn_TotalPacientesPorSede('Hospital Sur')  AS Pacientes_SedeInexistente;

-- ============================================================
-- CONSULTA COMPLETA: Todo junto en una sola tabla
-- ============================================================

SELECT
    m.Medico_ID,
    m.Nombre_Medico,
    m.Especialidad,
    fn_ContarDoctoresPorEspecialidad(m.Especialidad) AS Total_Doctores_Especialidad,
    fn_TotalPacientesPorMedico(m.Medico_ID)          AS Pacientes_Atendidos
FROM MEDICOS m;

-- ============================================================
-- CONSULTA SEDES: Pacientes por cada sede
-- ============================================================

SELECT
    s.Hospital_Sede,
    s.Dir_Sede,
    fn_TotalPacientesPorSede(s.Hospital_Sede) AS Total_Pacientes_Atendidos
FROM SEDES s;

-- ============================================================
-- VER LOGS - Distingue SP de Función
-- ============================================================

SELECT
    Log_ID,
    Nombre_Rutina,
    CASE
        WHEN Nombre_Rutina LIKE 'sp_%' THEN 'Procedimiento'
        WHEN Nombre_Rutina LIKE 'fn_%' THEN 'Función'
        ELSE 'Desconocido'
    END AS Tipo_Rutina,
    Nombre_Tabla,
    Codigo_Error,
    Mensaje_Error,
    Fecha_Hora
FROM LOGS_ERRORES
ORDER BY Fecha_Hora DESC;