pageextension 70001 SoListExtPOSoEt extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Post)
        {
            action("Import SO")
            {
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                var
                    ImpPOXml: XmlPort "Sales Bulk Upload";
                begin
                    ImpPOXml.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}