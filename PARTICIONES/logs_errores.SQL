-- =====================================================
-- PASO 1: Primero quitarle el AUTO_INCREMENT a Log_ID
-- para que MySQL nos deje modificar la PK
-- =====================================================
ALTER TABLE logs_errores 
MODIFY COLUMN Log_ID INT NOT NULL;


-- =====================================================
-- PASO 2: Ahora sí eliminar la Primary Key actual
-- Ya sin AUTO_INCREMENT MySQL nos lo permite
-- =====================================================
ALTER TABLE logs_errores DROP PRIMARY KEY;


-- =====================================================
-- PASO 3: Recrear la PK incluyendo Fecha_Hora
-- Ambas columnas juntas forman la nueva PK
-- =====================================================
ALTER TABLE logs_errores 
ADD PRIMARY KEY (Log_ID, Fecha_Hora);


-- =====================================================
-- PASO 4: Volver a poner AUTO_INCREMENT a Log_ID
-- Para que siga funcionando igual que antes
-- =====================================================
ALTER TABLE logs_errores 
MODIFY COLUMN Log_ID INT NOT NULL AUTO_INCREMENT;


-- =====================================================
-- PASO 5: Crear la partición
-- Ahora sí funciona sin ningún error
-- =====================================================
ALTER TABLE logs_errores
PARTITION BY RANGE (YEAR(Fecha_Hora)) (
    PARTITION p_antes_2022  VALUES LESS THAN (2022),  -- Logs antiguos
    PARTITION p_2022        VALUES LESS THAN (2023),  -- Logs año 2022
    PARTITION p_2023        VALUES LESS THAN (2024),  -- Logs año 2023
    PARTITION p_2024        VALUES LESS THAN (2025),  -- Logs año 2024
    PARTITION p_2025        VALUES LESS THAN (2026),  -- Logs año 2025
    PARTITION p_futuro      VALUES LESS THAN MAXVALUE -- Logs futuros
);


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
  AND TABLE_NAME = 'logs_errores'
  AND PARTITION_NAME IS NOT NULL;

  # Explicación y Motivo de las Particiones

  ## 2️⃣ `logs_errores` — Partición por `YEAR(Fecha_Hora)`

### ¿Por qué se particionó?
`logs_errores` es la tabla que **más rápido crece en todo el sistema** porque se llena de forma **completamente automática**, sin intervención humana. Cada vez que ocurre cualquier error en cualquier rutina o proceso del sistema, se inserta un registro automáticamente con fecha y hora exacta. A diferencia de `consulta_medica` que depende de que haya pacientes, los logs **nunca paran de generarse** mientras el sistema esté activo.

### ¿Qué problema resuelve la partición?
Los logs antiguos casi nunca se consultan en el día a día, pero ocupan espacio y ralentizan las búsquedas. Con la partición por año se logran **3 beneficios clave**:

1. **Búsquedas más rápidas** porque al filtrar por fecha MySQL solo revisa la partición del año buscado
2. **Limpieza fácil** porque si se quieren eliminar logs de un año viejo, se borra la partición completa con un solo comando sin afectar el resto
3. **Mantenimiento eficiente** porque cada año queda físicamente separado del siguiente

### ¿Por qué se modificó el `AUTO_INCREMENT`?
MySQL no permite modificar la PK de una tabla cuando tiene `AUTO_INCREMENT` activo. Por eso fue necesario quitarlo temporalmente, cambiar la PK a `(Log_ID, Fecha_Hora)`, y luego volver a activar el `AUTO_INCREMENT`.

### Particiones y su lógica

| Partición | Rango | Propósito |
|---|---|---|
| `p_antes_2022` | Antes del 2022 | Logs históricos antiguos |
| `p_2022` | Año 2022 | Logs año cerrado |
| `p_2023` | Año 2023 | Logs año cerrado |
| `p_2024` | Año 2024 | Logs año cerrado |
| `p_2025` | Año 2025 | Logs año cerrado |
| `p_futuro` | 2026 en adelante | Logs nuevos y futuros |


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