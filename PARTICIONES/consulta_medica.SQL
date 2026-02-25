-- =====================================================
-- PASO 1: Eliminar la FK de prescripcion_medica
-- que apunta hacia consulta_medica
-- =====================================================
ALTER TABLE prescripcion_medica DROP FOREIGN KEY prescripcion_medica_ibfk_2;


-- =====================================================
-- PASO 2: Ahora sí eliminar la PK de consulta_medica
-- =====================================================
ALTER TABLE consulta_medica DROP PRIMARY KEY;


-- =====================================================
-- PASO 3: Recrear la PK incluyendo fec_consulta
-- =====================================================
ALTER TABLE consulta_medica
ADD PRIMARY KEY (cod_consulta, fec_consulta);


-- =====================================================
-- PASO 4: Crear la partición
-- =====================================================
ALTER TABLE consulta_medica
PARTITION BY RANGE (YEAR(fec_consulta)) (
    PARTITION p_antes_2022  VALUES LESS THAN (2022),
    PARTITION p_2022        VALUES LESS THAN (2023),
    PARTITION p_2023        VALUES LESS THAN (2024),
    PARTITION p_2024        VALUES LESS THAN (2025),
    PARTITION p_2025        VALUES LESS THAN (2026),
    PARTITION p_futuro      VALUES LESS THAN MAXVALUE
);


-- =====================================================
-- PASO 5: Volver a agregar las FK de consulta_medica
-- =====================================================
ALTER TABLE consulta_medica 
    ADD CONSTRAINT fk_consulta_paciente 
    FOREIGN KEY (cod_paciente) 
    REFERENCES registro_paciente(cod_paciente);

ALTER TABLE consulta_medica 
    ADD CONSTRAINT fk_consulta_personal 
    FOREIGN KEY (cod_personal) 
    REFERENCES personal_medico(cod_personal);

ALTER TABLE consulta_medica 
    ADD CONSTRAINT fk_consulta_centro 
    FOREIGN KEY (cod_centro) 
    REFERENCES centro_asistencial(cod_centro);

ALTER TABLE consulta_medica 
    ADD CONSTRAINT fk_consulta_condicion 
    FOREIGN KEY (cod_condicion) 
    REFERENCES condicion_clinica(cod_condicion);


-- =====================================================
-- PASO 6: Volver a agregar la FK de prescripcion_medica
-- que apuntaba hacia consulta_medica
-- =====================================================
ALTER TABLE prescripcion_medica
    ADD CONSTRAINT prescripcion_medica_ibfk_2
    FOREIGN KEY (cod_consulta)
    REFERENCES consulta_medica(cod_consulta);


-- =====================================================
-- VERIFICAR QUE LA PARTICIÓN QUEDÓ BIEN
-- =====================================================
SELECT 
    TABLE_NAME              AS tabla,
    PARTITION_NAME          AS nombre_particion,
    PARTITION_METHOD        AS tipo_particion,
    PARTITION_DESCRIPTION   AS valor_limite,
    TABLE_ROWS              AS filas_aproximadas
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = 'clinica_universitaria'
  AND TABLE_NAME = 'consulta_medica'
  AND PARTITION_NAME IS NOT NULL;


  # Explicación y Motivo de las Particiones

---

## 1️⃣ `consulta_medica` — Partición por `YEAR(fec_consulta)`

### ¿Por qué se particionó?
`consulta_medica` es el **corazón del sistema clínico**. Cada vez que un paciente visita el médico se genera un nuevo registro, lo que significa que esta tabla crece de forma **constante e indefinida** con el paso del tiempo. En una clínica universitaria con cientos de pacientes atendidos mensualmente, en pocos años puede acumular **cientos de miles de registros**.

### ¿Qué problema resuelve la partición?
Sin partición, cuando el sistema busca consultas de un año específico, MySQL recorre **toda la tabla completa**. Con la partición por año, MySQL va **directamente a la partición correcta**, ignorando todos los demás años, lo que hace las consultas mucho más rápidas.

### ¿Por qué se cambió la PK?
MySQL exige que la columna usada para particionar sea parte de la clave primaria. Por eso la PK pasó de ser solo `cod_consulta` a ser **`(cod_consulta, fec_consulta)`**.

### ¿Por qué se eliminaron las FK?
MySQL **no permite Foreign Keys en tablas particionadas**, por eso se reemplazaron con triggers que hacen la misma validación de integridad referencial.

### Particiones y su lógica

| Partición | Rango | Propósito |
|---|---|---|
| `p_antes_2022` | Antes del 2022 | Historial médico antiguo |
| `p_2022` | Año 2022 | Año cerrado |
| `p_2023` | Año 2023 | Año cerrado |
| `p_2024` | Año 2024 | Año cerrado |
| `p_2025` | Año 2025 | Año cerrado |
| `p_futuro` | 2026 en adelante | Consultas nuevas y futuras |



## Comparación entre ambas particiones

| Aspecto | `consulta_medica` | `logs_errores` |
|---|---|---|
| **Motivo de crecimiento** | Visitas médicas de pacientes | Errores automáticos del sistema |
| **Velocidad de crecimiento** | Moderada | Muy alta |
| **Columna de partición** | `fec_consulta DATE` | `Fecha_Hora DATETIME` |
| **Cambio en PK** | Se agregó `fec_consulta` | Se agregó `Fecha_Hora` |
| **FK afectadas** | Sí, se reemplazaron con triggers | No tiene FK |
| **Tipo de partición** | `RANGE (YEAR())` | `RANGE (YEAR())` |
| **Particiones creadas** | 6 | 6 |