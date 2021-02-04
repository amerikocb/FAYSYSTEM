<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomErrorPage.aspx.cs" Inherits="Fay_System.ErrorControl.CustomErrorPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="ErrorStyle.css" rel="stylesheet" />

</head>
<body>

    <div id="notfound">
        <div class="notfound">
            <div class="notfound-404">
                <h1>Oops!</h1>
            </div>
            <h2>Ha ocurrido un error inesperado</h2>
            <br />
            <p>Por favor comunique al <strong>Administrador</strong> del sitio sobre el error</p>
            <a href="../Login.aspx">IR AL LOGIN</a>
        </div>
    </div>

</body>
</html>
