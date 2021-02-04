<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="UnidadesMedida.aspx.cs" Inherits="Fay_System.UnidadesMedida" %>

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
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Unidades de Medida" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div style="margin: 0px auto;">
                <dx:ASPxRadioButtonList runat="server" ID="rblOpUnidades" ClientInstanceName="rblOpUnidades" Theme="Material" RepeatDirection="Horizontal" Width="100%">
                    <Items>
                        <dx:ListEditItem Value="Servicios" Text="Servicios" Selected="true" />
                        <dx:ListEditItem Value="Productos" Text="Materiales" />
                    </Items>
                    <ClientSideEvents SelectedIndexChanged="LoadData" Init="OcultarGrids"/>
                </dx:ASPxRadioButtonList>
            </div>
        </div>
        <div class="row">
            <div class="col-1">
            </div>
            <div class="col-10">
                <dx:ASPxCallbackPanel runat="server" ID="cpObtainDataGv" ClientInstanceName="cpObtainDataGv" Theme="Material" OnCallback="cpObtainDataGv_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxGridView ID="dgServicios" runat="server" ClientInstanceName="dgServicios" KeyFieldName="Id"
                                Theme="Material" Width="100%" EnableCallBacks="true">
                                <SettingsSearchPanel Visible="true" />
                                <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Codigo" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="FechaCreacion" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                                    <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                </Columns>
                                <SettingsPager PageSize="5"></SettingsPager>
                                <SettingsDetail AllowOnlyOneMasterRowExpanded="true" />
                                <ClientSideEvents
                                    BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                                <Templates>
                                    <DetailRow>
                                        <dx:ASPxGridView runat="server" ID="dgUMServicios" ClientInstanceName="dgUMServicios" KeyFieldName="Id" Width="100%"
                                            DataSourceID="ObtenerUnidadesMedidaServicio" OnBeforePerformDataSelect="dgUMServicios_BeforePerformDataSelect"
                                            OnBatchUpdate="dgUMServicios_BatchUpdate">
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
                                            DataSourceID="ObtenerUnidadesMedidaMaterial" OnBeforePerformDataSelect="dgUMMateriales_BeforePerformDataSelect"
                                            OnBatchUpdate="dgUMMateriales_BatchUpdate">
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
                        </dx:PanelContent>
                    </PanelCollection>
                    <ClientSideEvents EndCallback="OcultarGrids" />
                </dx:ASPxCallbackPanel>
                <asp:SqlDataSource runat="server" ID="ObtenerUnidadesMedidaServicio" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion, IdEstado FROM UnidadMedida WHERE (IdServicio = @IdService)">
                    <SelectParameters>
                        <asp:SessionParameter Name="IdService" SessionField="IdService" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerUnidadesMedidaMaterial" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion, IdEstado FROM UnidadMedida WHERE (IdMaterial = @IdMaterial)">
                    <SelectParameters>
                        <asp:SessionParameter Name="IdMaterial" SessionField="IdMaterial" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource runat="server" ID="ObtenerEstadoUMS" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT E.Id, E.Descripcion FROM Estado E WHERE E.IdTipoEstado = 30"></asp:SqlDataSource>
            </div>
            <div class="col-1"></div>
        </div>
    </div>
</asp:Content>
