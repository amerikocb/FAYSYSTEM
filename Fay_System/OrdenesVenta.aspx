<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="OrdenesVenta.aspx.cs" Inherits="Fay_System.OrdenesVenta" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="Custom_Scripts/OrdenVentaScript.js"></script>
    <%--<script type="text/javascript">
        console.log(hfIdOrdenVenta.Get('IdOrdenVenta'));
    </script>--%>
    <style type="text/css">
        .btnSearchData {
            align-self: center;
        }
    </style>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Órdenes de Venta" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-1">
            </div>
            <div class="col-10">
                <dx:ASPxGridView ID="dgOrdenesVenta" runat="server" ClientInstanceName="dgOrdenesVenta" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgOrdenVentaes_CustomButtonCallback" EnableCallBacks="true"
                    OnCustomButtonInitialize="dgOrdenesVenta_CustomButtonInitialize">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" ShowStatusBar="Hidden" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="btnToOt" Text="">
                                    <Image IconID="businessobjects_boresume_16x16" ToolTip="Convertir a orden de trabajo">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="btnVender" Text="">
                                    <Image IconID="spreadsheet_formatnumbercurrency_16x16" ToolTip="Facturar">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="Editar" Text="">
                                    <Image IconID="actions_editname_16x16" ToolTip="Editar">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="Anular" Text="">
                                    <Image IconID="actions_clear_16x16" ToolTip="Anular">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="showReport" Text="" Image-ToolTip="Ver Comprobante de Venta">
                                    <Image IconID="businessobjects_boreport_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="showProforma" Text="" Image-ToolTip="Imprimir Proforma">
                                    <Image IconID="reports_designreport_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="EstadoOrdenVenta" Caption="Estado" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NombreRazonSocial" Caption="Datos Completos del Cliente" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="TipoOrdenVenta" Caption="Tipo de Orden" VisibleIndex="6" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="CostoTotal" Caption="Costo" VisibleIndex="7" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="BotonesOrdenVenta"
                        BatchEditStartEditing="function(s, e){
                            if (e.focusedColumn.fieldName != 'nothing')
                                e.cancel = true;
                        }"
                        EndCallback="function(s, e){
                            if(s.cpOperacionesGrid != null){
                                LanzarMensaje(s.cpOperacionesGrid);
                                delete(s.cpOperacionesGrid);
                            }

                            if (s.cpRedireccion) {  
                                window.open(s.cpRedireccion, '_blank')  
                                delete (s.cpRedireccion);  
                            } 
                        }" />
                </dx:ASPxGridView>
            </div>
            <div class="col-1"></div>
        </div>
        <div class="row">
            <div class="col-12 col-sm-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="addOrdenVentaes" ClientInstanceName="addOrdenVentaes" Theme="Material" Text="Agregar" OnClick="addOrdenVentaes_Click">
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorOrdenesVenta" ClientInstanceName="pcEditorOrdenesVenta" Theme="Moderno" HeaderText="Editor de Órdenes de Venta" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="1000px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-2">
                        <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Tipo Orden:"></dx:ASPxLabel>
                    </div>
                    <div class="col-6 col-centrada">
                        <dx:ASPxComboBox ID="cmbTipoOrden" ClientInstanceName="cmbTipoOrden" runat="server" Theme="Material" Width="100%" ValueType="System.Int32">
                            <Items>
                                <dx:ListEditItem Value="1" Selected="true" Text="Orden de Venta Asociada a una Orden de Trabajo" />
                                <dx:ListEditItem Value="2" Text="Orden de Venta Independiente" />
                            </Items>
                            <ClientSideEvents SelectedIndexChanged="function(s, e){
                                if(s.GetValue() == '2'){
                                    $('#smOrdenTrabajo').hide();
                                    $('#smVentaD').show();
                                    $('#smTotales').hide();
                                }
                                else{
                                    $('#smOrdenTrabajo').show();
                                    $('#smVentaD').hide();
                                    $('#smTotales').show();
                                }

                                }" />
                        </dx:ASPxComboBox>
                    </div>
                    <div class="col-4">
                        <dx:ASPxButton runat="server" ID="btnNewAdelanto" Width="100%" ClientInstanceName="btnSaveAdelanto" Text="Adelanto" AutoPostBack="false" Theme="Material">
                            <ClientSideEvents Click="function(s, e){pcAdelantos.Show(); }" />
                        </dx:ASPxButton>
                    </div>
                </div>
                <div class="row">
                    <div class="col-4 col-md-4">
                        <dx:ASPxLabel runat="server" ID="lblIddlsjf" Text="Tipo de Cliente:"></dx:ASPxLabel>
                        <dx:ASPxHiddenField runat="server" ID="hf" ClientInstanceName="hf"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hf1" ClientInstanceName="hf1"></dx:ASPxHiddenField>
                        <dx:ASPxRadioButtonList runat="server" ID="rbOpciones" ClientInstanceName="rbOpciones" RepeatDirection="Horizontal" ValueType="System.Int32" Width="100%">
                            <Items>
                                <dx:ListEditItem Value="1" Text="Natural" Selected="true" />
                                <dx:ListEditItem Value="2" Text="Jurídico" />
                            </Items>
                            <ClientSideEvents ValueChanged="EscogerTipoPersona" />
                            <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                            </ValidationSettings>
                        </dx:ASPxRadioButtonList>
                        <dx:ASPxHiddenField runat="server" ID="hfIdOrdenVenta" ClientInstanceName="hfIdOrdenVenta"></dx:ASPxHiddenField>
                    </div>
                    <div class="col-4 col-md-4">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Precio Dolar S/:"></dx:ASPxLabel>
                        <dx:ASPxTextBox runat="server" ID="txtPrecioDolar" ClientInstanceName="txtPrecioDolar" Theme="Material" Width="100%" ReadOnly="true">
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-4 col-md-4">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel10" Text="Fecha de Entrega: "></dx:ASPxLabel>
                        <dx:ASPxCallbackPanel runat="server" ID="cpUpdateFecha" ClientInstanceName="cpUpdateFecha" OnCallback="cpUpdateFecha_Callback">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxDateEdit runat="server" ID="deFechaEntrega" ClientInstanceName="deFechaEntrega" Theme="Material" Width="100%">
                                        <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                            <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                        </ValidationSettings>
                                        <ClientSideEvents DateChanged="function(s, e){
                                            if(hfIdOrdenVenta.Get('IdOrdenVenta') &gt;0)
                                                if(confirm('Está seguro que quiere cambiar la fecha de entrega?'))
                                                    cpUpdateFecha.PerformCallback(s.GetText());
                                            }" />
                                    </dx:ASPxDateEdit>
                                </dx:PanelContent>
                            </PanelCollection>
                            <ClientSideEvents EndCallback="function(s, e){
                                if(s.cpUpdateFecha != null){
                                    LanzarMensaje(s.cpUpdateFecha);
                                }
                            }" />
                        </dx:ASPxCallbackPanel>
                    </div>
                </div>
                <div class="row">
                    <div class="col-5 col-md-4">
                        <dx:ASPxLabel runat="server" ID="lblRucDni" ClientInstanceName="lblRucDni"
                            Theme="Material" Width="100%" Text="DNI: ">
                        </dx:ASPxLabel>
                        <dx:ASPxTextBox runat="server" ID="txtRucDni" ClientInstanceName="txtRucDni" Width="100%" ReadOnly="true">
                            <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                        <dx:ASPxHiddenField runat="server" ID="hfIdCliente" ClientInstanceName="hfIdCliente"></dx:ASPxHiddenField>
                    </div>
                    <div class="col-5 col-md-6">
                        <dx:ASPxLabel runat="server" ID="lblApelNomRazSoc" ClientInstanceName="lblApelNomRazSoc"
                            Theme="Material" Width="100%" Text="Apell. Nombres:">
                        </dx:ASPxLabel>
                        <dx:ASPxTextBox runat="server" ID="txtApelNomRazSoc" ClientInstanceName="txtApelNomRazSoc" Width="100%" ReadOnly="true">
                            <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-2 col-md-2">
                        <dx:ASPxButton runat="server" ID="btnBuscarPersonas" ClientInstanceName="btnBuscarPersonas" Text="BUSCAR" Width="100%" AutoPostBack="false" CssClass="btnSearchData">
                            <ClientSideEvents Click="AccionesBotonBuscarPersona" />
                        </dx:ASPxButton>
                        <dx:ASPxHiddenField runat="server" ID="hfEstadoOv" ClientInstanceName="hfEstadoOv"></dx:ASPxHiddenField>
                    </div>
                </div>
                <div class="row" id="smOrdenTrabajo">
                    <dx:ASPxGridView ID="dgOrdenVentaDetalle" runat="server" ClientInstanceName="dgOrdenVentaDetalle"
                        Theme="Material" Width="100%" OnBatchUpdate="dgOrdenVentaDetalle_BatchUpdate" KeyFieldName="Id"
                        EnableCallBacks="true" OnCellEditorInitialize="dgOrdenVentaDetalle_CellEditorInitialize">
                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                        <SettingsCommandButton>
                            <NewButton ButtonType="Image" RenderMode="Image">
                                <Image IconID="actions_add_16x16">
                                </Image>
                            </NewButton>
                            <RecoverButton>
                                <Image IconID="actions_reset2_16x16">
                                </Image>
                            </RecoverButton>
                        </SettingsCommandButton>
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image" ShowNewButtonInHeader="true" ShowDeleteButton="true" ShowRecoverButton="true">
                                <HeaderTemplate>
                                    <dx:ASPxButton runat="server" RenderMode="Link" AutoPostBack="false">
                                        <ClientSideEvents Click="function(s,e){ 
                                            if(txtRucDni.GetValue() != null)
                                                dgOrdenVentaDetalle.AddNewRow();
                                            else
                                                LanzarMensaje('Por favor seleccione un Cliente!');
                                            }"
                                            Init="function(s, e){if(hfEstadoOv.Get('Estado') == 59)s.SetVisible(false);}" />
                                        <Image IconID="actions_add_16x16"></Image>
                                    </dx:ASPxButton>
                                </HeaderTemplate>
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="Eliminar" Text="">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1" Visible="false"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdServicio" Caption="Servicio" VisibleIndex="2" AdaptivePriority="1">
                                <PropertiesComboBox ClientInstanceName="cmbServicios" ValueField="Id" TextField="Descripcion" DataSourceID="ObtenerServicios" EnableSynchronization="False">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                    <ClientSideEvents SelectedIndexChanged="ServicioCombo_SelectedIndexChanged" />
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataTextColumn FieldName="Observaciones" VisibleIndex="4" AdaptivePriority="1" UnboundType="String" PropertiesTextEdit-MaxLength="100"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="TipoMoneda" VisibleIndex="4" AdaptivePriority="1" UnboundType="String">
                                <PropertiesComboBox>
                                    <Items>
                                        <dx:ListEditItem Value="Dolares" Text="Dólares" />
                                        <dx:ListEditItem Value="Soles" />
                                    </Items>
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="5" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="g" MinValue="1" AllowNull="false" AllowMouseWheel="false" MaxValue="1000000">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdUnidadMedida" Caption="Unidad Medida" VisibleIndex="6" AdaptivePriority="1" UnboundType="Integer">
                                <PropertiesComboBox ClientInstanceName="cmbUnidadMedida" ValueField="Id" TextField="Descripcion" EnableCallbackMode="true" CallbackPageSize="100" OnItemRequestedByValue="cmbUnidadMedida_ItemRequestedByValue" OnItemsRequestedByFilterCondition="cmbUnidadMedida_ItemsRequestedByFilterCondition">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="7" AdaptivePriority="1" UnboundType="Decimal">
                                <PropertiesSpinEdit MinValue="0" MaxValue="100000" AllowMouseWheel="false" AllowNull="false" DisplayFormatString="f4">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="8" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataTextColumn FieldName="Equivalencia" VisibleIndex="9" PropertiesTextEdit-DisplayFormatString="f4"></dx:GridViewDataTextColumn>
                        </Columns>

                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click" BatchEditSettings-HighlightDeletedRows="true">
                            <BatchEditSettings StartEditAction="Click"></BatchEditSettings>
                        </SettingsEditing>
                        <ClientSideEvents CustomButtonClick="function(s, e){
                            if(e.buttonID == 'Eliminar'){
                                s.DeleteRow(e.visibleIndex);
                            }
                            }"
                            BatchEditStartEditing="InicioEdicionCD"
                            BatchEditRowInserting="onInserting"
                            EndCallback="function(s, e){
                                if(s.cpOperacionGrid != null){
                                    LanzarMensaje(s.cpOperacionGrid);
                                }
                            }"
                            BatchEditEndEditing="OnBatchEditEndEditing" />
                    </dx:ASPxGridView>
                </div>
                <div class="row" id="smVentaD">
                    <dx:ASPxGridView ID="dgSalidaMaterialDetalle" runat="server" ClientInstanceName="dgSalidaMaterialDetalle"
                        Theme="Material" Width="100%" OnBatchUpdate="dgSalidaMaterialDetalle_BatchUpdate" KeyFieldName="Id"
                        EnableCallBacks="true" OnCellEditorInitialize="dgSalidaMaterialDetalle_CellEditorInitialize">
                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                        <SettingsCommandButton>
                            <NewButton ButtonType="Image" RenderMode="Image">
                                <Image IconID="actions_add_16x16">
                                </Image>
                            </NewButton>
                            <RecoverButton>
                                <Image IconID="actions_reset2_16x16">
                                </Image>
                            </RecoverButton>
                        </SettingsCommandButton>
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" ButtonRenderMode="Image" ShowNewButtonInHeader="true" ShowRecoverButton="true">
                                <HeaderTemplate>
                                    <dx:ASPxButton runat="server" RenderMode="Link" AutoPostBack="false">
                                        <ClientSideEvents Click="NuevaFilaSMD" />
                                        <Image IconID="actions_add_16x16"></Image>
                                    </dx:ASPxButton>
                                </HeaderTemplate>
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="EliminarMD" Text="">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1" Visible="false"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdAlmacen" Caption="Almacén" VisibleIndex="2" AdaptivePriority="1">
                                <PropertiesComboBox ClientInstanceName="cmbAlmacenes" ValueField="Id" TextField="Descripcion" DataSourceID="ObtenerAlmacenes" ValueType="System.Int32">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                    <ClientSideEvents SelectedIndexChanged="AlmacenCombo_SelectedIndexChanged" />
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdMaterial" VisibleIndex="3" AdaptivePriority="1" Caption="Material">
                                <PropertiesComboBox ClientInstanceName="cmbMateriales" ValueField="IdMaterial" TextField="Descripcion" EnableCallbackMode="true" CallbackPageSize="100000" OnItemRequestedByValue="cmbMaterial_ItemRequestedByValue" OnItemsRequestedByFilterCondition="cmbMaterial_ItemsRequestedByFilterCondition">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                    <ClientSideEvents SelectedIndexChanged="MaterialCombo_SelectedIndexChanged" />
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="4" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="g" MinValue="1" MaxValue="100000">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdUnidadMedida" Caption="Unidad Medida" VisibleIndex="5" AdaptivePriority="1" UnboundType="Integer">
                                <PropertiesComboBox ClientInstanceName="cmbUnidadMedida" ValueField="Id" TextField="Descripcion" EnableCallbackMode="true" CallbackPageSize="100" OnItemRequestedByValue="cmbUnidadMedidaM_ItemRequestedByValue" OnItemsRequestedByFilterCondition="cmbUnidadMedidaM_ItemsRequestedByFilterCondition">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="6" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="c">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="7" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="c"></PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Stock" VisibleIndex="8" AdaptivePriority="2">
                            </dx:GridViewDataSpinEditColumn>
                        </Columns>
                        <Settings ShowFooter="true" />
                        <TotalSummary>
                            <dx:ASPxSummaryItem SummaryType="Sum" FieldName="Importe" />
                        </TotalSummary>
                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click" BatchEditSettings-HighlightDeletedRows="true"></SettingsEditing>
                        <ClientSideEvents
                            CustomButtonClick="function(s, e){
                                if(e.buttonID == 'EliminarMD'){
                                    s.DeleteRow(e.visibleIndex);
                                }
                            }"
                            BatchEditStartEditing="InicioEdicionSMD"
                            BatchEditRowInserting="onInserting"
                            BatchEditEndEditing="OnBatchEditEndEditingSMD"
                            BatchEditRowValidating="OnValidationSMD"
                            EndCallback="function(s, e){
                                if(s.cpOperacionGrid != null){
                                    LanzarMensaje(s.cpOperacionGrid);
                                }
                            }" />
                    </dx:ASPxGridView>
                    <dx:ASPxCallbackPanel runat="server" ID="cpGetPrecioMaterial" ClientInstanceName="cpGetPrecioMaterial" OnCallback="cpGetPrecioMaterial_Callback" Theme="Material">
                        <SettingsLoadingPanel Enabled="false" />
                        <ClientSideEvents EndCallback="function(s, e){
                            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(Indice, 'Precio', s.cpPrecioS.split('|')[0]);
                            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(Indice, 'Stock', s.cpPrecioS.split('|')[1]);
                            lpProcess.Hide();
                        }"
                            BeginCallback="function(s, e){lpProcess.Show();}" />
                    </dx:ASPxCallbackPanel>
                    <dx:ASPxCallbackPanel runat="server" ID="cpGeStockMaterial" ClientInstanceName="cpGeStockMaterial" OnCallback="cpGeStockMaterial_Callback" Theme="Material">
                        <SettingsLoadingPanel Enabled="false" />
                        <ClientSideEvents EndCallback="function(s, e){
                            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(Indice, 'Stock', s.cpStockM);
                            lpProcess.Hide();
                        }"
                            BeginCallback="function(s, e){lpProcess.Show();}" />
                    </dx:ASPxCallbackPanel>
                </div>
                <dx:ASPxHiddenField runat="server" ID="ASPxHiddenField1"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT [Material].[Id], [Material].[Descripcion] FROM [Material] INNER JOIN [Stock] ON [Stock].IdMaterial = [Material].Id WHERE ([Stock].[IdAlmacen] = @IdAlmacen)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="IdAlmacen" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <dx:ASPxHiddenField runat="server" ID="hfAcciones"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerServicios" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Servicio"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerAlmacenes" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Almacen"></asp:SqlDataSource>
                <div class="row" id="smTotales">
                    <div class="col-2 col-md-1" style="text-align: right;">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel2" Text="Total:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-md-3">
                        <dx:ASPxSpinEdit runat="server" ID="seCostoTotal" ClientInstanceName="seCostoTotal" Number="0" AllowNull="false"
                            Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Float" ReadOnly="true" DisplayFormatString="f4">
                            <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                            </ValidationSettings>
                            <ClientSideEvents ValueChanged="function(s, e){saldo();}" />
                        </dx:ASPxSpinEdit>
                    </div>
                    <div class="col-2 col-md-1" style="text-align: right;">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel3" Text="Adelanto:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-md-3">
                        <dx:ASPxSpinEdit runat="server" ID="seAdelanto" ClientInstanceName="seAdelanto" Number="0" AllowNull="false"
                            Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Float" DisplayFormatString="f4">
                            <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                            </ValidationSettings>
                            <ClientSideEvents ValueChanged="saldo" />
                        </dx:ASPxSpinEdit>
                    </div>
                    <div class="col-2 col-md-1" style="text-align: right;">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel17" Text="Saldo:"></dx:ASPxLabel>
                    </div>
                    <div class="col-4 col-md-3">
                        <dx:ASPxSpinEdit runat="server" ID="seSaldoOrden" ClientInstanceName="seSaldoOrden" ReadOnly="true" Number="0" AllowNull="false"
                            Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Float" DisplayFormatString="f4">
                            <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                            </ValidationSettings>
                        </dx:ASPxSpinEdit>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){
            if(cmbTipoOrden.GetValue() == '2'){
                $('#smOrdenTrabajo').hide();
                $('#smVentaD').show();
                $('#smTotales').hide();
            }
            else{
                $('#smOrdenTrabajo').show();
                $('#smVentaD').hide();
                $('#smTotales').show();
            }

        }" />
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl runat="server" ID="pcListadoEmpresas" ClientInstanceName="pcListadoEmpresas" Theme="Moderno" HeaderText="Listado de Empresas" PopupHorizontalAlign="WindowCenter" LoadContentViaCallback="OnFirstShow">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <dx:ASPxGridView ID="dgEmpresas" runat="server" ClientInstanceName="dgEmpresas" KeyFieldName="Id" Theme="Material" Width="100%" EnableCallBacks="true" OnCommandButtonInitialize="generico_CommandButtonInitialize">
                        <SettingsSearchPanel Visible="true" />
                        <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="btnSelEmpresa" Text="">
                                        <Image IconID="actions_loadfrom_16x16">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="Id" Caption="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="RazonSocial" Caption="Razón Social" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="RUC" Caption="RUC" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Estado" Caption="Estado" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        </Columns>
                        <SettingsPager PageSize="5"></SettingsPager>
                        <SettingsEditing Mode="Batch"></SettingsEditing>
                        <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'btnSelEmpresa')
                            SeleccionarEmpresa(e.visibleIndex);
                        }"
                            BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName !='Hola') e.cancel=true;}" />
                    </dx:ASPxGridView>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl runat="server" ID="pcListadoClientes" ClientInstanceName="pcListadoClientes" Theme="Moderno" HeaderText="Listado de Clientes" PopupHorizontalAlign="WindowCenter" LoadContentViaCallback="OnFirstShow">
        <SettingsAdaptivity Mode="Always" MaxWidth="900px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <dx:ASPxGridView ID="dgClientes" runat="server" ClientInstanceName="dgClientes" KeyFieldName="IdCliente" Theme="Material" Width="100%" EnableCallBacks="true" OnCommandButtonInitialize="generico_CommandButtonInitialize">
                        <SettingsSearchPanel Visible="true" />
                        <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                        <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                        <Columns>
                            <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="btnSelCliente" Text="">
                                        <Image IconID="actions_loadfrom_16x16">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="IdCliente" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Dni" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="ApellidoPaterno" Caption="Ap. Paterno" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="ApellidoMaterno" Caption="Ap. Materno" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Nombres" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Estado" Caption="Estado" VisibleIndex="6" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        </Columns>
                        <SettingsPager PageSize="5"></SettingsPager>
                        <SettingsEditing Mode="Batch"></SettingsEditing>
                        <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'btnSelCliente')
                            SeleccionarCliente(e.visibleIndex);
                        }"
                            BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName !='Hola') e.cancel=true;}" />
                    </dx:ASPxGridView>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl runat="server" ID="pcFacturarOrdenVenta" ClientInstanceName="pcFacturarOrdenVenta" Theme="Moderno" HeaderText="Facturar Orden de Venta" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxCallbackPanel runat="server" ID="cpEmitirComprobante" ClientInstanceName="cpEmitirComprobante" Theme="Material" OnCallback="cpEmitirComprobante_Callback">
                    <SettingsLoadingPanel Enabled="false" />
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel68" runat="server" Text="Fecha:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxDateEdit ID="dtpFecha" runat="server" ClientInstanceName="dtpFecha" Theme="Material" Width="100%" ReadOnly="true">
                                        <ValidationSettings ValidationGroup="Prestaciones">
                                        </ValidationSettings>
                                    </dx:ASPxDateEdit>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="Fecha Venc:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxDateEdit ID="dtpFechaVencimiento" runat="server" ClientInstanceName="dtpFechaVencimiento" Theme="Material" Width="100%">
                                        <ValidationSettings ValidationGroup="Prestaciones">
                                        </ValidationSettings>
                                    </dx:ASPxDateEdit>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="Sub Total:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxSpinEdit ID="txtSubTotalTicket" runat="server" ClientInstanceName="txtSubTotalTicket" ReadOnly="True" Width="100%" Theme="Material">
                                    </dx:ASPxSpinEdit>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="IGV:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxSpinEdit ID="txtIGV" runat="server" ClientInstanceName="txtIGV" ReadOnly="True" Width="100%" Theme="Material">
                                    </dx:ASPxSpinEdit>
                                    <dx:ASPxHiddenField runat="server" ID="hfRuc" ClientInstanceName="hfRuc"></dx:ASPxHiddenField>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="Descuento:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxSpinEdit ID="txtDescuento" runat="server" ClientInstanceName="txtDescuento" Width="100%" Theme="Material">
                                        <ClientSideEvents LostFocus="TotalPagar"
                                            KeyDown="function(s, e){
                                           if (e.htmlEvent.keyCode == 13) {
                                               ASPxClientUtils.PreventEventAndBubble (e.htmlEvent);
                                               txtTotalTicket.SetValue (CalcularTotalBoleta());
                                           }
                                     }" />
                                        <ValidationSettings ValidationGroup="Prestaciones" Display="Dynamic">
                                            <RegularExpression ValidationExpression="^[0-9]+([.][0-9]+)?$" ErrorText="No Válido" />
                                        </ValidationSettings>
                                    </dx:ASPxSpinEdit>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel8" runat="server" Text="Total:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxSpinEdit ID="txtTotalTicket" runat="server" ClientInstanceName="txtTotalTicket" ReadOnly="True" Width="100%" Theme="Material">
                                    </dx:ASPxSpinEdit>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel9" runat="server" Text="Tipo Doc:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxComboBox ID="cbTipoDocumento" runat="server" ClientInstanceName="cbTipoDocumento" DataSourceID="ObtenerTipoDoc" Theme="Material" ValueType="System.Int32" Width="100%" ValueField="Id" TextField="Descripcion">
                                        <ClientSideEvents ValueChanged="function(s, e){
                                                if(s.GetValue() == 1 && (hfRuc.Get('RUC') == null || hfRuc.Get('RUC') == '')){
                                                    LanzarMensaje('El cliente no tiene un N° de RUC válido');
                                                    s.SetValue(2);
                                                }
                                                else{
                                                    return;
                                                }
                                                }" />
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel71" runat="server" Text="Dirigido A:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxLabel ID="lblPersona" runat="server" ClientInstanceName="lblPersona" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-4" style="text-align: right;">
                                    <dx:ASPxLabel ID="ASPxLabel16" runat="server" Text="Tipo de Pago:" Theme="Material">
                                    </dx:ASPxLabel>
                                </div>
                                <div class="col-8">
                                    <dx:ASPxComboBox ID="cbTipoPago" runat="server" ClientInstanceName="cbTipoPago" Theme="Material" ValueType="System.Int32" Width="100%" DataSourceID="ObtenerTipoPago" ValueField="Id" TextField="Descripcion">
                                        <ClientSideEvents ValueChanged="function(s, e) {                               
                                            
                                           }" />
                                    </dx:ASPxComboBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-2"></div>
                                <div class="col-4">
                                    <dx:ASPxButton ID="btnAceptar2" runat="server" ClientInstanceName="btnAceptar2" Text="Aceptar" Theme="Material" ValidationGroup="Prestaciones" AutoPostBack="false">
                                        <ClientSideEvents Click="function(s,e){
                                               cpEmitirComprobante.PerformCallback(2);
                                              }" />
                                    </dx:ASPxButton>
                                </div>
                                <div class="col-4">
                                    <dx:ASPxButton ID="btnCancelar2" runat="server" AutoPostBack="False" ClientInstanceName="btnCancelar2" EnableTheming="True" Text="Cancelar" Theme="Material">
                                        <ClientSideEvents Click="function(s, e) {
                                            pcFacturarOrdenVenta.Hide();	
                                            }" />
                                    </dx:ASPxButton>
                                </div>
                                <div class="col-2"></div>

                            </div>
                            <dx:ASPxHiddenField runat="server" ID="hfIdOV" ClientInstanceName="hfIdOV"></dx:ASPxHiddenField>
                            <dx:ASPxHiddenField runat="server" ID="hfIdPersona" ClientInstanceName="hfIdPersona"></dx:ASPxHiddenField>
                            <asp:SqlDataSource ID="ObtenerTipoDoc" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM TipoDocumento WHERE Id IN(1, 2, 3)"></asp:SqlDataSource>
                            <asp:SqlDataSource ID="ObtenerTipoPago" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM TipoPago"></asp:SqlDataSource>
                        </dx:PanelContent>
                    </PanelCollection>
                    <ClientSideEvents EndCallback="function(s, e){
                        if(s.cpEmisionCV != null){
                            if(s.cpEmisionCV == 'OK'){
                                pcFacturarOrdenVenta.Hide();
                                LanzarMensaje('Operación realizada correctamente');
                                dgOrdenesVenta.Refresh();
                            }
                            else
                                LanzarMensaje(s.cpEmisionCV);
                            delete(s.cpEmisionCV);
                        }
                        lpProcess.Hide();
                     }"
                        BeginCallback="function(s, e){lpProcess.Show();}" />
                </dx:ASPxCallbackPanel>
                <div style="display: none">
                    <table class="auto-style32">
                        <tr>
                            <td>&nbsp;</td>
                            <td class="auto-style475">
                                <dx:ASPxLabel ID="lbTarjeta" ClientInstanceName="lbTarjeta" runat="server" Text="Tarjeta:" Theme="MetropolisBlue" ClientVisible="false">
                                </dx:ASPxLabel>
                            </td>
                            <td class="auto-style596">&nbsp;</td>
                            <td class="auto-style477">
                                <dx:ASPxComboBox ID="cbTipoTarjeta" runat="server" ClientInstanceName="cbTipoTarjeta" Theme="MetropolisBlue" ValueType="System.String" Width="150px" ClientVisible="false" NullText="Seleccione">
                                    <ValidationSettings ValidationGroup="Prestaciones" Display="Dynamic">
                                        <RequiredField IsRequired="True" />
                                    </ValidationSettings>
                                </dx:ASPxComboBox>
                            </td>
                            <td class="auto-style486">&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td class="auto-style480">
                                <dx:ASPxLabel ID="lbDigitos" ClientInstanceName="lbDigitos" runat="server" Text="Digitos:" Theme="MetropolisBlue" ClientVisible="false">
                                </dx:ASPxLabel>
                            </td>
                            <td class="auto-style595">&nbsp;</td>
                            <td class="auto-style453">
                                <dx:ASPxTextBox ID="txtDigitosTarjeta" runat="server" ClientInstanceName="txtDigitosTarjeta" Theme="MetropolisBlue" Width="90px" ClientVisible="false" MaxLength="4">
                                    <ValidationSettings ValidationGroup="Prestaciones" Display="Dynamic">
                                        <RequiredField IsRequired="True" />
                                        <RegularExpression ErrorText="Valor no válido" ValidationExpression="^[0-9]*$" />
                                    </ValidationSettings>
                                    <ClientSideEvents KeyDown="function(s, e){
                                                                if (e.htmlEvent.keyCode == 13) {
                                                                    ASPxClientUtils.PreventEventAndBubble (e.htmlEvent);
                                                                    }
                                                            }" />
                                </dx:ASPxTextBox>
                            </td>
                            <td class="auto-style486">&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td class="auto-style475">
                                <dx:ASPxTextBox ID="lblTicket" runat="server" ClientInstanceName="lblTicket" ClientVisible="False" Width="25px">
                                </dx:ASPxTextBox>
                            </td>
                            <td class="auto-style596">&nbsp;</td>
                            <td class="auto-style477">&nbsp;</td>
                            <td class="auto-style486">&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                    <table class="auto-style623">
                        <tr>
                            <td>&nbsp;</td>
                            <td class="auto-style636">&nbsp;</td>
                            <td class="auto-style632"></td>
                            <td class="auto-style628"></td>
                            <td></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td class="auto-style636">&nbsp;</td>
                            <td class="auto-style632">&nbsp;</td>
                            <td class="auto-style628">&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td class="auto-style636">&nbsp;</td>
                            <td class="auto-style632">
                                <dx:ASPxLabel ID="ASPxLabel12" runat="server" Font-Bold="true" Text="Garantia: ">
                                </dx:ASPxLabel>
                            </td>
                            <td class="auto-style628">
                                <dx:ASPxLabel ID="lblGarantia" runat="server" ClientInstanceName="lblGarantia" ForeColor="Red" Font-Bold="true">
                                </dx:ASPxLabel>
                            </td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>

                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxCallbackPanel runat="server" ID="cpGetPrecioServ" ClientInstanceName="cpGetPrecioServ" OnCallback="cpGetPrecioServ_Callback" Theme="Material">
        <ClientSideEvents EndCallback="function(s, e){
            dgOrdenVentaDetalle.batchEditApi.SetCellValue(Indice, 'Precio', s.cpPrecioS);
            lpProcess.Hide();
            }"
            BeginCallback="function(s, e){lpProcess.Show();}" />
    </dx:ASPxCallbackPanel>
    <dx:ASPxPopupControl runat="server" ID="pcShowResults" ClientInstanceName="pcShowResults" HeaderText="Mensaje del Sistema">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxLabel ID="lblMessage" ClientInstanceName="lblMessage" runat="server" Text=""></dx:ASPxLabel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){setTimeout(function () { pcShowResults.Hide(); }, 3000);}" />
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ID="pcAdelantos" runat="server" ClientInstanceName="pcAdelantos" DragElement="Window" HeaderText="Adelanto"
        Height="460px" Theme="Material" Width="600px" PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter" Modal="True" CloseAction="CloseButton" ScrollBars="Auto">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="cpLoadAdelantos" ClientInstanceName="cpLoadAdelantos" Theme="Material" OnCallback="cpLoadAdelantos_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-3 text-right">Orden Venta:</div>
                                    <div class="col-9 text-right">
                                        <dx:ASPxTextBox ID="IdOV" runat="server" ClientInstanceName="IdOV" Theme="Material" Width="100%" ReadOnly="True">
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-3 text-right">Fecha:</div>
                                    <div class="col-9 text-right">
                                        <dx:ASPxDateEdit ID="fecha" runat="server" Theme="Material" ReadOnly="true" Width="100%"></dx:ASPxDateEdit>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-3 text-right">Observación:</div>
                                    <div class="col-9 text-right">
                                        <dx:ASPxMemo ID="txtObserv" ClientInstanceName="txtObserv" runat="server" Width="100%" Theme="Material" MaxLength="500" Height="130">
                                        </dx:ASPxMemo>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-3 text-right">Saldo:</div>
                                    <div class="col-9 text-right">
                                        <dx:ASPxSpinEdit ID="seSaldoFinOrden" ClientInstanceName="seSaldoFinOrden" runat="server" Width="100%" Theme="Material" MinValue="1" MaxValue="1000000" AllowMouseWheel="false" ReadOnly="true">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="egreso">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxSpinEdit>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-3 text-right">Monto:</div>
                                    <div class="col-9 text-right">
                                        <dx:ASPxSpinEdit ID="seMonto" runat="server" ClientInstanceName="seMonto" Width="100%" Theme="Material" MinValue="1" MaxValue="1000000" AllowMouseWheel="false">
                                            <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="egreso">
                                                <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                            </ValidationSettings>
                                        </dx:ASPxSpinEdit>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-12 text-right">
                                        <dx:ASPxCallbackPanel runat="server" ID="cpSaveAdelanto" ClientInstanceName="cpSaveAdelanto" Theme="Material" OnCallback="cpSaveAdelanto_Callback">
                                            <SettingsLoadingPanel Enabled="false" />
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <dx:ASPxButton ID="btnSaveAdelanto" runat="server" Text="Registrar Adelanto" Theme="Material" ValidationGroup="Transf" Width="100%">
                                                        <ClientSideEvents Click="function(s, e){
                                                                e.processOnServer = false;
                                                                if(ASPxClientEdit.ValidateGroup('egreso')){
                                                                    if(seMonto.GetValue() &gt; seSaldoFinOrden.GetValue())
                                                                        LanzarMensaje('Error: El adelanto no puede ser mayo al costo total');
                                                                    else {
                                                                        window.setTimeout(function(){s.SetEnabled(false); },0);
                                                                        cpSaveAdelanto.PerformCallback();
                                                                    }
                                                                } 
                                                            }" />
                                                    </dx:ASPxButton>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                            <ClientSideEvents EndCallback="function(s, e){
                                                                if(s.cpMensajeResult != null){
                                                                    LanzarMensaje(s.cpMensajeResult);
                                                                    delete(s.cpMensajeResult);
                                                                    btnSaveAdelanto.SetEnabled(true);
                                                                }
                                                                lpProcess.Hide();
                                                                pcAdelantos.Hide();
                                                              }"
                                                BeginCallback="function(s, e){lpProcess.Show();}" />
                                        </dx:ASPxCallbackPanel>
                                    </div>
                                </div>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
                <%--<div class="col-2 col-md-1" style="text-align: right;">
                    </div>
                    <div class="col-4 col-md-2">
                        <dx:ASPxButton runat="server" ID="btnSaveCosto" ClientInstanceName="btnSaveCosto" Text="" RenderMode="Link" AutoPostBack="false">
                            <Image IconID="save_saveas_32x32" ToolTip="Guardar Pagos">
                            </Image>
                            <ClientSideEvents Click="function(s, e){
                                            if(seAdelanto.GetValue() &gt; seCostoTotal.GetValue())
                                                LanzarMensaje('Error: El adelanto no puede ser mayo al costo total');
                                            else
                                                cpSaveCosto.PerformCallback(hfIdOrdenVenta.Get('IdOrdenVenta') + '|' + seCostoTotal.GetValue() + '|' + seAdelanto.GetValue());}" />
                        </dx:ASPxButton>

                    </div>--%>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){cpLoadAdelantos.PerformCallback();}" />
    </dx:ASPxPopupControl>


    <dx:ASPxLoadingPanel runat="server" ID="lpProcess" ClientInstanceName="lpProcess" Modal="true" Text="Procesando" Theme="Material"></dx:ASPxLoadingPanel>
</asp:Content>
