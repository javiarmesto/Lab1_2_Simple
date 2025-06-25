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
   - Publica la extensión 
   - Prueba los nuevos botones:
     - Vendor Card: Botón **"Mejorar con Copilot"**
     - Vendor List: Botón **"Asistente Copilot"**

5. **Explora y extiende la funcionalidad**
   - 💡 Ideas:
     - **Añade más tipos de asistencia en la página del asistente:**
       - "Análisis de Riesgo": Añade esta opción al enum `AssistanceTypeOption`
       - "Comparación de Proveedores": Extiende el enum y agrega el case correspondiente en `BuildSystemPrompt()`
     
     - **Personaliza los prompts para sugerencias de IA:**
       - Modifica los textos en `BuildSystemPrompt()` para incluir criterios específicos por región
       - Agrega variables de configuración para personalizar el tono y detalle de las respuestas
     
     - **Agrega nuevas acciones o campos contextuales:**
       - Añade un campo `VendorPriority` en el área de variables de la página
       - Agrega nuevas acciones en el área `PromptGuide` con ejemplos específicos por industria
     
     - **Mejora la experiencia con validaciones o mensajes personalizados:**
       - Implementa validación en `CreateSuggestion()` para verificar que `InputVendorInfo` no esté vacío
       - Agrega mensajes de estado mientras se procesa la solicitud usando `Dialog.Open()`

6. **Documenta tus cambios**
   - Comenta tu código y explica tus aportaciones para facilitar el trabajo en equipo.

7. **Preserva tu trabajo**
   ```bash
   # Crea tu propia rama para experimentar
   git checkout -b mi-solucion-[TuNombre]
   git add .
   git commit -m "Mi implementación personalizada"
   
   # O mejor aún: haz un fork del repositorio en GitHub
```

---

## 🔧 Soluciones de Extensión Implementadas

### 1. **Nuevos Tipos de Asistencia**

**Modificación en `vendor_copilot_assistant.al` - Variables:**
```al
AssistanceTypeOption: Option "Descripción Completa","Categorización","Términos de Pago","Checklist Onboarding","Análisis de Riesgo","Comparación de Proveedores";
```

**Actualizar OptionCaption en el campo AssistanceType:**
```al
OptionCaption = 'Descripción Completa,Categorización,Términos de Pago,Checklist Onboarding,Análisis de Riesgo,Comparación de Proveedores';
```

**Agregar en la función `BuildSystemPrompt()` - Nuevos casos:**
```al
AssistanceTypeOption::"Análisis de Riesgo":
    SystemPrompt := 'Eres un analista de riesgos especializado en evaluación de proveedores. ' +
        'Analiza la información y evalúa: riesgo financiero, riesgo operacional, riesgo de cumplimiento, ' +
        'riesgo geográfico y riesgo de dependencia. Para cada categoría, asigna una puntuación (Alto/Medio/Bajo) ' +
        'y proporciona recomendaciones de mitigación específicas. ' +
        'Formato HTML con niveles de riesgo en colores: <span style="color:red;">Alto</span>, <span style="color:orange;">Medio</span>, <span style="color:green;">Bajo</span>.';

AssistanceTypeOption::"Comparación de Proveedores":
    SystemPrompt := 'Eres un consultor experto en procurement y análisis comparativo de proveedores. ' +
        'Basándote en la información proporcionada, crea una matriz de evaluación que incluya: ' +
        'criterios de selección clave, fortalezas y debilidades, análisis coste-beneficio, ' +
        'y recomendaciones de selección. Sugiere qué información adicional sería necesaria ' +
        'para una comparación completa. Formato HTML con tablas comparativas y puntuaciones.';
```

### 2. **Personalización de Prompts con Contexto Regional**

**Agregar variables adicionales:**
```al
RegionCode: Code[10];
DetailLevel: Option Basic,Standard,Detailed;
```

**Nuevos campos en PromptOptions:**
```al
field(Region; RegionCode)
{
    Caption = 'Región';
    ToolTip = 'Código de región para consideraciones locales';
    TableRelation = "Country/Region".Code;
}

field(Detail; DetailLevel)
{
    Caption = 'Nivel de Detalle';
    ToolTip = 'Selecciona el nivel de detalle para la respuesta';
    OptionCaption = 'Básico,Estándar,Detallado';
}
```

**Modificar `BuildSystemPrompt()` para incluir contexto:**
```al
local procedure BuildSystemPrompt(): Text
var
    SystemPrompt: Text;
    RegionContext: Text;
    DetailContext: Text;
begin
    // Construir contexto regional
    if RegionCode <> '' then
        RegionContext := ' Considera las regulaciones y prácticas comerciales específicas de ' + RegionCode + '.';
    
    // Construir contexto de detalle
    case DetailLevel of
        DetailLevel::Basic:
            DetailContext := ' Proporciona una respuesta concisa y directa.';
        DetailLevel::Standard:
            DetailContext := ' Proporciona un análisis equilibrado con ejemplos relevantes.';
        DetailLevel::Detailed:
            DetailContext := ' Proporciona un análisis exhaustivo con múltiples ejemplos y consideraciones avanzadas.';
    end;

    case AssistanceTypeOption of
        // ... casos existentes, agregando al final de cada SystemPrompt:
        // + RegionContext + DetailContext;
```

### 3. **Campos Contextuales y Nuevas Acciones**

**Variable de prioridad:**
```al
VendorPriority: Option " ",Critical,Important,Standard;
```

**Campo de prioridad en PromptOptions:**
```al
field(Priority; VendorPriority)
{
    Caption = 'Prioridad del Proveedor';
    ToolTip = 'Nivel de importancia estratégica del proveedor';
    OptionCaption = ' ,Crítico,Importante,Estándar';
}
```

**Nuevas acciones en PromptGuide:**
```al
action("FinancialVendor")
{
    Caption = 'Proveedor Financiero';
    ToolTip = 'Ejemplo de proveedor de servicios financieros';

    trigger OnAction()
    begin
        InputVendorInfo := 'FinanceConsult Pro - Consultoría financiera especializada en auditorías y asesoramiento fiscal. 15 años en el mercado, equipo de 25 profesionales certificados. Servicios: auditoría externa, consultoría fiscal, planificación financiera.';
        VendorPriority := VendorPriority::Critical;
    end;
}

action("CleaningVendor")
{
    Caption = 'Proveedor de Limpieza';
    ToolTip = 'Ejemplo de proveedor de servicios de limpieza';

    trigger OnAction()
    begin
        InputVendorInfo := 'CleanMaster Services - Empresa de servicios de limpieza comercial. Cobertura nacional, 200 empleados, certificaciones ambientales. Servicios: limpieza diaria, mantenimiento, desinfección especializada.';
        VendorPriority := VendorPriority::Standard;
    end;
}
```

### 4. **Validaciones y Mensajes Mejorados**

**Trigger OnAction mejorado para systemaction(Generate):**
```al
trigger OnAction()
var
    SystemPrompt: Text;
    ProgressDialog: Dialog;
begin
    // Validación mejorada
    if InputVendorInfo = '' then begin
        Message('⚠️ Por favor, introduce información del proveedor antes de generar contenido.');
        exit;
    end;

    if StrLen(InputVendorInfo) < 20 then begin
        Message('⚠️ La información del proveedor es muy breve. Por favor, proporciona más detalles para obtener mejores resultados.');
        exit;
    end;

    // Mensaje de progreso
    ProgressDialog.Open('🤖 Analizando información del proveedor...\Generando contenido con IA...\Por favor, espera...');
    
    SystemPrompt := BuildSystemPrompt();
    OutputContent := CreateSuggestion(SystemPrompt, InputVendorInfo);
    
    ProgressDialog.Close();
    
    // Mensaje de éxito
    if not OutputContent.StartsWith('❌') then
        Message('✅ Contenido generado exitosamente. Revisa el resultado y confirma si deseas aplicar los cambios.');
end;
```

**Función `CreateSuggestion()` mejorada:**
```al
local procedure CreateSuggestion(SystemPrompt: Text; VendorInfo: Text): Text
var
    // ... variables existentes ...
    EnhancedUserMessage: Text;
begin
    // Validación adicional
    if StrLen(VendorInfo) > 4000 then
        VendorInfo := CopyStr(VendorInfo, 1, 4000) + '...';

    // ... código existente ...

    // Preparar mensaje mejorado del usuario
    EnhancedUserMessage := 'Información del proveedor: ' + VendorInfo;
    if VendorPriority <> VendorPriority::" " then
        EnhancedUserMessage += ' | Prioridad: ' + Format(VendorPriority);

    // Preparar mensajes del chat
    AOAIChatMessages.AddSystemMessage(SystemPrompt);
    AOAIChatMessages.AddUserMessage(EnhancedUserMessage);

    // Generar respuesta con manejo de errores mejorado
    if not AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse) then
        exit('❌ Error de conexión: No se pudo conectar con el servicio de IA. Verifica tu conexión a internet.');

    if AOAIOperationResponse.IsSuccess() then
        exit('🎯 ' + AOAIChatMessages.GetLastMessage())
    else
        exit('❌ Error al generar contenido: ' + AOAIOperationResponse.GetError() + '. Intenta nuevamente o contacta al administrador.');
end;
```



---

## 📚 Recursos útiles

- [Documentación AL](https://docs.microsoft.com/es-es/dynamics365/business-central/dev-itpro/developer/)
- [Ejemplos de Extensiones](https://github.com/microsoft/ALAppExtensions)
- [Copilot PromptDialog Documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/copilot-create-promptdialog)

---

> ℹ️ **Consulta el archivo `RECOMENDACIONES_AULA.md` para saber cómo preservar y compartir tu trabajo de forma segura y ordenada.**
