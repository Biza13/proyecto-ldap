#creamos el repositorio ecr
/* resource "aws_ecr_repository" "repositorio_ecr" {
  name = var.ecr

  tags = {
    "Name"        = "repositorio"
    "Environment" = "Production"
  }
} */

#recurso para hacer el build y el push de las imagenes al repositorio ecr
/* resource "null_resource" "crear-y-subir-imagenes" {
  depends_on = [aws_ecr_repository.repositorio_ecr]

  provisioner "local-exec" {
    command = <<EOT

      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.repositorio_ecr.repository_url}

      docker build --no-cache -t img-apache -f ../Dockerfile.web ../
      docker tag img-apache:latest ${aws_ecr_repository.repositorio_ecr.repository_url}:img-apache
      docker push ${aws_ecr_repository.repositorio_ecr.repository_url}:img-apache

    EOT
  }
} */

/* docker build --no-cache -t img-apache -f ./Dockerfile .
docker tag img-apache:latest ${aws_ecr_repository.repositorio_ecr.repository_url}:img-apache
docker push ${aws_ecr_repository.repositorio_ecr.repository_url}:img-apache */

//esta seria la imagen del dockerfile de ldap que no funciona
/* docker build --no-cache -t img-ldap -f ../Dockerfile.ldap ../
      docker tag img-ldap:latest ${aws_ecr_repository.repositorio_ecr.repository_url}:img-ldap
      docker push ${aws_ecr_repository.repositorio_ecr.repository_url}:img-ldap */

# Referencia al rol IAM existente en mi cuenta de aws que es (LabRole) usando su ARN
/* data "aws_iam_role" "labrole" {
  name = "LabRole"
} */

# Crear el perfil de IAM para la instancia EC2
/* resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = data.aws_iam_role.labrole.name
} */