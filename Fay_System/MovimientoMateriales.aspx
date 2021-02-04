<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="MovimientoMateriales.aspx.cs" Inherits="Fay_System.MovimientoMateriales" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var IdEmpresa = 0;
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Movimiento de Materiales" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1">
            </div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgMovimientoMateriales" runat="server" ClientInstanceName="dgMovimientoMateriales" KeyFieldName="IdTransaccion" Theme="Material" Width="100%" EnableCallBacks="true">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="IdTransaccion" Caption="Id" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="FechaTransaccion" Caption="F. Transacción" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Accion" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Operacion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="IdMaterial" Caption="Material" VisibleIndex="4" AdaptivePriority="1">
                            <PropertiesComboBox ClientInstanceName="cbMateriales" DataSourceID="ObtenerMateriales" ValueField="Id" TextField="Descripcion" ValueType="System.Int32"></PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="IdAlmacen" Caption="Almacen" VisibleIndex="5" AdaptivePriority="1">
                            <PropertiesComboBox ClientInstanceName="cbMateriales" DataSourceID="ObtenerAlmacenes" ValueField="Id" TextField="Descripcion" ValueType="System.Int32"></PropertiesComboBox>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataTextColumn FieldName="StockFecha" VisibleIndex="6" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="CantidadAlterada" VisibleIndex="7" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="StockResultante" VisibleIndex="8" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuarioo" Caption="Usuario" VisibleIndex="9" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                    </Columns>
                    <Toolbars>
                        <dx:GridViewToolbar EnableAdaptivity="true">
                            <Items>
                                <dx:GridViewToolbarItem Command="ExportToXlsx" Text="EXPORTAR A EXCEL" ItemStyle-HorizontalAlign="Right" />
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>
                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" />
                    <SettingsPager PageSize="5"></SettingsPager>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar')
                            IdEmpresa = s.batchEditApi.GetCellValue(e.visibleIndex, 'Id');
                            campoO.SetText('1');
                            pcClientes.Show();
                        }" />
                </dx:ASPxGridView>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Material"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerAlmacenes" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Almacen "></asp:SqlDataSource>
            </div>
            <div class="col-12 col-md-1"></div>
        </div>

    </div>

</asp:Content>
