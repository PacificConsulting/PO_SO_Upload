xmlport 50001 "Purchase Bulk Upload"
{
    Format = VariableText;
    Direction = Import;

    schema
    {
        textelement(root)
        {
            tableelement("Purchase HeaderD"; "Purchase Header")
            {
                AutoSave = false;
                MinOccurs = Zero;
                XmlName = 'PurchaseHeader';
                textelement("DocumentType")
                {
                }
                textelement("DocumentNo.")
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(VendorNo)
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
                textelement(directUnitCost)
                {
                }
                textelement("PaymentTermsCode")
                {
                }
                textelement(VendorInvNo)
                {
                }
                textelement(VendorInvDate)
                {
                }
                // textelement(GenbusPost)
                // {
                // }
                textelement(GenProdpost)
                {
                }
                textelement(Site)
                {
                }

                textelement(Store)
                {
                }




                // textelement(DueDate)
                // {
                // }

                // textelement(CurrencyCode)
                // {
                // }



                // textelement(Description)
                // {
                // }
                // textelement(GSTGroupCode)
                // {
                // }
                // textelement(GSTGroupType)
                // {
                // }
                // textelement(HSN)
                // {
                // }




                // textelement(DimDept)
                // {
                // }
                // textelement(DimProd)
                // {
                // }


                // textelement(TDSReason)
                // {
                // }
                // textelement(StructureNew)
                // {
                // }
                // textelement(Post_Description)
                // {
                // }

                trigger OnAfterInitRecord()
                begin


                end;

                trigger OnAfterModifyRecord()
                begin
                    // IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice, "Purchase Header"."No.") THEN BEGIN
                    //     PurchaseLine.RESET;
                    //     PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Invoice);
                    //     PurchaseLine.SETRANGE("Document No.", InvNo);
                    //     IF PurchaseLine.FINDLAST THEN
                    //         //PurchaseHeader.VALIDATE("Pay-to Vendor No.","Purchase Header"."Pay-to Vendor No."); //New Change
                    //         PurchaseHeader.VALIDATE("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                    //     PurchaseHeader.MODIFY(TRUE);
                    // END;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    //Message(DocumentType);
                    if DocumentType = 'Document Type' then
                        currXMLport.Skip();

                    "Purchase Header".Reset();
                    if DocumentType = 'Invoice' then
                        "Purchase Header".SetRange("Document Type", "Purchase Header"."Document Type"::Invoice);
                    if DocumentType = 'Order' then
                        "Purchase Header".SetRange("Document Type", "Purchase Header"."Document Type"::Order);
                    if DocumentType = 'Credit Memo' then
                        "Purchase Header".SetRange("Document Type", "Purchase Header"."Document Type"::"Credit Memo");
                    if DocumentType = 'Quote' then
                        "Purchase Header".SetRange("Document Type", "Purchase Header"."Document Type"::Quote);
                    if DocumentType = 'Return Order' then
                        "Purchase Header".SetRange("Document Type", "Purchase Header"."Document Type"::"Return Order");
                    "Purchase Header".SetRange("No.", "DocumentNo.");
                    if "Purchase Header".FindFirst() then begin
                        PurchaseLine2.Reset();
                        PurchaseLine2.SetRange("Document Type", "Purchase Header"."Document Type");
                        PurchaseLine2.SetRange("Document No.", "Purchase Header"."No.");
                        if PurchaseLine2.FindLast() then begin
                            NewLineNo := PurchaseLine2."Line No." + 10000;
                        end else begin
                            NewLineNo := 10000;
                        end;
                        PurchaseLine.INIT;

                        PurchaseLine."Document Type" := "Purchase Header"."Document Type";
                        PurchaseLine.VALIDATE("Document No.", "Purchase Header"."No.");
                        NewLineNo += 10000;
                        PurchaseLine."Line No." := NewLineNo;
                        PurchaseLine.VALIDATE("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                        IF Type = 'Item' THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item
                        ELSE
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";

                        PurchaseLine.Validate("No.", No);
                        PurchaseLine.VALIDATE("Location Code", Locationcode);
                        EVALUATE(Qty, Quantity);
                        PurchaseLine.VALIDATE(Quantity, Qty);
                        EVALUATE(directCost, directUnitCost);
                        PurchaseLine.VALIDATE("Direct Unit Cost", directCost);
                        PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", Site);
                        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", Store);
                        PurchaseLine."Gen. Prod. Posting Group" := GenProdpost;
                        PurchaseLine.INSERT(TRUE);
                    end else begin

                        IF ("Purchase Header"."No." <> "DocumentNo.") THEN BEGIN
                            "Purchase Header".INIT;
                            if DocumentType = 'Invoice' then
                                "Purchase Header"."Document Type" := "Purchase Header"."Document Type"::Invoice;
                            if DocumentType = 'Order' then
                                "Purchase Header"."Document Type" := "Purchase Header"."Document Type"::Order;
                            if DocumentType = 'Credit Memo' then
                                "Purchase Header"."Document Type" := "Purchase Header"."Document Type"::"Credit Memo";
                            if DocumentType = 'Quote' then
                                "Purchase Header"."Document Type" := "Purchase Header"."Document Type"::Quote;
                            if DocumentType = 'Return Order' then
                                "Purchase Header"."Document Type" := "Purchase Header"."Document Type"::"Return Order";
                            "Purchase Header".VALIDATE("No.", "DocumentNo.");
                            if VendorInvDate <> '' then begin
                                EVALUATE(DocDate, VendorInvDate);
                                "Purchase Header".VALIDATE("Document Date", DocDate);
                            end;

                            EVALUATE(postDate, PostingDate);
                            "Purchase Header".VALIDATE("Posting Date", postDate);

                            "Purchase Header".VALIDATE("Buy-from Vendor No.", VendorNo);
                            "Purchase Header".VALIDATE("Vendor Invoice No.", VendorInvNo);
                            "Purchase Header".VALIDATE("Location Code", Locationcode); //New Change
                            "Purchase Header".VALIDATE("Pay-to Vendor No.", VendorNo); //New Change
                            "Purchase Header".VALIDATE("Payment Terms Code", PaymentTermsCode);

                            "Purchase Header".INSERT(TRUE);
                            "Purchase Header".VALIDATE("Shortcut Dimension 1 Code", Site);
                            "Purchase Header".VALIDATE("Shortcut Dimension 2 Code", Store);
                            "Purchase Header".MODIFY;

                            PurchaseLine.INIT;

                            PurchaseLine."Document Type" := "Purchase Header"."Document Type";
                            PurchaseLine.VALIDATE("Document No.", "Purchase Header"."No.");
                            NewLineNo += 10000;
                            PurchaseLine."Line No." := NewLineNo;
                            PurchaseLine.VALIDATE("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                            IF Type = 'Item' THEN
                                PurchaseLine.Type := PurchaseLine.Type::Item
                            ELSE
                                PurchaseLine.Type := PurchaseLine.Type::"G/L Account";

                            PurchaseLine.Validate("No.", No);
                            PurchaseLine.VALIDATE("Location Code", Locationcode);
                            EVALUATE(Qty, Quantity);
                            PurchaseLine.VALIDATE(Quantity, Qty);
                            EVALUATE(directCost, directUnitCost);
                            PurchaseLine.VALIDATE("Direct Unit Cost", directCost);
                            PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", Site);
                            PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", Store);
                            PurchaseLine."Gen. Prod. Posting Group" := GenProdpost;
                            PurchaseLine.INSERT(TRUE);
                        end;
                    end;

                    //     CLEAR(PurchaseLine);
                    //     IF "Purchase Header".GET("Purchase Header"."Document Type"::Invoice, InvNo) THEN BEGIN
                    //         //PurchaseHeader.VALIDATE(PurchaseHeader."Shortcut Dimension 1 Code",DimDept);
                    //         //PurchaseHeader.VALIDATE(PurchaseHeader."Shortcut Dimension 2 Code",DimProd);
                    //         //PurchaseHeader.MODIFY;
                    //         PurchaseLine.RESET;
                    //         PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Invoice);
                    //         PurchaseLine.SETRANGE("Document No.", InvNo);
                    //         IF PurchaseLine.FINDLAST THEN BEGIN

                    //             PurchaseLine.INIT;
                    //             PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
                    //             PurchaseLine.VALIDATE("Document No.", "Purchase Header"."No.");
                    //             NewLineNo += 10000;
                    //             PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;

                    //             PurchaseLine.VALIDATE("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                    //             PurchaseLine.VALIDATE("Pay-to Vendor No.", "Purchase Header"."Pay-to Vendor No.");//New Change
                    //             IF Type = 'Item' THEN
                    //                 PurchaseLine.Type := PurchaseLine.Type::Item
                    //             ELSE
                    //                 PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                    //             PurchaseLine."No." := No;
                    //             PurchaseLine.Description := Description;
                    //             //PurchaseLine.INSERT(TRUE);
                    //             EVALUATE(TypeGSTGroup, GSTGroupType);
                    //             PurchaseLine.VALIDATE("GST Group Type", TypeGSTGroup);
                    //             PurchaseLine.VALIDATE("GST Group Code", GSTGroupCode);
                    //             PurchaseLine.VALIDATE("HSN/SAC Code", HSN);
                    //             PurchaseLine.VALIDATE("Location Code", Locationcode);
                    //             EVALUATE(Qty, Quantity);
                    //             PurchaseLine.VALIDATE(Quantity, Qty);
                    //             PurchaseLine.VALIDATE("Unit of Measure Code", uom);
                    //             EVALUATE(directCost, directUnitCost);
                    //             PurchaseLine.VALIDATE("Direct Unit Cost", directCost);
                    //             //PCPL
                    //             PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", DimDept);
                    //             PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", DimProd);
                    //             //PCPL
                    //             PurchaseLine."Shortcut Dimension 1 Code" := DimDept; //
                    //             PurchaseLine."Shortcut Dimension 2 Code" := DimProd; //
                    //             PurchaseLine."Gen. Bus. Posting Group" := GenbusPost;
                    //             PurchaseLine."Gen. Prod. Posting Group" := GenProdpost;
                    //             PurchaseLine."TDS Reason Code" := TDSReason;//PCPL/NSW/260620
                    //                                                         //PurchaseLine.VALIDATE(st)
                    //             PurchaseLine.INSERT(TRUE);

                    //         END;
                    //     END ELSE
                    //         IF ("Purchase Header"."No." <> InvNo) THEN BEGIN
                    //             "Purchase Header".INIT;
                    //             "Purchase Header"."Document Type" := "Purchase Header"."Document Type"::Invoice;
                    //             "Purchase Header".VALIDATE("No.", InvNo);
                    //             EVALUATE(postDate, PostingDate);
                    //             "Purchase Header".VALIDATE("Posting Date", postDate);
                    //             "Purchase Header".VALIDATE("Buy-from Vendor No.", VendorNo);    // "Purchase Header"."Currency Code"
                    //             EVALUATE(DocDate, DocumentDate);
                    //             "Purchase Header".VALIDATE("Document Date", DocDate);
                    //             "Purchase Header".VALIDATE("Vendor Invoice No.", VendorInvNo);
                    //             //PCPL-New Change Dt: 26/10/2017
                    //             "Purchase Header".VALIDATE("Location Code", Locationcode);
                    //             //PCPL-New Change Dt: 26/10/2017
                    //             EVALUATE(datedue, DueDate);
                    //             //"Purchase Header".VALIDATE("Due Date",datedue);

                    //             "Purchase Header".VALIDATE("Vendor Order No.", VendorOrderNo);
                    //             "Purchase Header".VALIDATE("Currency Code", CurrencyCode);
                    //             "Purchase Header".VALIDATE("Location Code", Locationcode); //New Change
                    //             "Purchase Header".VALIDATE("Pay-to Vendor No.", VendorNo); //New Change
                    //             "Purchase Header".VALIDATE("Payment Terms Code", DueDate);
                    //             // "Purchase Header".VALIDATE(Structure, StructureNew);//PCPl/NSW/020720  //pcpl-065
                    //             "Purchase Header".VALIDATE("Posting Description", Post_Description);//PCPl/NSW/020720

                    //             "Purchase Header".INSERT(TRUE);
                    //             "Purchase Header".VALIDATE("Shortcut Dimension 1 Code", DimDept);
                    //             "Purchase Header".VALIDATE("Shortcut Dimension 2 Code", DimProd);
                    //             //<<OA.DT
                    //             IF Vend.GET("Purchase Header"."Pay-to Vendor No.") THEN BEGIN
                    //                 IF Vend."GST Registration No." <> '' THEN BEGIN
                    //                     "Purchase Header"."Vendor GST Reg. No." := Vend."GST Registration No.";

                    //                     IF Location1.GET(PurchaseHeader."Location Code") THEN BEGIN
                    //                         "Purchase Header"."Location GST Reg. No." := Location1."GST Registration No.";
                    //                         "Purchase Header"."Location State Code" := Location1."State Code";
                    //                     END;
                    //                 END;
                    //                 /*
                    //                 IF NODHeader.GET(NODHeader.Type::Vendor, "Purchase Header"."Pay-to Vendor No.") THEN
                    //                     "Purchase Header".VALIDATE("Assessee Code", NODHeader."Assesse Code")
                    //                 ELSE
                    //                     "Purchase Header".VALIDATE("Assessee Code", '');
                    //                     */
                    //             END;

                    //             //>>OA.DT

                    //             "Purchase Header".MODIFY;
                    //             PurchaseLine.INIT;

                    //             PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
                    //             PurchaseLine.VALIDATE("Document No.", "Purchase Header"."No.");
                    //             NewLineNo += 10000;
                    //             PurchaseLine."Line No." := NewLineNo;

                    //             PurchaseLine.VALIDATE("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");

                    //             PurchaseLine.VALIDATE("Pay-to Vendor No.", "Purchase Header"."Pay-to Vendor No.");//New Change

                    //             IF Type = 'Item' THEN
                    //                 PurchaseLine.Type := PurchaseLine.Type::Item
                    //             ELSE
                    //                 PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                    //             PurchaseLine."No." := No;
                    //             PurchaseLine.Description := Description;
                    //             EVALUATE(TypeGSTGroup, GSTGroupType);
                    //             //PurchaseLine."GST Group Type"::Service

                    //             PurchaseLine.VALIDATE("GST Group Type", TypeGSTGroup);
                    //             PurchaseLine.VALIDATE("GST Group Code", GSTGroupCode);
                    //             PurchaseLine.VALIDATE("HSN/SAC Code", HSN);
                    //             PurchaseLine.VALIDATE("Location Code", Locationcode);
                    //             EVALUATE(Qty, Quantity);
                    //             PurchaseLine.VALIDATE(Quantity, Qty);
                    //             PurchaseLine.VALIDATE("Unit of Measure Code", uom);
                    //             EVALUATE(directCost, directUnitCost);
                    //             PurchaseLine.VALIDATE("Direct Unit Cost", directCost);
                    //             PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", DimDept);
                    //             PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", DimProd);
                    //             PurchaseLine."Gen. Bus. Posting Group" := GenbusPost;
                    //             PurchaseLine."Gen. Prod. Posting Group" := GenProdpost;
                    //             PurchaseLine."TDS Reason Code" := TDSReason;//PCPL/NSW/260620
                    //                                                         //OA.DT<<
                    //             PurchHead.SETRANGE("Document Type", PurchaseLine."Document Type");
                    //             PurchHead.SETRANGE("No.", PurchaseLine."Document No.");
                    //             IF PurchHead.FINDSET THEN BEGIN
                    //                 PurchaseLine."Buy-From GST Registration No" := PurchHead."Vendor GST Reg. No.";
                    //                 PurchaseLine.VALIDATE("State Code", PurchHead.State);
                    //             END;
                    //             //OA.DT>>

                    //             PurchaseLine.INSERT(TRUE);
                    //         END;
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
        PurchaseLine: Record 39;
        PurchaseLine2: Record 39;
        //purchLine: Record 39;
        i: Integer;
        postDate: Date;
        DocDate: Date;
        datedue: Date;
        NewLineNo: Integer;
        TypeGSTGroup: Option Goods,Service;
        Qty: Decimal;
        directCost: Decimal;
        PurchaseHeader: Record 38;
        Vend: Record 23;
        Location1: Record 14;
        PurchHead: Record 38;
        "Purchase Header": Record 38;
    //  NODHeader: Record "NOD/NOC Header";//13786; //pcpl-065
}

