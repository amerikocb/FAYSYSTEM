<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Fay_System.Login" %>

<%@ Register Assembly="DevExpress.Web.v17.2, Version=17.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>

<body>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link href="Content/Site.css" rel="stylesheet" />
    <form id="form1" runat="server">
        <dx:ASPxPopupControl ID="AccesoFayceWindow" runat="server" ClientInstanceName="AccesoFayceWindow" CloseAction="None"
            Theme="BassetTheme" HeaderText="Acceso - Faysystem">
            <SettingsAdaptivity Mode="Always" MaxWidth="400px" HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter"></SettingsAdaptivity>
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div class="continer-fluid">
                        <div class="row">
                            <div class="col-2"></div>
                            <div class="col-3 titulo-control">
                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Usuario: "></dx:ASPxLabel>
                            </div>
                            <div class="col-5">
                                <dx:ASPxTextBox ID="txtUsuario" ClientInstanceName="txtUsuario" runat="server" Width="100%" Theme="BassetTheme"></dx:ASPxTextBox>
                            </div>
                            <div class="col-2"></div>
                        </div>
                        <div class="row">
                            <div class="col-2"></div>
                            <div class="col-3 titulo-control">
                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Contraseña: "></dx:ASPxLabel>
                            </div>
                            <div class="col-5">
                                <dx:ASPxTextBox ID="txtPass" ClientInstanceName="txtPass" runat="server" Width="100%" Theme="BassetTheme" Password="true"></dx:ASPxTextBox>
                            </div>
                            <div class="col-2"></div>
                        </div>
                        <div class="row">
                            <div class="col-2"></div>
                            <div class="col-8" style="text-align: center">
                                <dx:ASPxLabel ID="lblControlErrores" runat="server" Text="" ClientInstanceName="lblControlErrores"></dx:ASPxLabel>
                            </div>
                            <div class="col-2"></div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-2"></div>
                            <div class="col-4 titulo-control">
                                <dx:ASPxButton ID="btnAceptar" runat="server" ClientInstanceName="btnAceptar" Text="Aceptar" Theme="BassetTheme" AutoPostBack="false">
                                    <ClientSideEvents Click="function(s, e){cpValidateUser.PerformCallback();}" />
                                </dx:ASPxButton>
                            </div>
                            <div class="col-4">
                                <dx:ASPxButton ID="btnCancelar" runat="server" ClientInstanceName="btnCancelar" Text="Cancelar" Theme="BassetTheme"></dx:ASPxButton>
                            </div>
                            <div class="col-2"></div>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxCallbackPanel runat="server" ID="cpValidateUser" ClientInstanceName="cpValidateUser" OnCallback="cpValidateUser_Callback">
            <SettingsLoadingPanel Enabled="false" />
            <ClientSideEvents EndCallback="function(s, e){
                if(s.cpError != null){
                    pcShowResults.Show();
                    lblMessage.SetText(s.cpError);
                    txtUsuario.SetText(null);
                    txtPass.SetText(null);
                    txtUsuario.SetFocus();
                    delete(s.cpError);
                    lpProcess.Hide();
                }
            }"
                BeginCallback="function(s, e){lpProcess.Show();}" />
        </dx:ASPxCallbackPanel>

        <dx:ASPxLoadingPanel runat="server" ID="lpProcess" ClientInstanceName="lpProcess" Modal="true" Text="Validando Datos.." Theme="Material"></dx:ASPxLoadingPanel>

        <dx:ASPxPopupControl runat="server" ID="pcShowResults" ClientInstanceName="pcShowResults" HeaderText="Atención!!!">
            <SettingsAdaptivity Mode="Always" MaxWidth="400px" HorizontalAlign="WindowCenter"></SettingsAdaptivity>
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <dx:ASPxLabel ID="lblMessage" ClientInstanceName="lblMessage" runat="server" Text="" Font-Bold="true"></dx:ASPxLabel>
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents Shown="function(s, e){setTimeout(function () { pcShowResults.Hide(); }, 3000);}" />
        </dx:ASPxPopupControl>
    </form>
</body>
</html>
