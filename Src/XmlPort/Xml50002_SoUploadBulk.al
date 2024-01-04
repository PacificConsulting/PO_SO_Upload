xmlport 50002 "Sales Bulk Upload"
{
    Format = VariableText;
    Direction = Import;
    schema
    {
        textelement(root)
        {
            tableelement("Sales HeaderD"; "Sales Header")
            {
                AutoSave = false;
                MinOccurs = Zero;
                XmlName = 'SalesHeader';
                textelement("DocumentType")
                {
                }
                textelement("DocumentNo.")
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(CustNo)
                {
                }
                textelement(ShipToCOde)
                {
                }
                textelement(BIllToCOde)
                {
                }
                textelement(Locationcode)
                {
                }
                textelement(Type)
                {
                }
                textelement(No)
                {
                }
                textelement(Quantity)
                {
                }
                textelement(UnitPrice)
                {
                }
                textelement(LineDiscAmt)
                {
                }
                textelement("PaymentTermsCode")
                {
                }
                textelement(ExtDOCNo)
                {
                }

                textelement(GenProdpost)
                {
                }
                textelement(Site)
                {
                }

                textelement(Store)
                {
                }





                trigger OnAfterInitRecord()
                begin


                end;

                trigger OnAfterModifyRecord()
                begin

                end;

                trigger OnBeforeInsertRecord()
                begin

                    if DocumentType = 'Document Type' then
                        currXMLport.Skip();

                    "Sales Header".Reset();
                    if DocumentType = 'Invoice' then
                        "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::Invoice);
                    if DocumentType = 'Order' then
                        "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::Order);
                    if DocumentType = 'Credit Memo' then
                        "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::"Credit Memo");
                    if DocumentType = 'Quote' then
                        "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::Quote);
                    if DocumentType = 'Return Order' then
                        "Sales Header".SetRange("Document Type", "Sales Header"."Document Type"::"Return Order");
                    "Sales Header".SetRange("No.", "DocumentNo.");
                    if "Sales Header".FindFirst() then begin
                        SalesLine2.Reset();
                        SalesLine2.SetRange("Document Type", "Sales Header"."Document Type");
                        SalesLine2.SetRange("Document No.", "Sales Header"."No.");
                        if SalesLine2.FindLast() then begin
                            NewLineNo := SalesLine2."Line No." + 10000;
                        end else begin
                            NewLineNo := 10000;
                        end;
                        SalesLine.INIT;

                        SalesLine."Document Type" := "Sales Header"."Document Type";
                        SalesLine.VALIDATE("Document No.", "Sales Header"."No.");
                        NewLineNo += 10000;
                        SalesLine."Line No." := NewLineNo;
                        SalesLine.VALIDATE("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                        IF Type = 'Item' THEN
                            SalesLine.Type := SalesLine.Type::Item
                        ELSE
                            SalesLine.Type := SalesLine.Type::"G/L Account";

                        SalesLine.Validate("No.", No);
                        SalesLine.VALIDATE("Location Code", Locationcode);
                        EVALUATE(Qty, Quantity);
                        SalesLine.VALIDATE(Quantity, Qty);
                        EVALUATE(UnitPriceV, UnitPrice);
                        SalesLine.VALIDATE("Unit Price", UnitPriceV);
                        SalesLine.VALIDATE("Shortcut Dimension 1 Code", Site);
                        SalesLine.VALIDATE("Shortcut Dimension 2 Code", Store);
                        SalesLine."Gen. Prod. Posting Group" := GenProdpost;
                        Clear(LineDiscAmtV);
                        if LineDiscAmt <> '' then begin
                            Evaluate(LineDiscAmtV, LineDiscAmt);
                            SalesLine.Validate("Line Discount Amount", LineDiscAmtV);
                        end;
                        SalesLine.INSERT(TRUE);
                    end else begin

                        IF ("Sales Header"."No." <> "DocumentNo.") THEN BEGIN
                            "Sales Header".INIT;
                            if DocumentType = 'Invoice' then
                                "Sales Header"."Document Type" := "Sales Header"."Document Type"::Invoice;
                            if DocumentType = 'Order' then
                                "Sales Header"."Document Type" := "Sales Header"."Document Type"::Order;
                            if DocumentType = 'Credit Memo' then
                                "Sales Header"."Document Type" := "Sales Header"."Document Type"::"Credit Memo";
                            if DocumentType = 'Quote' then
                                "Sales Header"."Document Type" := "Sales Header"."Document Type"::Quote;
                            if DocumentType = 'Return Order' then
                                "Sales Header"."Document Type" := "Sales Header"."Document Type"::"Return Order";
                            "Sales Header".VALIDATE("No.", "DocumentNo.");
                            EVALUATE(postDate, PostingDate);
                            "Sales Header".VALIDATE("Posting Date", postDate);
                            "Sales Header".VALIDATE("Sell-to Customer No.", CustNo);
                            "Sales Header".VALIDATE("External Document No.", ExtDOCNo);
                            "Sales Header".VALIDATE("Location Code", Locationcode); //New Change
                            if BIllToCOde <> '' then
                                "Sales Header".VALIDATE("Bill-to Customer No.", BIllToCOde); //New Change
                            "Sales Header".VALIDATE("Payment Terms Code", PaymentTermsCode);
                            if ShipToCOde <> '' then
                                "Sales Header".Validate("Ship-to Code", ShipToCOde);
                            "Sales Header".INSERT(TRUE);
                            "Sales Header".VALIDATE("Shortcut Dimension 1 Code", Site);
                            "Sales Header".VALIDATE("Shortcut Dimension 2 Code", Store);
                            "Sales Header".MODIFY;

                            SalesLine.INIT;


                            SalesLine."Document Type" := "Sales Header"."Document Type";
                            SalesLine.VALIDATE("Document No.", "Sales Header"."No.");
                            NewLineNo += 10000;
                            SalesLine."Line No." := NewLineNo;
                            SalesLine.VALIDATE("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
                            IF Type = 'Item' THEN
                                SalesLine.Type := SalesLine.Type::Item
                            ELSE
                                SalesLine.Type := SalesLine.Type::"G/L Account";

                            SalesLine.Validate("No.", No);
                            SalesLine.VALIDATE("Location Code", Locationcode);
                            EVALUATE(Qty, Quantity);
                            SalesLine.VALIDATE(Quantity, Qty);
                            EVALUATE(UnitPriceV, UnitPrice);
                            SalesLine.VALIDATE("Unit Price", UnitPriceV);
                            SalesLine.VALIDATE("Shortcut Dimension 1 Code", Site);
                            SalesLine.VALIDATE("Shortcut Dimension 2 Code", Store);
                            SalesLine."Gen. Prod. Posting Group" := GenProdpost;
                            Clear(LineDiscAmtV);
                            if LineDiscAmt <> '' then begin
                                Evaluate(LineDiscAmtV, LineDiscAmt);
                                SalesLine.Validate("Line Discount Amount", LineDiscAmtV);
                            end;

                            SalesLine.INSERT(TRUE);
                        end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('Data Uploaded Successfully')
    end;

    trigger OnPreXmlPort()
    begin
        //i := 0;
    end;

    var
        Qtytext: Decimal;
        LineDiscAmtV: Decimal;
        SalesLine: Record 37;
        SalesLine2: Record 37;
        //SaleLine: Record 37;
        i: Integer;
        postDate: Date;
        DocDate: Date;
        datedue: Date;
        NewLineNo: Integer;
        TypeGSTGroup: Option Goods,Service;
        Qty: Decimal;
        UnitPriceV: Decimal;
        SalesHeader: Record 36;
        Vend: Record 23;
        Location1: Record 14;
        SalesHead: Record 36;
        "Sales Header": Record 36;
    //  NODHeader: Record "NOD/NOC Header";//13786; //pcpl-065
}

