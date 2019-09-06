# Implementación de un pipeline del procesador MIPS
## Descripción
1. El Procesador MIPS esta segmentado en las siguientes Etapas:
  - IF (Instruction Fetch): Búsqueda de la instrucción en la memoria de
programa.
  -  ID (Instruction Decode): Decodificación de la instrucción y lectura de
registros.
  - EX (Excecute): Ejecución de la instrucción propiamente dicha.
  - MEM (Memory Access): Lectura o escritura desde/hacia la memoria de datos.
  - WB (Write back): Escritura de resultados en los registros.
2. El programa a ejecutar es cargado en la memoria de programa mediante un
archivo ensamblador.
3. El programa se transmite mediante interfaz UART antes de comenzar a
ejecutar.
4. Se incluye una unidad de Debug que envia información hacia y desde la
PC mediante la UART.

5. El procesador tiene soporte para los siguientes tipos de riesgos:
  - Estructurales. Se producen cuando dos instrucciones tratan de utilizar el mismo recurso en el mismo ciclo.
  - De datos. Se intenta utilizar un dato antes de que esté preparado. Mantenimiento del
orden estricto de lecturas y escrituras.
  - De control. Intentar tomar una decisión sobre una condición todavía no evaluada.

## Modos de operación
  - Antes de estar disponible para ejecutar, el procesador está a la espera para recibir un programa mediante la Debug Unit. Una vez cargado el programa permite dos modos de operación:
    1. Continuo, se envía un comando a la FPGA por UART y esta inicia la ejecución del programa hasta llegar al final del mismo (Instrucción HALT). Llegado ese punto se muestran todos los valores indicados en pantalla.
    2. Paso a paso: Enviando un comando por UART se ejecuta un ciclo de Clock.

![alt text](https://raw.githubusercontent.com/username/projectname/branch/path/to/img.png)
