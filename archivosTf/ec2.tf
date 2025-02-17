data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]

}

#crear una instancia
resource "aws_instance" "instancia" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"    #poner el t2
  subnet_id = aws_subnet.subred-publica.id
  vpc_security_group_ids = [aws_security_group.security.id]
  #key_name      = aws_key_pair.deployer.key_name  # Usar la clave "deployer-key"
  key_name = "deployer-key"  # coje el par de claves que ya estan en aws por el nombre

  # Asignar el perfil de IAM
  iam_instance_profile = "ecsInstanceProfile"

  tags = {
    Name = "instancia"
  }

  user_data = file("./instalar-docker.sh")

  # Conexión SSH para poder subir los archivos
  connection {
    type        = "ssh"
    user        = "ubuntu" 
    private_key = <<EOF
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
    NhAAAAAwEAAQAAAQEAt/OxKLcDQ3TfqkF1orjg69TIYGlV9t/dATyNS9JnI+/d5VmhzvGy
    VG37m9k8X3QlxJnsfObugc8HmaP3AYvDuI/5Nipx/mG6GAF6Roo312WCTDAF88O+NCD1L3
    qGiN1uZvRVXMr4DhY6oBO6u5i4eVOtnEI0SWk+/z002p6lxWx11fttDQr100uerctluE4v
    XartcgalVEquK+htt19QJlak98Fza2pM9yey5oLU/d6wKeewcB18dF/kb26qbEIxWTQ/2H
    7KOc7A0IvCpAFg4fVYs6BJr2ei2m5rTupFJ3tYV61KP5Qqd/2Gx/iWPMlSR8rpZ/94PGtY
    UiVUtCJ9fQAAA8CKKQVNiikFTQAAAAdzc2gtcnNhAAABAQC387EotwNDdN+qQXWiuODr1M
    hgaVX2390BPI1L0mcj793lWaHO8bJUbfub2TxfdCXEmex85u6BzweZo/cBi8O4j/k2KnH+
    YboYAXpGijfXZYJMMAXzw740IPUveoaI3W5m9FVcyvgOFjqgE7q7mLh5U62cQjRJaT7/PT
    TanqXFbHXV+20NCvXTS56ty2W4Ti9dqu1yBqVUSq4r6G23X1AmVqT3wXNrakz3J7LmgtT9
    3rAp57BwHXx0X+RvbqpsQjFZND/Yfso5zsDQi8KkAWDh9VizoEmvZ6LabmtO6kUne1hXrU
    o/lCp3/YbH+JY8yVJHyuln/3g8a1hSJVS0In19AAAAAwEAAQAAAQAfqUIEz/sv0R3uH/Yv
    W8La1HToozi4lS9k1xc6xawa814t649+HvuirItx96H8i/E0NYoOtXC3xvp351DMY1H8ok
    syl3unXQq6twZkvcV+vWn/0wQzQK2sK0AIO/6L8BDgh41pu0WWpxzQEJVDVLXrrAtlqb92
    IzdElzRRrJy7rfQtMnXXKAENZVlRZmueDBhlgIDSSeIKTPZ6WrONPCMpmIDfatAnF7hDWY
    SSVLoI7YAvg50cirAMxMEoP6LXkWP08war+TH4h7NOoHs6eBsssHYsioE3V8n82zNO/GuO
    TLtie7Jj0ubDG58qH5p2OzuvFd8l/6XO5JIXVGryVkABAAAAgQClbC2SVMdObSYNTQ/sj/
    8eAf0Hs2ZFzMfuuroaxBFoioaPZyw69JsbtgiSd1loFkLfEdY6nwnob0UM3WK7HVmF1+Kc
    5piCpT2BArfd81d2DQ4NO5QnCOdSQkB7V0/sPYB8pHVuaTjZ76Bd1okYyn/pWn8/W4Ht07
    sFaAtcaXcLyAAAAIEA8t2LQL3x+G2+8nyMaNgb0KduziDogUt19KEf9HIspBbKGVoLlQ+s
    lN4jeu6sAP8jEd3v/3t2+FFfQ42P8jCkSF3T4S3j10SNncj9ULV3Vx8ly/IHTGDliSLJhb
    GEL2iUVFh4VzjWg0nhC/wJb0s3i7K4uzAmP7BuJNnebm2DQwEAAACBAMHmfqED+wcUELI2
    Ve6c2Ct5wT57XCLZpd1TMupiQTAbRGjwmY4QwnROWtMdZIcRFL060I0A0c4LSmOVO8o5tI
    ZusLgETI/JdeJAHgRiTIrsTjbDwsybSQ9xzqbtSpyVUY2jLTaT3+jEwI8AQGMW13OOf+IO
    eueapDbUuZgNOMZ9AAAACnNlcnJhQEJlZ28=
    -----END OPENSSH PRIVATE KEY-----
    EOF
    host        = self.public_ip
  }

  #subir dockerfiles a la instancia
  provisioner "file" {
    source      = "../Dockerfile.web"  # Ruta del archivo en tu máquina local
    destination = "/home/ubuntu/Dockerfile.web"  # Ruta donde debe ir el archivo en la instancia
  }

  provisioner "file" {
    source      = "../Dockerfile.LDAP"
    destination = "/home/ubuntu/Dockerfile.LDAP"
  }

  provisioner "file" {
    source      = "../empleados.ldif"
    destination = "/home/ubuntu/empleados.ldif"
  }

  provisioner "file" {
    source      = "../usuario.ldif"
    destination = "/home/ubuntu/usuario.ldif"
  }

  provisioner "file" {
    source      = "../000-default.conf"
    destination = "/home/ubuntu/000-default.conf"
  }

  provisioner "file" {
    source      = "../default-ssl.conf"
    destination = "/home/ubuntu/default-ssl.conf"
  }

  provisioner "file" {
  source      = "../certificado"
  destination = "/home/ubuntu/certificado"
}
}

/* resource "aws_eip" "ip-elastica" {
  instance = aws_instance.instancia.id

  #para que no se destruya con el terraform destroy
  lifecycle {
    prevent_destroy = true
  }
} */