<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Transferencias.aspx.cs" Inherits="Fay_System.Transferencias" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .gridCentrado {
            margin: 0 auto;
        }
    </style>
    <script type="text/javascript">
        var IdUsuario = 0;
        function OnMenuPadreChanged(cmbParent) {
            if (isUpdating)
                return;
            var comboValue = cmbParent.GetSelectedItem().value;
            if (comboValue)
                dgOpcionesMenu.GetEditor("IdMenuHijo").PerformCallback(comboValue.toString());
        }
        var combo = null;
        var isUpdating = false;
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Transferencias de Stock" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-2">
            </div>
            <div class="col-12 col-md-8">
                <dx:ASPxGridView runat="server" ClientInstanceName="dgTransferencias" Theme="Material" Width="100%" 
                    ID="dgTransferencias" EnableCallBacks="False" OnCustomButtonCallback="dgTransferencias_CustomButtonCallback">
                    <SettingsSearchPanel Visible="true" />
                    <Settings ShowFilterRow="true" ShowFilterRowMenu="true" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" AllowOnlyOneAdaptiveDetailExpanded="true" AdaptiveColumnPosition="Right"></SettingsAdaptivity>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <Columns>
                        <dx:GridViewCommandColumn ButtonRenderMode="Image">
                            <CustomButtons>
                                <dx:GridViewCommandColumnCustomButton ID="Detail">
                                    <Image IconID="actions_show_16x16" ToolTip="Ver Detalle">
                                    </Image>
                                </dx:GridViewCommandColumnCustomButton>
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="AlmacenOrigen" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="AlmacenDestino" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Usuario" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataDateColumn FieldName="Fecha" VisibleIndex="5" AdaptivePriority="2"></dx:GridViewDataDateColumn>
                    </Columns>
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-2"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarTr" AutoPostBack="false" ClientInstanceName="btnAgregarTr" Theme="Material" Text="Agregar" OnClick="btnAgregarTr_Click">
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl ID="ASPxTransferencias" runat="server" ClientInstanceName="ASPxTransferencias" DragElement="Window" HeaderText="Transferencias" 
        Height="534px" PopupElementID="btnAgregar" Theme="Material" Width="600px" PopupHorizontalAlign="WindowCenter" 
        PopupVerticalAlign="WindowCenter" Modal="True" CloseAction="CloseButton" ScrollBars="Auto">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-3 text-right">ID:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxTextBox ID="nroTransferencia" runat="server" ClientInstanceName="nroTransferencia" Theme="Material" Width="100%" ReadOnly="True">
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
                        <div class="col-3 text-right">Almacén Orígen:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxComboBox ID="almacenOrigen" runat="server" AutoPostBack="true" Width="100%" Theme="Material" NullText="Almacén Origen" NullTextStyle-ForeColor="#ff9900" 
                                OnSelectedIndexChanged="almacenOrigen_SelectedIndexChanged" ValueType="System.Int32">
                                <NullTextStyle ForeColor="#FF9900"></NullTextStyle>
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Transf">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 text-right">Almacén Destino:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxComboBox ID="almacenDestino" runat="server" Width="100%" Theme="Material" NullText="Almacén Destino" NullTextStyle-ForeColor="#ff9900" ValueType="System.Int32">
                                <NullTextStyle ForeColor="#FF9900"></NullTextStyle>
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Transf">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 text-right">Material:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxComboBox runat="server" ID="producto" Width="100%" Theme="Material" NullText="Seleccione Producto" TextFormatString="{0}" DropDownWidth="100%">
                                <Columns>
                                    <dx:ListBoxColumn FieldName="Descripcion" Caption="Descripción" Width="360" />
                                    <dx:ListBoxColumn FieldName="UnitsStock" Caption="Stock" Width="40" />
                                </Columns>

                                <NullTextStyle ForeColor="#FF9900"></NullTextStyle>

                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Transf">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                                <ClientSideEvents ValueChanged="function(s, e){StockDisponible.SetText(s.GetSelectedItem().texts[1]);}" />
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 text-right">Stock:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxSpinEdit ID="StockDisponible" ClientInstanceName="StockDisponible" runat="server" MaxValue="10000" Theme="Material" Width="100%" ClientEnabled="false">
                            </dx:ASPxSpinEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 text-right">Motivo:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxMemo ID="txtMotivo" ClientInstanceName="txtMotivo" runat="server" Width="100%" Theme="Material" NullText="Ingrese un motivo" NullTextStyle-ForeColor="#ff9900" MaxLength="500">
                                <NullTextStyle ForeColor="#FF9900"></NullTextStyle>
                            </dx:ASPxMemo>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-3 text-right">Cant. Transf:</div>
                        <div class="col-9 text-right">
                            <dx:ASPxSpinEdit ID="transferir" runat="server" Width="100%" Theme="Material" MinValue="0" MaxValue="10000" AllowMouseWheel="false">
                                <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Transf">
                                    <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                </ValidationSettings>
                            </dx:ASPxSpinEdit>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 text-right">
                            <dx:ASPxButton ID="btnAgregarMaterial" runat="server" OnClick="btnAgregarMaterial_Click" Text="Transferir" Theme="Material" ValidationGroup="Transf" Width="100%">
                                <ClientSideEvents Click="function(s, e){
                                    if(ASPxClientEdit.ValidateGroup('Transf'))
                                        window.setTimeout(function(){s.SetEnabled(false); },0);
                                    }" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <dx:ASPxLabel ID="mensaje" runat="server" Font-Bold="True" Font-Size="Small" ForeColor="Red" Theme="Material" Width="100%">
                            </dx:ASPxLabel>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 font-weight-bold text-center">MATERIALES TRANSFERIDOS</div>
                        <div class="col-12">
                            <dx:ASPxGridView ID="productosTransferidos" runat="server" AutoGenerateColumns="False" KeyFieldName="Id" CssClass="gridCentrado" Theme="Material" Width="100%">
                                <SettingsPager PageSize="5"></SettingsPager>
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="Material"  VisibleIndex="0"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Cantidad" Width="90" VisibleIndex="1"></dx:GridViewDataTextColumn>
                                </Columns>
                            </dx:ASPxGridView>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12" style="text-align: center;">
                            <dx:ASPxButton ID="btnVolver" runat="server" AutoPostBack="False" ClientInstanceName="btnVolver" Text="Cancelar" Theme="Material" Style="margin-top: 20px" >
                                <ClientSideEvents Click="function(s, e) { ASPxTransferencias.Hide(); e.processOnServer = false; }" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                </div>
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
</asp:Content>
