namespace YourCompany.VendorCopilot;
using Microsoft.Purchases.Vendor;

/// <summary>
/// Extensión de la página Vendor List para agregar acceso al asistente Copilot
/// </summary>
pageextension 50100 "Vendor List Copilot Ext" extends "Vendor List"
{
    actions
    {
        addfirst(Prompting)
        {
            action("VendorCopilotAssistant")
            {
                ApplicationArea = All;
                Caption = 'Asistente Copilot';
                ToolTip = 'Usa IA para generar información detallada de proveedores';
                Image = Sparkle;

                trigger OnAction()
                begin
                    Page.Run(Page::"Vendor Copilot Assistant");
                end;
            }
        }
    }
}