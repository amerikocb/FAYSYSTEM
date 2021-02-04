<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="OrdenesTrabajo.aspx.cs" Inherits="Fay_System.OrdenesTrabajo" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        hr {
            margin-top: 0 !important;
            width: 100%;
            border-top: 1px solid #26A69A !important;
        }

        .delAl {
            display: flex;
        }

        .DA {
            padding-top: 9px !important;
            padding-right: 2px !important;
        }

        .cbAut {
            display: inline-grid !important;
        }
    </style>
    <script type="text/javascript">
        ActualizarAlturaGrid(dgOrdenesTrabajo);
        //ActualizarAlturaGrid(dgRecepcionDetalle);
        var textSeparator = ";";
        function updateText(lista, combo) {
            var selectedItems = lista.GetSelectedItems();
            combo.SetText(getSelectedItemsText(selectedItems));
        }
        function synchronizeListBoxValues(combo1, lista1) {
            lista1.UnselectAll();
            var texts = combo1.GetText().split(';');
            var values = getValuesByTexts(texts, lista1);
            lista1.SelectValues(values);
            updateText(lista1, combo1); // for remove non-existing texts
        }
        function getSelectedItemsText(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                texts.push(items[i].text);
            return texts.join(';');
        }
        function getValuesByTexts(texts, lista2) {
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = lista2.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }
        function calcularSaldoOrden(s, e) {
            seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetText()) - parseFloat(seAdelanto.GetText()));
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administración de Órdenes de Trabajo" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1">
            </div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgOrdenesTrabajo" runat="server" ClientInstanceName="dgOrdenesTrabajo" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCustomButtonCallback="dgOrdenesTrabajo_CustomButtonCallback" EnableCallBacks="false">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" ShowStatusBar="Hidden" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <Columns>
                        <dx:GridViewCommandColumn VisibleIndex="0" Caption="Opciones" ButtonRenderMode="Image" ShowDeleteButton="true">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="Editar" Text="" Image-ToolTip="Editar">
                                    <Image IconID="actions_editname_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="Anular" Text="" Image-ToolTip="Anular">
                                    <Image IconID="actions_clear_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="showReport" Text="" Image-ToolTip="Ver Reporte">
                                    <Image IconID="businessobjects_boreport_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                                <dx:GridViewCommandColumnCustomButton ID="entregarOrden" Text="" Image-ToolTip="Entregar Orden de Trabajo">
                                    <Image IconID="actions_apply_16x16">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Trabajo" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="FechaEmision" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="FechaEntregaF" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataDateColumn>
                        <dx:GridViewDataTextColumn FieldName="DatosEjecutivo" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="DatosCliente" VisibleIndex="7" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="IdOrdenVenta" Caption="Orden Venta" VisibleIndex="8" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') e.processOnServer=true;
                        if(e.buttonID == 'entregarOrden'){
                            e.processOnServer= confirm('La orden de trabajo será bloqueada, impidiendo cualquier modificación posterior; está seguro que quiere realizar esta operación?');
                        }
                        if(e.buttonID == 'Anular') e.processOnServer = confirm('La Recepcion será anulada: está seguro que desea realizar esta acción?');
                        if(e.buttonID == 'showReport'){ 
                            cpOpenReport.PerformCallback(s.batchEditApi.GetCellValue(e.visibleIndex, 'Id'));
                            e.processOnServer=false
                        };
                     }"
                        BatchEditStartEditing="function(s, e){if(e.FocusedColumn.fieldName != 'Nothing') e.cancel = true;}" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-1"></div>
        </div>
        <div class="row">
            <div class="col-5 col-sm-5"></div>
            <div class="col-2 col-sm-2" style="display: none;">
                <dx:ASPxButton runat="server" ID="addOrdenTrabajo" ClientInstanceName="addOrdenTrabajo" Theme="Material" Text="Agregar" OnClick="addOrdenTrabajo_Click">
                </dx:ASPxButton>
            </div>
            <div class="col-5 col-sm-5"></div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEditorOrdenesTrabajo" ClientInstanceName="pcEditorOrdenesTrabajo" Theme="Moderno" HeaderText="Editor de OrdenesTrabajo" PopupHorizontalAlign="WindowCenter">
        <SettingsAdaptivity Mode="Always" MaxWidth="1100px" />
        <ContentCollection>
            <dx:PopupControlContentControl Width="100%">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel9" Text="Fecha Emisión:" Width="100%"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxDateEdit runat="server" ID="deFechaEmision" ClientInstanceName="deFechaEmision" Width="100%">
                                <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                    <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                </ValidationSettings>
                            </dx:ASPxDateEdit>
                        </div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel10" Text="Fecha Entrega:" Width="100%"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxDateEdit runat="server" ID="deFechaEntregaF" ClientInstanceName="deFechaEntregaF" Width="100%">
                                <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                    <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                </ValidationSettings>
                            </dx:ASPxDateEdit>
                        </div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel11" Text="Ejecutivo:" Width="100%"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxComboBox runat="server" ID="cmbEjecutivo" ClientInstanceName="cmbEjecutivo" Theme="Material" Width="100%" DataSourceID="dsObtnerOperadores"
                                TextField="Nombre" ValueField="Id" ValueType="System.Int32">
                                <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                    <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel1" Text="Cliente:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxComboBox runat="server" ID="cmbCliente" ClientInstanceName="cmbCliente"
                                Theme="Material" Width="100%" ValueType="System.Int32">
                                <ValidationSettings Display="Dynamic" ValidationGroup="ot" ErrorDisplayMode="ImageWithTooltip" ErrorText="No Válido" SetFocusOnError="true">
                                    <RequiredField IsRequired="True" ErrorText="Campo Obligatorio" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel19" Text="Trabajo:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-6">
                            <dx:ASPxMemo runat="server" ID="txtTrabajo" ClientInstanceName="txtTrabajo" Theme="Material" Width="100%" MaxLength="500">
                                <ClientSideEvents KeyDown="ControlarEnterKey" Init="function(s, e) {
                                                       s.GetInputElement().style.width='100%';
                                                    }" />
                            </dx:ASPxMemo>
                        </div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel16" Text="Contacto:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxTextBox runat="server" ID="seContacto" ClientInstanceName="seContacto" Theme="Material" Width="100%" MaxLength="9">
                                <ClientSideEvents KeyDown="ControlarEnterKey" Init="function(s, e) {
                                                       s.GetInputElement().style.width='100%';
                                                    }" />
                            </dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel15" Text="Operador:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxDropDownEdit runat="server" ID="cmbOperador" ClientInstanceName="cmbOperador"
                                Theme="Material" Width="100%" ValueType="System.Int32">
                                <DropDownWindowTemplate>
                                    <dx:ASPxListBox Width="100%" ID="listBox" ClientInstanceName="checkListBox" SelectionMode="CheckColumn" OnDataBound="listBox_DataBound"
                                        runat="server" Height="200" EnableSelectAll="true" DataSourceID="dsObtnerOperadores" TextField="Nombre" ValueField="Id">
                                        <FilteringSettings ShowSearchUI="true" />
                                        <Border BorderStyle="None" />
                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                        <ClientSideEvents SelectedIndexChanged="function(s, e){updateText(checkListBox, cmbOperador);}" />
                                    </dx:ASPxListBox>
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="padding: 4px">
                                                <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" Text="Cerrar" Style="float: right">
                                                    <ClientSideEvents Click="function(s, e){ cmbOperador.HideDropDown(); }" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </DropDownWindowTemplate>
                                <ClientSideEvents TextChanged="function(s, e){synchronizeListBoxValues(cmbOperador, checkListBox)}" DropDown="function(s, e){synchronizeListBoxValues(cmbOperador, checkListBox)}" />
                            </dx:ASPxDropDownEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2 col-2" style="text-align: right;"></div>
                        <div class="col-md-1 col-4" style="text-align: right;">
                            <dx:ASPxCheckBox runat="server" ID="cbxCTP" ClientInstanceName="cbxCTP" Theme="Material" Text="CTP"></dx:ASPxCheckBox>
                        </div>
                        <div class="col-md-2 col-2" style="text-align: right;"></div>
                        <div class="col-md-1 col-4" style="text-align: right;">
                            <dx:ASPxCheckBox runat="server" ID="cbxCanson" ClientInstanceName="cbxCanson" Theme="Material" Text="Canson"></dx:ASPxCheckBox>
                        </div>
                        <div class="col-md-1 col-2" style="text-align: right;"></div>
                        <div class="col-md-5 col-10" style="text-align: right;">
                            <dx:ASPxRadioButtonList runat="server" ID="rbColores" ClientInstanceName="rbColores" Theme="Material" RepeatDirection="Horizontal">
                                <Items>
                                    <dx:ListEditItem Value="FullColor" Text="Full Color" />
                                    <dx:ListEditItem Value="Colores" Text="Colores" />
                                    <dx:ListEditItem Value="UnColor" Text="1 Color" />
                                </Items>
                            </dx:ASPxRadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel21" Text="Num. Selecc:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxSpinEdit runat="server" ID="seNumSelecciones" ClientInstanceName="seNumSelecciones"
                                Theme="Material" Width="100%" MinValue="0" MaxValue="100000000" NumberType="Integer" AllowNull="false">
                            </dx:ASPxSpinEdit>
                        </div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel22" Text="Placas 1 Color:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxSpinEdit runat="server" ID="sePlaUnCol" ClientInstanceName="sePlaUnCol"
                                Theme="Material" Width="100%" MinValue="0" MaxValue="100000000" NumberType="Integer" AllowNull="false">
                            </dx:ASPxSpinEdit>
                        </div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel23" Text="Total Placas:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-2">
                            <dx:ASPxSpinEdit runat="server" ID="seTotalPlacas" ClientInstanceName="seTotalPlacas"
                                Theme="Material" Width="100%" MinValue="0" MaxValue="100000000" NumberType="Integer" AllowNull="false">
                            </dx:ASPxSpinEdit>
                        </div>
                    </div>
                    <%--<div class="row" style="display:none;">
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel6" Text="Máquina:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxTextBox runat="server" ID="txtMaquina" ClientInstanceName="txtMaquina" Theme="Material" Width="100%" MaxLength="5">
                                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                                            </dx:ASPxTextBox>
                                        </div>
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel7" Text="Pág. Portada:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxSpinEdit runat="server" ID="sePagPortada" ClientInstanceName="sePagPortada"
                                                Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Integer" AllowNull="false">
                                            </dx:ASPxSpinEdit>
                                        </div>
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel8" Text="Pág. Interiores:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxSpinEdit runat="server" ID="sePagInteriores" ClientInstanceName="sePagInteriores"
                                                Theme="Material" Width="100%" MinValue="0" MaxValue="100000" NumberType="Integer" AllowNull="false">
                                            </dx:ASPxSpinEdit>
                                        </div>
                                    </div>--%>
                    <%--<div class="row">
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel12" Text="Colores:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxTextBox runat="server" ID="txtColores" ClientInstanceName="txtColores" Theme="Material" Width="100%" MaxLength="500">

                                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                                            </dx:ASPxTextBox>
                                        </div>
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel13" Text="IColor:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxTextBox runat="server" ID="txtIColor" ClientInstanceName="txtIColor" Theme="Material" Width="100%" MaxLength="50">
                                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                                            </dx:ASPxTextBox>
                                        </div>
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel14" Text="Num. Seleciones:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                        </div>
                                    </div>--%>
                    <%--<div class="row">
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel15" Text="Full Color:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxCheckBox runat="server" ID="cbxFullColor" ClientInstanceName="cbxFullColor" Theme="Material" Text="Full Color">
                                            </dx:ASPxCheckBox>
                                        </div>
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel16" Text="Paneles:"></dx:ASPxLabel>
                                            <dx:ASPxCheckBox runat="server" ID="cbxPaneles" ClientInstanceName="cbxPaneles" Theme="Material" Text="Paneles">
                                            </dx:ASPxCheckBox>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxCheckBox runat="server" ID="cbxPaneles" ClientInstanceName="cbxPaneles" Theme="Material" Width="100%">
                                            </dx:ASPxCheckBox>
                                        </div>
                                        <div class="col-4 col-md-2" style="text-align: right;">
                                            <dx:ASPxLabel runat="server" ID="ASPxLabel17" Text="CTP:"></dx:ASPxLabel>
                                        </div>
                                        <div class="col-8 col-md-2">
                                            <dx:ASPxCheckBox runat="server" ID="cbxCTP" ClientInstanceName="cbxCTP" Theme="Material" Width="100%">
                                            </dx:ASPxCheckBox>
                                        </div>
                                    </div>--%>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel20" Text="Observaciones:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxMemo runat="server" ID="txtObservacionesMain" ClientInstanceName="txtObservacionesMain" Theme="Material" Width="100%" MaxLength="500">
                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                            </dx:ASPxMemo>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12" style="text-align: center; font-weight: bold;">
                            ALMACÉN - INVENTARIO
                        </div>
                        <hr />
                    </div>
                    <div class="row">
                        <div class="col-2" style="text-align: right;">#</div>
                        <div class="col-2" style="text-align: center;">Cantidad</div>
                        <div class="col-2" style="text-align: center;">Descripción</div>
                        <div class="col-2" style="text-align: center;">Demasia</div>
                        <div class="col-2" style="text-align: center;">Medida</div>
                        <div class="col-2" style="text-align: center;">Tam. Corte</div>
                    </div>
                    <div class="row">
                        <div class="col-2" style="text-align: right;">Pliegos</div>
                        <div class="col-2">
                            <dx:ASPxSpinEdit runat="server" ID="seCantPlieg" ClientInstanceName="seCantPlieg" Theme="Material" Width="100%" MinValue="0" MaxValue="100000000"></dx:ASPxSpinEdit>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtDescPli" ClientInstanceName="txdivescPli" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtDemPli" ClientInstanceName="txdivemPli" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtMedPli" ClientInstanceName="txtMedPli" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtTamCortPli" ClientInstanceName="txtTamCortPli" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-2" style="text-align: right;">Resmas</div>
                        <div class="col-2">
                            <dx:ASPxSpinEdit runat="server" ID="seCantResmas" ClientInstanceName="seCantResmas" Theme="Material" Width="100%" MinValue="0" MaxValue="100000000"></dx:ASPxSpinEdit>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtxDescResmas" ClientInstanceName="txdivescResmas" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtDemResmas" ClientInstanceName="txdivemResmas" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtMedResmas" ClientInstanceName="txtMedResmas" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-2">
                            <dx:ASPxTextBox runat="server" ID="txtTamCortResmas" ClientInstanceName="txtTamCortResmas" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row">AUTOCOPIATIVO</div>
                    <div class="row">
                        <div class="col-6 col-md-3" style="text-align: center;">
                            Hojas<dx:ASPxTextBox runat="server" ID="txtHojasAut" ClientInstanceName="txtHojasAut" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-6 col-md-3" style="text-align: center;">
                            Cantidad<dx:ASPxTextBox runat="server" ID="txtCantidadAut" ClientInstanceName="txtCantidadAut" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-6 col-md-3" style="text-align: center;">
                            <dx:ASPxCheckBox CssClass="cbAut" runat="server" ID="cbxCB" Text="CB" ClientInstanceName="cbxCB" Theme="Material"></dx:ASPxCheckBox>
                            <dx:ASPxTextBox runat="server" ID="txtCB" ClientInstanceName="txtCB" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-6 col-md-3" style="text-align: center;">
                            <dx:ASPxCheckBox CssClass="cbAut" runat="server" ID="cbxCF" Text="CF" ClientInstanceName="cbxCF" Theme="Material"></dx:ASPxCheckBox>
                            <dx:ASPxTextBox runat="server" ID="txtCF" ClientInstanceName="txtCF" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-6 col-md-3" style="text-align: center;">
                            <dx:ASPxCheckBox CssClass="cbAut" runat="server" ID="cbxCFB" Text="CFB" ClientInstanceName="cbxCFB" Theme="Material"></dx:ASPxCheckBox>
                            <dx:ASPxTextBox runat="server" ID="txtCFB" ClientInstanceName="txtCFB" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-6 col-md-3" style="text-align: center;">
                            <dx:ASPxCheckBox CssClass="cbAut" runat="server" ID="cbxCFB1" Text="CFB" ClientInstanceName="cbxCFB1" Theme="Material"></dx:ASPxCheckBox>
                            <dx:ASPxTextBox runat="server" ID="txtCFB1" ClientInstanceName="txtCFB1" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                        <div class="col-6 col-md-3" style="text-align: center;">
                            <dx:ASPxCheckBox CssClass="cbAut" runat="server" ID="cbxCFB2" Text="CFB" ClientInstanceName="cbxCFB2" Theme="Material"></dx:ASPxCheckBox>
                            <dx:ASPxTextBox runat="server" ID="txtCFB2" ClientInstanceName="txtCFB2" Theme="Material" Width="100%"></dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-12">

                            <%--<dx:ASPxGridView ID="dgBodegaInventarioCorte" runat="server" ClientInstanceName="dgBodegaInventarioCorte" EnableCallBacks="true"
                                Theme="Material" Width="100%" KeyFieldName="IdBodegaInventarioOrdenProduccion" OnCellEditorInitialize="generic_CellEditorInitialize"
                                OnBatchUpdate="dgBodegaInventarioCorte_BatchUpdate">
                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"
                                    AdaptiveColumnPosition="Right">
                                </SettingsAdaptivity>
                                <SettingsCommandButton>
                                    <NewButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_add_16x16">
                                        </Image>
                                    </NewButton>
                                    <DeleteButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </DeleteButton>
                                    <RecoverButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_reset_16x16">
                                        </Image>
                                    </RecoverButton>
                                </SettingsCommandButton>
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0" ShowNewButtonInHeader="true" ShowDeleteButton="true" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                    <dx:GridViewDataCheckColumn FieldName="IdBodegaInventarioOrdenProduccion" Visible="false" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataCheckColumn>
                                    <dx:GridViewDataTextColumn FieldName="Trabajo" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PliegoPrisma" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Descripcion" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Medida" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="TamañoCorte" VisibleIndex="5"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Demasia" VisibleIndex="6"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="TotalCorte" VisibleIndex="7"></dx:GridViewDataTextColumn>
                                </Columns>
                                

                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click">
                                    <BatchEditSettings StartEditAction="Click"></BatchEditSettings>
                                </SettingsEditing>
                                <ClientSideEvents
                                    EndCallback="function(s, e){
                                    if(s.cpBodegaInventario != null)
                                        LanzarMensaje(s.cpBodegaInventario);
                                }" />
                            </dx:ASPxGridView>--%>
                        </div>
                    </div>
                    <%--<div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel24" Text="Responsables:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxDropDownEdit runat="server" ID="cmbOperadorB" ClientInstanceName="cmbOperadorB"
                                Theme="Material" Width="100%" ValueType="System.Int32">
                                <DropDownWindowTemplate>
                                    <dx:ASPxListBox Width="100%" ID="listBox" ClientInstanceName="checkListBoxB" SelectionMode="CheckColumn" OnDataBound="listBox_DataBound"
                                        runat="server" Height="200" EnableSelectAll="true" DataSourceID="dsObtnerOperadores" TextField="Nombre" ValueField="Id">
                                        <FilteringSettings ShowSearchUI="true" />
                                        <Border BorderStyle="None" />
                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                        <ClientSideEvents SelectedIndexChanged="function(s, e){updateText(checkListBoxB, cmbOperadorB);}" />
                                    </dx:ASPxListBox>
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="padding: 4px">
                                                <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" Text="Cerrar" Style="float: right">
                                                    <ClientSideEvents Click="function(s, e){ cmbOperadorB.HideDropDown(); }" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </DropDownWindowTemplate>
                                <ClientSideEvents TextChanged="function(s, e){synchronizeListBoxValues(cmbOperadorB, checkListBoxB)}" DropDown="function(s, e){synchronizeListBoxValues(cmbOperadorB, checkListBoxB)}" />
                            </dx:ASPxDropDownEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12"></div>
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel25" Text="Observaciones:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxTextBox runat="server" ID="txtObservacionesB" ClientInstanceName="txtObservacionesB" Theme="Material" Width="100%" MaxLength="500">
                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                            </dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 text-center">
                            <dx:ASPxButton AutoPostBack="false" runat="server" ID="hlGuardarDatosBIC" ClientInstanceName="hlGuardarDatosBIC" Text="Guardar Datos Bodega Inventario Corte" Theme="Material">
                                <ClientSideEvents Click="function(s, e){cpSaveDatosOT.PerformCallback(1);}" />
                            </dx:ASPxButton>
                        </div>
                    </div>--%>
                    <div class="row" style="display: none;">
                        <div class="col-12" style="text-align: center; font-weight: bold;">
                            PRENSA
                        </div>
                        <hr />
                        <div class="col-12"></div>
                        <div class="col-12">
                            <dx:ASPxGridView ID="dgPrensaOrdenTrabajo" runat="server" ClientInstanceName="dgPrensaOrdenTrabajo" EnableCallBacks="true"
                                Theme="Material" Width="100%" KeyFieldName="IdPrensaOrdenTrabajo" OnCellEditorInitialize="generic_CellEditorInitialize"
                                OnBatchUpdate="dgPrensaOrdenTrabajo_BatchUpdate">
                                <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true"
                                    AdaptiveColumnPosition="Right">
                                </SettingsAdaptivity>
                                <SettingsCommandButton>
                                    <NewButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_add_16x16">
                                        </Image>
                                    </NewButton>
                                    <DeleteButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_trash_16x16">
                                        </Image>
                                    </DeleteButton>
                                    <RecoverButton ButtonType="Image" RenderMode="Image">
                                        <Image IconID="actions_reset_16x16">
                                        </Image>
                                    </RecoverButton>
                                </SettingsCommandButton>
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0" ShowNewButtonInHeader="true" ShowDeleteButton="true" ButtonRenderMode="Image"></dx:GridViewCommandColumn>
                                    <dx:GridViewDataCheckColumn FieldName="IdPrensaOrdenTrabajo" Visible="false" VisibleIndex="0" AdaptivePriority="1"></dx:GridViewDataCheckColumn>
                                    <dx:GridViewDataTextColumn FieldName="Trabajo" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Tamaño" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Tiros" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Demasia" VisibleIndex="4"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Tira" VisibleIndex="5"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Retira" VisibleIndex="6"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="P_Exceso" VisibleIndex="7"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="T" VisibleIndex="8"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="T_R" VisibleIndex="9"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="T_Plus_R" VisibleIndex="10"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Maquina" VisibleIndex="11"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Observaciones" VisibleIndex="12"></dx:GridViewDataTextColumn>
                                </Columns>

                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                <SettingsEditing Mode="Batch" BatchEditSettings-StartEditAction="Click">
                                    <BatchEditSettings StartEditAction="Click"></BatchEditSettings>
                                </SettingsEditing>
                                <ClientSideEvents
                                    EndCallback="function(s, e){
                                    if(s.cpPrensaOrden != null)
                                        LanzarMensaje(s.cpPrensaOrden);
                                }" />
                            </dx:ASPxGridView>
                        </div>
                    </div>
                    <div class="row" style="display: none">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel26" Text="Responsables:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxDropDownEdit runat="server" ID="cmbOperadorP" ClientInstanceName="cmbOperadorP"
                                Theme="Material" Width="100%" ValueType="System.Int32">
                                <DropDownWindowTemplate>
                                    <dx:ASPxListBox Width="100%" ID="listBox" ClientInstanceName="checkListBoxP" SelectionMode="CheckColumn" OnDataBound="listBox_DataBound"
                                        runat="server" Height="200" EnableSelectAll="true" DataSourceID="dsObtnerOperadores" TextField="Nombre" ValueField="Id">
                                        <FilteringSettings ShowSearchUI="true" />
                                        <Border BorderStyle="None" />
                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                        <ClientSideEvents SelectedIndexChanged="function(s, e){updateText(checkListBoxP, cmbOperadorP);}" />
                                    </dx:ASPxListBox>
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="padding: 4px">
                                                <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" Text="Cerrar" Style="float: right">
                                                    <ClientSideEvents Click="function(s, e){ cmbOperadorP.HideDropDown(); }" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </DropDownWindowTemplate>
                                <ClientSideEvents TextChanged="function(s, e){synchronizeListBoxValues(cmbOperadorP, checkListBoxP)}" DropDown="function(s, e){synchronizeListBoxValues(cmbOperadorP, checkListBoxP)}" />
                            </dx:ASPxDropDownEdit>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel27" Text="Observaciones:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxTextBox runat="server" ID="txtObservacionesP" ClientInstanceName="txtObservacionesP" Theme="Material" Width="100%" MaxLength="500">
                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                            </dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-12 text-center">
                            <dx:ASPxButton AutoPostBack="false" runat="server" ID="hlGuardarDatosP" ClientInstanceName="hlGuardarDatosP" Text="Guardar Datos Prensa" Theme="Material">
                                <ClientSideEvents Click="function(s, e){cpSaveDatosOT.PerformCallback(2);}" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12" style="text-align: center; font-weight: bold;">
                            POS - PRENSA
                        </div>
                        <hr />
                        <div class="col-12"></div>
                        <div class="col-12">
                            <dx:ASPxCallbackPanel runat="server" ID="cpPosPrensa" ClientInstanceName="cpPosPrensa" Theme="Material" OnCallback="cpPosPrensa_Callback">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <div class="container-fluid">
                                            <div class="row">
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxNumerado" ClientInstanceName="cbxNumerado" Text="Numerado"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6 delAl" style="text-align: center;">
                                                    <dx:ASPxLabel runat="server" ID="ASPxCheckBox1" Text="DEL: " CssClass="DA"></dx:ASPxLabel>
                                                    <dx:ASPxSpinEdit runat="server" ID="cbxDel" ClientInstanceName="cbxDel" NullText="DEL" AllowNull="false" MinValue="0" MaxValue="100000000" Width="100%"></dx:ASPxSpinEdit>
                                                </div>
                                                <div class="col-md-2 col-6 delAl" style="text-align: center;">
                                                    <dx:ASPxLabel runat="server" ID="ASPxLabel2" Text="AL:  " CssClass="DA"></dx:ASPxLabel>
                                                    <dx:ASPxSpinEdit runat="server" ID="cbxAl" ClientInstanceName="cbxAl" NullText="AL" AllowNull="false" MinValue="0" MaxValue="100000000" Width="100%"></dx:ASPxSpinEdit>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxCompaginado" ClientInstanceName="cbxCompaginado" Text="Compaginado"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxEncolado" ClientInstanceName="cbxEncolado" Text="Encolado"></dx:ASPxCheckBox>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxEngrampado" ClientInstanceName="cbxEngrampado" Text="Engrampado"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxPerforado" ClientInstanceName="cbxPerforado" Text="Perforado"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxTroquelado" ClientInstanceName="cbxTroquelado" Text="Troquelado"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxRefilado" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxAnillado" ClientInstanceName="cbxAnillado" Text="Anillado"></dx:ASPxCheckBox>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxRadioButton GroupName="rbBarPlas" runat="server" ID="cbxBarnizado" ClientInstanceName="cbxBarnizado" Text="Barnizado"></dx:ASPxRadioButton>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxRadioButton GroupName="rbMatBr" runat="server" ID="cbxMate" ClientInstanceName="cbxMate" Text="Mate"></dx:ASPxRadioButton>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxTira" ClientInstanceName="cbxTira" Text="Tira"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox4" ClientInstanceName="cbxBarnizado" Text="Barnizado"></dx:ASPxCheckBox>--%></div>
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxDobleRing" ClientInstanceName="cbxDobleRing" Text="Doble Ring"></dx:ASPxCheckBox>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-3 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox3" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>--%></div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxRadioButton GroupName="rbMatBr" runat="server" ID="cbxBrillante" ClientInstanceName="cbxBrillante" Text="Brillante"></dx:ASPxRadioButton>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxTiraRet" ClientInstanceName="cbxTiraRet" Text="Tira/Retira"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox3" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>--%></div>
                                                <div class="col-md-3 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox3" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>--%></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-3 col-6">
                                                    <dx:ASPxRadioButton GroupName="rbBarPlas" runat="server" ID="cbxPlastificado" ClientInstanceName="cbxPlastificado" Text="Plastificado"></dx:ASPxRadioButton>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxRadioButton GroupName="rbMatBr1" runat="server" ID="cbxMate1" ClientInstanceName="cbxMate1" Text="Mate"></dx:ASPxRadioButton>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxTira1" ClientInstanceName="cbxTira1" Text="Tira"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox1" ClientInstanceName="cbxAnillado" Text="Anillado"></dx:ASPxCheckBox>--%></div>
                                                <div class="col-md-3 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox2" ClientInstanceName="cbxDobleRing" Text="Doble Ring"></dx:ASPxCheckBox>--%></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-3 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox3" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>--%></div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxRadioButton GroupName="rbMatBr1" runat="server" ID="cbxBrillante1" ClientInstanceName="cbxBrillante1" Text="Brillante"></dx:ASPxRadioButton>
                                                </div>
                                                <div class="col-md-2 col-6">
                                                    <dx:ASPxCheckBox runat="server" ID="cbxTiraRet1" ClientInstanceName="cbxTiraRet1" Text="Tira/Retira"></dx:ASPxCheckBox>
                                                </div>
                                                <div class="col-md-2 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox3" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>--%></div>
                                                <div class="col-md-3 col-6"><%--<dx:ASPxCheckBox runat="server" ID="ASPxCheckBox3" ClientInstanceName="cbxRefilado" Text="Refilado"></dx:ASPxCheckBox>--%></div>
                                            </div>
                                        </div>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxCallbackPanel>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel28" Text="Responsables:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxDropDownEdit runat="server" ID="cmbOperadorPP" ClientInstanceName="cmbOperadorPP"
                                Theme="Material" Width="100%" ValueType="System.Int32">
                                <DropDownWindowTemplate>
                                    <dx:ASPxListBox Width="100%" ID="listBox" ClientInstanceName="checkListBoxPP" SelectionMode="CheckColumn" OnDataBound="listBox_DataBound"
                                        runat="server" Height="200" EnableSelectAll="true" DataSourceID="dsObtnerOperadores" TextField="Nombre" ValueField="Id">
                                        <FilteringSettings ShowSearchUI="true" />
                                        <Border BorderStyle="None" />
                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                        <ClientSideEvents SelectedIndexChanged="function(s, e){updateText(checkListBoxPP, cmbOperadorPP);}" />
                                    </dx:ASPxListBox>
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="padding: 4px">
                                                <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" Text="Cerrar" Style="float: right">
                                                    <ClientSideEvents Click="function(s, e){ cmbOperadorPP.HideDropDown(); }" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                </DropDownWindowTemplate>
                                <ClientSideEvents TextChanged="function(s, e){synchronizeListBoxValues(cmbOperadorPP, checkListBoxPP)}" DropDown="function(s, e){synchronizeListBoxValues(cmbOperadorPP, checkListBoxPP)}" />
                            </dx:ASPxDropDownEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-4 col-md-2" style="text-align: right;">
                            <dx:ASPxLabel runat="server" ID="ASPxLabel29" Text="Observaciones:"></dx:ASPxLabel>
                        </div>
                        <div class="col-8 col-md-10">
                            <dx:ASPxTextBox runat="server" ID="txtObservacionesPP" ClientInstanceName="txtObservacionesPP" Theme="Material" Width="100%" MaxLength="500">
                                <ClientSideEvents KeyDown="ControlarEnterKey" />
                            </dx:ASPxTextBox>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-12 text-center">
                            <dx:ASPxButton AutoPostBack="false" runat="server" ID="hlGuardarDatos" ClientInstanceName="hlGuardarDatos" Text="Guardar Datos Pos Prensa" Theme="Material">
                                <ClientSideEvents Click="function(s, e){cpPosPrensa.PerformCallback();}" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                    <dx:ASPxCallbackPanel runat="server" ID="cpSaveDatosOT" ClientInstanceName="cpSaveDatosOT" Theme="Material" OnCallback="cpSaveDatosOT_Callback">
                        <Styles>
                            <LoadingPanel HorizontalAlign="Center" VerticalAlign="Middle"></LoadingPanel>
                        </Styles>
                        <ClientSideEvents EndCallback="function(s, e){
                                                if(s.cpResultado != null)
                                                    LanzarMensaje(s.cpResultado);
                                            }" />
                    </dx:ASPxCallbackPanel>
                </div>

                <asp:SqlDataSource ID="dsObtnerOperadores" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT e.Id, p.Nombres + ' ' + p.ApellidoPaterno + ' ' + p.ApellidoMaterno  as Nombre FROM Empleado e INNER JOIN Persona p on p.Id = e. IdPersona"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerClientes" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT c.IdCliente, p.ApellidoPaterno + ' ' + p.ApellidoMaterno + ', ' + p.Nombres as Nombre FROM Cliente c INNER JOIN Persona p on p.Id = c. IdPersona"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerEstadosOT" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Estado WHERE IdTipoEstado = 20"></asp:SqlDataSource>
                <dx:ASPxHiddenField runat="server" ID="hfAcciones"></dx:ASPxHiddenField>
                <asp:SqlDataSource ID="ObtenerMateriales" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT Id, Descripcion FROM Producto"></asp:SqlDataSource>
                <asp:SqlDataSource ID="ObtenerEmpresas" runat="server" ConnectionString="<%$ connectionStrings:cone %>" SelectCommand="SELECT e.Id, p.RazonSocial FROM Empresa e INNER JOIN Persona p on p.Id = e. IdPersona WHERE e.Proveedor = 1"></asp:SqlDataSource>

                <div class="row">
                    <div class="col-5 col-sm-5">
                        <dx:ASPxLabel runat="server" ID="lblOperacion" ClientInstanceName="lblOperacion" ClientVisible="false"></dx:ASPxLabel>
                        <dx:ASPxLabel runat="server" ID="lblIdOrden" ClientInstanceName="lblIdOrden" ClientVisible="false"></dx:ASPxLabel>
                        <dx:ASPxLabel runat="server" ID="lblOperadores" ClientInstanceName="lblOperadores"></dx:ASPxLabel>
                    </div>
                    <div class="col-2 col-sm-2">
                        <dx:ASPxButton runat="server" ID="btnACeptarMain" ClientInstanceName="btnACeptarMain" Theme="Material"
                            Text="Aceptar" ValidationGroup="ot" OnClick="btnACeptarMain_Click">
                        </dx:ASPxButton>
                    </div>
                    <div class="col-5 col-sm-5"></div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){
            if(lblIdOrden.GetText() == 0)
                $('#cardInferior').hide();
            else
                $('#cardInferior').show();

            }" />
    </dx:ASPxPopupControl>

    <dx:ASPxPopupControl runat="server" ID="pcShowResults" ClientInstanceName="pcShowResults" HeaderText="Atención!!!">
        <SettingsAdaptivity Mode="Always" MaxWidth="400px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxLabel ID="lblMessage" ClientInstanceName="lblMessage" runat="server" Text="" Font-Bold="true"></dx:ASPxLabel>
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
