

CREATE DATABASE IF NOT EXISTS clinica_universitaria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE clinica_universitaria;

-- ============================================================
-- TABLAS
-- ============================================================


CREATE TABLE IF NOT EXISTS UNIDAD_ACADEMICA (
    cod_unidad_academica  VARCHAR(6)   NOT NULL,
    nom_unidad_academica  VARCHAR(45)  NOT NULL,
    director_unidad       VARCHAR(100) NOT NULL,
    CONSTRAINT PK_UNIDAD_ACADEMICA PRIMARY KEY (cod_unidad_academica)
);


CREATE TABLE IF NOT EXISTS AREA_MEDICA (
    cod_area_medica   VARCHAR(6)  NOT NULL,
    desc_area_medica  VARCHAR(45) NOT NULL,
    CONSTRAINT PK_AREA_MEDICA PRIMARY KEY (cod_area_medica)
);


CREATE TABLE IF NOT EXISTS REGISTRO_PACIENTE (
    cod_paciente     VARCHAR(6)   NOT NULL,
    primer_nombre    VARCHAR(45)  NOT NULL,
    primer_apellido  VARCHAR(45)  NOT NULL,
    num_contacto     VARCHAR(15),
    CONSTRAINT PK_REGISTRO_PACIENTE PRIMARY KEY (cod_paciente)
);


CREATE TABLE IF NOT EXISTS PERSONAL_MEDICO (
    cod_personal          VARCHAR(6)   NOT NULL,
    nom_personal_medico   VARCHAR(100) NOT NULL,
    cod_unidad_academica  VARCHAR(6)   NOT NULL,
    cod_area_medica       VARCHAR(6)   NOT NULL,
    CONSTRAINT PK_PERSONAL_MEDICO PRIMARY KEY (cod_personal),
    CONSTRAINT FK_PERSONAL_UNIDAD
        FOREIGN KEY (cod_unidad_academica) REFERENCES UNIDAD_ACADEMICA(cod_unidad_academica),
    CONSTRAINT FK_PERSONAL_AREA
        FOREIGN KEY (cod_area_medica) REFERENCES AREA_MEDICA(cod_area_medica)
);


CREATE TABLE IF NOT EXISTS CENTRO_ASISTENCIAL (
    cod_centro       VARCHAR(6)   NOT NULL,
    nom_centro       VARCHAR(100) NOT NULL,
    ubicacion_centro VARCHAR(150) NOT NULL,
    CONSTRAINT PK_CENTRO_ASISTENCIAL PRIMARY KEY (cod_centro)
);


CREATE TABLE IF NOT EXISTS CONDICION_CLINICA (
    cod_condicion   VARCHAR(6)   NOT NULL,
    desc_condicion  VARCHAR(255) NOT NULL,
    CONSTRAINT PK_CONDICION_CLINICA PRIMARY KEY (cod_condicion)
);


CREATE TABLE IF NOT EXISTS CONSULTA_MEDICA (
    cod_consulta   VARCHAR(6)  NOT NULL,
    fec_consulta   DATE        NOT NULL,
    cod_paciente   VARCHAR(6)  NOT NULL,
    cod_personal   VARCHAR(6)  NOT NULL,
    cod_centro     VARCHAR(6)  NOT NULL,
    cod_condicion  VARCHAR(6)  NOT NULL,
    CONSTRAINT PK_CONSULTA_MEDICA PRIMARY KEY (cod_consulta),
    CONSTRAINT FK_CONSULTA_PACIENTE
        FOREIGN KEY (cod_paciente)  REFERENCES REGISTRO_PACIENTE(cod_paciente),
    CONSTRAINT FK_CONSULTA_PERSONAL
        FOREIGN KEY (cod_personal)  REFERENCES PERSONAL_MEDICO(cod_personal),
    CONSTRAINT FK_CONSULTA_CENTRO
        FOREIGN KEY (cod_centro)    REFERENCES CENTRO_ASISTENCIAL(cod_centro),
    CONSTRAINT FK_CONSULTA_CONDICION
        FOREIGN KEY (cod_condicion) REFERENCES CONDICION_CLINICA(cod_condicion)
);



CREATE TABLE IF NOT EXISTS FARMACO (
    cod_farmaco  VARCHAR(6)  NOT NULL,
    nom_farmaco  VARCHAR(45) NOT NULL,
    CONSTRAINT PK_FARMACO PRIMARY KEY (cod_farmaco)
);


CREATE TABLE IF NOT EXISTS PRESCRIPCION_MEDICA (
    cod_prescripcion  VARCHAR(6)  NOT NULL,
    dosis_prescrita   VARCHAR(45) NOT NULL,
    cod_farmaco       VARCHAR(6)  NOT NULL,
    cod_consulta      VARCHAR(6)  NOT NULL,
    CONSTRAINT PK_PRESCRIPCION_MEDICA PRIMARY KEY (cod_prescripcion),
    CONSTRAINT FK_PRESCRIPCION_FARMACO
        FOREIGN KEY (cod_farmaco)  REFERENCES FARMACO(cod_farmaco),
    CONSTRAINT FK_PRESCRIPCION_CONSULTA
        FOREIGN KEY (cod_consulta) REFERENCES CONSULTA_MEDICA(cod_consulta)
);


CREATE TABLE IF NOT EXISTS LOGS_ERRORES (
    Log_ID        INT          NOT NULL AUTO_INCREMENT,
    Nombre_Rutina VARCHAR(100) NOT NULL,
    Nombre_Tabla  VARCHAR(100) NOT NULL,
    Codigo_Error  VARCHAR(10)  NOT NULL,
    Mensaje_Error VARCHAR(500) NOT NULL,
    Fecha_Hora    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LOGS PRIMARY KEY (Log_ID)
);


-- ============================================================
-- INSERTS
-- ============================================================

INSERT IGNORE INTO UNIDAD_ACADEMICA (cod_unidad_academica, nom_unidad_academica, director_unidad) VALUES
    ('F-01', 'Medicina', 'Dr. Wilson'),
    ('F-02', 'Ciencias', 'Dr. Palmer');

INSERT IGNORE INTO AREA_MEDICA (cod_area_medica, desc_area_medica) VALUES
    ('E-01', 'Infectología'),
    ('E-02', 'Cardiología'),
    ('E-03', 'Neurocirugía');

INSERT IGNORE INTO REGISTRO_PACIENTE (cod_paciente, primer_nombre, primer_apellido, num_contacto) VALUES
    ('P-501', 'Juan', 'Rivas', '600-111'),
    ('P-502', 'Ana',  'Soto',  '600-222'),
    ('P-503', 'Luis', 'Paz',   '600-333');

INSERT IGNORE INTO PERSONAL_MEDICO (cod_personal, nom_personal_medico, cod_unidad_academica, cod_area_medica) VALUES
    ('M-10', 'Dr. House',   'F-01', 'E-01'),
    ('M-22', 'Dra. Grey',   'F-01', 'E-02'),
    ('M-30', 'Dr. Strange', 'F-02', 'E-03');

INSERT IGNORE INTO CENTRO_ASISTENCIAL (cod_centro, nom_centro, ubicacion_centro) VALUES
    ('H-01', 'Centro Médico', 'Calle 5 #10'),
    ('H-02', 'Clínica Norte', 'Av. Libertador');

INSERT IGNORE INTO CONDICION_CLINICA (cod_condicion, desc_condicion) VALUES
    ('D-01', 'Gripe Fuerte'),
    ('D-02', 'Infección'),
    ('D-03', 'Arritmia'),
    ('D-04', 'Migraña');

INSERT IGNORE INTO CONSULTA_MEDICA (cod_consulta, fec_consulta, cod_paciente, cod_personal, cod_centro, cod_condicion) VALUES
    ('C-001', '2024-05-10', 'P-501', 'M-10', 'H-01', 'D-01'),
    ('C-002', '2024-05-11', 'P-502', 'M-10', 'H-01', 'D-02'),
    ('C-003', '2024-05-12', 'P-501', 'M-22', 'H-02', 'D-03'),
    ('C-004', '2024-05-15', 'P-503', 'M-30', 'H-02', 'D-04');

INSERT IGNORE INTO FARMACO (cod_farmaco, nom_farmaco) VALUES
    ('MED-01', 'Paracetamol'),
    ('MED-02', 'Ibuprofeno'),
    ('MED-03', 'Amoxicilina'),
    ('MED-04', 'Aspirina'),
    ('MED-05', 'Ergotamina');

INSERT IGNORE INTO PRESCRIPCION_MEDICA (cod_prescripcion, dosis_prescrita, cod_farmaco, cod_consulta) VALUES
    ('R-001', '500mg', 'MED-01', 'C-001'),
    ('R-002', '400mg', 'MED-02', 'C-001'),
    ('R-003', '875mg', 'MED-03', 'C-002'),
    ('R-004', '100mg', 'MED-04', 'C-003'),
    ('R-005', '1mg',   'MED-05', 'C-004');