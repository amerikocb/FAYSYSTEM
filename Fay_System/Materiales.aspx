<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Materiales.aspx.cs" Inherits="Fay_System.Materiales" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        ActualizarAlturaGrid(dgRequerimientos);
        ActualizarAlturaGrid(dgRequerimientoDetalle);

        var IdMaterial = 0;

        function Costos() {
            if (txtCosto.GetValue() != null && txtPrecio.GetValue() != null) {
                if (parseFloat(txtCosto.GetValue()) > parseFloat(txtPrecio.GetValue())) return true;
                else return false;
            }
        }

        function ClickAceptar(s, e) {
            if (parseFloat(txtCosto.GetValue()) > parseFloat(txtPrecio.GetValue())) {
                txtCosto.SetIsValid(false);
                txtCosto.SetErrorText('El precio de compra no puede ser mayor al precio de venta');

                txtPrecio.SetIsValid(false);
                txtPrecio.SetErrorText('El precio de compra no puede ser mayor al precio de venta');
                e.processOnServer = false;
            }
            else {
                if (ASPxClientEdit.ValidateGroup('materiales')) {
                    e.processOnServer = true
                    window.setTimeout(function () { s.SetEnabled(false); }, 0)
                }
                else e.processOnserver = false;
            }
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administración de Materiales" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgMateriales" runat="server" ClientInstanceName="dgMateriales" KeyFieldName="IdMaterial;Descripcion"
                    Theme="Material" Width="100%" EnableCallBacks="true" OnHtmlDataCellPrepared="dgMateriales_HtmlDataCellPrepared">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="Editar" Text="">
                                    <Image IconID="actions_editname_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="IdMaterial" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Codigo" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="IdAlmacen" Name="cmbAlmacen" VisibleIndex="3" Caption="Almacén" AdaptivePriority="1">
                            <PropertiesComboBox ClientInstanceName="cmbAlmacen" DropDownStyle="DropDownList" DataSourceID="ObtenerAlmacenes" ValueField="Id" TextField="Descripcion">
                            </PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataTextColumn FieldName="UnitsStock" Caption="Stock" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="7" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') {
                            IdMaterial = s.batchEditApi.GetCellValue(e.visibleIndex, 'IdMaterial') + '|' + s.batchEditApi.GetCellValue(e.visibleIndex, 'IdAlmacen');
                            campoO.SetText('1');
                            pcMateriales.Show(); };
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                </dx:ASPxGridView>
                <asp:SqlDataSource ID="ObtenerAlmacenes" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="Select  A.Id, A.Descripcion from Almacen A where A.IdEstado not in (38) order by A.Descripcion"></asp:SqlDataSource>

            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarMaterial" AutoPostBack="false" ClientInstanceName="btnAgregarMaterial" Theme="Material" Text="Agregar">
                    <ClientSideEvents Click="function(s, e){
                        campoO.SetText('2');
                        pcMateriales.Show();
                        e.processOnServer = false;
                        }" />
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcMateriales" ClientInstanceName="pcMateriales" Theme="Moderno" HeaderText="Materiales" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="cpEditorMateriales" Width="100%" ClientInstanceName="cpEditorMateriales" Theme="BassetTheme" OnCallback="cpEditorMateriales_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Id:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxTextBox ID="txtId" ClientInstanceName="txtId" runat="server" Theme="Material" Width="100%" ReadOnly="true">
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="lblRUC" runat="server" Theme="Material" Text="Código:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxTextBox ID="txtCodigo" ClientInstanceName="txtCodigo" runat="server" Theme="Material" Width="100%">
                                                    <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="materiales">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="lblRazonSocial" runat="server" Theme="Material" Text="Descripción:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxMemo ID="txtDescripcion" ClientInstanceName="txtDescripcion" runat="server" Theme="Material" Width="100%">
                                                    <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="materiales">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxMemo>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Theme="Material" Text="Stock:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtStock" ClientInstanceName="txtStock" runat="server" ClientEnabled="false" Theme="Material" Width="100%">
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="lblTelefono" runat="server" Theme="Material" Text="Precio Compra:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtCosto" ClientInstanceName="txtCosto" DisplayFormatString="C" runat="server" Theme="Material" Width="100%" MinValue="0" MaxValue="100000" AllowNull="false" AllowMouseWheel="false">
                                                    <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="materiales">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Theme="Material" Text="Precio Venta:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtPrecio" ClientInstanceName="txtPrecio" DisplayFormatString="C" runat="server" Theme="Material" Width="100%" MinValue="0" MaxValue="100000" AllowNull="false" AllowMouseWheel="false">
                                                    <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="materiales">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="ASPxLabel3" runat="server" Theme="Material" Text="Almacén:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxComboBox ID="cmbAlmacen" ClientInstanceName="cmbAlmacen" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id" Width="100%">
                                                    <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="materiales">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-4 text-right">
                                                <dx:ASPxLabel ID="lblEstado" runat="server" Theme="Material" Text="Estado:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-8 col-centrada">
                                                <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id" Width="100%">
                                                    <ValidationSettings ValidateOnLeave="False" EnableCustomValidation="True" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="materiales">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-2 text-right">
                                        <dx:ASPxLabel ID="lblDireccion" runat="server" Theme="Material" Text="Observación:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-10">
                                        <dx:ASPxMemo ID="txtObservacion" ClientInstanceName="txtObservacion" runat="server" Theme="Material" Width="100%">
                                        </dx:ASPxMemo>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-12 col-md-3"></div>
                                    <div class="col-6 col-md-3 text-right">
                                        <dx:ASPxButton ID="btnAceptar" ClientInstanceName="btnAceptar" runat="server" Text="Aceptar" Theme="Material" OnClick="btnAceptar_Click" ValidationGroup="materiales" AutoPostBack="false">
                                            <ClientSideEvents Click="ClickAceptar" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-6 col-md-3 text-left">
                                        <dx:ASPxButton ID="btnCancelar" AutoPostBack="false" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material">
                                            <ClientSideEvents Click="function(s, e){pcMateriales.Hide();}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-12 col-md-3">
                                        <dx:ASPxTextBox ID="campoO" runat="server" ClientInstanceName="campoO" Border-BorderColor="White" Width="1px"></dx:ASPxTextBox>
                                    </div>
                                </div>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){
            cpEditorMateriales.PerformCallback(IdMaterial);
            }" />
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
