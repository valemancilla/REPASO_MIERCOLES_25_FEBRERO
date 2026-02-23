
-- ============================================================
-- 1. CREACIÓN DE USUARIOS
-- ============================================================

CREATE USER 'admin_sistema'@'localhost'         IDENTIFIED BY 'Admin@Secure2024!';
CREATE USER 'medico_usuario'@'localhost'        IDENTIFIED BY 'Medico@Secure2024!';
CREATE USER 'enfermero_usuario'@'localhost'     IDENTIFIED BY 'Enfermero@Secure2024!';
CREATE USER 'farmaceutico_usuario'@'localhost'  IDENTIFIED BY 'Farma@Secure2024!';
CREATE USER 'recepcionista_usuario'@'localhost' IDENTIFIED BY 'Recep@Secure2024!';


-- ============================================================
-- 2. GRANT - ASIGNACIÓN DE PERMISOS
-- ============================================================

-- -------------------------------------------------------
-- SUPERUSUARIO: admin_sistema
-- Acceso total a toda la base de datos y gestión de usuarios
-- -------------------------------------------------------
GRANT ALL PRIVILEGES ON clinica_universitaria.* TO 'admin_sistema'@'localhost';
GRANT CREATE USER, RELOAD ON *.* TO 'admin_sistema'@'localhost';


-- -------------------------------------------------------
-- USUARIO 1: medico_usuario
-- Registra y consulta consultas médicas, emite prescripciones,
-- ve pacientes, fármacos, condiciones, área, unidad y centro.
-- NO modifica: pacientes, fármacos, logs_errores.
-- -------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON clinica_universitaria.consulta_medica     TO 'medico_usuario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON clinica_universitaria.prescripcion_medica TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.registro_paciente   TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.personal_medico     TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.area_medica         TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.unidad_academica    TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.centro_asistencial  TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.condicion_clinica   TO 'medico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.farmaco             TO 'medico_usuario'@'localhost';
-- logs_errores: SIN ACCESO (solo el admin la gestiona)


-- -------------------------------------------------------
-- USUARIO 2: enfermero_usuario
-- Solo lectura en todas las tablas clínicas.
-- NO puede modificar ningún dato.
-- NO tiene acceso a logs_errores.
-- -------------------------------------------------------
GRANT SELECT ON clinica_universitaria.consulta_medica     TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.prescripcion_medica TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.registro_paciente   TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.personal_medico     TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.area_medica         TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.unidad_academica    TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.centro_asistencial  TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.condicion_clinica   TO 'enfermero_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.farmaco             TO 'enfermero_usuario'@'localhost';
-- logs_errores: SIN ACCESO (solo el admin la gestiona)


-- -------------------------------------------------------
-- USUARIO 3: farmaceutico_usuario
-- Gestión completa del catálogo de fármacos.
-- Consulta prescripciones para despachar medicamentos.
-- Acceso restringido a columnas de registro_paciente
-- (solo cod_paciente, primer_nombre, primer_apellido).
-- NO tiene acceso a logs_errores.
-- -------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON clinica_universitaria.farmaco             TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.prescripcion_medica TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.consulta_medica     TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.condicion_clinica   TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.area_medica         TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.personal_medico     TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.unidad_academica    TO 'farmaceutico_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.centro_asistencial  TO 'farmaceutico_usuario'@'localhost';
-- Acceso solo a columnas específicas de registro_paciente (sin num_contacto por privacidad)
GRANT SELECT (cod_paciente, primer_nombre, primer_apellido)ON clinica_universitaria.registro_paciente TO 'farmaceutico_usuario'@'localhost';
-- logs_errores: SIN ACCESO (solo el admin la gestiona)


-- -------------------------------------------------------
-- USUARIO 4: recepcionista_usuario
-- Registra y actualiza pacientes.
-- Agenda consultas médicas.
-- Consulta médicos, áreas, unidades y centros para asignarlos.
-- NO tiene acceso a prescripciones, fármacos ni logs_errores.
-- -------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON clinica_universitaria.registro_paciente  TO 'recepcionista_usuario'@'localhost';
GRANT SELECT, INSERT ON clinica_universitaria.consulta_medica    TO 'recepcionista_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.personal_medico    TO 'recepcionista_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.area_medica        TO 'recepcionista_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.unidad_academica   TO 'recepcionista_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.centro_asistencial TO 'recepcionista_usuario'@'localhost';
GRANT SELECT ON clinica_universitaria.condicion_clinica  TO 'recepcionista_usuario'@'localhost';
-- farmaco: SIN ACCESO (no es su función)
-- prescripcion_medica: SIN ACCESO (no es su función)
-- logs_errores: SIN ACCESO (solo el admin la gestiona)


-- ============================================================
-- 3. APLICAR CAMBIOS
-- ============================================================
FLUSH PRIVILEGES;


-- ============================================================
-- 4. VERIFICAR PERMISOS
-- ============================================================
SHOW GRANTS FOR 'admin_sistema'@'localhost';
SHOW GRANTS FOR 'medico_usuario'@'localhost';
SHOW GRANTS FOR 'enfermero_usuario'@'localhost';
SHOW GRANTS FOR 'farmaceutico_usuario'@'localhost';
SHOW GRANTS FOR 'recepcionista_usuario'@'localhost';


-- ============================================================
-- 5. REVOKE - EJEMPLO DE CÓMO QUITAR PERMISOS
-- ============================================================
-- REVOKE DELETE ON clinica_universitaria.farmaco FROM 'farmaceutico_usuario'@'localhost';
-- REVOKE INSERT ON clinica_universitaria.consulta_medica FROM 'recepcionista_usuario'@'localhost';


-- ============================================================
-- 6. CAMBIO DE CONTRASEÑA
-- ============================================================
-- ALTER USER 'medico_usuario'@'localhost' IDENTIFIED BY 'NuevaContrasena@2024!';
-- SET PASSWORD FOR 'enfermero_usuario'@'localhost' = 'NuevaContrasena@2024!';


-- ============================================================
-- 7. ELIMINAR USUARIO
-- ============================================================
-- DROP USER 'recepcionista_usuario'@'localhost';