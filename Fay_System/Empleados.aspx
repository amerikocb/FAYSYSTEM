<%@ Page Title="" Language="C#" MasterPageFile="~/PaginaMaestra.Master" AutoEventWireup="true" CodeBehind="Empleados.aspx.cs" Inherits="Fay_System.Empleados" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var IdEmpleado = 0;
        var isPostback = false;
        function OnClick(s, e) {
            e.processOnServer = !isPostback;
            isPostback = true;
        }
    </script>
    <div class="container-fluid">
        <div class="row" style="text-align: center;">
            <div class="col-12 form-title">
                <dx:ASPxLabel runat="server" ID="formTitle" ClientInstanceName="formTitle" Text="Administrador de Empleados" Font-Bold="true" Font-Size="Larger" ForeColor="#009688"></dx:ASPxLabel>
            </div>
        </div>
        <div class="row">
            <div class="col-12 col-md-1">
            </div>
            <div class="col-12 col-md-10">
                <dx:ASPxGridView ID="dgEmpleados" runat="server" ClientInstanceName="dgEmpleados" KeyFieldName="Id"
                    Theme="Material" Width="100%" OnCommandButtonInitialize="dgEmpleados_CommandButtonInitialize" EnableCallBacks="true">
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
                            </CustomButtons>
                        </dx:GridViewCommandColumn>
                        <dx:GridViewDataTextColumn FieldName="Id" Caption="Id" VisibleIndex="1" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="DNI" Caption="DNI" VisibleIndex="2" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="RUC" Caption="RUC" VisibleIndex="3" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="NombreCompleto" Caption="Empleado" VisibleIndex="4" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Cargo" Caption="Cargo" VisibleIndex="5" AdaptivePriority="1"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Profesion" Caption="Profesión" VisibleIndex="6" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="Estado" Caption="Estado" VisibleIndex="7" AdaptivePriority="2"></dx:GridViewDataTextColumn>
                    </Columns>
                    <SettingsEditing Mode="Batch"></SettingsEditing>
                    <SettingsPager PageSize="5"></SettingsPager>
                    <ClientSideEvents CustomButtonClick="function(s, e){
                        if(e.buttonID == 'Editar') 
                            IdEmpleado = s.batchEditApi.GetCellValue(e.visibleIndex, 'Id');
                            campoO.SetText('1');
                            pcEmpleados.Show();
                        }"
                        BatchEditStartEditing="function(s, e){if(e.focusedColumn.fieldName != 'Hola') e.cancel = true;}" />
                </dx:ASPxGridView>
            </div>
            <div class="col-12 col-md-1"></div>
        </div>
        <div class="row">
            <div class="col-12 col-md-12" style="text-align: center;">
                <dx:ASPxButton runat="server" ID="btnAgregarEmpleados" AutoPostBack="false" ClientInstanceName="btnAgregarEmpleados" Theme="Material" Text="Agregar" OnClick="btnAgregarEmpleados_Click">
                    <ClientSideEvents Click="function(s, e){
                        campoO.SetText('2');
                        pcEmpleados.Show();
                        e.processOnServer = false;
                        }" />
                </dx:ASPxButton>
            </div>
        </div>
    </div>
    <dx:ASPxPopupControl runat="server" ID="pcEmpleados" ClientInstanceName="pcEmpleados" Theme="Moderno" HeaderText="Empleados" PopupHorizontalAlign="WindowCenter">
        <SettingsAdaptivity Mode="Always" MaxWidth="800px" />
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="cpEditorEmpleados" Width="100%" ClientInstanceName="cpEditorEmpleados" Theme="BassetTheme" OnCallback="cpEditorEmpleados_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblCodigo" runat="server" Theme="Material" Text="Id:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtId" ClientInstanceName="txtId" runat="server" Theme="Material" ReadOnly="true">
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblDNI" runat="server" Theme="Material" Text="DNI:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtDni" ClientInstanceName="txtDni" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblApPaterno" runat="server" Theme="Material" Text="Ap. Paterno:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtApPaterno" ClientInstanceName="txtApPaterno" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblApMaterno" runat="server" Theme="Material" Text="Ap. Materno:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtApMaterno" ClientInstanceName="txtApMaterno" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblNombres" runat="server" Theme="Material" Text="Nombres:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtNombre" ClientInstanceName="txtNombre" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblSexo" runat="server" Theme="Material" Text="Sexo:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbSexo" ClientInstanceName="cmbSexo" runat="server" Theme="Material">
                                                    <Items>
                                                        <dx:ListEditItem Value="Femenino" Text="Femenino" />
                                                        <dx:ListEditItem Value="Masculino" Text="Masculino" />
                                                    </Items>
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblFechaNac" runat="server" Theme="Material" Text="Fecha Nacimiento">
                                                </dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxDateEdit ID="deFechaN" ClientInstanceName="deFechaN" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxDateEdit>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-sm-6">
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblCargo" runat="server" Theme="Material" Text="Cargo:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbCargo" ClientInstanceName="cmbCargo" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblProfesión" runat="server" Theme="Material" Text="Profesión:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbProfesion" ClientInstanceName="cmbProfesion" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblEmail" runat="server" Theme="Material" Text="Email:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtEmail" ClientInstanceName="txtEmail" runat="server" Theme="Material">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RegularExpression ValidationExpression="^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})$" ErrorText="No válido" />
                                                    </ValidationSettings>
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblTelefono" runat="server" Theme="Material" Text="Teléfono:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxTextBox ID="txtTelefono" ClientInstanceName="txtTelefono" runat="server" Theme="Material">
                                                </dx:ASPxTextBox>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblRUC" runat="server" Theme="Material" Text="RUC:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxSpinEdit ID="txtRuc" ClientInstanceName="txtRuc" runat="server" Theme="Material" NumberType="Integer" MinValue="0" MaxValue="999999999999">
                                                </dx:ASPxSpinEdit>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-3 col-md-5 text-right">
                                                <dx:ASPxLabel ID="lblEstado" runat="server" Theme="Material" Text="Estado:"></dx:ASPxLabel>
                                            </div>
                                            <div class="col-7 col-md-7 col-centrada">
                                                <dx:ASPxComboBox ID="cmbEstado" ClientInstanceName="cmbEstado" runat="server" Theme="Material" ValueType="System.Int32" TextField="Descripcion" ValueField="Id">
                                                    <ValidationSettings Display="Dynamic" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Empleados">
                                                        <RequiredField IsRequired="true" ErrorText="Campo Requerido" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">

                                    <div class="col-3 col-md-2 text-right">
                                        <dx:ASPxLabel ID="lblDireccion" runat="server" Theme="Material" Text="Dirección:"></dx:ASPxLabel>
                                    </div>
                                    <div class="col-9 col-md-10 col-centrada">
                                        <dx:ASPxTextBox ID="txtDireccion" ClientInstanceName="txtDireccion" runat="server" Theme="Material" Width="100%">
                                        </dx:ASPxTextBox>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-1 col-md-3"></div>
                                    <div class="col-3 col-md-3 text-right">
                                        <dx:ASPxButton ID="btnAceptar" ClientInstanceName="btnAceptar" runat="server" Text="Aceptar" Theme="Material" OnClick="btnAceptar_Click" ValidationGroup="Empleados">
                                            <ClientSideEvents Click="OnClick" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-3 col-md-3 text-left">
                                        <dx:ASPxButton ID="btnCancelar" ClientInstanceName="btnCancelar" runat="server" Text="Cancelar" Theme="Material" AutoPostBack="false">
                                            <ClientSideEvents Click="function(s, e){pcEmpleados.Hide();}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <div class="col-3 col-md-3">
                                        <dx:ASPxTextBox ID="campoO" runat="server" ClientInstanceName="campoO" Border-BorderColor="White" Width="1px"></dx:ASPxTextBox>
                                    </div>
                                </div>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Shown="function(s, e){
            cpEditorEmpleados.PerformCallback(IdEmpleado);
            }" />
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
