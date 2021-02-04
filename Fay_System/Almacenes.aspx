<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Almacenes.aspx.cs" Inherits="Fay_System.Almacenes" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">

        var IdAlmacen = 0;
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administración de Almacenes" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgAlmacenes" runat="server" ClientInstanceName="dgAlmacenes" KeyFieldName="Id;Descripcion"
                    Theme="Material" Width="100%" EnableCallBacks="true">
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
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') {
                            IdAlmacen = s.batchEditApi.GetCellValue(e.visibleIndex, 'Id');
                            campoO.SetText('1');
                            pcAlmacenes.Show(); };
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                </dx:ASPxGridView>
                <asp:SqlDataSource ID="ObtenerAlmacenes" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="Select  A.Id, A.Descripcion from Almacen A where A.IdEstado not in (38) order by A.Descripcion"></asp:SqlDataSource>

            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarAlmacen" AutoPostBack="false" ClientInstanceName="btnAgregarAlmacen" Theme="Material" Text="Agregar">
                    <ClientSideEvents Click="function(s, e){
                        campoO.SetText('2');
                        pcAlmacenes.Show();
                        e.processOnServer = false;
                        }" />
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcAlmacenes" ClientInstanceName="pcAlmacenes" Theme="Moderno" HeaderText="Almacenes" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="cpEditorAlmacenes" Width="100%" ClientInstanceName="cpEditorAlmacenes" Theme="BassetTheme" OnCallback="cpEditorAlmacenes_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-4 text-right">
                                        <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Id:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-centrada">
                                        <dx:ASPxTextBox ID="txtId" ClientInstanceName="txtId" runat="server" Theme="Material" Width="100%" ReadOnly="true">
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 text-right">
                                        <dx:ASPxLabel ID="lblRazonSocial" runat="server" Theme="Material" Text="Descripción:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-centrada">
                                        <dx:ASPxTextBox ID="txtDescripcion" ClientInstanceName="txtDescripcion" runat="server" Theme="Material" Width="100%">
                                            <ValidationSettings Display="Dynamic" ValidationGroup="Almacenes" ErrorDisplayMode="ImageWithTooltip">
                                                <RequiredField IsRequired="true" ErrorText="Campor Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4 text-right">
                                        <dx:ASPxLabel ID="lblEstado" runat="server" Theme="Material" Text="Estado:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-8 col-centrada">
                                        <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id" Width="100%">
                                        </dx:ASPxComboBox>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-2"></div>
                                    <div class="col-4">
                                        <dx:ASPxButton ID="btnAceptar" ClientInstanceName="btnAceptar" runat="server" Text="Aceptar" Theme="Material" OnClick="btnAceptar_Click" ValidationGroup="Almacenes">
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-4">
                                        <dx:ASPxButton ID="btnCancelar" AutoPostBack="false" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material">
                                            <ClientSideEvents Click="function(s, e){pcAlmacenes.Hide();}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-2">
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
            cpEditorAlmacenes.PerformCallback(IdAlmacen);
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
