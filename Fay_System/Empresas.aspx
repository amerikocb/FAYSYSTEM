<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Empresas.aspx.cs" Inherits="Fay_System.Empresas" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var IdEmpresa = 0;
        var isPostback = false;
        function OnClick(s, e) {
            e.processOnServer = !isPostback;
            isPostback = true;
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Empresas" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1">
            </div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgEmpresas" runat="server" ClientInstanceName="dgEmpresas" KeyFieldName="Id" Theme="Material" Width="100%" EnableCallBacks="true" OnCommandButtonInitialize="dgEmpresas_CommandButtonInitialize">
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
                        <dx:GridViewDataTextColumn FieldName="Id" Caption="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="RUC" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="RazonSocial" Caption="Razón Social" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Direccion" Caption="Dirección" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataCheckColumn FieldName="Proveedor" Caption="Proveedor" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataCheckColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" Caption="Estado" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar')
                            IdEmpresa = s.batchEditApi.GetCellValue(e.visibleIndex, 'Id');
                            campoO.SetText('1');
                            pcEmpresas.Show();
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-1"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarEmpresas" AutoPostBack="false" ClientInstanceName="btnAgregarEmpresas" Theme="Material" Text="Agregar" OnClick="btnAgregarEmpresas_Click">
                    <ClientSideEvents Click="function(s, e){
                        campoO.SetText('2');
                        pcEmpresas.Show();
                        e.processOnServer = false;
                        }" />
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEmpresas" ClientInstanceName="pcEmpresas" Theme="Moderno" HeaderText="Empresas" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="cpEditorEmpresas" Width="100%" ClientInstanceName="cpEditorEmpresas" Theme="BassetTheme" OnCallback="cpEditorEmpresas_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Id:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxTextBox ID="txtId" ClientInstanceName="txtId" runat="server" Theme="Material" Width="100%" ReadOnly="true"></dx:ASPxTextBox>
                                    </div>
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblRUC" runat="server" Theme="Material" Text="RUC:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxSpinEdit ID="txtRUC" ClientInstanceName="txtRUC" runat="server" Theme="Material" MaxLength="11" MinValue="0" MaxValue="999999999999" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empresas">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxSpinEdit>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblRazonSocial" runat="server" Theme="Material" Text="Razón Social:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-10 col-centrada">
                                        <dx:ASPxTextBox ID="txtRazonSocial" ClientInstanceName="txtRazonSocial" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empresas">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblTelefono" runat="server" Theme="Material" Text="Teléfono:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxTextBox ID="txtTelefono" ClientInstanceName="txtTelefono" runat="server" Theme="Material" Width="100%"></dx:ASPxTextBox>
                                    </div>
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblEmail" runat="server" Theme="Material" Text="Email:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxTextBox ID="txtEmail" ClientInstanceName="txtEmail" runat="server" Theme="Material" Width="100%"></dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblPagWeb" runat="server" Theme="Material" Text="Página Web:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxTextBox ID="txtPagWeb" ClientInstanceName="txtPagWeb" runat="server" Theme="Material" Width="100%">
                                        </dx:ASPxTextBox>
                                    </div>
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="EsProveedor" runat="server" Theme="Material" Text="Proveedor:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxComboBox ID="cmbProveedor" ClientInstanceName="cmbProveedor" runat="server" Theme="Material" ValueType="System.Int32" Width="100%">
                                            <Items>
                                                <dx:ListEditItem Text="SI" Value="1" />
                                                <dx:ListEditItem Text="NO" Value="0" Selected="true" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Theme="Material" Text="Contacto:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxTextBox ID="txtContact" ClientInstanceName="txtContact" runat="server" Theme="Material" Width="100%">
                                        </dx:ASPxTextBox>
                                    </div>
                                    <div class="col-4 col-md-2" style="text-align: right;">
                                        <dx:ASPxLabel ID="lblEstado" runat="server" Theme="Material" Text="Estado:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-4 col-centrada">
                                        <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id" Width="100%">
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblDireccion" runat="server" Theme="Material" Text="Dirección:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-md-10 col-centrada">
                                        <dx:ASPxTextBox ID="txtDireccion" ClientInstanceName="txtDireccion" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empresas">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>

                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-12 col-md-3"></div>
                                    <div class="col-6 col-md-3 text-right">
                                        <dx:ASPxButton ID="btnAceptar" ClientInstanceName="btnAceptar" ValidationGroup="Empresas" runat="server" Text="Aceptar" Theme="Material" OnClick="btnAceptar_Click">
                                            <ClientSideEvents Click="OnClick" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-6 col-md-3 text-left">
                                        <dx:ASPxButton ID="btnCancelar" AutoPostBack="false" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material">
                                            <ClientSideEvents Click="function(s, e){pcEmpresas.Hide();}" />
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
            cpEditorEmpresas.PerformCallback(IdEmpresa);
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
