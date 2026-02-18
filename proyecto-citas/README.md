# Portal de Gestión de Citas - Centro Médico

## Descripción

Aplicación web desplegada en AWS que permite gestionar citas para centro médico.

El proyecto moderniza una aplicación tradicional mediante:

- Contenerización con Docker
- Registro de imágenes en Amazon ECR
- Despliegue en Amazon ECS Fargate
- Base de datos gestionada en Amazon RDS (PostgreSQL)
- Infraestructura como Código con Terraform
- Recursos adicionales mediante AWS CDK
- Gestión de estado y detección de drift

---

## MVP (Minimum Viable Product)

Funcionalidades mínimas:

- Crear cita
- Listar citas
- Cancelar cita
- Validación para evitar citas duplicadas en la misma franja horaria

---

## Arquitectura

Usuario -> ALB -> ECS Fargate (FastAPI) -> RDS PostgreSQL
Logs -> CloudWatch
Imágenes -> Amazon ECR
Infraestructura -> Terraform + CDK
