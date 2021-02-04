<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="Fay_System.Usuarios" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var IdUsuario = 0;
        var isPostback = false;
        function OnClick(s, e) {
            e.processOnServer = !isPostback;
            isPostback = true;
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Usuarios" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgUsuarios" runat="server" ClientInstanceName="dgUsuarios" KeyFieldName="Id" 
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgUsuarios_CustomButtonCallback" EnableCallBacks="false">
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
                        <dx:GridViewDataTextColumn FieldName="Nombre" Caption="Usuario" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Nombres" Caption="Nombres" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ApellidoPaterno" Caption="Ap. Paterno" VisibleIndex="3" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ApellidoMaterno" Caption="Ap. Materno" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="DescripcionTipoU" Caption="TipoUsuario" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="IdEstado" Caption="Estado" VisibleIndex="6" AdaptivePriority="2">
                            <PropertiesComboBox DataSourceID="ObtenerEstadoUsuario" TextField="Descripcion" ValueField="Id" ValueType="System.Int32"></PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar'){campoO.SetText('1'); pcUsuarios.Show(); IdUsuario = s.batchEditApi.GetCellValue(e.visibleIndex, 'Id');}
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarUsuarios" AutoPostBack="false" ClientInstanceName="btnAgregarUsuarios" Theme="Material" Text="Agregar" OnClick="btnAgregarUsuarios_Click">
                    <ClientSideEvents Click="function(s, e){
                        campoO.SetText('2');
                        pcUsuarios.Show();
                        e.processOnServer = false;
                        }" />
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcUsuarios" ClientInstanceName="pcUsuarios" Theme="Moderno" HeaderText="Usuarios" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxCallbackPanel runat="server" ID="cpAdministracionUsuarios" ClientInstanceName="cpAdministracionUsuarios" OnCallback="cpAdministracionUsuarios_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblId" runat="server" Theme="Material" Text="Id:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxTextBox ID="txtId" ClientInstanceName="txtId" runat="server" Theme="Material" ReadOnly="true">
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblEmpleado" runat="server" Theme="Material" Text="Empleado:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxComboBox ID="cmbEmpleado" ClientInstanceName="cmbEmpleado" runat="server" Theme="Material" ValueField="Id" TextField="NombreCompleto" ValueType="System.Int32">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblUsario" runat="server" Theme="Material" Text="Usuario:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxCallbackPanel runat="server" ID="cpComprobarUser" ClientInstanceName="cpComprobarUser" OnCallback="cpComprobarUser_Callback">
                                            <SettingsLoadingPanel Enabled="false" />
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <dx:ASPxTextBox ID="txtUsuario" ClientInstanceName="txtUsuario" runat="server" Theme="Material">
                                                        <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                            <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                        </ValidationSettings>
                                                        <ClientSideEvents LostFocus="function(s, e){
                                                            if(s.GetValue() != null)
                                                                cpComprobarUser.PerformCallback(s.GetValue());
                                                           }" />
                                                    </dx:ASPxTextBox>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxCallbackPanel>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblContraseña01" runat="server" Theme="Material" Text="Contraseña:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxTextBox ID="txtContraseña01" ClientInstanceName="txtContraseña01" runat="server" Theme="Material" Password="true">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblContraseña02" runat="server" Theme="Material" Text="Repita Contraseña:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxTextBox ID="txtContraseña02" ClientInstanceName="txtContraseña02" runat="server" Theme="Material" Password="true">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToCompare="txtContraseña01" ControlToValidate="txtContraseña02" ErrorMessage="Contraseñas no coinciden." ValidationGroup="Users" Width="154px" Font-Bold="True" ForeColor="Red"></asp:CompareValidator>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblTipoUsuario" runat="server" Theme="Material" Text="Tipo Usuario:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxComboBox ID="cmbTipoUsuario" ClientInstanceName="cmbTipoUsuario" runat="server" Theme="Material" ValueType="System.Int32" ValueField="Id" TextField="Descripcion">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-3 col-md-5 text-right">
                                        <dx:ASPxLabel ID="lblEstado" runat="server" Theme="Material" Text="Estado:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-7 col-centrada">
                                        <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Theme="Material" ValueType="System.Int32" ValueField="Id" TextField="Descripcion">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-3 col-md-2 text-right">
                                        <dx:ASPxTextBox ID="campoO" runat="server" ClientInstanceName="campoO" Border-BorderColor="White" Width="1px"></dx:ASPxTextBox>
                                    </div>
                                    <div class="col-2 col-md-2 text-right">
                                        <dx:ASPxButton ID="btnAceptar" ClientInstanceName="btnAceptar" runat="server" Text="Aceptar" Theme="Material" ValidationGroup="Users" OnClick="btnAceptar_Click">
                                            <ClientSideEvents Click="OnClick" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-2 col-md-2 text-right"></div>
                                    <div class="col-2 col-md-2 text-left">
                                        <dx:ASPxButton ID="btnCancelar" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material" AutoPostBack="false">
                                            <ClientSideEvents Click="function(s, e){pcUsuarios.Hide()}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-1 col-md-1 text-right">
                                    </div>
                                </div>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){cpAdministracionUsuarios.PerformCallback(IdUsuario);}" />
    </dx:ASPxPopupControl>
    <asp:SqlDataSource ID="ObtenerEstadoUsuario" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Estado WHERE IdTipoEstado = 15"></asp:SqlDataSource>

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
