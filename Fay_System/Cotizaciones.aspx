<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Cotizaciones.aspx.cs" Inherits="Fay_System.Cotizaciones" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        ActualizarAlturaGrid(dgCotizaciones);
        ActualizarAlturaGrid(dgCotizacionDetalle);

        var precioS, Indice, nuevaFila;
        var curentEditingIndex;
        var lastServicio = null;
        var isCustomCascadingCallback = false;

        function ValidarCotizacionesDetalle(s, e) {
            var grid = ASPxClient.Cast(s);
        }
        function EscogerTipoPersona(s, e) {
            if (s.GetValue() == 1) {
                lblRucDni.SetText('DNI:');
                lblApelNomRazSoc.SetText('Apell. Nombres:');
                txtRucDni.SetText('');
                txtApelNomRazSoc.SetText('');
            }
            else {
                lblRucDni.SetText('RUC:');
                lblApelNomRazSoc.SetText('Razón Social:');
                txtRucDni.SetText('');
                txtApelNomRazSoc.SetText('');
            }
        }
        function AccionesBotonBuscarPersona(s, e) {
            if (rbOpciones.GetValue() == 2) pcListadoEmpresas.Show();
            else pcListadoClientes.Show();
        }
        function SeleccionarEmpresa(indice) {
            hfIdCliente.Set("IdPersona", dgEmpresas.batchEditApi.GetCellValue(indice, 'Id'));
            txtRucDni.SetText(dgEmpresas.batchEditApi.GetCellValue(indice, 'RUC'));
            txtApelNomRazSoc.SetText(dgEmpresas.batchEditApi.GetCellValue(indice, 'RazonSocial'));
            pcListadoEmpresas.Hide();
        }
        function SeleccionarCliente(indice) {
            hfIdCliente.Set("IdPersona", dgClientes.batchEditApi.GetCellValue(indice, 'IdCliente'));
            txtRucDni.SetText(dgClientes.batchEditApi.GetCellValue(indice, 'Dni'));
            txtApelNomRazSoc.SetText(dgClientes.batchEditApi.GetCellValue(indice, 'ApellidoPaterno') + ' ' + dgClientes.batchEditApi.GetCellValue(indice, 'ApellidoMaterno') + ', ' + dgClientes.batchEditApi.GetCellValue(indice, 'Nombres'));
            pcListadoClientes.Hide();
        }
        var currentColumnName;
        function OnBatchEditStartEditing(s, e) {
            currentColumnName = e.focusedColumn.fieldName;
        }
        function OnBatchEditEndEditing(s, e) {
            window.setTimeout(function () {
                var cantidad, precio, tipoMoneda, precioD;
                precioD = txtPrecioDolar.GetValue();
                cantidad = s.batchEditApi.GetCellValue(e.visibleIndex, "Cantidad", null, true);
                precio = s.batchEditApi.GetCellValue(e.visibleIndex, "Precio", null, true);
                tipoMoneda = s.batchEditApi.GetCellValue(e.visibleIndex, "TipoMoneda", null, true);
                s.batchEditApi.SetCellValue(e.visibleIndex, "Importe", cantidad * precio, null, true);
                if (tipoMoneda == 'Soles') {
                    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) / precioD).toFixed(4), null, true);
                }
                else if (tipoMoneda == 'Dolares') {
                    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) * precioD).toFixed(4), null, true);
                }
                else
                    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", 0, null, true);

                seCostoTotal.SetValue(CalcularTotalPagar());
                seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetValue()) - parseFloat(seAdelanto.GetValue()));
            }, 0);
        }
        function InicioEdicionCD(s, e) {
            Indice = e.visibleIndex;
            if (e.focusedColumn.fieldName == 'Id' || e.focusedColumn.fieldName == 'Importe' || e.focusedColumn.fieldName == 'Equivalencia')
                e.cancel = true;
            if (e.visibleIndex < 0 && nuevaFila == true) {
                s.batchEditApi.SetCellValue(e.visibleIndex, 'TipoMoneda', "Soles");
                s.batchEditApi.SetCellValue(e.visibleIndex, 'Cantidad', "1");
            }

            nuevaFila = false;

            curentEditingIndex = e.visibleIndex;
            var currentServicio = dgCotizacionDetalle.batchEditApi.GetCellValue(curentEditingIndex, "IdServicio");
            hf.Set("CurrentServicio", currentServicio);
            if (currentServicio != lastServicio && e.focusedColumn.fieldName == "IdUnidadMedida" && currentServicio != null) {
                lastServicio = currentServicio;
                RefreshData(currentServicio);
            }
        }

        function onInserting(s, e) {
            nuevaFila = true;
        }

        function CalcularTotalPagar() {
            TotalPagar = 0;
            for (var i = 1; i <= dgCotizacionDetalle.GetVisibleRowsOnPage(); i++) {
                //alert(parseFloat(dgServiciosDetalle.batchEditApi.GetCellValue(-i, 'TotalPaciente')));
                if (dgCotizacionDetalle.batchEditApi.GetCellValue(-i, 'Importe') != null)
                    TotalPagar = (parseFloat(TotalPagar) + parseFloat(dgCotizacionDetalle.batchEditApi.GetCellValue(-i, 'Importe'))).toFixed(4);
                else
                    TotalPagar = (parseFloat(TotalPagar) + 0).toFixed(4);
            }
            for (var i = 0; i <= dgCotizacionDetalle.GetVisibleRowsOnPage(); i++) {
                //alert(parseFloat(dgServiciosDetalle.batchEditApi.GetCellValue(-i, 'TotalPaciente')));
                if (dgCotizacionDetalle.batchEditApi.GetCellValue(i, 'Importe') != null)
                    TotalPagar = (parseFloat(TotalPagar) + parseFloat(dgCotizacionDetalle.batchEditApi.GetCellValue(i, 'Importe'))).toFixed(4);
                else
                    TotalPagar = (parseFloat(TotalPagar) + 0).toFixed(4);
            }

            return parseFloat(TotalPagar).toFixed(4);
        }
        function saldo() {
            seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetValue()) - parseFloat(seAdelanto.GetValue()));
        }

        function ServicioCombo_SelectedIndexChanged(s, e) {
            lastServicio = s.GetValue();
            isCustomCascadingCallback = true;
            cpGetPrecioServ.PerformCallback(s.GetValue());
            RefreshData(lastServicio);
        }
        function UnidadMedida_EndCallback(s, e) {
            if (isCustomCascadingCallback) {
                if (s.GetItemCount() > 0)
                    dgCotizacionDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdUnidadMedida", s.GetItem(0).value);
                isCustomCascadingCallback = false;
            }
        }

        function RefreshData(servicioValue) {
            hf.Set("CurrentServicio", servicioValue);
            UnidadMedidaEditor.PerformCallback();
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Cotizaciones" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgCotizaciones" runat="server" ClientInstanceName="dgCotizaciones" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgCotizaciones_CustomButtonCallback" EnableCallBacks="true"
                    OnCustomButtonInitialize="dgCotizaciones_CustomButtonInitialize">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="btnToOrdenVenta" Text="">
                                    <Image IconID="actions_converttorange_16x16" ToolTip="Convertir en Orden de Venta">
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
                                <dx:GridViewCommandColumnCustomButton ID="VerReporteC" Text="">
                                    <Image IconID="programming_showtestreport_16x16" ToolTip="Ver Reporte">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="EstadoCotizacion" VisibleIndex="3" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NombreRazonSocial" Caption="Datos Cliente" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') e.processOnServer=true;
                        if(e.buttonID == 'VerReporteC') e.processOnServer=true;
                        if(e.buttonID == 'Anular') e.processOnServer = confirm('La Cotización será anulado: está seguro que desea realizar esta acción?');
                        if(e.buttonID == 'btnToOrdenVenta')e.processOnServer = confirm('La Cotización será convertida en orden de venta: está seguro que desea realizar esta acción?');}"
                        EndCallback="function(s, e){
                            if(s.cpOperacionesCot != null){
                                LanzarMensaje(s.cpOperacionesCot);
                                delete(cpOperacionesCot);
                            }

                            if (s.cpRedireccion) {  
                                window.open(s.cpRedireccion, '_blank')  
                                delete (s.cpRedireccion);  
                            } 
                        }" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-sm-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="addCotizaciones" ClientInstanceName="addCotizaciones" Theme="Material" Text="Agregar" OnClick="addCotizaciones_Click">
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorCotizaciones" ClientInstanceName="pcEditorCotizaciones" Theme="Moderno" HeaderText="Editor de Cotizaciones" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="1000px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-4 col-sm-4">
                        <dx:ASPxLabel runat="server" ID="lblIddlsjf" Text="Tipo de Cliente:"></dx:ASPxLabel>
                        <dx:ASPxHiddenField runat="server" ID="hf" ClientInstanceName="hf"></dx:ASPxHiddenField>
                        <dx:ASPxRadioButtonList runat="server" ID="rbOpciones" ClientInstanceName="rbOpciones" RepeatDirection="Horizontal" ValueType="System.Int32">
                            <Items>
                                <dx:ListEditItem Value="1" Text="Natural" Selected="true" />
                                <dx:ListEditItem Value="2" Text="Jurídico" />
                            </Items>
                            <ClientSideEvents ValueChanged="EscogerTipoPersona" />
                            <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                            </ValidationSettings>
                        </dx:ASPxRadioButtonList>
                    </div>
                    <div class="col-4 col-md-4">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Precio Dolar S/:"></dx:ASPxLabel>
                        <dx:ASPxHiddenField runat="server" ID="hfIdCotizacion" ClientInstanceName="hfIdCotizacion"></dx:ASPxHiddenField>
                        <dx:ASPxTextBox runat="server" ID="txtPrecioDolar" ClientInstanceName="txtPrecioDolar" Theme="Material" Width="100%" ReadOnly="true">
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-4 col-md-4">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel4" Text="Fecha de Entrega: "></dx:ASPxLabel>
                        <dx:ASPxCallbackPanel runat="server" ID="cpUpdateFecha" ClientInstanceName="cpUpdateFecha" OnCallback="cpUpdateFecha_Callback">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxDateEdit runat="server" ID="deFechaEntrega" ClientInstanceName="deFechaEntrega" Theme="Material" Width="100%">
                                        <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                            <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                        </ValidationSettings>
                                        <ClientSideEvents DateChanged="function(s, e){
                                            if(hfIdCotizacion.Get('IdCotizacion') != 'Nuevo'){
                                                if(confirm('Está seguro que quiere cambiar la fecha de entrega?'))
                                                    cpUpdateFecha.PerformCallback(s.GetText());
                                                }
                                            }
                                            " />
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
                    <div class="col-5 col-sm-4">
                        <dx:ASPxLabel runat="server" ID="lblRucDni" ClientInstanceName="lblRucDni" Theme="Material" Width="100%" Text="DNI: "></dx:ASPxLabel>
                        <dx:ASPxTextBox runat="server" ID="txtRucDni" ClientInstanceName="txtRucDni" Width="100%">
                            <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-5 col-sm-6">
                        <dx:ASPxHiddenField runat="server" ID="hfIdCliente" ClientInstanceName="hfIdCliente"></dx:ASPxHiddenField>
                        <dx:ASPxLabel runat="server" ID="lblApelNomRazSoc" ClientInstanceName="lblApelNomRazSoc"
                            Theme="Material" Width="100%" Text="Apell. Nombres:">
                        </dx:ASPxLabel>
                        <dx:ASPxTextBox runat="server" ID="txtApelNomRazSoc" ClientInstanceName="txtApelNomRazSoc" Width="100%">
                            <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                            </ValidationSettings>
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-2 col-sm-2">
                        <dx:ASPxButton runat="server" ID="btnBuscarPersonas" ClientInstanceName="btnBuscarPersonas" Text="BUSCAR" Width="100%" AutoPostBack="false" CssClass="btnBusqueda">
                            <ClientSideEvents Click="AccionesBotonBuscarPersona" />
                        </dx:ASPxButton>
                    </div>
                </div>
                <div class="row">
                    <dx:ASPxGridView ID="dgCotizacionDetalle" runat="server" ClientInstanceName="dgCotizacionDetalle"
                        Theme="Material" Width="100%" OnBatchUpdate="dgCotizacionDetalle_BatchUpdate" KeyFieldName="Id"
                        EnableCallBacks="true" OnCommandButtonInitialize="dgCotizacionDetalle_CommandButtonInitialize"
                        OnCellEditorInitialize="dgCotizacionDetalle_CellEditorInitialize" AutoGenerateColumns="false">
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
                                        <ClientSideEvents Click="function(s,e){ 
                                            if(txtRucDni.GetValue() == null)
                                                LanzarMensaje('Por favor seleccione un Cliente!');
                                            else if(deFechaEntrega.GetValue() == null)
                                                LanzarMensaje('Por favor seleccione la fecha de entrega');
                                            else
                                                dgCotizacionDetalle.AddNewRow();
                                            }" />
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
                            <dx:GridViewDataComboBoxColumn FieldName="TipoMoneda" VisibleIndex="5" AdaptivePriority="1" UnboundType="String">
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
                            <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="6" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="g" MinValue="1" AllowNull="false" MaxValue="1000000" AllowMouseWheel="false">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdUnidadMedida" Caption="Unidad Medida" VisibleIndex="7" AdaptivePriority="1" UnboundType="Integer">
                                <PropertiesComboBox ClientInstanceName="cmbUnidadMedida" ValueField="Id" TextField="Descripcion" EnableCallbackMode="true" CallbackPageSize="100" OnItemRequestedByValue="cmbUnidadMedida_ItemRequestedByValue" OnItemsRequestedByFilterCondition="cmbUnidadMedida_ItemsRequestedByFilterCondition">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="8" AdaptivePriority="1" UnboundType="Decimal">
                                <PropertiesSpinEdit MinValue="0" MaxValue="100000" AllowNull="false" AllowMouseWheel="false" DisplayFormatString="f4">
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
                        <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click" BatchEditSettings-HighlightDeletedRows="true"></SettingsEditing>
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
                <dx:ASPxCallbackPanel runat="server" ID="cpSaveCosto" ClientInstanceName="cpSaveCosto" Theme="Material" OnCallback="cpSaveCosto_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="row" style="display: none">
                                <div class="col-2 col-md-1" style="text-align: right;">
                                    <dx:ASPxLabel runat="server" ID="ASPxLabel2" Text="Total:"></dx:ASPxLabel>
                                </div>
                                <div class="col-4 col-md-2">
                                    <dx:ASPxSpinEdit runat="server" ID="seCostoTotal" ClientInstanceName="seCostoTotal" Number="0" AllowNull="false"
                                        Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Float" DisplayFormatString="f4">
                                        <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                            <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                        </ValidationSettings>
                                        <ClientSideEvents ValueChanged="function(s, e){saldo();}" />
                                    </dx:ASPxSpinEdit>
                                </div>
                                <div class="col-2 col-md-1" style="text-align: right;">
                                    <dx:ASPxLabel runat="server" ID="ASPxLabel3" Text="Adelanto:"></dx:ASPxLabel>
                                </div>
                                <div class="col-4 col-md-2">
                                    <dx:ASPxSpinEdit runat="server" ID="seAdelanto" ClientInstanceName="seAdelanto" Number="0" AllowNull="false"
                                        Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Float" DisplayFormatString="f4">
                                        <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                            <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                        </ValidationSettings>
                                        <ClientSideEvents ValueChanged="function(s, e){saldo();}" />
                                    </dx:ASPxSpinEdit>
                                </div>
                                <div class="col-2 col-md-1" style="text-align: right;">
                                    <dx:ASPxLabel runat="server" ID="ASPxLabel17" Text="Saldo:"></dx:ASPxLabel>
                                </div>
                                <div class="col-4 col-md-2">
                                    <dx:ASPxSpinEdit runat="server" ID="seSaldoOrden" ClientInstanceName="seSaldoOrden" ReadOnly="true" Number="0" AllowNull="false"
                                        Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Float" DisplayFormatString="f4">
                                        <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                            <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                        </ValidationSettings>
                                    </dx:ASPxSpinEdit>
                                </div>
                                <div class="col-2 col-md-1" style="text-align: right;">
                                </div>
                                <div class="col-4 col-md-2">
                                    <dx:ASPxButton runat="server" ID="btnSaveCosto" ClientInstanceName="btnSaveCosto" Text="" RenderMode="Link" AutoPostBack="false">
                                        <Image IconID="save_saveas_32x32" ToolTip="Guardar Pagos">
                                        </Image>
                                        <ClientSideEvents Click="function(s, e){cpSaveCosto.PerformCallback(hfIdCotizacion.Get('IdCotizacion'));}" />
                                    </dx:ASPxButton>
                                </div>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                    <ClientSideEvents EndCallback="function(s, e){
                            if(s.cpMensajeResult != null) 
                                LanzarMensaje(s.cpMensajeResult);
                        }" />
                </dx:ASPxCallbackPanel>
                <dx:ASPxHiddenField runat="server" ID="hfAcciones"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerServicios" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Servicio"></asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
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
    <dx:ASPxCallbackPanel runat="server" ID="cpGetPrecioServ" ClientInstanceName="cpGetPrecioServ" OnCallback="cpGetPrecioServ_Callback" Theme="Material">
        <SettingsLoadingPanel Enabled="false" />
        <ClientSideEvents EndCallback="function(s, e){
            dgCotizacionDetalle.batchEditApi.SetCellValue(Indice, 'Precio', s.cpPrecioS);
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

    <dx:ASPxLoadingPanel runat="server" ID="lpProcess" ClientInstanceName="lpProcess" Modal="true" Text="Procesando" Theme="Material"></dx:ASPxLoadingPanel>
</asp:Content>
