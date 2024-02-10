# Herramienta de Gestión de Máquinas Virtuales

Este script de Bash proporciona una interfaz de línea de comandos (CLI) para interactuar con una base de datos de máquinas virtuales. La base de datos se accede mediante un archivo JavaScript llamado "bundle.js" que se encuentra en un servidor remoto. La herramienta es útil para realizar diversas operaciones, como búsqueda por nombre o dirección IP, obtención de enlaces de resolución en YouTube, y filtrado por dificultad, sistema operativo y habilidades.

## Características Principales

- **Colores en la Terminal:**
  - Se han definido colores para mejorar la presentación de la salida en la terminal, facilitando la lectura y comprensión.

- **Manejo de Señal Ctrl+C:**
  - Implementación de una función de salida segura en caso de interrupción (Ctrl+C).

- **Actualización de Archivos:**
  - Descarga o actualiza la base de datos de máquinas desde una URL remota.
  - Utiliza `js-beautify` para formatear el código JavaScript.

- **Funciones de Búsqueda y Filtrado:**
  - Búsqueda por nombre de máquina.
  - Búsqueda por dirección IP.
  - Obtención de enlaces de resolución en YouTube.
  - Filtrado por dificultad, sistema operativo y habilidades.

- **Panel de Ayuda Interactivo:**
  - Muestra un panel de ayuda detallando las opciones disponibles.

## Uso

1. **Descarga o Actualización de Archivos:**
   ```bash
   ./script.sh -u
   ```

2. **Búsqueda por Nombre de Máquina:**
   ```bash
   ./script.sh -m nombre_maquina
   ```

3. **Búsqueda por Dirección IP:**
   ```bash
   ./script.sh -i direccion_ip
   ```

4. **Obtención de Enlace de Resolución en YouTube:**
   ```bash
   ./script.sh -y nombre_maquina
   ```

5. **Filtrado por Dificultad:**
   ```bash
   ./script.sh -d dificultad
   ```

6. **Filtrado por Sistema Operativo:**
   ```bash
   ./script.sh -o sistema_operativo
   ```

7. **Filtrado por Habilidades:**
   ```bash
   ./script.sh -s habilidad
   ```

8. **Mostrar Panel de Ayuda:**
   ```bash
   ./script.sh -h
   ```

## Requisitos

- Bash
- curl
- js-beautify
- sponge

## Notas

- El script depende de la existencia de la base de datos remota y su estructura específica en el archivo "bundle.js".
- Se recomienda tener acceso a internet para descargar la base de datos desde el servidor remoto.

---

**Nota:** Este script ha sido creado con el propósito de gestionar y consultar una base de datos de máquinas virtuales de forma eficiente y amigable desde la línea de comandos.
sponge
