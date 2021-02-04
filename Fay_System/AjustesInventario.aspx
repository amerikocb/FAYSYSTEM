<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="AjustesInventario.aspx.cs" Inherits="Fay_System.AjustesInventario" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .gridCentrado {
            margin: 0 auto;
        }
    </style>
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
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Ajustes de Inventario" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgAjustesInventario" runat="server" ClientInstanceName="dgAjustesInventario" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgAjustesInventario_CustomButtonCallback" EnableCallBacks="false">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" AdaptivePriority="1" ButtonRenderMode="Image" Caption="Opciones">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="btnEditar">
                                    <Image IconID="actions_show_16x16" ToolTip="Ver Detalle">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" Caption="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Almacen" Caption="Almacén" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="3"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" Caption="Usuario Creación" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="4" AdaptivePriority="5"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'btnEditar'){e.processOnServer = true;}
                        }" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarAjuste" AutoPostBack="false" ClientInstanceName="btnAgregarAjuste" Theme="Material" Text="Agregar" OnClick="btnAgregarAjuste_Click">
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcAjusteInventario" ClientInstanceName="pcAjusteInventario" Theme="Material" HeaderText="Ajuste de Inventario" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="600px" />
        <HeaderStyle BackColor="Gray" ForeColor="White" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxCallbackPanel runat="server" ID="cpAdministracionAjustes" ClientInstanceName="cpAdministracionAjustes">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblId" runat="server" Theme="Material" Text="Id:" Width="100%"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-4 col-centrada">
                                        <dx:ASPxTextBox ID="txtNumeroAjuste" ClientInstanceName="txtNumeroAjuste" runat="server" Theme="Material" ReadOnly="true" Width="100%">
                                        </dx:ASPxTextBox>
                                    </div>
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblEmpleado" runat="server" Theme="Material" Text="Estado:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-4 col-centrada">
                                        <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Width="100%" Theme="Material" ValueField="Id" TextField="Descripcion" ValueType="System.Int32" DataSourceID="ObtenerEstados">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="AjusteI">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>

                                <div class="row">
                                </div>

                                <div class="row">
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblUsario" runat="server" Theme="Material" Text="Fecha:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-4 col-centrada">
                                        <dx:ASPxDateEdit ID="deFecha" ClientInstanceName="deFecha" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="AjusteI">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxDateEdit>
                                    </div>
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblContraseña01" runat="server" Theme="Material" Text="Almacen:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-4 col-centrada">
                                        <dx:ASPxComboBox ID="cmbAlmacen" ClientInstanceName="cmbAlmacen" runat="server" Width="100%" ValueField="Id" TextField="Descripcion" Theme="Material" DataSourceID="ObtenerAlmacenes" ValueType="System.Int32">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="AjusteI">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                            <ClientSideEvents ValueChanged="function(s, e){cmbMaterial.SetEnabled(true); cmbMaterial.PerformCallback(s.GetValue());}" />
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <div class="row">
                                </div>
                                <div class="row">
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblTipoUsuario" runat="server" Theme="Material" Text="Material:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-10 col-centrada">
                                        <dx:ASPxComboBox ID="cmbMaterial" ClientInstanceName="cmbMaterial" runat="server" Theme="Material" ValueType="System.Int32" ValueField="IdMaterial" TextField="Descripcion" Width="100%" OnCallback="cmbMaterial_Callback" TextFormatString="{1}">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="AjusteI">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                            <Columns>
                                                <dx:ListBoxColumn FieldName="IdMaterial" Caption="Id" Width="40"></dx:ListBoxColumn>
                                                <dx:ListBoxColumn FieldName="Descripcion" Width="300"></dx:ListBoxColumn>
                                                <dx:ListBoxColumn FieldName="UnitsStock" Caption="Stock" Width="60"></dx:ListBoxColumn>
                                            </Columns>
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>

                                <div class="row">
                                </div>
                                <div class="row">
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblContraseña02" runat="server" Theme="Material" Text="Motivo:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-10 col-centrada">
                                        <dx:ASPxMemo ID="txtMotivo" ClientInstanceName="txtMotivo" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="AjusteI">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxMemo>
                                    </div>
                                </div>
                                <div class="row">
                                </div>
                                <div class="row">
                                    <div class="col-5 col-md-2 text-right">
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Theme="Material" Text="Cantidad a Ajustar:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-7 col-md-4 col-centrada">
                                        <dx:ASPxSpinEdit ID="txtCantAjustar" ClientInstanceName="txtId" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="AjusteI">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxSpinEdit>
                                    </div>
                                    <div class="col-5 col-md-2 text-right">
                                    </div>
                                    <div class="col-7 col-md-4 col-centrada">
                                        <dx:ASPxButton ID="btnAjustar" ClientInstanceName="btnAjustar" runat="server" Theme="Material" Text="Ajustar" ValidationGroup="AjusteI" OnClick="btnAjustar_Click">
                                        </dx:ASPxButton>
                                    </div>
                                </div>
                                <div class="row">
                                </div>
                                <div class="row">
                                    <div class="col-12" style="text-align:center;">
                                        <dx:ASPxLabel runat="server" ID="lblErrores" ClientInstanceName="lblErrores" Theme="Material" Font-Bold="true" ForeColor="Red"></dx:ASPxLabel>
                                    </div>
                                </div>
                                <div class="row">
                                </div>
                                <div class="row">
                                    <dx:ASPxGridView runat="server" ID="dgMaterialesAjustados" Width="100%" ClientInstanceName="dgAjustesInventario" Theme="Material" CssClass="gridCentrado">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="IdMaterial" VisibleIndex="0"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="Material" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="Cantidad" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-3 col-md-2 text-right">
                                        <dx:ASPxTextBox ID="campoO" runat="server" ClientInstanceName="campoO" Border-BorderColor="White" Width="1px"></dx:ASPxTextBox>
                                    </div>

                                    <div class="col-2 col-md-2 text-right"></div>
                                    <div class="col-2 col-md-2 text-left">
                                        <dx:ASPxButton ID="btnCancelar" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material" AutoPostBack="false">
                                            <ClientSideEvents Click="function( s, e){pcAjusteInventario.Hide()}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-1 col-md-1 text-right">
                                    </div>
                                </div>
                            </div>
                            <asp:SqlDataSource runat="server" ID="ObtenerOpcionesMenuPorUsuario" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT IdMenuPerfil, IdMenuPadre, IdMenuHijo, SoloLectura, Descripcion FROM MenuPerfil INNER JOIN Estado ON Estado.Id = MenuPerfil.IdEstado WHERE (IdUsuario = @IdUserMenu)">
                                <SelectParameters>
                                    <asp:SessionParameter Name="IdUserMenu" SessionField="IdUserMenu" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource runat="server" ID="ObtenerEstados" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT E.Id, E.Descripcion FROM Estado E INNER JOIN TipoEstado TE  ON TE.IdTipoEstado = E.IdTipoEstado WHERE E.IdTipoEstado = 1"></asp:SqlDataSource>
                            <asp:SqlDataSource runat="server" ID="ObtenerAlmacenes" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Almacen ORDER BY 2"></asp:SqlDataSource>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){}" />
    </dx:ASPxPopupControl>
    <asp:SqlDataSource ConnectionString="<%$ connectionStrings:cone %>" ID="ObtenerEstadosAjustesInv" runat="server" SelectCommand="SELECT Id, Descripcion FROM Estado WHERE IdTipoEstado = 4"></asp:SqlDataSource>

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
