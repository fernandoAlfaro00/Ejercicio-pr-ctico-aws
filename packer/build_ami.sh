#!/bin/bash

# Ruta del archivo de configuración de Packer
PACKER_TEMPLATE="./aws-ubuntu.pkr.hcl"

# Formateo (opcional, pero es una buena práctica)
echo "Formateando la plantilla Packer..."
packer fmt "$PACKER_TEMPLATE"

# Validación de la plantilla Packer
echo "Validando la plantilla Packer..."
packer validate "$PACKER_TEMPLATE"

# Construcción de la imagen y obtención del ID de la AMI generada
echo "Iniciando la construcción de la AMI..."
AMI_ID=$(packer build -machine-readable "$PACKER_TEMPLATE" | awk -F, '$0 ~/artifact,0,id/ {print $6}')

echo "La AMI se ha generado con el ID: $AMI_ID"
