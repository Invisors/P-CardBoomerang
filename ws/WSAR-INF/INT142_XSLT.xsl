<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ws="urn:com.workday/workersync" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xtt="urn:com.workday/xtt" 
    xmlns:etv="urn:com.workday/etv" 
    xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:wd="urn:com.workday/bsvc"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="wd:Report_Data">
        <root>
            <xsl:apply-templates select="wd:Report_Entry"/>
        </root>
    </xsl:template>
    
    <xsl:template match="wd:Report_Entry">
        <env:Envelope 
            xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <env:Body>
                <wd:Put_Ad_Hoc_Project_Transaction_Request 
                    xmlns:wd="urn:com.workday/bsvc"
                    wd:Add_Only="true"
                    wd:version="v36.1">
                    <wd:BusDocID><xsl:value-of select="wd:Business_Document/@wd:Descriptor"/></wd:BusDocID>
                    <wd:Ad_Hoc_Project_Transaction_Data>
                        <wd:Ad_Hoc_Project_Transaction_ID>
                            <xsl:value-of select="concat(wd:Reference_ID,'-',wd:WID)"/>
                        </wd:Ad_Hoc_Project_Transaction_ID>
                        <wd:Project_Transaction_Source_Reference>
                            <wd:ID wd:type="Project_Transaction_Source_ID">EXPENSE</wd:ID>
                        </wd:Project_Transaction_Source_Reference>
                        <wd:Ad_Hoc_Project_Expense_Transaction_Data>
                            <wd:Project_Reference>
                                <wd:ID wd:type="Project_ID">
                                    <xsl:value-of select="wd:project/wd:ID[@wd:type = 'Project_ID']"/>                                 
                                </wd:ID>
                            </wd:Project_Reference>
                            <wd:Billing_Status_Reference>
                                <wd:ID wd:type="Document_Status_ID">Awaiting Review</wd:ID>
                            </wd:Billing_Status_Reference>
                            <wd:Transaction_Date>
                                <xsl:value-of
                                    select="wd:Credit_Card_Transaction_group/wd:Credit_Card_Charge_Date"/>
                            </wd:Transaction_Date>
                            <wd:Worker_Reference>
                                <xsl:choose>
                                    <xsl:when test="wd:project_group/wd:Worker">
                                        <wd:ID wd:type="Employee_ID">
                                            <xsl:value-of
                                                select="wd:project_group/wd:Worker[1]/wd:ID[@wd:type = 'Employee_ID']"/>
                                        </wd:ID>
                                    </xsl:when>
                                    <xsl:otherwise> </xsl:otherwise>
                                </xsl:choose>
                            </wd:Worker_Reference>
                            <wd:Project_Task_Reference>
                                <xsl:choose>
                                    <xsl:when test="wd:Project_Plan_Task">
                                        <wd:ID wd:type="Project_Plan_ID">
                                            <xsl:value-of
                                                select="wd:Project_Plan_Task/wd:ID[@wd:type = 'Project_Plan_ID']"/>
                                        </wd:ID>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </wd:Project_Task_Reference>
                            <wd:Spend_Category_Reference>
                                <wd:ID wd:type="Spend_Category_ID">
                                    <xsl:value-of
                                        select="wd:Spend_Category_as_Worktag/wd:ID[@wd:type = 'Spend_Category_ID']"
                                    />
                                </wd:ID>
                            </wd:Spend_Category_Reference>
                            <wd:Quantity>
                                <xsl:choose>
                                    <xsl:when
                                        test="wd:Distribution_Extended_Amount > 0">
                                        <xsl:text>1</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>-1</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </wd:Quantity>
                            <wd:Include_Cost>true</wd:Include_Cost>
                            <wd:Ad_Hoc_Project_Expense_Billing_Reference>
                              <!--  <wd:Unit_Billing_Amount>
                                    <xsl:value-of
                                        select="wd:Credit_Card_Transaction_group/wd:Credit_Card_Extended_Amount"/>
                                </wd:Unit_Billing_Amount>-->
                                <wd:Extended_Billing_Amount>
                                    <xsl:value-of
                                        select="wd:Distribution_Extended_Amount"/>
                                </wd:Extended_Billing_Amount>
                                <wd:Billing_Currency_Reference>
                                    <wd:ID wd:type="Currency_ID">
                                        <xsl:value-of
                                            select="wd:Credit_Card_Transaction_group/wd:Target_Currency/wd:ID[@wd:type = 'Currency_ID']"/>
                                    </wd:ID>
                                </wd:Billing_Currency_Reference>
                            </wd:Ad_Hoc_Project_Expense_Billing_Reference>
                            <wd:Worktags_Reference>
                                <wd:ID wd:type="Organization_Reference_ID">
                                    <xsl:value-of
                                        select="wd:Division/wd:ID[@wd:type = 'Organization_Reference_ID']"
                                    />
                                </wd:ID>
                            </wd:Worktags_Reference>
                            <wd:Worktags_Reference>
                                <wd:ID wd:type="Organization_Reference_ID">
                                    <xsl:value-of
                                        select="wd:Segment/wd:ID[@wd:type = 'Organization_Reference_ID']"
                                    />
                                </wd:ID>
                            </wd:Worktags_Reference>
                            <wd:Worktags_Reference>
                                <wd:ID wd:type="Organization_Reference_ID">
                                    <xsl:value-of
                                        select="wd:Specialty/wd:ID[@wd:type = 'Organization_Reference_ID']"
                                    />
                                </wd:ID>
                            </wd:Worktags_Reference>
                            <wd:Worktags_Reference>
                                <wd:ID wd:type="Organization_Reference_ID">
                                    <xsl:value-of
                                        select="wd:Cost_Center/wd:ID[@wd:type = 'Organization_Reference_ID']"
                                    />
                                </wd:ID>
                            </wd:Worktags_Reference>
                            <wd:Worktags_Reference>
                                <wd:ID wd:type="Organization_Reference_ID">
                                    <xsl:value-of
                                        select="wd:Revenue_Organization/wd:ID[@wd:type = 'Organization_Reference_ID']"/>
                                </wd:ID>
                            </wd:Worktags_Reference>
                            <wd:Worktags_Reference>
                                <xsl:choose>
                                    <xsl:when test="wd:project_group/wd:IC_Supplier">
                                        <wd:ID wd:type="Supplier_ID">
                                            <xsl:value-of
                                                select="wd:project_group/wd:IC_Supplier[1]/wd:ID[@wd:type = 'Supplier_ID']"/>
                                        </wd:ID>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </wd:Worktags_Reference>
                            <wd:Memo>
                                <xsl:value-of select="wd:Line_Description"/>
                            </wd:Memo>
                        </wd:Ad_Hoc_Project_Expense_Transaction_Data>
                    </wd:Ad_Hoc_Project_Transaction_Data>
                </wd:Put_Ad_Hoc_Project_Transaction_Request>
            </env:Body>
        </env:Envelope>
    </xsl:template>
</xsl:stylesheet>