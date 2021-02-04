<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Recepciones.aspx.cs" Inherits="Fay_System.Recepciones" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        //ActualizarAlturaGrid(dgRecepciones);
        //ActualizarAlturaGrid(dgRecepcionDetalle);

        function OnBatchEditEndEditing(s, e) {
            window.setTimeout(function () {
                var cantidad, precio, tipoMoneda, precioD;
                //precioD = txtPrecioDolar.GetValue();
                cantidad = s.batchEditApi.GetCellValue(e.visibleIndex, "CantidadRecibida", null, true);
                precio = s.batchEditApi.GetCellValue(e.visibleIndex, "Precio", null, true);
                //tipoMoneda = s.batchEditApi.GetCellValue(e.visibleIndex, "TipoMoneda", null, true);
                s.batchEditApi.SetCellValue(e.visibleIndex, "Importe", cantidad * precio, null, true);
            }, 0);

            if ((e.focusedColumn.fieldName == 'CantidadRecibida' || e.focusedColumn.fieldName == 'Precio') && s.batchEditApi.GetCellValue(e.visibleIndex, 'Seleccion') == true)
                e.cancel = false;
            else if (e.focusedColumn.fieldName == 'Seleccion')
                e.cancel = false;
            else
                e.cancel = true;
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Recepciones" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1"></div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgRecepciones" runat="server" ClientInstanceName="dgRecepciones" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgRecepciones_CustomButtonCallback" EnableCallBacks="false">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" ShowStatusBar="Hidden"/>
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="Editar" Text="" Image-ToolTip="Detalle Recepción">
                                    <Image IconID="chart_chartsshowlegend_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="showReport" Text="" Image-ToolTip="Ver Reporte">
                                    <Image IconID="businessobjects_boreport_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="RazonSocial" Caption="Razon Social del Proveedor" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Documento" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Serie" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Numero" VisibleIndex="6" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="7" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') e.processOnServer=true;
                        if(e.buttonID == 'showReport'){
                            cpOpenReport.PerformCallback(s.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                            e.processOnServer = false;
                        }
                        if(e.buttonID == 'Anular') e.processOnServer = confirm('La Recepcion será anulada: está seguro que desea realizar esta acción?');
                        }" BatchEditStartEditing="function(s, e){if(e.FocusedColumn.fieldName != 'Nothing') e.cancel = true;}" />
                </dx:ASPxGridView>

            </div>
            <div class="col-12 col-md-1"></div>
        </div>
        <div class="row">
            <div class="col-5 col-sm-5"></div>
            <div class="col-2 col-sm-2">
                <dx:ASPxButton runat="server" ID="addRecepcion" ClientInstanceName="addRecepcion" Theme="Material" Text="Agregar" OnClick="addRecepcion_Click">
                </dx:ASPxButton>
            </div>
            <div class="col-5 col-sm-5"></div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorRecepciones" ClientInstanceName="pcEditorRecepciones" Theme="Moderno" HeaderText="Editor de Recepciones" PopupHorizontalAlign="WindowCenter">
        <SettingsAdaptivity Mode="Always" MaxWidth="900px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="lblIddlsjf" Text="Ord. C.:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxComboBox runat="server" ID="cmbIdOrdenCompra" ClientInstanceName="cmbIdOrdenCompra"
                            Theme="Material" Width="100%" DropDownStyle="DropDownList" DropDownWidth="400px"
                            OnValueChanged="cmbIdOrdenCompra_ValueChanged" AutoPostBack="true" ValueType="System.Int32"
                            ValueField="Id" TextField="RazonSocial">
                            <Columns>
                                <dx:ListBoxColumn FieldName="Id" Caption="N°Orden" Width="25"></dx:ListBoxColumn>
                                <dx:ListBoxColumn FieldName="Fecha" Width="27">
                                </dx:ListBoxColumn>
                                <dx:ListBoxColumn FieldName="NRequerimiento" Caption="N°Req" Width="20"></dx:ListBoxColumn>
                                <dx:ListBoxColumn FieldName="RazonSocial" Caption="Proveedor" Width="60"></dx:ListBoxColumn>
                            </Columns>
                        </dx:ASPxComboBox>
                    </div>
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Proveedor:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxComboBox runat="server" ID="cmbProveedor" ClientInstanceName="cmbProveedor"
                            Theme="Material" Width="100%" ValueField="Id" TextField="RazonSocial" ValueType="System.Int32">
                        </dx:ASPxComboBox>
                    </div>
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel4" Text="T. Doc.:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxComboBox runat="server" ID="cmbTipoDocumento" ClientInstanceName="cmbTipoDocumento"
                            Theme="Material" Width="100%" ValueField="Id" TextField="Descripcion" ValueType="System.Int32">
                        </dx:ASPxComboBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel2" Text="Serie Doc.:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxTextBox runat="server" ID="txtSerieDocumento" ClientInstanceName="txtSerieDocumento" Theme="Material" Width="100%" MaxLength="4">
                            <ValidationSettings Display="Dynamic" ValidationGroup="Recept" SetFocusOnError="true" ErrorDisplayMode="ImageWithTooltip">
                                <RequiredField IsRequired="True" ErrorText="Campo obligatorio" />
                            </ValidationSettings>
                            <ClientSideEvents KeyDown="ControlarEnterKey" />
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel3" Text="Núm. Doc.:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxTextBox runat="server" ID="txtNumeroDocumento" ClientInstanceName="txtNumeroDocumento" Theme="Material" Width="100%">
                            <ValidationSettings Display="Dynamic" ValidationGroup="Recept" ErrorDisplayMode="ImageWithTooltip" SetFocusOnError="true">
                                <RegularExpression ValidationExpression="^[0-9]+$" />
                                <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                            </ValidationSettings>
                            <ClientSideEvents KeyDown="ControlarEnterKey" />
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel5" Text="Estado:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxTextBox runat="server" ID="txtEstadoRecep" ClientInstanceName="txtEstadoRecep" Theme="Material" Width="100%"></dx:ASPxTextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel6" Text="Serie Guía:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxTextBox runat="server" ID="txtSerieGuia" ClientInstanceName="txtSerieGuia" Theme="Material" Width="100%" MaxLength="5">
                            <ValidationSettings Display="Dynamic" ValidationGroup="Recept" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                            </ValidationSettings>
                            <ClientSideEvents KeyDown="ControlarEnterKey" />
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel7" Text="Núm. Guía:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxTextBox runat="server" ID="txtNumeroGuia" ClientInstanceName="txtNumeroGuia" Theme="Material" Width="100%">
                            <ValidationSettings Display="Dynamic" ValidationGroup="Recept" ErrorDisplayMode="ImageWithTooltip" SetFocusOnError="true">
                                <RegularExpression ErrorText="No Válido" ValidationExpression="^[0-9]+$" />
                                <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                            </ValidationSettings>
                            <ClientSideEvents KeyDown="ControlarEnterKey" />
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-1 col-sm-1">
                        <dx:ASPxLabel runat="server" ID="ASPxLabel8" Text="Fecha:"></dx:ASPxLabel>
                    </div>
                    <div class="col-3 col-sm-3">
                        <dx:ASPxDateEdit runat="server" ID="deFechaRecepcion" ClientInstanceName="deFechaRecepcion" Theme="Material" Width="100%"></dx:ASPxDateEdit>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <dx:ASPxGridView ID="dgRecepcionDetalle" runat="server" ClientInstanceName="dgRecepcionDetalle"
                            Theme="Material" Width="100%" KeyFieldName="IdOrdenCompraDetalle" Visible="false">
                            <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                            <SettingsCommandButton>
                                <NewButton ButtonType="Image" RenderMode="Image">
                                    <Image IconID="actions_add_16x16">
                                    </Image>
                                </NewButton>
                            </SettingsCommandButton>
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="IdOrdenCompraDetalle" Caption="N°" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IdMaterial" Caption="N° Prod." VisibleIndex="1" AdaptivePriority="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="2" AdaptivePriority="1">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="CantidadRecibida" VisibleIndex="3" AdaptivePriority="1">
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataTextColumn FieldName="UnidadMedida" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="5" AdaptivePriority="2">
                                    <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="6" AdaptivePriority="2">
                                    <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>

                            </Columns>
                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                            <ClientSideEvents CustomButtonClick="function(s, e){
                            if(e.buttonID == 'Eliminar'){
                                s.DeleteRow(e.visibleIndex);
                            }
                            }" />
                        </dx:ASPxGridView>
                    </div>
                    <div class="col-12">
                        <dx:ASPxGridView ID="dgRecepcionDetalleNew" runat="server" ClientInstanceName="dgRecepcionDetalleNew"
                            Theme="Material" Width="100%" KeyFieldName="IdOrdenCompraDetalle"
                            OnCellEditorInitialize="dgRecepcionDetalleNew_CellEditorInitialize"
                            OnBatchUpdate="dgRecepcionDetalleNew_BatchUpdate">
                            <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"
                                AdaptiveColumnPosition="Right">
                            </SettingsAdaptivity>
                            <Columns>
                                <dx:GridViewDataCheckColumn FieldName="Seleccion" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataCheckColumn>
                                <dx:GridViewDataTextColumn FieldName="IdOrdenCompraDetalle" Caption="N°" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IdMaterial" Caption="N° Prod." VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="4" UnboundType="Integer"></dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="CantidadRecibida" VisibleIndex="5" UnboundType="Integer">
                                    <PropertiesSpinEdit AllowMouseWheel="false" ValidationSettings-RequiredField-IsRequired="true" NumberType="Integer" MinValue="1" MaxValue="1000000"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataTextColumn FieldName="UnidadMedida" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="7" AdaptivePriority="2">
                                    <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                                <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="8" AdaptivePriority="2">
                                    <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                                </dx:GridViewDataSpinEditColumn>
                            </Columns>
                            <Templates>
                                <StatusBar>
                                    <div style="text-align: right">
                                        <dx:ASPxHyperLink ID="hlSaveChanges" ClientInstanceName="hlSaveChanges" runat="server" Text="Guardar Cambios" Font-Bold="true" Theme="MaterialCompact" Cursor="pointer" NavigateUrl="javascript:void(0);">
                                            <DisabledStyle ForeColor="gray" />
                                            <ClientSideEvents Click="function(s, e){ 
                                                    ASPxClientEdit.ValidateEditorsInContainer(null);
                                                    var ind = dgRecepcionDetalleNew.GetVisibleRowsOnPage();
                                                    var contador = 0;
                                                    var isPostback = false;
                                                    for (var i = 0; i &lt; ind; i++) {
                                                        if (dgRecepcionDetalleNew.batchEditApi.GetCellValue(i, 'Seleccion') == true) {
                                                            contador = contador + 1;   
                                                        }
                                                    }
                                                    if(contador &gt; 0 && ASPxClientEdit.ValidateGroup('Recept')){
                                                        dgRecepcionDetalleNew.UpdateEdit();
                                                        e.processOnServer = true;
                                                    }
                                                    
                                                    else{
                                                        e.processOnServer = false;
                                                        hlSaveChanges.SetEnabled(true);
                                                    }
                                                    } " />
                                        </dx:ASPxHyperLink>
                                        &nbsp;
                                            <dx:ASPxHyperLink ID="hlCancel" ClientInstanceName="hlCancel" runat="server" Text="Cancelar Cambios" Cursor="pointer" Font-Bold="true" Theme="MaterialCompact" NavigateUrl="javascript:void(0);">
                                                <DisabledStyle ForeColor="gray" />
                                                <ClientSideEvents Click="function(s, e){ dgRecepcionDetalleNew.CancelEdit(); cbOrdenCompra.SetValue(0);}" />
                                            </dx:ASPxHyperLink>
                                    </div>
                                </StatusBar>
                            </Templates>

                            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                            <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click"></SettingsEditing>
                            <ClientSideEvents CustomButtonClick="function(s, e){
                            if(e.buttonID == 'Eliminar'){
                                s.DeleteRow(e.visibleIndex);
                            }
                            }"
                                BatchEditStartEditing="OnBatchEditEndEditing"
                                BatchEditRowValidating="function(s, e){
                                    var infoCeldaCantidad = e.validationInfo[s.GetColumnByField('Cantidad').index];
                                    var infoCeldaPrecio = e.validationInfo[s.GetColumnByField('Precio').index];
                                    var infoCeldaCantidadRecibida = e.validationInfo[s.GetColumnByField('CantidadRecibida').index];

                                    var cantidad = infoCeldaCantidad.value;
                                    var precio = infoCeldaPrecio.value;
                                    var CantidadRecibida = infoCeldaCantidadRecibida.value;
                                    if(CantidadRecibida == null || CantidadRecibida &lt; 0 || CantidadRecibida &gt; cantidad){
                                        infoCeldaCantidadRecibida.isValid = false;
                                        infoCeldaCantidadRecibida.errorText = 'Error, cantidad no válida';
                                    }
                                    else infoCeldaCantidadRecibida.isValid = true;
                                    if(precio &lt;= 0 ){
                                        infoCeldaPrecio.isValid = false;
                                        infoCeldaPrecio.errorText = 'El precio no puede ser menor o igual a cero';
                                    }
                                    else
                                        infoCeldaPrecio.isValid = true;
                                    
                                }"
                                EndCallback="function(s, e){
                                    pcEditorRecepciones.Hide();
                                    dgRecepciones.Refresh();
                                    if(s.cpAdminOperacion != null)
                                        LanzarMensaje(s.cpAdminOperacion);
                                }" />
                        </dx:ASPxGridView>
                    </div>
                </div>
                <dx:ASPxHiddenField runat="server" ID="hfAcciones"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Producto"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerEmpresas" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT e.Id, p.RazonSocial FROM Empresa e INNER JOIN Persona p on p.Id = e. IdPersona WHERE e.Proveedor = 1"></asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
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

    <dx:ASPxCallbackPanel runat="server" ID="cpOpenReport" ClientInstanceName="cpOpenReport" OnCallback="cpOpenReport_Callback">
        <ClientSideEvents EndCallback="function(s, e){
            if(s.cpRedireccion != null)
                window.open(s.cpRedireccion, '_blank');
            delete(s.cpRedireccion)
            }" />
    </dx:ASPxCallbackPanel>
</asp:Content>
