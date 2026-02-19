Informe Técnico – Estado Actual del Proyecto
Portal de Gestión de Citas – Centro Médico

Fase completada: Desarrollo local + Contenerización

1️⃣ Objetivo del Proyecto

El objetivo del proyecto es modernizar una aplicación tradicional de gestión de citas mediante:

Contenerización con Docker

Infraestructura como Código (Terraform + CDK)

Despliegue en AWS (ECR, ECS Fargate, RDS)

Gestión de estado y detección de drift

Actualmente se ha completado la fase de:

Desarrollo del MVP funcional y ejecución en entorno Docker local.

2️⃣ Desarrollo del MVP (Minimum Viable Product)
2.1 Definición del MVP

Se definió una versión mínima funcional que permite:

Crear cita médica

Listar citas (requiere token administrativo)

Cancelar cita (requiere token)

Validar que no existan citas duplicadas en la misma franja horaria

Endpoint de salud (/health)

2.2 Arquitectura Local Implementada

Arquitectura actual en entorno local:

Usuario
   ↓
FastAPI (contenedor Docker)
   ↓
PostgreSQL (contenedor Docker)

3️⃣ Implementación Backend
3.1 Tecnología utilizada

Python 3.11

FastAPI

SQLAlchemy

PostgreSQL

Uvicorn

3.2 API REST implementada
Método	Endpoint	Función
GET	/health	Comprobación de estado
POST	/api/appointments	Crear cita
GET	/api/appointments	Listar citas (requiere token)
DELETE	/api/appointments/{id}	Eliminar cita (requiere token)
3.3 Seguridad Implementada

Se implementó autenticación básica mediante:

Header: X-Admin-Token


Solo los endpoints administrativos requieren dicho token.

3.4 Validación de negocio

Se añadió una restricción UNIQUE en la base de datos:

UniqueConstraint("appointment_at")


Esto impide que existan dos citas en la misma franja horaria.

En caso de conflicto:

Se lanza excepción

Se devuelve HTTP 409

4️⃣ Base de Datos en Desarrollo
4.1 Motor utilizado

PostgreSQL 16 ejecutándose en contenedor Docker.

4.2 Persistencia

Se creó un volumen Docker:

pgdata


Esto permite:

Mantener los datos aunque el contenedor se reinicie

No perder información al detener el servicio

4.3 Creación automática de tablas

Se implementó:

Base.metadata.create_all(bind=engine)


Esto permite que las tablas se creen automáticamente al arrancar la aplicación.

En producción (AWS RDS) se mantendrá este comportamiento para simplificar la gestión.

5️⃣ Contenerización
5.1 Dockerfile creado

Se generó un Dockerfile que:

Usa imagen base python:3.11-slim

Copia requirements.txt

Instala dependencias

Copia el código fuente

Expone puerto 8000

Ejecuta uvicorn

Esto permite:

Ejecutar la API en cualquier entorno sin depender del sistema local.

5.2 Docker Compose

Se definieron dos servicios:

db → PostgreSQL

api → FastAPI

Ambos se ejecutan en red interna de Docker.

La API se conecta a la base de datos mediante:

DATABASE_URL=postgresql+psycopg2://postgres:postgres@db:5432/appointments


El nombre db funciona como DNS interno de Docker.

6️⃣ Flujo Actual de Ejecución

Para levantar el entorno completo:

docker compose up --build -d


Esto crea:

Contenedor app-api-1

Contenedor app-db-1

Y expone:

Puerto 8000 → API

Puerto 5432 → PostgreSQL

7️⃣ Control de Versiones

Se configuró correctamente el repositorio Git:

Eliminación de inicialización incorrecta en HOME

Inicialización correcta en proyecto-citas

Creación de .gitignore

Subida a repositorio remoto

Esto garantiza:

Trabajo colaborativo

Historial de cambios

Recuperación ante pérdida

8️⃣ Estado del Proyecto en Este Momento

Actualmente el sistema:

✅ Funciona correctamente en local
✅ Está completamente contenerizado
✅ Tiene base de datos persistente
✅ Está versionado en Git
✅ Está listo para pasar a AWS

9️⃣ Qué NO hemos hecho todavía

Aún no hemos implementado:

ECR (registro de imágenes)

ECS Fargate

RDS en AWS

Terraform infraestructura real

CDK recursos adicionales

Gestión de estado remoto Terraform

Simulación de Drift
