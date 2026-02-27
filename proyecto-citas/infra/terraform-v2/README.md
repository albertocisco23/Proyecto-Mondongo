# Terraform - Portal de Citas (AWS)

## Requisitos
- AWS CLI configurado (`aws sts get-caller-identity`)
- Terraform instalado
- Imagen subida a ECR (image_uri en tfvars)

## Despliegue rápido
```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply