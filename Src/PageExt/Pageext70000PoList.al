pageextension 70000 PoListExtPOSoEt extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Post)
        {
            action("Import PO")
            {
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                var
                    ImpPOXml: XmlPort "Purchase Bulk Upload";
                begin
                    ImpPOXml.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}