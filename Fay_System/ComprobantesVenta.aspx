<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="ComprobantesVenta.aspx.cs" Inherits="Fay_System.ComprobantesVenta" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function LoadData(s, e) {
            if (rblOpUnidades.GetValue() == 'Servicios') {
                cpObtainDataGv.PerformCallback(1);
            }
            else {
                cpObtainDataGv.PerformCallback(2);
            }
        }

        function OcultarGrids(s, e) {
            if (rblOpUnidades.GetValue() == 'Servicios')
                dgMateriales.SetVisible(false);
            else dgServicios.SetVisible(false);
        }

        function ClickApplyCreditNote(s, e) {
            if (ASPxClientEdit.ValidateGroup('ComprobNC'))
                e.processOnServer = true;
            else e.processOnserver = false;
        }

        function BotonesComprobantes(s, e) {
            if (e.buttonID == 'NotaCredito') {
                var iniciales = s.batchEditApi.GetCellValue(e.visibleIndex, 'Serie').substring(0, 2);
                if (iniciales == 'BC' || iniciales == 'FC' || iniciales == 'TC') {
                    LanzarMensaje('Operación denegada, el comprobante es una nota de crédito!');
                    e.processOnServer = false;
                } else
                    e.processOnServer = true;
            }
            if (e.buttonID == 'VerReporte') e.processOnServer = true;
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Comprobantes de Venta" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-1">
            </div>
            <div class="col-10">
                <dx:ASPxGridView ID="dgComprobantes" runat="server" ClientInstanceName="dgComprobantes"
                    Theme="Material" Width="100%" EnableCallBacks="true" KeyFieldName="IdComprobanteVentaAuxiliar"
                    DataSourceID="CargarComprobantes" OnCustomButtonCallback="dgComprobantes_CustomButtonCallback">
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <Settings ShowFilterRow="true" ShowStatusBar="Hidden"/>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="NotaCredito" Text="">
                                    <Image IconID="content_notes_16x16" ToolTip="Aplicar Nota de Crédito">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="VerReporte" Text="">
                                    <Image IconID="programming_showtestreport_16x16" ToolTip="Ver Reporte">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="IdComprobanteVentaAuxiliar" Visible="false"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Serie" VisibleIndex="3"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Numero" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="{0:00000000}"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="RazonSocial" Caption="Datos del Cliente" VisibleIndex="5"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Total" VisibleIndex="6"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Motivo" VisibleIndex="7"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="8"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="9"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="IdOrdenVenta" Caption="N° Orden" VisibleIndex="10"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NotasCredito" VisibleIndex="11"></dx:GridViewDataTextColumn>
                    </Columns>
                    <ClientSideEvents CustomButtonClick="BotonesComprobantes"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Nothing') e.cancel = true;}"
                        EndCallback="function(s, e){
                            if (s.cpRedireccion) {  
                                window.open(s.cpRedireccion, '_blank')  
                                delete (s.cpRedireccion);  
                            } 
                        }"/>
                </dx:ASPxGridView>
                <dx:EntityServerModeDataSource runat="server" ID="CargarComprobantes" OnSelecting="CargarComprobantes_Selecting" />
            </div>
            <div class="col-1"></div>
        </div>
    </div>

    <dx:ASPxPopupControl runat="server" ID="pcEmisorNotasCredito" ClientInstanceName="pcEmisorNotasCredito" Theme="Moderno" HeaderText="Editor de Órdenes de Venta" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="lblIddlsjf" Text="Comprobante:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-4" style="text-align: center">
                            <dx:ASPxTextBox runat="server" ID="txtComprobante" ClientInstanceName="txtComprobante" Theme="Material" Width="100%" ReadOnly="true">
                                <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="ComprobNC">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                            <dx:ASPxHiddenField runat="server" ID="hfIdComprobante" ClientInstanceName="hfIdComprobante"></dx:ASPxHiddenField>
                        </div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Fecha:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-4">
                            <dx:ASPxDateEdit runat="server" ID="deFecha" ClientInstanceName="deFecha" Theme="Material" Width="100%" ReadOnly="true">
                                <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="ComprobNC">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                            </dx:ASPxDateEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Motivo:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10 col-centrada">
                            <dx:ASPxMemo ID="txtMotivo" ClientInstanceName="txtMotivo" runat="server" Theme="Material" Width="100%">
                                <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="ComprobNC">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                            </dx:ASPxMemo>
                        </div>
                    </div>
                    <div class="row">
                        <dx:ASPxGridView ID="dgMaterialesComprobante" runat="server" ClientInstanceName="dgMaterialesComprobante"
                            Theme="Material" Width="100%" KeyFieldName="Id">
                            <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1" Visible="false"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="Almacen" Caption="Almacén" VisibleIndex="2" AdaptivePriority="1">
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="Material" VisibleIndex="3" AdaptivePriority="1" Caption="Material">
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="4" AdaptivePriority="1">
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="UnidadMedida" Caption="Unidad Medida" VisibleIndex="5" AdaptivePriority="1">
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="6" AdaptivePriority="1">
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="7" AdaptivePriority="1">
                                    <PropertiesSpinEdit DisplayFormatString="c"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                            </Columns>
                            <Settings ShowFooter="true" />
                            <TotalSummary>
                                <dx:ASPxSummaryItem SummaryType="Sum" FieldName="Importe" />
                            </TotalSummary>
                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        </dx:ASPxGridView>
                        <%--<dx:EntityServerModeDataSource runat="server" ID="dsMaterialesCV"  OnSelecting="dsMaterialesCV_Selecting" />--%>
                    </div>
                    <div class="row">
                        <dx:ASPxGridView ID="dgServiciosComprobante" runat="server" ClientInstanceName="dgServiciosComprobante"
                            Theme="Material" Width="100%" KeyFieldName="Id">
                            <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1" Visible="false"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="Servicio" VisibleIndex="3" AdaptivePriority="1">
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="4" AdaptivePriority="1">
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="UnidadMedida" Caption="Unidad Medida" VisibleIndex="5" AdaptivePriority="1">
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="6" AdaptivePriority="1">
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="7" AdaptivePriority="1">
                                    <PropertiesSpinEdit DisplayFormatString="c"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                            </Columns>
                            <Settings ShowFooter="true" />
                            <TotalSummary>
                                <dx:ASPxSummaryItem SummaryType="Sum" FieldName="Importe" />
                            </TotalSummary>
                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        </dx:ASPxGridView>
                        <%--<dx:EntityServerModeDataSource runat="server" ID="dsServiciosCV"  OnSelecting="dsServiciosCV_Selecting" />--%>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-2 col-md-4"></div>
                        <div class="col-8 col-md-4" style="text-align: center">
                            <dx:ASPxButton runat="server" ID="btnApplyCreditNote" ClientInstanceName="btnApplyCreditNote" Theme="Material" AutoPostBack="false" Text="Aplicar Nota de Crédito" OnClick="btnApplyCreditNote_Click" ValidationGroup="ComprobNC">
                                <ClientSideEvents Click="ClickApplyCreditNote" />
                            </dx:ASPxButton>
                        </div>
                        <div class="col-2 col-md-4"></div>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl runat="server" ID="pcShowResults" ClientInstanceName="pcShowResults" HeaderText="Mensaje del Sistema">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxLabel ID="lblMessage" ClientInstanceName="lblMessage" runat="server" Text=""></dx:ASPxLabel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){setTimeout(function () { pcShowResults.Hide(); }, 3000);}" />
    </dx:ASPxPopupControl>
</asp:Content>
