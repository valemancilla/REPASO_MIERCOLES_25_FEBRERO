USE clinica_universitaria;

-- =====================================================
-- PASO 1: ACTIVAR EL PROGRAMADOR DE EVENTOS
-- =====================================================

SET GLOBAL event_scheduler = ON;

-- =====================================================
-- PASO 2: CREAR LA TABLA QUE ALMACENA EL INFORME
-- Aquí se guardarán los datos resultantes cada día
-- =====================================================

CREATE TABLE IF NOT EXISTS informe_diario_consultas (
    id_informe      INT             AUTO_INCREMENT PRIMARY KEY,
    fecha_informe   DATE            NOT NULL,
    cod_centro      VARCHAR(6)      NOT NULL,
    nom_centro      VARCHAR(45)     NOT NULL,
    cod_personal    VARCHAR(6)      NOT NULL,
    nom_medico      VARCHAR(45)     NOT NULL,
    total_pacientes INT             DEFAULT 0,
    fecha_generado  DATETIME        DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- PASO 3: PROCEDIMIENTO QUE GENERA EL INFORME
-- El evento lo llama diariamente
-- =====================================================

DELIMITER $$

CREATE PROCEDURE sp_generar_informe_diario()
BEGIN

    -- Eliminar el informe del día actual para regenerarlo limpio
    DELETE FROM informe_diario_consultas
    WHERE fecha_informe = CURDATE();

    -- Insertar los datos actualizados del día
    INSERT INTO informe_diario_consultas (
        fecha_informe,
        cod_centro,
        nom_centro,
        cod_personal,
        nom_medico,
        total_pacientes
    )
    SELECT
        cm.fec_consulta                         AS fecha_informe,
        ca.cod_centro                           AS cod_centro,
        ca.nom_centro                           AS nom_centro,
        pm.cod_personal                         AS cod_personal,
        pm.nom_personal_medico                  AS nom_medico,
        COUNT(cm.cod_paciente)                  AS total_pacientes
    FROM
        consulta_medica     cm
        INNER JOIN centro_asistencial   ca ON cm.cod_centro   = ca.cod_centro
        INNER JOIN personal_medico      pm ON cm.cod_personal  = pm.cod_personal
    WHERE
        cm.fec_consulta = CURDATE()
    GROUP BY
        cm.fec_consulta,
        ca.cod_centro,
        ca.nom_centro,
        pm.cod_personal,
        pm.nom_personal_medico
    ORDER BY
        ca.nom_centro,
        pm.nom_personal_medico;

END$$

DELIMITER ;

-- =====================================================
-- PASO 4: EVENTO RECURRENTE - SE EJECUTA CADA DÍA
-- Llama al procedimiento automáticamente
-- =====================================================

DELIMITER $$

CREATE EVENT evt_informe_diario_consultas
ON SCHEDULE
    EVERY 1 DAY                         -- EVENTO RECURRENTE: cada 24 horas
    STARTS CURRENT_TIMESTAMP            -- Inicia desde ahora mismo
    ON COMPLETION PRESERVE              -- El evento se conserva aunque ya haya corrido
DO
BEGIN

    CALL sp_generar_informe_diario();   -- Llama al procedimiento que genera el informe

END$$

DELIMITER ;

-- =====================================================
-- PASO 5: EJECUCION MANUAL PARA PROBAR YA MISMO
-- Sin esperar al evento del día siguiente
-- =====================================================

CALL sp_generar_informe_diario();

-- =====================================================
-- PASO 6: CONSULTAR EL INFORME GENERADO
-- =====================================================

SELECT
    fecha_informe,
    nom_centro          AS sede,
    nom_medico          AS medico,
    total_pacientes,
    fecha_generado      AS ultima_actualizacion
FROM
    informe_diario_consultas
ORDER BY
    fecha_informe DESC,
    nom_centro,
    nom_medico;

-- =====================================================
-- COMANDOS UTILES PARA ADMINISTRAR EL EVENTO
-- =====================================================

-- Ver el estado del evento
SHOW EVENTS FROM clinica_universitaria;

-- Pausar el evento temporalmente
-- ALTER EVENT evt_informe_diario_consultas DISABLE;

-- Volver a activar el evento
-- ALTER EVENT evt_informe_diario_consultas ENABLE;

-- Eliminar el evento si ya no se necesita
-- DROP EVENT IF EXISTS evt_informe_diario_consultas;
```

---

## ¿Cómo funciona  EL Flujo?

```
[Cada día automáticamente]
        ↓
  evt_informe_diario_consultas  (EVENTO RECURRENTE)
        ↓
  sp_generar_informe_diario()   (PROCEDIMIENTO)
        ↓
  DELETE registros del día  →  INSERT datos frescos
        ↓
  informe_diario_consultas       (TABLA RESULTADO)
        ↓
  SELECT para ver el informe