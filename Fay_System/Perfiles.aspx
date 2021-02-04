<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Perfiles.aspx.cs" Inherits="Fay_System.Perfiles" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var IdUsuario = 0;
        function OnMenuPadreChanged(cmbParent) {
            if (isUpdating)
                return;
            var comboValue = cmbParent.GetSelectedItem().value;
            if (comboValue)
                dgOpcionesMenu.GetEditor("IdMenuHijo").PerformCallback(comboValue.toString());
        }
        var combo = null;
        var isUpdating = false;
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Perfiles de Usuarios" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgUsuarios" runat="server" ClientInstanceName="dgUsuarios" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgUsuarios_CustomButtonCallback" EnableCallBacks="true">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="Id" Caption="Id" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Nombre" Caption="Usuario" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
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
                    <SettingsDetail AllowOnlyOneMasterRowExpanded="true" />
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar'){campoO.SetText('1'); pcUsuarios.Show(); IdUsuario = s.batchEditApi.GetCellValue(e.visibleIndex, 'Id');}
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                    <Templates>
                        <DetailRow>
                            <dx:ASPxGridView runat="server" ID="dgOpcionesMenu" ClientInstanceName="dgOpcionesMenu" KeyFieldName="IdMenuPerfil" DataSourceID="ObtenerOpcionesMenuPorUsuario" Width="100%"
                                OnCellEditorInitialize="dgOpcionesMenu_CellEditorInitialize" OnBeforePerformDataSelect="dgOpcionesMenu_BeforePerformDataSelect" OnBatchUpdate="dgOpcionesMenu_BatchUpdate"
                                OnLoad="dgOpcionesMenu_Load" OnHtmlRowPrepared="dgOpcionesMenu_HtmlRowPrepared">
                                <SettingsCommandButton>
                                    <NewButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_add_16x16">
                                        </Image>
                                    </NewButton>
                                    <DeleteButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </DeleteButton>
                                </SettingsCommandButton>
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0" ShowNewButtonInHeader="true" ShowDeleteButton="true"></dx:GridViewCommandColumn>
                                    <dx:GridViewDataTextColumn FieldName="IdMenuPerfil" Visible="false" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="IdMenuPadre" Caption="Opción Principal" VisibleIndex="2">
                                        <PropertiesComboBox DataSourceID="ObtenerOpcionesPadre" ValueField="IdMenu" TextField="NombreMenu"
                                            ValueType="System.Int32" EnableSynchronization="False" IncrementalFilteringMode="StartsWith">
                                            <ClientSideEvents SelectedIndexChanged="function(s, e) { OnMenuPadreChanged(s); }" />
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                                <RequiredField IsRequired="true" ErrorText="CampoRequerido" />
                                            </ValidationSettings>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="IdMenuHijo" Caption="Opción Secundaria Nivel 1" VisibleIndex="3">
                                        <PropertiesComboBox EnableSynchronization="False" IncrementalFilteringMode="StartsWith" ValueField="IdMenu" TextField="NombreMenu"
                                            ValueType="System.Int32" DataSourceID="ObtenerOpcionesHijoAll">
                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                                <RequiredField IsRequired="true" ErrorText="CampoRequerido" />
                                            </ValidationSettings>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataCheckColumn FieldName="SoloLectura" VisibleIndex="4"></dx:GridViewDataCheckColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="Descripcion" Caption="Estado" VisibleIndex="5">
                                        <PropertiesComboBox EnableSynchronization="False" IncrementalFilteringMode="StartsWith" ValueField="Id" TextField="Descripcion"
                                            ValueType="System.Int32" DataSourceID="ObtenerEstadoMenuPerfil">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                </Columns>
                                <SettingsEditing Mode="Batch"></SettingsEditing>
                                <SettingsPager PageSize="5"></SettingsPager>
                            </dx:ASPxGridView>
                        </DetailRow>
                    </Templates>
                    <SettingsDetail ShowDetailRow="true" />
                </dx:ASPxGridView>
                <asp:SqlDataSource runat="server" ID="ObtenerOpcionesMenuPorUsuario" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT IdMenuPerfil, IdMenuPadre, IdMenuHijo, SoloLectura, Descripcion FROM MenuPerfil INNER JOIN Estado ON Estado.Id = MenuPerfil.IdEstado WHERE (IdUsuario = @IdUserMenu)">
                    <SelectParameters>
                        <asp:SessionParameter Name="IdUserMenu" SessionField="IdUserMenu" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerEstadoMenuPerfil" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT E.Id, E.Descripcion FROM Estado E INNER JOIN TipoEstado TE  ON TE.IdTipoEstado = E.IdTipoEstado WHERE E.IdTipoEstado = 24"></asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerOpcionesPadre" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT IdMenu, NombreMenu FROM Menu WHERE IdMenuPadre IS NULL"></asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerOpcionesHijo" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT IdMenu, NombreMenu FROM Menu WHERE IdMenuPadre IS NOT NULL AND (IdMenuPadre = @IdMenuPadre)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="0" Name="IdMenuPadre" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerOpcionesHijoAll" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT IdMenu, NombreMenu FROM Menu WHERE IdMenuPadre IS NOT NULL"></asp:SqlDataSource>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center; display: none;">
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
    <dx:ASPxPopupControl runat="server" ID="pcUsuarios" ClientInstanceName="pcUsuarios" Theme="Moderno" HeaderText="Perfiles" PopupHorizontalAlign="WindowCenter">
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
                                        <dx:ASPxTextBox ID="txtUsuario" ClientInstanceName="txtUsuario" runat="server" Theme="Material">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Users">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
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
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-2 col-md-2 text-right"></div>
                                    <div class="col-2 col-md-2 text-left">
                                        <dx:ASPxButton ID="btnCancelar" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material" AutoPostBack="false">
                                            <ClientSideEvents Click="function( s, e){pcUsuarios.Hide()}" />
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
