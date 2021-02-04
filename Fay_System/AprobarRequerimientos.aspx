<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="AprobarRequerimientos.aspx.cs" Inherits="Fay_System.AprobarRequerimientos" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        ActualizarAlturaGrid(dgRequerimientos);
        ActualizarAlturaGrid(dgRequerimientoDetalle);

        var precioS, Indice, nuevaFila;
        var curentEditingIndex;
        var lastMaterial = null;
        var isCustomCascadingCallback = false;

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
            }, 0);
        }

        function InicioEdicionRD(s, e) {
            Indice = e.visibleIndex;
            if (e.focusedColumn.fieldName == 'Id' || e.focusedColumn.fieldName == 'Importe' || e.focusedColumn.fieldName == 'Equivalencia')
                e.cancel = true;
            if (e.visibleIndex < 0) {
                s.batchEditApi.SetCellValue(e.visibleIndex, 'TipoMoneda', "Soles");
                s.batchEditApi.SetCellValue(e.visibleIndex, 'Cantidad', "1");
                s.batchEditApi.SetCellValue(e.visibleIndex, 'Proveedor', "1");
            }
        }

        function InicioEdicionRD(s, e) {
            Indice = e.visibleIndex;
            if (e.focusedColumn.fieldName == 'Id' || e.focusedColumn.fieldName == 'Importe' || e.focusedColumn.fieldName == 'Equivalencia')
                e.cancel = true;
            if (e.visibleIndex < 0 && nuevaFila == true) {
                s.batchEditApi.SetCellValue(e.visibleIndex, 'TipoMoneda', "Soles");
                s.batchEditApi.SetCellValue(e.visibleIndex, 'Cantidad', "1");
                s.batchEditApi.SetCellValue(e.visibleIndex, 'Proveedor', "1");
            }

            nuevaFila = false;
            curentEditingIndex = e.visibleIndex;
            var currentMaterial = dgRequerimientoDetalle.batchEditApi.GetCellValue(curentEditingIndex, "IdMaterial");
            hf.Set("CurrentMaterial", currentMaterial);
            if (currentMaterial != lastMaterial && e.focusedColumn.fieldName == "IdUnidadMedida" && currentMaterial != null) {
                lastMaterial = currentMaterial;
                RefreshData(currentMaterial);
            }
        }

        function onInserting(s, e) {
            nuevaFila = true;
        }

        function MaterialCombo_SelectedIndexChanged(s, e) {
            lastMaterial = s.GetValue();
            isCustomCascadingCallback = true;
            cpGetPrecioMaterial.PerformCallback(s.GetValue() + '|' + 1);
            RefreshData(lastMaterial);
        }
        function UnidadMedida_EndCallback(s, e) {
            if (isCustomCascadingCallback) {
                if (s.GetItemCount() > 0)
                    dgRequerimientoDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdUnidadMedida", s.GetItem(0).value);
                isCustomCascadingCallback = false;
            }
        }

        function RefreshData(materialValue) {
            hf.Set("CurrentMaterial", materialValue);
            UnidadMedidaEditor.PerformCallback();
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Aprobar Requerimientos" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView ID="dgRequerimientos" runat="server" ClientInstanceName="dgRequerimientos" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgRequerimientos_CustomButtonCallback" EnableCallBacks="true">
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
                                <dx:GridViewCommandColumnCustomButton ID="Anular" Text="">
                                    <Image IconID="actions_clear_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="EstadoRequerimiento" VisibleIndex="3" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="4" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') e.processOnServer=true;
                        if(e.buttonID == 'Anular') e.processOnServer = confirm('El requerimiento será anulado: está seguro que desea realizar esta acción?');
                        }" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorRequerimientos" ClientInstanceName="pcEditorRequerimientos" Theme="Moderno" HeaderText="Editor de Requerimientos" PopupHorizontalAlign="WindowCenter">
        <SettingsAdaptivity Mode="Always" MaxWidth="1000px" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div class="row">
                    <div class="col-3"></div>
                    <div class="col-3 col-md-2" style="text-align: right;">
                        <dx:ASPxLabel runat="server" ID="lblPrecioDolar" ClientInstanceName="lblPrecioDolar" Theme="Material" Text="Precio Dólar: S/"></dx:ASPxLabel>
                        <dx:ASPxHiddenField runat="server" ID="hf" ClientInstanceName="hf"></dx:ASPxHiddenField>
                    </div>
                    <div class="col-9 col-md-4">
                        <dx:ASPxTextBox runat="server" ID="txtPrecioDolar" ClientInstanceName="txtPrecioDolar" Theme="Material" Width="100%" ReadOnly="true">
                        </dx:ASPxTextBox>
                    </div>
                    <div class="col-3"></div>
                </div>
                <div class="row">
                    <dx:ASPxGridView ID="dgRequerimientoDetalle" runat="server" ClientInstanceName="dgRequerimientoDetalle"
                        Theme="Material" Width="100%" OnBatchUpdate="dgRequerimientoDetalle_BatchUpdate" KeyFieldName="Id"
                        EnableCallBacks="true" OnCellEditorInitialize="dgRequerimientoDetalle_CellEditorInitialize">
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
                                <CustomButtons>
                                    <dx:GridViewCommandColumnCustomButton ID="Eliminar" Text="">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </dx:GridViewCommandColumnCustomButton>
                                </CustomButtons>
                            </dx:GridViewCommandColumn>
                            <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1" Visible="false"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="Material" VisibleIndex="2" AdaptivePriority="1">
                                <PropertiesComboBox ClientInstanceName="cmbMateriales" ValueField="Id" TextField="Descripcion" DataSourceID="ObtenerMateriales">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                    <ClientSideEvents SelectedIndexChanged="MaterialCombo_SelectedIndexChanged" />
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="Proveedor" VisibleIndex="2" AdaptivePriority="1">
                                <PropertiesComboBox ClientInstanceName="cmbEmpresa" ValueField="Id" TextField="RazonSocial" DataSourceID="ObtenerEmpresas">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataComboBoxColumn FieldName="TipoMoneda" VisibleIndex="3" AdaptivePriority="1" UnboundType="String">
                                <PropertiesComboBox>
                                    <Items>
                                        <dx:ListEditItem Value="Dolares" Text="Dólares" Selected="true" />
                                        <dx:ListEditItem Value="Soles" />
                                    </Items>
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesComboBox>
                            </dx:GridViewDataComboBoxColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Cantidad" VisibleIndex="4" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="g" MinValue="1" NumberType="Integer" MaxValue="100000000">
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
                            <dx:GridViewDataSpinEditColumn FieldName="Precio" VisibleIndex="5" AdaptivePriority="1" UnboundType="Decimal">
                                <PropertiesSpinEdit NumberType="Float" MinValue="0" MaxValue="100000" DisplayFormatString="f4">
                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" Display="Dynamic">
                                        <RequiredField IsRequired="true" ErrorText="Campo requerido" />
                                    </ValidationSettings>
                                </PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataSpinEditColumn FieldName="Importe" VisibleIndex="6" AdaptivePriority="1">
                                <PropertiesSpinEdit DisplayFormatString="f4"></PropertiesSpinEdit>
                            </dx:GridViewDataSpinEditColumn>
                            <dx:GridViewDataTextColumn FieldName="Equivalencia" VisibleIndex="7" PropertiesTextEdit-DisplayFormatString="f4"></dx:GridViewDataTextColumn>
                        </Columns>
                        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                        <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click" BatchEditSettings-HighlightDeletedRows="true"></SettingsEditing>
                        <ClientSideEvents CustomButtonClick="function(s, e){
                            if(e.buttonID == 'Eliminar'){
                                s.DeleteRow(e.visibleIndex);
                            }
                            }"
                            BatchEditStartEditing="InicioEdicionRD"
                            BatchEditRowInserting="onInserting"
                            EndCallback="function(s, e){
                                pcEditorRequerimientos.Hide();
                                if(s.cpOperacionGrid != null){
                                    LanzarMensaje(s.cpOperacionGrid);
                                    dgRequerimientos.Refresh();
                                }
                            }"
                            BatchEditEndEditing="OnBatchEditEndEditing" />
                    </dx:ASPxGridView>
                </div>
                <div class="row">
                    <div class="col-4"></div>
                    <div class="col-4">
                        <dx:ASPxButton runat="server" ID="btnAprobarRequerimiento" ClientInstanceName="btnAprobarRequerimiento" Theme="Material" Text="Aprobar Requerimiento" OnClick="btnAprobarRequerimiento_Click">
                        </dx:ASPxButton>
                    </div>
                    <div class="col-4"></div>
                </div>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Material"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerEmpresas" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT e.Id, p.RazonSocial FROM Empresa e INNER JOIN Persona p on p.Id = e. IdPersona WHERE e.Proveedor = 1"></asp:SqlDataSource>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxCallbackPanel runat="server" ID="cpGetPrecioMaterial" ClientInstanceName="cpGetPrecioMaterial" OnCallback="cpGetPrecioMaterial_Callback" Theme="Material">
        <SettingsLoadingPanel Enabled="false" />
        <ClientSideEvents EndCallback="function(s, e){
                dgRequerimientoDetalle.batchEditApi.SetCellValue(Indice, 'Precio', s.cpStockM.split('|')[0]);
                lpProcess.Hide();
        }"
            BeginCallback="function(s, e){lpProcess.Show();}" />
    </dx:ASPxCallbackPanel>

    <dx:ASPxLoadingPanel runat="server" ID="lpProcess" ClientInstanceName="lpProcess" Modal="true" Text="Procesando"></dx:ASPxLoadingPanel>

    <dx:ASPxPopupControl runat="server" ID="pcShowResults" ClientInstanceName="pcShowResults" HeaderText="Mensaje del Sistema" Theme="iOS">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxLabel ID="lblMessage" ClientInstanceName="lblMessage" runat="server" Text=""></dx:ASPxLabel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){setTimeout(function () { pcShowResults.Hide(); }, 3000);}" />
    </dx:ASPxPopupControl>
</asp:Content>
