<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="OrdenesCompra.aspx.cs" Inherits="Fay_System.OrdenesCompra" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        ActualizarAlturaGrid(dgOrdenesCompra);
        ActualizarAlturaGrid(dgOrdenCompraDetalle);
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Órdenes de Compra" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1">
            </div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgOrdenesCompra" runat="server" ClientInstanceName="dgOrdenesCompra" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgOrdenesCompra_CustomButtonCallback" EnableCallBacks="false">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="Editar" Text="">
                                    <Image IconID="chart_chartsshowlegend_16x16" ToolTip="Ver Detalle">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="Anular" Text="">
                                    <Image IconID="actions_clear_16x16" ToolTip="Anular">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="ViewReport" Text="">
                                    <Image IconID="businessobjects_boreport_16x16" ToolTip="Ver Reporte">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="RazonSocial" Caption="Proveedor" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NRequerimiento" Caption="N° Requerimiento" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>

                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') e.processOnServer=true;
                        if(e.buttonID == 'ViewReport') e.processOnServer = true;
                        if(e.buttonID == 'Anular') e.processOnServer = confirm('El OrdenCompra será anulado: está seguro que desea realizar esta acción?');
                        }" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-1"></div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorOrdenesCompra" ClientInstanceName="pcEditorOrdenesCompra" Theme="Moderno" HeaderText="Editor de OrdenesCompra" PopupHorizontalAlign="WindowCenter">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-2 col-sm-2">
                        <dx:ASPxLabel runat="server" ID="lblIddlsjf" Text="Fecha:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-sm-4">
                        <dx:ASPxTextBox runat="server" ID="txtFecha" ClientInstanceName="txtFecha" ClientEnabled="false" Theme="Material" Width="100%"></dx:ASPxTextBox>
                    </div>
                    <div class="col-2 col-sm-2">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Proveedor:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-sm-4">
                        <dx:ASPxTextBox runat="server" ID="txtProveedor" ClientInstanceName="txtProveedor" ClientEnabled="false" Theme="Material" Width="100%"></dx:ASPxTextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-2 col-sm-2">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel2" Text="DocRef:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-sm-4">
                        <dx:ASPxTextBox runat="server" ID="txtDocumentoRef" ClientInstanceName="txtDocumentoRef" ClientEnabled="false" Theme="Material" Width="100%"></dx:ASPxTextBox>
                    </div>
                    <div class="col-2 col-sm-2">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel3" Text="Estado:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-sm-4">
                        <dx:ASPxTextBox runat="server" ID="txtEstadoOCD" ClientInstanceName="txtEstadoOCD" ClientEnabled="false" Theme="Material" Width="100%"></dx:ASPxTextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <dx:ASPxGridView ID="dgOrdenCompraDetalle" runat="server" ClientInstanceName="dgOrdenCompraDetalle"
                            Theme="Material" Width="100%">
                            <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                            <SettingsCommandButton>
                                <NewButton ButtonType="Image" RenderMode="Image">
                                    <Image IconID="actions_add_16x16">
                                    </Image>
                                </NewButton>
                            </SettingsCommandButton>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="IdOrdenCD" Caption="N°" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IdMaterial" Caption="N° Prod." VisibleIndex="1" AdaptivePriority="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="2" AdaptivePriority="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="3" AdaptivePriority="1">
                                    <PropertiesSpinEdit DisplayFormatString="g"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataTextColumn FieldName="UnidadMedida" Caption="N°" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="5" AdaptivePriority="2">
                                    <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="6" AdaptivePriority="2">
                                    <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>

                            </Columns>
                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                            <ClientSideEvents CustomButtonClick="function(s, e){
                            if(e.buttonID == 'Eliminar'){
                                s.DeleteRow(e.visibleIndex);
                            }
                            }" />
                        </dx:ASPxGridView>
                    </div>
                </div>
                <dx:ASPxHiddenField runat="server" ID="hfAcciones"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Producto"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerEmpresas" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT e.Id, p.RazonSocial FROM Empresa e INNER JOIN Persona p on p.Id = e. IdPersona WHERE e.Proveedor = 1"></asp:SqlDataSource>
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
