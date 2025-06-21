Vendor Copilot Assistant – Ejercicio Práctico de Extensión para Business Central
Resumen
Este repositorio contiene un ejemplo de extensión para Microsoft Dynamics 365 Business Central que integra capacidades de IA (Copilot) en la gestión de proveedores. La extensión permite generar descripciones, categorías, términos de pago y checklists inteligentes para proveedores, todo desde el propio BC.

Estructura del Proyecto
app.json: Configuración principal de la extensión (nombre, dependencias, rangos de objetos, etc.).
vendor_capability_enum.al: Extensión del enum Copilot Capability para registrar la nueva capacidad de gestión de proveedores.
vendor_card_extension.al: Extensión de la página “Vendor Card” que añade una acción para lanzar la asistencia de Copilot.
vendor_list_extension.al: Extensión de la página “Vendor List” que añade acceso directo al asistente Copilot.
vendor_copilot_assistant.al: Página principal del asistente Copilot, donde se introduce la información del proveedor y se generan sugerencias inteligentes usando IA.
Ejercicio Paso a Paso
1. Clona el repositorio
bash
git clone https://github.com/javiarmesto/Lab1_1_Simple.git
Abre la carpeta en Visual Studio Code.

2. Descarga los símbolos y conecta tu entorno
Presiona Ctrl+Shift+P y ejecuta AL: Download Symbols para conectar con tu sandbox de Business Central.
3. Analiza los objetos AL
Abre y revisa los archivos .al y su documentación (comentarios /// <summary>).
Observa cómo se añaden acciones a las páginas de proveedores y cómo se lanza la página de asistente.
4. Prueba la extensión en tu entorno
Publica la extensión (Ctrl+Shift+P → AL: Publish).
Entra en la lista o ficha de proveedores y prueba las nuevas acciones:
Vendor Card: Botón "Mejorar con Copilot".
Vendor List: Botón "Asistente Copilot".
5. Explora y extiende la funcionalidad
Algunas ideas de mejora o ejercicios:

Añade más tipos de asistencia en la página Vendor Copilot Assistant.
Modifica los prompts para personalizar las sugerencias de IA.
Añade nuevas acciones contextuales o campos.
Mejora la experiencia de usuario con validaciones o mensajes personalizados.
6. Documenta tus cambios
Comenta tu código y detalla cualquier cambio relevante para que otros puedan entender tu aportación.

7. Sube tus cambios
bash
git add .
git commit -m "Mejoras y extensión de Vendor Copilot Assistant"
git push
Recursos útiles
Documentación AL
Extensiones de ejemplo
