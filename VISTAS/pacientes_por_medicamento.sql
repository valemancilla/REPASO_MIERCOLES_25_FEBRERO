
-- =====================================================
-- VISTA 2: Número de Pacientes por Medicamento
-- =====================================================
-- Esta vista muestra cuántos pacientes han sido tratados
-- con cada medicamento registrado en la clínica.
-- Relaciona 3 tablas: farmaco, prescripcion_medica y consulta_medica
-- Útil para: identificar los medicamentos más recetados,
-- controlar el consumo de fármacos y apoyar decisiones
-- sobre el inventario o tratamientos más frecuentes.
-- NOTA: COUNT(DISTINCT) evita contar el mismo paciente
-- dos veces si recibió el mismo medicamento en varias consultas.
-- =====================================================

DROP VIEW IF EXISTS vista_pacientes_por_medicamento;

CREATE VIEW vista_pacientes_por_medicamento AS
SELECT 
    f.cod_farmaco                           AS codigo_medicamento,
    f.nom_farmaco                           AS nombre_medicamento,
    COUNT(DISTINCT cm.cod_paciente)         AS total_pacientes_unicos,
    COUNT(pm.cod_prescripcion)              AS total_veces_recetado
FROM farmaco f
INNER JOIN prescripcion_medica pm 
    ON f.cod_farmaco = pm.cod_farmaco         -- Relaciona fármaco con su prescripción
INNER JOIN consulta_medica cm 
    ON pm.cod_consulta = cm.cod_consulta      -- Relaciona prescripción con la consulta médica
GROUP BY 
    f.cod_farmaco, 
    f.nom_farmaco
ORDER BY total_pacientes_unicos DESC;         -- Ordena del medicamento más usado al menos usado


-- =====================================================
-- CÓMO USAR LA VISTA 2:
-- =====================================================
SELECT * FROM vista_pacientes_por_medicamento;