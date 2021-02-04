<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="MarcaMateriales.aspx.cs" Inherits="Fay_System.MarcaMateriales" %>

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
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Marcas de Materiales" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgMateriales" runat="server" ClientInstanceName="dgMateriales" KeyFieldName="IdMaterial" 
                                Theme="Material" Width="100%" EnableCallBacks="true">
                                <SettingsSearchPanel Visible="true" />
                                <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="IdMaterial" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Codigo" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsPager PageSize="5"></SettingsPager>
                                <SettingsDetail AllowOnlyOneMasterRowExpanded="true" />
                                <ClientSideEvents
                                    BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                                <Templates>
                                    <DetailRow>
                                        <dx:ASPxGridView runat="server" ID="dgUMMateriales" ClientInstanceName="dgUMMateriales" KeyFieldName="Id" Width="100%"
                                            DataSourceID="ObtenerMarcaMaterial" OnBeforePerformDataSelect="dgMMateriales_BeforePerformDataSelect"
                                            OnBatchUpdate="dgMMateriales_BatchUpdate">
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
                                                <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" Visible="false"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="2"></dx:GridViewDataTextColumn>
                                                <dx:GridViewDataComboBoxColumn FieldName="IdEstado" Caption="Estado" VisibleIndex="3">
                                                    <PropertiesComboBox ClientInstanceName="cmbEstado" ValueField="Id" TextField="Descripcion" DataSourceID="ObtenerEstadoUMS">
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                                            <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                                        </ValidationSettings>
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

                <asp:SqlDataSource runat="server" ID="ObtenerMarcaMaterial" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion, IdEstado FROM MarcaMaterial WHERE (IdMaterial = @IdMaterial)">
                    <SelectParameters>
                        <asp:SessionParameter Name="IdMaterial" SessionField="IdMaterial" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerEstadoUMS" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT E.Id, E.Descripcion FROM Estado E WHERE E.IdTipoEstado = 31"></asp:SqlDataSource>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
    </div>
</asp:Content>
