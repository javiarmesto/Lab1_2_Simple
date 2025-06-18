namespace YourCompany.VendorCopilot;
using Microsoft.Purchases.Vendor;

/// <summary>
/// Extensión de la página Vendor Card para agregar funcionalidad Copilot contextual
/// </summary>
pageextension 50101 "Vendor Card Copilot Ext" extends "Vendor Card"
{
    actions
    {
        addfirst(Prompting)
        {
            action("EnhanceWithCopilot")
            {
                ApplicationArea = All;
                Caption = 'Mejorar con Copilot';
                ToolTip = 'Usa IA para generar descripción y categorización basada en la información actual del proveedor';
                Image = Robot;
                
                trigger OnAction()
                var
                    VendorCopilotPage: Page "Vendor Copilot Assistant";
                begin
                    // Pre-rellenar con información actual del proveedor
                    VendorCopilotPage.SetVendorInfo(Rec.Name, Rec."Search Name");
                    VendorCopilotPage.RunModal();
                end;
            }
        }
    }
}