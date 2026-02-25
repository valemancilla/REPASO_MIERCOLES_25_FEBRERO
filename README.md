## 📋 Descripción del Proyecto

Este trabajo implementa una **base de datos para una clínica universitaria** en **MySQL**, con tablas clínicas (pacientes, médicos, consultas, prescripciones, fármacos), además de **validaciones**, **automatizaciones** y **mecanismos de seguridad**.  
El sistema incluye una tabla de **auditoría de errores** (`LOGS_ERRORES`) para registrar fallos producidos por procedimientos, funciones y triggers.

## Características Destacadas

- **Modelo relacional completo** con claves primarias y foráneas.
- **Procedimientos almacenados (SP)** para operaciones CRUD y consultas.
- **Funciones** para cálculos/consultas y validaciones.
- **Triggers** `BEFORE INSERT/UPDATE` para validación de datos y reglas de negocio.
- **Vistas** para reportes rápidos (médicos por facultad/especialidad y pacientes por medicamento).
- **Particionado** por año en tablas clave (`consulta_medica` y `logs_errores`) para mejorar rendimiento y mantenimiento.
- **Eventos programados** para generar un **informe diario** automático.
- **Usuarios y permisos** por rol (admin, médico, enfermero, farmacéutico, recepcionista).
- **Registro de errores centralizado** en `LOGS_ERRORES` usando `HANDLER`, `GET DIAGNOSTICS` y `SIGNAL`.

## Objetivo

Aplicar y demostrar el uso de conceptos de MySQL en un caso realista:

- Diseño de base de datos (DDL) y carga de datos (DML).
- Programación en SQL con **procedimientos**, **funciones**, **triggers**, **vistas** y **eventos**.
- Manejo de errores y trazabilidad mediante **logs**.
- Optimización y mantenimiento mediante **particiones**.
- Control de acceso con **roles y privilegios**.

## Tecnologías Utilizadas

- **MySQL** (DDL/DML, Stored Procedures, Functions, Triggers, Views, Events)
- **SQL dinámico** con `PREPARE` / `EXECUTE`
- **Transacciones** (`START TRANSACTION`, `COMMIT`, `ROLLBACK`)
- **Manejo de errores** (`HANDLER`, `GET DIAGNOSTICS`, `SIGNAL`)

## Estructura del Sistema

- **Scripts principales (raíz)**: creación del esquema, triggers, eventos y permisos.
- **`procedimientos/`**: procedimientos almacenados por entidad (CRUD y consultas).
- **`funciones/`**: funciones (conteos/consultas) y pruebas.
- **`VISTAS/`**: vistas para reportes.
- **`PARTICIONES/`**: scripts para particionar tablas por rango de años.
- **`PREPARE y EXECUTE/`**: versión de procedimientos que usan SQL dinámico y manejo avanzado de errores.
- **`modelo fisico.png`**: diagrama del modelo físico.

## Qué Hace Cada Archivo

### Archivos en la raíz

- **`creacion_base_de_datos.sql`**: crea la BD `clinica_universitaria`, define las tablas principales (incluyendo `LOGS_ERRORES`) e inserta datos de ejemplo.
- **`TRIGGER.SQL`**: define funciones de validación, el procedimiento `sp_lanzar_error` y triggers de validación para `registro_paciente` y `consulta_medica`.
- **`EVENTOS.SQL`**: habilita el scheduler, crea la tabla `informe_diario_consultas`, el procedimiento `sp_generar_informe_diario` y el evento diario `evt_informe_diario_consultas`.
- **`PERMISOS.SQL`**: crea usuarios y asigna permisos por rol (admin, médico, enfermero, farmacéutico, recepcionista).
- **`modelo fisico.png`**: diagrama del modelo físico (tablas y relaciones).

### Carpeta `procedimientos/`

Procedimientos almacenados por tabla/entidad (CRUD y consultas). Incluye archivos como:

- **`AREA_MEDICA.sql`**
- **`CENTRO_ASISTENCIAL.sql`**
- **`CONDICION_CLINICA.sql`**
- **`CONSULTA_MEDICA.sql`**: SP para insertar, consultar (todas/por id), actualizar y eliminar consultas (incluye eliminación de prescripciones asociadas).
- **`FARMACO.sql`**
- **`PERSONAL_MEDICO.sql`**
- **`PRESCRIPCION_MEDICAS.sql`**
- **`REGISTRO_PACIENTE.sql`**
- **`sp_logs.sql`**: operaciones/consultas relacionadas con `LOGS_ERRORES`.
- **`UNIDAD_ACADEMICA.sql`**

### Carpeta `funciones/`

- **`funciones.sql`**: funciones de conteo/consulta (por especialidad, por médico, por sede) con registro de errores en `LOGS_ERRORES`, e incluye consultas de prueba.

### Carpeta `VISTAS/`

- **`medico_especialidad_facultad.sql`**: crea la vista `vista_medico_facultad_especialidad` (médico + facultad/unidad académica + especialidad/área médica).
- **`pacientes_por_medicamento.sql`**: crea la vista `vista_pacientes_por_medicamento` (pacientes únicos y veces recetado por fármaco).

### Carpeta `PARTICIONES/`

- **`consulta_medica.SQL`**: particiona `consulta_medica` por `YEAR(fec_consulta)` (requiere ajustar PK y reconfigurar constraints).
- **`logs_errores.SQL`**: particiona `logs_errores` por `YEAR(Fecha_Hora)` (ajusta PK incluyendo `Fecha_Hora`).

### Carpeta `PREPARE y EXECUTE/`

Procedimientos que usan **SQL dinámico** con `PREPARE`/`EXECUTE`, transacciones y handlers. Incluye:

- **`AREA_MEDICA.SQL`**
- **`CENTRO_ASISTENCIA.SQL`**
- **`CONDICION_CLINICA.SQL`**
- **`CONSULTA_MEDICA.SQL`**
- **`FARMACO.SQL`**
- **`PERSONAL_MEDICO.SQL`**
- **`PRESCRIPCION_MEDICA.SQL`**
- **`RESGISTRO_PACIENTE.SQL`**
- **`SP_LOGS.SQL`**
- **`UNIDAD_ACADEMICA.SQL`**

## Autor

- **Valentina Mancilla**

