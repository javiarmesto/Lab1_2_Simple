namespace YourCompany.VendorCopilot;
using System.AI;
using Microsoft.Foundation.Address;

/// <summary>
/// Página principal del asistente Copilot para gestión de proveedores
/// Permite generar descripciones, categorías, términos de pago y checklists
/// En realidad, esta página es un PromptDialog que interactúa con Azure OpenAI.
/// El usuario puede introducir información del proveedor y seleccionar el tipo de asistencia deseada.  
/// El contenido generado por IA se muestra en un campo de texto enriquecido.
/// Esta página no tiene una SourceTable física, ya que es un PromptDialog.
/// El usuario puede confirmar o descartar los cambios generados por IA.
/// Pero no guardaremos nada, no hemos añadido la lógica para ello, pero recordar que debemos usar tablas temporales por Responsabilidad AI
/// Esta página es un ejemplo de cómo integrar IA en la gestión de proveedores en Business Central.
/// 
page 50100 "Vendor Copilot Assistant"
{
    PageType = PromptDialog;
    ApplicationArea = All;
    Caption = 'Vendor Copilot Assistant';
    PromptMode = Prompt;
    //SourceTable = "Copilot XXX temporal";// No se usa SourceTable físico, ya que es un PromptDialog
    Extensible = false;

    layout
    {
        area(Prompt)
        {
            field(VendorInfoField; InputVendorInfo)
            {
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Introduce información básica del proveedor (nombre, industria, servicios, ubicación, etc.)';
            }
        }

        area(PromptOptions)
        {
            field(AssistanceType; AssistanceTypeOption)
            {
                Caption = 'Tipo de Asistencia';
                ToolTip = 'Selecciona qué tipo de ayuda necesitas para este proveedor';
                OptionCaption = 'Descripción Completa,Categorización,Términos de Pago,Checklist Onboarding,Análisis de Riesgo,Comparación de Proveedores';
            }
            // [COPILOT] Campo de región para contexto regional
            // [COPILOT] Campo de región como Option
            field(Region; RegionOption)
            {
                Caption = 'Región';
                ToolTip = 'Código de región para consideraciones locales';
                OptionCaption = 'España,Estados Unidos,México,Argentina';
            }
            // [COPILOT] Campo de nivel de detalle
            field(Detail; DetailLevel)
            {
                Caption = 'Nivel de Detalle';
                ToolTip = 'Selecciona el nivel de detalle para la respuesta';
                OptionCaption = 'Básico,Estándar,Detallado';
            }
            // [COPILOT] Campo de prioridad del proveedor
            field(Priority; VendorPriority)
            {
                Caption = 'Prioridad del Proveedor';
                ToolTip = 'Nivel de importancia estratégica del proveedor';
                OptionCaption = ' ,Crítico,Importante,Estándar';
            }
        }

        area(Content)
        {
            field("Generated Content"; OutputContent)
            {
                Caption = 'Contenido Generado por IA';
                MultiLine = true;
                ExtendedDatatype = RichContent;
                Editable = false;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            // Puedes tener un comportamiento personalizado para las acciones principales del sistema en una página de tipo PromptDialog, como generar una sugerencia con Copilot, regenerar o descartar la sugerencia.
            // Cuando desarrolles una funcionalidad de Copilot, recuerda: el usuario siempre debe tener el control (el usuario debe confirmar cualquier cosa que Copilot sugiera antes de que se guarde algún cambio).
            // Esta es también la razón por la cual no puedes tener una SourceTable física en una página de tipo PromptDialog (debes usar una tabla temporal o ninguna tabla).
            systemaction(Generate)
            {
                Caption = 'Generar con Copilot';
                ToolTip = 'Usa IA para generar contenido del proveedor';

                trigger OnAction()
                var
                    SystemPrompt: Text;
                    ProgressDialog: Dialog; // [COPILOT] Añadido para mostrar progreso
                begin
                    // [COPILOT] Validación mejorada
                    if InputVendorInfo = '' then begin
                        Message('⚠️ Por favor, introduce información del proveedor antes de generar contenido.');
                        exit;
                    end;

                    if StrLen(InputVendorInfo) < 20 then begin
                        Message('⚠️ La información del proveedor es muy breve. Por favor, proporciona más detalles para obtener mejores resultados.');
                        exit;
                    end;

                    // [COPILOT] Mensaje de progreso
                    ProgressDialog.Open('🤖 Analizando información del proveedor...\Generando contenido con IA...\Por favor, espera...');

                    SystemPrompt := BuildSystemPrompt();
                    OutputContent := CreateSuggestion(SystemPrompt, InputVendorInfo);

                    ProgressDialog.Close();

                    // [COPILOT] Mensaje de éxito
                    if not OutputContent.StartsWith('❌') then
                        Message('✅ Contenido generado exitosamente. Revisa el resultado y confirma si deseas aplicar los cambios.');
                end;
            }
            //Importante: En un PromptDialog, las acciones de sistema como "Generate", "Regenerate" y "Discard" no tienen un SourceTable asociado, ya que no se guardan cambios directamente en una tabla.
            systemaction(OK)
            {
                Caption = 'Confirmar';
                ToolTip = 'Confirmar y guardar cambios';
            }
            systemaction(Cancel)
            {
                Caption = 'Descartar';
                ToolTip = 'Descartar cambios y cerrar el asistente';
            }


        }

        area(PromptGuide)
        {
            action("TechVendor")
            {
                Caption = 'Proveedor Tecnológico';
                ToolTip = 'Ejemplo de proveedor de servicios tecnológicos';

                trigger OnAction()
                begin
                    InputVendorInfo := 'TechSolutions SA - Empresa de desarrollo de software especializada en ERP y CRM. Ubicada en Madrid, 50 empleados, certificada ISO 27001. Servicios: desarrollo custom, consultoría, soporte técnico 24/7.';
                end;
            }

            action("LogisticsVendor")
            {
                Caption = 'Proveedor Logístico';
                ToolTip = 'Ejemplo de proveedor de servicios logísticos';

                trigger OnAction()
                begin
                    InputVendorInfo := 'LogiTrans Express - Empresa de transporte y logística. Opera a nivel nacional con flota de 200 vehículos. Servicios: transporte urgente, almacenaje, distribución last-mile, tracking en tiempo real.';
                end;
            }

            action("SupplierMaterial")
            {
                Caption = 'Proveedor de Materiales';
                ToolTip = 'Ejemplo de proveedor de materiales';

                trigger OnAction()
                begin
                    InputVendorInfo := 'Materiales Construcción López - Distribuidor de materiales de construcción. 30 años en el mercado, almacén de 5000m². Productos: cemento, hierro, herramientas, maquinaria pesada.';
                end;
            }

            // [COPILOT] Acción de ejemplo: Proveedor Financiero
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

            // [COPILOT] Acción de ejemplo: Proveedor de Limpieza
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
        }
    }

    var
        InputVendorInfo: Text;
        OutputContent: Text;
        AssistanceTypeOption: Option "Descripción Completa","Categorización","Términos de Pago","Checklist Onboarding","Análisis de Riesgo","Comparación de Proveedores";
        // [COPILOT] Variables para contexto regional y nivel de detalle
        RegionOption: Option ES,US,MX,AR;
        DetailLevel: Option Basic,Standard,Detailed;
        // [COPILOT] Variable de prioridad
        VendorPriority: Option " ",Critical,Important,Standard;

    /// <summary>
    /// Construye el prompt del sistema según el tipo de asistencia seleccionado.
    /// Esta función determina el mensaje de instrucciones (prompt) que se enviará a la IA,
    /// adaptando el contenido y formato según la opción elegida por el usuario.
    /// El prompt guía a la IA para que genere una respuesta relevante y estructurada.
    /// </summary>
    // [COPILOT] BuildSystemPrompt mejorado para contexto regional y nivel de detalle
    local procedure BuildSystemPrompt(): Text
    var
        SystemPrompt: Text;
        RegionContext: Text;
        DetailContext: Text;
    begin
        // [COPILOT] Construir contexto regional
        if RegionOption <> RegionOption::ES then
            RegionContext := ' Considera las regulaciones y prácticas comerciales específicas de ' + Format(RegionOption) + '.';

        // [COPILOT] Construir contexto de detalle
        case DetailLevel of
            DetailLevel::Basic:
                DetailContext := ' Proporciona una respuesta concisa y directa.';
            DetailLevel::Standard:
                DetailContext := ' Proporciona un análisis equilibrado con ejemplos relevantes.';
            DetailLevel::Detailed:
                DetailContext := ' Proporciona un análisis exhaustivo con múltiples ejemplos y consideraciones avanzadas.';
        end;

        case AssistanceTypeOption of
            AssistanceTypeOption::"Descripción Completa":
                SystemPrompt := 'Eres un experto en gestión de proveedores en Microsoft Dynamics 365 Business Central. ' +
                    'Genera una descripción completa y profesional del proveedor en formato HTML. ' +
                    'Incluye: descripción de servicios, fortalezas principales, consideraciones de riesgo, y recomendaciones de gestión. ' +
                    'Usa formato HTML con encabezados <h3>, listas <ul> y texto en <p>. Sé específico y profesional.';

            AssistanceTypeOption::Categorización:
                SystemPrompt := 'Eres un especialista en categorización de proveedores para sistemas ERP. ' +
                    'Analiza la información y sugiere: categoría principal, subcategoría, código de clasificación sugerido, ' +
                    'nivel de criticidad (Alto/Medio/Bajo) y justificación detallada. ' +
                    'Formato HTML con categorías en <strong> y justificaciones en viñetas <ul>.';

            AssistanceTypeOption::"Términos de Pago":
                SystemPrompt := 'Eres un experto en términos comerciales y gestión de cash flow. ' +
                    'Basándote en el tipo de proveedor y servicios, sugiere: ' +
                    'términos de pago óptimos, descuentos por pronto pago recomendados, ' +
                    'frecuencia de pago sugerida y consideraciones de riesgo financiero. ' +
                    'Incluye ejemplos de códigos de términos de pago para Business Central (ej: 30 DÍAS, NET30, 2%10NET30).';

            AssistanceTypeOption::"Checklist Onboarding":
                SystemPrompt := 'Eres un consultor experto en onboarding de proveedores en entornos empresariales. ' +
                    'Crea un checklist detallado de onboarding específico para este tipo de proveedor. ' +
                    'Incluye: documentación requerida, verificaciones necesarias, ' +
                    'configuraciones en Business Central, responsables y timeline estimado. ' +
                    'Formato HTML con checkboxes (☐) y prioridades marcadas con emojis (🔴 Alta, 🟡 Media, 🟢 Baja).';
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
        end;


        // [COPILOT] Añadir contexto al final del prompt
        exit(SystemPrompt + RegionContext + DetailContext);


    end;

    /// <summary>
    /// Crea la sugerencia usando Azure OpenAI Service.
    /// Esta función orquesta todo el proceso de generación de contenido con IA:
    /// 1. Registra la capacidad de Copilot si no existe.
    /// 2. Configura la conexión a Azure OpenAI (endpoint, deployment, API key, modelo).
    /// 3. Define los parámetros del modelo (máximo de tokens, temperatura).
    /// 4. Prepara los mensajes del chat (sistema y usuario).
    /// 5. Llama al servicio de IA para obtener la respuesta.
    /// 6. Devuelve el contenido generado o un mensaje de error.
    ///
    /// Codeunits utilizadas:
    /// - CopilotCapability: Gestiona el registro y consulta de capacidades Copilot.
    /// - AzureOpenAI: Maneja la autenticación y comunicación con Azure OpenAI.
    /// - AOAIDeployments: Permite obtener información sobre los modelos y despliegues disponibles.
    /// - AOAIChatCompletionParams: Define los parámetros de la solicitud al modelo (tokens, temperatura, etc.).
    /// - AOAIChatMessages: Gestiona los mensajes enviados y recibidos en la conversación con la IA.
    /// - AOAIOperationResponse: Recoge el resultado y estado de la operación de IA.
    /// </summary>
    // [COPILOT] CreateSuggestion mejorada con validaciones, prioridad y mensajes enriquecidos
    local procedure CreateSuggestion(SystemPrompt: Text; VendorInfo: Text): Text
    var
        // Codeunit "Copilot Capability": Gestiona el registro y consulta de capacidades Copilot.
        CopilotCapability: Codeunit "Copilot Capability";
        // Codeunit "Azure OpenAI": Maneja la autenticación y comunicación con Azure OpenAI.
        AzureOpenAI: Codeunit "Azure OpenAI";
        // Codeunit "AOAI Deployments": Permite obtener información sobre los modelos y despliegues disponibles.
        AOAIDeployments: Codeunit "AOAI Deployments";
        // Codeunit "AOAI Chat Completion Params": Define los parámetros de la solicitud al modelo (tokens, temperatura, etc.).
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        // Codeunit "AOAI Chat Messages": Gestiona los mensajes enviados y recibidos en la conversación con la IA.
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        // Codeunit "AOAI Operation Response": Recoge el resultado y estado de la operación de IA.
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        // [COPILOT] Variable para mensaje enriquecido
        EnhancedUserMessage: Text;
    begin
        // Registrar capacidad si no existe
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Vendor Enhancement") then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Vendor Enhancement", 'https://about:none');

        // Configurar Azure OpenAI con managed resources (si se dispone de un recurso administrado)
        //AzureOpenAI.SetManagedResourceAuthorization(
        //    Enum::"AOAI Model Type"::"Chat Completions",
        //    GetEndpoint(),
        //    GetDeployment(),
        //    GetApiKey(),
        //    AOAIDeployments.GetGPT4oLatest()
        //);
        // If you are using your own Azure OpenAI subscription, call this function instead:
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", GetEndpoint(), GetDeployment(), GetApiKey());
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Vendor Enhancement");

        // Configurar parámetros del modelo
        AOAIChatCompletionParams.SetMaxTokens(2000);
        AOAIChatCompletionParams.SetTemperature(0.3); // Un poco de creatividad pero manteniendo precisión

        // [COPILOT] Validación adicional de longitud
        if StrLen(VendorInfo) > 4000 then
            VendorInfo := CopyStr(VendorInfo, 1, 4000) + '...';

        // [COPILOT] Preparar mensaje enriquecido del usuario
        EnhancedUserMessage := 'Información del proveedor: ' + VendorInfo;
        if VendorPriority <> VendorPriority::" " then
            EnhancedUserMessage += ' | Prioridad: ' + Format(VendorPriority);

        // Preparar mensajes del chat
        AOAIChatMessages.AddSystemMessage(SystemPrompt);
        AOAIChatMessages.AddUserMessage(EnhancedUserMessage);

        // Generar respuesta con manejo de errores mejorado
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

        if AOAIOperationResponse.IsSuccess() then
            exit('🎯 ' + AOAIChatMessages.GetLastMessage())
        else
            exit('❌ Error al generar contenido: ' + AOAIOperationResponse.GetError() + '. Intenta nuevamente o contacta al administrador.');
    end;

    // Métodos de configuración (usar valores dummy para demo con managed resources)
    local procedure GetApiKey(): SecretText
    begin
        // En producción real, usar Azure Key Vault o Isolated Storage (ver ejemplo en documentación oficial)
        // Para este demo, usamos un API directamenten ya que es un laboratorio
        exit(Format('FnXj5Vh1LblqLKCXGRUtAdUsZl3wPPauYbZdpMibcksRg931taulJQQJ99BAACYeBjFXJ3w3AAABACOGuFRM'));
    end;

    local procedure GetDeployment(): Text
    begin
        // Para managed resources, el deployment name es manejado automáticamente , aqui indicamos el modelo
        // En este caso, usamos gpt-4o como modelo en la suscripcion azure
        exit('gpt-4o');
    end;

    local procedure GetEndpoint(): Text
    begin
        // Para managed resources, el endpoint es manejado automáticamente , aqui indicamos el endpoint
        // En este caso, usamos el endpoint de Azure OpenAI
        exit('https://circe.openai.azure.com/');
    end;

    /// <summary>
    /// Método público para pre-llenar información del proveedor (llamado desde extensiones)
    /// </summary>
    procedure SetVendorInfo(VendorName: Text; VendorSearchName: Text)
    begin
        InputVendorInfo := VendorName;
        if VendorSearchName <> '' then
            InputVendorInfo += ' - ' + VendorSearchName;
    end;
}