variable "region" {
  type        = string
  description = "Region donde se van a crear los recursos"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "Identificado de la vpc"
}

variable "vpc_availability_zones" {
  type        = list(string)
  description = "Listado de zona de disponibilidad"

}

variable "public_subnets" {
  type        = list(string)
  description = "Lista de redes publica"
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de redes privadas"
}

variable "database_subnets" {
  type        = list(string)
  description = "Lista de redes para base de datos"
}

variable "db_password" {
  type        = string
  description = "Password del usuario de la base de datos primaria"
}

variable "db_username" {
  type        = string
  description = "Username del usuario de la base de datos primaria"
}

variable "db_instance_type" {
  type        = string
  description = "Tipo de instancia a usar base de datos"
  default     = "db.t3.micro"
}

variable "db_engine" {
  type        = string
  description = "Motor de base de datos a usar (postgres, mysql, oracle , sql server , custom)."
  default     = "postgres"
}

variable "db_engine_version" {
  type        = string
  description = "Version de motor de base de datos."
  default     = "13.7"
}

variable "db_allocated_storage" {
  type        = number
  description = "Almacenamiento asignado en gibibytes"
  default     = 5
}

variable "name_keypair" {
  type        = string
  description = "Nombre de par de claves"
  default     = "example"
}

variable "filename_keypair" {
  type        = string
  description = "Nombre archivo que va contener llave privada"
  default     = "example.pem"
}

variable "ec2_instance_type" {
  type        = string
  description = "Tipo de instancia a usar"
  default     = "t3.micro"
}

variable "ec2_ami" {
  type        = string
  description = "AMI que usara la instancia"
}


variable "ec2_enable_public_ip" {
  type        = bool
  description = "(optional) Asociar una ip publica a la instancia."
  default     = false
}


variable "tags" {
  type        = map(string)
  description = "(optional) Tags en comun de los recursos"
  default = {
    Environment = "production"
  }
}