# 🚀 Vendor Copilot Assistant – Ejercicio Práctico para Business Central

¡Bienvenido/a! Este repositorio contiene un ejemplo de extensión para **Microsoft Dynamics 365 Business Central** que integra capacidades de IA (Copilot) en la gestión de proveedores.  
La extensión permite generar sugerencias inteligentes y mejorar la experiencia de usuario en la gestión de proveedores.

---

## 📂 Estructura del Proyecto

- `app.json`: Configuración principal de la extensión (nombre, dependencias, objetos, etc.).
- `vendor_capability_enum.al`: Enum extendido para registrar la nueva capacidad de gestión de proveedores.
- `vendor_card_extension.al`: Extensión de la página **Vendor Card** con acción para lanzar Copilot.
- `vendor_list_extension.al`: Extensión de la página **Vendor List** con acceso directo al asistente.
- `vendor_copilot_assistant.al`: Página principal del asistente Copilot, donde se generan sugerencias inteligentes usando IA.

---

## 🛠️ Ejercicio Paso a Paso

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/javiarmesto/Lab1_1_Simple.git
   ```
   Abre la carpeta en Visual Studio Code.

2. **Descarga los símbolos y conecta tu entorno**
   - Pulsa `Ctrl+Shift+P` y ejecuta `AL: Download Symbols` para conectar con tu sandbox de Business Central.

3. **Analiza los objetos AL**
   - Explora los archivos `.al` y revisa los comentarios/documentación.
   - Observa cómo se añaden acciones a las páginas y cómo se lanza el asistente.

4. **Prueba la extensión**
   - Publica la extensión (`Ctrl+Shift+P` → `AL: Publish`).
   - Prueba los nuevos botones:
     - Vendor Card: Botón **"Mejorar con Copilot"**
     - Vendor List: Botón **"Asistente Copilot"**

5. **Explora y extiende la funcionalidad**
   - 💡 Ideas:
     - Añade más tipos de asistencia en la página del asistente.
     - Personaliza los prompts para sugerencias de IA.
     - Agrega nuevas acciones o campos contextuales.
     - Mejora la experiencia con validaciones o mensajes personalizados.

6. **Documenta tus cambios**
   - Comenta tu código y explica tus aportaciones para facilitar el trabajo en equipo.

7. **Sube tus cambios**
   ```bash
   git add .
   git commit -m "Mejoras y extensión de Vendor Copilot Assistant"
   git push
   ```

---

## 📚 Recursos útiles

- [Documentación AL](https://docs.microsoft.com/es-es/dynamics365/business-central/dev-itpro/developer/)
- [Ejemplos de Extensiones](https://github.com/microsoft/ALAppExtensions)

---
