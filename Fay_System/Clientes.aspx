<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Clientes.aspx.cs" Inherits="Fay_System.Clientes" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var IdCliente = 0;
        var isPostback = false;

        function OnClick(s, e) {
            e.processOnServer = !isPostback;
            isPostback = true;
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Clientes" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1">
            </div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgClientes" runat="server" ClientInstanceName="dgClientes" KeyFieldName="IdCliente" Theme="Material" Width="100%" EnableCallBacks="true">
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
                        <dx:GridViewDataTextColumn FieldName="IdCliente" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ApellidoPaterno" Caption="Ap. Paterno" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ApellidoMaterno" Caption="Ap. Materno" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Nombres" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Dni" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Direccion" Caption="Dirección" VisibleIndex="6" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Telefono" Caption="Teléfono" VisibleIndex="7" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Email" VisibleIndex="8" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" Caption="Estado" VisibleIndex="9" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar')
                            IdCliente = s.batchEditApi.GetCellValue(e.visibleIndex, 'IdCliente');
                            campoO.SetText('1');
                            pcClientes.Show();
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-1"></div>
        </div>
        <div class="row">
            <div class="col-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarClientes" AutoPostBack="false" ClientInstanceName="btnAgregarClientes" Theme="Material" Text="Agregar" OnClick="btnAgregarClientes_Click">
                    <ClientSideEvents Click="function(s, e){
                        campoO.SetText('2');
                        pcClientes.Show();
                        e.processOnServer = false;
                        }" />
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcClientes" ClientInstanceName="pcClientes" Theme="Moderno" HeaderText="Clientes" PopupHorizontalAlign="WindowCenter">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="cpEditorClientes" Width="100%" ClientInstanceName="cpEditorClientes" Theme="BassetTheme" OnCallback="cpEditorClientes_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Id:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtId" ClientInstanceName="txtId" runat="server" Theme="Material" ReadOnly="true">
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblDNI" runat="server" Theme="Material" Text="DNI:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtDni" ClientInstanceName="txtDni" runat="server" Theme="Material" MaxLength="8" >
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblNombre" runat="server" Theme="Material" Text="Nombre:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtNombre" ClientInstanceName="txtNombre" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblApPaterno" runat="server" Theme="Material" Text="Ap. Paterno:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtApPaterno" ClientInstanceName="txtApPaterno" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblApMaterno" runat="server" Theme="Material" Text="Ap. Materno:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtApMaterno" ClientInstanceName="txtApMaterno" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblFechaNacimiento" runat="server" Theme="Material" Text="F. Nacimiento:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxDateEdit ID="deFechaNacimiento" ClientInstanceName="deFechaNacimiento" runat="server" Theme="Material">
                                                    <%--<ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>--%>
                                                </dx:ASPxDateEdit>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblSexo" runat="server" Theme="Material" Text="Sexo:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbSexo" ClientInstanceName="cmbSexo" runat="server" Theme="Material">
                                                    <Items>
                                                        <dx:ListEditItem Value="Masculino" Text="Masculino" Selected="true" />
                                                        <dx:ListEditItem Value="Femenino" Text="Femenino" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblEstado" runat="server" Theme="Material" Text="Estado:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Theme="Material" ValueType="System.Int32" DataSourceID="ObtenerEstadosCliente" TextField="Descripcion" ValueField="Id">
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblRuc" runat="server" Theme="Material" Text="RUC:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtRuc" ClientInstanceName="txtRuc" runat="server" Theme="Material" MaxLength="11" NumberType="Integer" MaxValue="99999999999" MinValue="0">
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblTelefono" runat="server" Theme="Material" Text="Teléfono:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtTelefono" ClientInstanceName="txtTelefono" runat="server" Theme="Material">
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblEmail" runat="server" Theme="Material" Text="Email:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtEmail" ClientInstanceName="txtEmail" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id">
                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                                        <RegularExpression ValidationExpression="^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})$" ErrorText="Email incorrecto" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblDepartamento" runat="server" Theme="Material" Text="Departamento:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbDepartamento" ClientInstanceName="cmbDepartamento" runat="server" Theme="Material" ValueType="System.Int32" TextField="DepaDescripcion" ValueField="IdDepa">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                    <ClientSideEvents ValueChanged="function(s, e){cmbProvincia.SetEnabled(true); cmbProvincia.PerformCallback(s.GetValue());}" />
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblProvincia" runat="server" Theme="Material" Text="Provincia:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbProvincia" ClientInstanceName="cmbProvincia" runat="server" Theme="Material" ValueType="System.Int32" TextField="ProvDescripcion" ValueField="IdProv" OnCallback="cmbProvincia_Callback">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-3 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblDireccion" runat="server" Theme="Material" Text="Dirección:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-9 col-md-10 col-centrada">
                                        <dx:ASPxTextBox ID="txtDireccion" ClientInstanceName="txtDireccion" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Clientes">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-1 col-md-3"></div>
                                    <div class="col-3 col-md-3 text-right">
                                        <dx:ASPxButton ID="btnAceptar" ClientInstanceName="btnAceptar" runat="server" Text="Aceptar" Theme="Material" OnClick="btnAceptar_Click" ValidationGroup="Clientes">
                                            <ClientSideEvents Click="OnClick" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-3 col-md-3">
                                        <dx:ASPxButton ID="btnCancelar" AutoPostBack="false" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material">
                                            <ClientSideEvents Click="function(s, e){pcClientes.Hide(); e.processOnServer = false;}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-3 col-md-3">
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
            cpEditorClientes.PerformCallback(IdCliente);
            }" />
    </dx:ASPxPopupControl>
    <asp:SqlDataSource ConnectionString="<%$ connectionStrings:cone %>" ID="ObtenerEstadosCliente" runat="server" SelectCommand="SELECT Id, Descripcion FROM Estado WHERE IdTipoEstado = 7"></asp:SqlDataSource>

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
