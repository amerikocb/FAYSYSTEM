<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="SalidaMateriales.aspx.cs" Inherits="Fay_System.SalidaMateriales" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        ActualizarAlturaGrid(dgSalidaMateriales);
        ActualizarAlturaGrid(dgSalidaMaterialDetalle);

        var precioS, Indice, nuevaFila;

        var curentEditingIndex;
        var lastAlmacen = null;
        var lastMaterial = null;
        var isCustomCascadingCallback = false;
        var isCustomCascadingCallback1 = false;

        function ValidarSalidaMaterialesDetalle(s, e) {
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
        function OnBatchEditEndEditing(s, e) {
            window.setTimeout(function () {
                var cantidad, precio, tipoMoneda, precioD;
                //precioD = txtPrecioDolar.GetValue();
                cantidad = s.batchEditApi.GetCellValue(e.visibleIndex, "Cantidad", null, true);
                precio = s.batchEditApi.GetCellValue(e.visibleIndex, "Precio", null, true);
                //tipoMoneda = s.batchEditApi.GetCellValue(e.visibleIndex, "TipoMoneda", null, true);
                s.batchEditApi.SetCellValue(e.visibleIndex, "Importe", cantidad * precio, null, true);
                //if (tipoMoneda == 'Soles') {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) / precioD).toFixed(2), null, true);
                //}
                //else if (tipoMoneda == 'Dolares') {
                //    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) * precioD).toFixed(2), null, true);
                //}
                //else
                //    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", 0, null, true);

                //seCostoTotal.SetValue(CalcularTotalPagar());
                //seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetValue()) - parseFloat(seAdelanto.GetValue()));
            }, 0);
        }

        function InicioEdicionSMD(s, e) {
            Indice = e.visibleIndex;
            if (e.focusedColumn.fieldName == 'Id' || e.focusedColumn.fieldName == 'Importe' || e.focusedColumn.fieldName == 'Equivalencia' || e.focusedColumn.fieldName == 'Stock')
                e.cancel = true;
            if (e.visibleIndex < 0 && nuevaFila == true) {
                dgSalidaMaterialDetalle.batchEditApi.SetCellValue(e.visibleIndex, 'Cantidad', "1");
                dgSalidaMaterialDetalle.batchEditApi.SetCellValue(e.visibleIndex, 'IdAlmacen', "1");
            }
            nuevaFila = false;

            curentEditingIndex = e.visibleIndex;
            var currentAlmacen = dgSalidaMaterialDetalle.batchEditApi.GetCellValue(curentEditingIndex, "IdAlmacen");
            hf.Set("CurrentAlmacen", currentAlmacen);
            if (currentAlmacen != lastAlmacen && e.focusedColumn.fieldName == "IdMaterial" && currentAlmacen != null) {
                lastAlmacen = currentAlmacen;
                RefreshData(currentAlmacen, null);
            }
        }

        function onInserting(s, e) {
            nuevaFila = true;
        }

        function OnValidation(s, e) {
            var grid = ASPxClientGridView.Cast(s);
            var cellInfo1 = e.validationInfo[grid.GetColumnByField("Cantidad").index];
            var cellInfo2 = e.validationInfo[grid.GetColumnByField("Stock").index];

            if (cellInfo1.value > cellInfo2.value) {
                cellInfo1.isValid = false;
                cellInfo2.isValid = false;
                cellInfo1.errorText = "Error: La cantidad es mayor que las unidades en stock";
                cellInfo2.errorText = "Error: Las unidades en stock es menor que la cantidad";
            } else {
                cellInfo1.isValid = true;
                cellInfo2.isValid = true;
            }
        }

        function AlmacenCombo_SelectedIndexChanged(s, e) {
            lastAlmacen = s.GetValue();
            isCustomCascadingCallback = true;
            RefreshData(lastAlmacen);
        }
        function Material_EndCallback(s, e) {
            if (isCustomCascadingCallback) {
                if (s.GetItemCount() > 0) {
                    dgSalidaMaterialDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdMaterial", s.GetItem(0).value);
                    isCustomCascadingCallback1 = true;
                    RefreshData(null, s.GetItem(0).value);
                    cpGetPrecioMaterial.PerformCallback(dgSalidaMaterialDetalle.batchEditApi.GetCellValue(curentEditingIndex, 'IdMaterial') + '|' + dgSalidaMaterialDetalle.batchEditApi.GetCellValue(curentEditingIndex, 'IdAlmacen'));
                }
                isCustomCascadingCallback = false;
            }
        }

        function MaterialCombo_SelectedIndexChanged(s, e) {
            lastMaterial = s.GetValue();
            isCustomCascadingCallback1 = true;
            RefreshData(null, lastMaterial);
            cpGetPrecioMaterial.PerformCallback(s.GetValue() + '|' + dgSalidaMaterialDetalle.batchEditApi.GetCellValue(Indice, 'IdAlmacen'));
        }

        function UnidadMedida_EndCallback(s, e) {
            if (isCustomCascadingCallback1) {
                if (s.GetItemCount() > 0) {
                    dgSalidaMaterialDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdUnidadMedida", s.GetItem(0).value);
                }
                isCustomCascadingCallback1 = false;
            }
        }

        function RefreshData(almacenValue, materialValue) {
            if (almacenValue != null) {
                hf.Set("CurrentAlmacen", almacenValue);
                MaterialEditor.PerformCallback();
            }
            if (materialValue != null) {
                hf1.Set("CurrentMaterial", materialValue);
                UnidadMedidaEditor.PerformCallback();
            }
        }

        function NuevaFilaSMD(s, e) {
            if (cmbTipoSalida.GetValue() == 'PrestamoMateriales') {
                if (txtRucDni.GetValue() == null)
                    LanzarMensaje('Por favor seleccione un Cliente!');
                else
                    dgSalidaMaterialDetalle.AddNewRow();
            } else {
                if (!hfOt.Get('IdOt'))
                    LanzarMensaje('Por favor seleccione una Orden de Trabajo!');
                else if (cmbEmpleado.GetValue() == null)
                    LanzarMensaje('Por favor seleccione un Empleado!');
                else
                    dgSalidaMaterialDetalle.AddNewRow();
            }
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Salida de Materiales" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-md-2">
            </div>
            <div class="col-xs-12 col-md-8">
                <dx:ASPxGridView ID="dgSalidaMateriales" runat="server" ClientInstanceName="dgSalidaMateriales" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgSalidaMateriales_CustomButtonCallback" EnableCallBacks="true">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="Editar" Text="">
                                    <Image IconID="actions_editname_16x16" ToolTip="Editar">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="VerReporteSM" Text="">
                                    <Image IconID="programming_showtestreport_16x16" ToolTip="Imprimir Vale de Salida">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="EstadoSalidaMaterial" Caption="Estado" VisibleIndex="3" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NombreRazonSocial" Caption="Datos Completos Cliente" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') e.processOnServer=true;
                        if(e.buttonID == 'VerReporteSM') e.processOnServer=true;
                        if(e.buttonID == 'Anular') e.processOnServer = confirm('La Cotización será anulado: está seguro que desea realizar esta acción?');
                        if(e.buttonID == 'btnToOrdenVenta')e.processOnServer = confirm('La Cotización será convertida en orden de venta: está seguro que desea realizar esta acción?');}"
                        EndCallback="function(s, e){
                            if(s.cpOperacionesCot != null){
                                LanzarMensaje(s.cpOperacionesCot);
                                delete(s.cpOperacionesCot);
                            }

                            if (s.cpRedireccion) {  
                                window.open(s.cpRedireccion, '_blank')  
                                delete (s.cpRedireccion);  
                            } 
                        }" />
                </dx:ASPxGridView>
            </div>
            <div class="col-xs-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="addSalidaMateriales" ClientInstanceName="addSalidaMateriales" Theme="Material" Text="Agregar" OnClick="addSalidaMateriales_Click">
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorSalidaMateriales" ClientInstanceName="pcEditorSalidaMateriales" Theme="Moderno" HeaderText="Editor de SalidaMateriales" PopupHorizontalAlign="WindowCenter" CloseAction="CloseButton">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-2" style="text-align: right;">
                        <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Tipo Salida:"></dx:ASPxLabel>
                        <dx:ASPxHiddenField runat="server" ID="hf" ClientInstanceName="hf"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hf1" ClientInstanceName="hf1"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hfIdOrdenVenta" ClientInstanceName="hfIdOrdenVenta"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hfOt" ClientInstanceName="hfOt"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hfRucDni" ClientInstanceName="hfRucDni"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hfIdSalidaMaterial" ClientInstanceName="hfIdSalidaMaterial"></dx:ASPxHiddenField>
                        <dx:ASPxHiddenField runat="server" ID="hfIdCliente" ClientInstanceName="hfIdCliente"></dx:ASPxHiddenField>
                    </div>
                    <div class="col-10 col-centrada">
                        <dx:ASPxComboBox ID="cmbTipoSalida" ClientInstanceName="cmbTipoSalida" runat="server" Theme="Material" Width="100%">
                            <Items>
                                <dx:ListEditItem Value="PrestamoMateriales" Text="Préstamo de Materiales" />
                                <dx:ListEditItem Value="SalidaOrdenTrabajo" Selected="true" Text="Salida para Orden de Trabjo" />
                            </Items>
                            <ClientSideEvents SelectedIndexChanged="function(s, e){
                                if(s.GetValue() == 'PrestamoMateriales'){
                                    $('#smOrdenTrabajo').hide();
                                    $('#smPrestamo').show();
                                }
                                else{
                                    $('#smOrdenTrabajo').show();
                                    $('#smPrestamo').hide();
                                }

                                }" />
                        </dx:ASPxComboBox>
                    </div>
                </div>
                <div class="row" id="smOrdenTrabajo">
                    <div class="col-4 col-md-2" style="text-align: right;">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel2" Text="Orden Trabajo:"></dx:ASPxLabel>
                    </div>
                    <div class="col-8 col-md-4 col-centrada">
                        <dx:ASPxComboBox runat="server" ID="cmbOrdenesTrabajo" ClientInstanceName="cmbOrdenesTrabajo" Theme="Material" Width="100%" DropDownWidth="600px">
                            <Columns>
                                <dx:ListBoxColumn FieldName="Id" Width="50"></dx:ListBoxColumn>
                                <dx:ListBoxColumn FieldName="Trabajo"></dx:ListBoxColumn>
                                <dx:ListBoxColumn FieldName="DatosCliente"></dx:ListBoxColumn>
                            </Columns>
                            <ClientSideEvents SelectedIndexChanged="function(s, e){hfOt.Set('IdOt', s.GetValue());}" />
                        </dx:ASPxComboBox>
                    </div>
                    <div class="col-4 col-md-2" style="text-align: right;">
                        <dx:ASPxLabel ID="lblEmpl" ClientInstanceName="lblEmpl" runat="server" Theme="Material" Text="Empleado:"></dx:ASPxLabel>
                    </div>
                    <div class="col-8 col-md-4 col-centrada">
                        <dx:ASPxComboBox ID="cmbEmpleado" ClientInstanceName="cmbEmpleado" runat="server" Theme="Material" Width="100%" ValueField="Id" TextField="NombreCompleto" ValueType="System.Int32">
                        </dx:ASPxComboBox>
                    </div>
                </div>

                <div id="smPrestamo">
                    <div class="row">
                        <div class="col-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Tipo de Cliente:"></dx:ASPxLabel>
                        </div>
                        <div class="col-10 col-centrada">
                            <dx:ASPxRadioButtonList runat="server" ID="rbOpciones" ClientInstanceName="rbOpciones" RepeatDirection="Horizontal" ValueType="System.Int32" Width="100%">
                                <Items>
                                    <dx:ListEditItem Value="1" Text="Persona Natural" Selected="true" />
                                    <dx:ListEditItem Value="2" Text="Persona Jurídica" />
                                </Items>
                                <ClientSideEvents ValueChanged="EscogerTipoPersona" />
                                <ValidationSettings ValidationGroup="Cotizacion" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                </ValidationSettings>
                            </dx:ASPxRadioButtonList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="lblRucDni" ClientInstanceName="lblRucDni"
                                Theme="Material" Width="100%" Text="DNI: ">
                            </dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-4">
                            <dx:ASPxTextBox runat="server" ID="txtRucDni" ClientInstanceName="txtRucDni" Width="100%" ReadOnly="true">
                                <ValidationSettings ValidationGroup="SalidaMaterial" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </div>
                        <div class="col-xs-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="lblApelNomRazSoc" ClientInstanceName="lblApelNomRazSoc"
                                Theme="Material" Width="100%" Text="Apell. Nombres:">
                            </dx:ASPxLabel>
                        </div>
                        <div class="col-7 col-md-3">
                            <dx:ASPxTextBox runat="server" ID="txtApelNomRazSoc" ClientInstanceName="txtApelNomRazSoc" Width="100%" ReadOnly="true">
                                <ValidationSettings ValidationGroup="SalidaMaterial" Display="Dynamic" ErrorDisplayMode="ImageWithTooltip">
                                    <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </div>
                        <div class="col-1" style="text-align: center;">
                            <dx:ASPxButton runat="server" ID="btnBuscarPersonas" ClientInstanceName="btnBuscarPersonas" Text="..." Width="100%" AutoPostBack="false">
                                <ClientSideEvents Click="AccionesBotonBuscarPersona" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                </div>

                <div class="row">
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
                                    <dx:GridViewCommandColumnCustomButton ID="Eliminar" Text="">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1" Visible="false"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="IdAlmacen" Caption="Almacén" VisibleIndex="2" AdaptivePriority="1">
                                <PropertiesComboBox ClientInstanceName="cmbAlmacenes" ValueField="Id" TextField="Descripcion" DataSourceID="ObtenerAlmacenes">
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
                            <dx:GridViewDataComboBoxColumn FieldName="IdUnidadMedida" Caption="Unidad Medida" VisibleIndex="6" AdaptivePriority="1" UnboundType="Integer">
                                <PropertiesComboBox ClientInstanceName="cmbUnidadMedida" ValueField="Id" TextField="Descripcion" EnableCallbackMode="true" CallbackPageSize="100" OnItemRequestedByValue="cmbUnidadMedida_ItemRequestedByValue" OnItemsRequestedByFilterCondition="cmbUnidadMedida_ItemsRequestedByFilterCondition">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="5" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="c">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="6" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="c"></PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Stock" VisibleIndex="7" AdaptivePriority="2">
                            </dx:GridViewDataSpinEditColumn>
                        </Columns>

                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click" BatchEditSettings-HighlightDeletedRows="true"></SettingsEditing>
                        <ClientSideEvents CustomButtonClick="function(s, e){
                            if(e.buttonID == 'Eliminar'){
                                s.DeleteRow(e.visibleIndex);
                            }
                            }"
                            BatchEditStartEditing="InicioEdicionSMD"
                            BatchEditRowInserting="onInserting"
                            BatchEditEndEditing="OnBatchEditEndEditing"
                            BatchEditRowValidating="OnValidation"
                            EndCallback="function(s, e){
                                if(s.cpOperacionGrid != null){
                                    LanzarMensaje(s.cpOperacionGrid);
                                }
                            }" />
                    </dx:ASPxGridView>
                </div>
                <dx:ASPxHiddenField runat="server" ID="hfAcciones"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT [Material].[Id], [Material].[Descripcion] FROM [Material] INNER JOIN [Stock] ON [Stock].IdMaterial = [Material].Id WHERE ([Stock].[IdAlmacen] = @IdAlmacen)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="-1" Name="IdAlmacen" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerAlmacenes" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Almacen"></asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){
            if(cmbTipoSalida.GetValue() == 'PrestamoMateriales'){
                $('#smOrdenTrabajo').hide();
                $('#smPrestamo').show();
            }
            else{
                $('#smOrdenTrabajo').show();
                $('#smPrestamo').hide();
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
                            <dx:GridViewDataDateColumn FieldName="RazonSocial" Caption="Razón Social" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
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
    <dx:ASPxCallbackPanel runat="server" ID="cpGetPrecioMaterial" ClientInstanceName="cpGetPrecioMaterial" OnCallback="cpGetPrecioMaterial_Callback" Theme="Material">
        <SettingsLoadingPanel Enabled="false" />
        <ClientSideEvents EndCallback="function(s, e){
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(Indice, 'Precio', s.cpPrecioS.split('|')[0]);
            lpProcess.Hide();
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(Indice, 'Stock', s.cpPrecioS.split('|')[1]);
            }" BeginCallback="function(s, e){lpProcess.Show();}"/>
    </dx:ASPxCallbackPanel>
    <dx:ASPxCallbackPanel runat="server" ID="cpGeStockMaterial" ClientInstanceName="cpGeStockMaterial" OnCallback="cpGeStockMaterial_Callback" Theme="Material">
        <SettingsLoadingPanel Enabled="false" />
        <ClientSideEvents EndCallback="function(s, e){
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(Indice, 'Stock', s.cpStockM);
            lpProcess.Hide();
            }" BeginCallback="function(s, e){lpProcess.Show();}" />
    </dx:ASPxCallbackPanel>

    <dx:ASPxLoadingPanel runat="server" ID="lpProcess" ClientInstanceName="lpProcess" Modal="true" Text="Procesando" Theme="Material"></dx:ASPxLoadingPanel>

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
