namespace YourCompany.VendorCopilot;
using System.AI;

/// <summary>
/// Página principal del asistente Copilot para gestión de proveedores
/// Permite generar descripciones, categorías, términos de pago y checklists
/// </summary>
page 50100 "Vendor Copilot Assistant"
{
    PageType = PromptDialog;
    ApplicationArea = All;
    Caption = 'Vendor Copilot Assistant';
    PromptMode = Prompt;
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
                OptionCaption = 'Descripción Completa,Categorización,Términos de Pago,Checklist Onboarding';
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
            systemaction(Generate)
            {
                Caption = 'Generar con Copilot';
                ToolTip = 'Usa IA para generar contenido del proveedor';
                
                trigger OnAction()
                var
                    SystemPrompt: Text;
                begin
                    if InputVendorInfo = '' then begin
                        Message('Por favor, introduce información del proveedor.');
                        exit;
                    end;

                    SystemPrompt := BuildSystemPrompt();
                    OutputContent := CreateSuggestion(SystemPrompt, InputVendorInfo);
                end;
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
        }
    }

    var
        InputVendorInfo: Text;
        OutputContent: Text;
        AssistanceTypeOption: Option "Descripción Completa","Categorización","Términos de Pago","Checklist Onboarding";

    /// <summary>
    /// Construye el prompt del sistema según el tipo de asistencia seleccionado
    /// </summary>
    local procedure BuildSystemPrompt(): Text
    var
        SystemPrompt: Text;
    begin
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
        end;
        
        exit(SystemPrompt);
    end;

    /// <summary>
    /// Crea la sugerencia usando Azure OpenAI Service
    /// </summary>
    local procedure CreateSuggestion(SystemPrompt: Text; VendorInfo: Text): Text
    var
        CopilotCapability: Codeunit "Copilot Capability";
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIDeployments: Codeunit "AOAI Deployments";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
    begin
        // Registrar capacidad si no existe
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Vendor Enhancement") then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Vendor Enhancement", 'https://about:none');

        // Configurar Azure OpenAI con managed resources (para demo)
        AzureOpenAI.SetManagedResourceAuthorization(
            Enum::"AOAI Model Type"::"Chat Completions",
            GetEndpoint(), 
            GetDeployment(), 
            GetApiKey(), 
            AOAIDeployments.GetGPT4oLatest()
        );
        
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Vendor Enhancement");

        // Configurar parámetros del modelo
        AOAIChatCompletionParams.SetMaxTokens(2000);
        AOAIChatCompletionParams.SetTemperature(0.3); // Un poco de creatividad pero manteniendo precisión

        // Preparar mensajes del chat
        AOAIChatMessages.AddSystemMessage(SystemPrompt);
        AOAIChatMessages.AddUserMessage(VendorInfo);

        // Generar respuesta
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        
        if AOAIOperationResponse.IsSuccess() then
            exit(AOAIChatMessages.GetLastMessage())
        else
            exit('❌ Error al generar contenido: ' + AOAIOperationResponse.GetError());
    end;

    // Métodos de configuración (usar valores dummy para demo con managed resources)
    local procedure GetApiKey(): SecretText
    begin
        // En producción real, usar Azure Key Vault o Isolated Storage
        // Para este demo, usamos un GUID dummy ya que usamos managed resources
        exit(Format(CreateGuid()));
    end;

    local procedure GetDeployment(): Text
    begin
        // Para managed resources, el deployment name es manejado automáticamente
        exit('gpt-4o-demo');
    end;

    local procedure GetEndpoint(): Text
    begin
        // Para managed resources, el endpoint es manejado automáticamente
        exit('https://demo-deployment.openai.azure.com/');
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