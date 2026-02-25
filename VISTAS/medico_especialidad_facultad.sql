
-- =====================================================
-- VISTA 1: Médico, Facultad y Especialidad
-- =====================================================
-- Esta vista muestra la información completa de cada médico,
-- incluyendo la facultad (unidad académica) a la que pertenece
-- y la especialidad médica que ejerce.
-- Relaciona 3 tablas: personal_medico, unidad_academica y area_medica
-- Útil para: consultar qué médicos hay, en qué facultad trabajan
-- y cuál es su área de especialización médica.
-- =====================================================

DROP VIEW IF EXISTS vista_medico_facultad_especialidad;

CREATE VIEW vista_medico_facultad_especialidad AS
SELECT 
    pm.cod_personal                 AS codigo_medico,
    pm.nom_personal_medico          AS nombre_medico,
    ua.cod_unidad_academica         AS codigo_facultad,
    ua.nom_unidad_academica         AS nombre_facultad,
    ua.director_unidad              AS director_facultad,
    am.cod_area_medica              AS codigo_especialidad,
    am.desc_area_medica             AS nombre_especialidad
FROM personal_medico pm
INNER JOIN unidad_academica ua 
    ON pm.cod_unidad_academica = ua.cod_unidad_academica  -- Relaciona médico con su facultad
INNER JOIN area_medica am 
    ON pm.cod_area_medica = am.cod_area_medica;           -- Relaciona médico con su especialidad


-- =====================================================
-- CÓMO USAR LA VISTA 1:
-- =====================================================
SELECT * FROM vista_medico_facultad_especialidad;