<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Prijava.aspx.cs" Inherits="Aplikacija.Prijava" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Prijava</title>
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
    <link href="Style/Style.css" rel="stylesheet" />
    <script src="res/JQ.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="banner">
        <div class="banner-wrap">
            <div class="logo"></div>
            <div class="siteMap">
                <asp:SiteMapPath ID="SiteMapPath1" runat="server" Font-Names="Verdana" Font-Size="0.8em" PathSeparator=" : ">
                    <CurrentNodeStyle ForeColor="White" />
                    <NodeStyle Font-Bold="True" ForeColor="#E8E8E8" />
                    <PathSeparatorStyle Font-Bold="True" ForeColor="#5D7B9D" />
                    <RootNodeStyle Font-Bold="True" ForeColor="Silver" />
                </asp:SiteMapPath>
            </div>
            <a href="Predbiljezba.aspx">
                <div id="natrag">Natrag</div>
            </a>
        </div>
    </div>
    <div id="loginWrapper">
        <div class="login shadow">
        <table style="width: 100%;">
            <tr>
                <td>
                    <asp:TextBox ID="txtKorisnickoIme" runat="server" ValidationGroup="Login" placeholder="Korisničko ime" Width="260px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvKorisnickoIme" runat="server" ControlToValidate="txtKorisnickoIme" ErrorMessage="Potrebno je unijeti korisničko ime" ForeColor="Red" ValidationGroup="Login">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txtLozinka" runat="server" TextMode="Password" ValidationGroup="Login" placeholder="Lozinka" Width="260px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLozinka" runat="server" ControlToValidate="txtLozinka" ErrorMessage="Potrebno je unijeti lozinku!" ForeColor="Red" ValidationGroup="Login">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="margin-left: 40px">
                    <asp:Button ID="btnPrijavi" CssClass="btnPrijavi" runat="server" OnClick="btnPrijavi_Click" Text="Prijavi" ValidationGroup="Login" Width="115px" />
                    <br />
                </td>
            </tr>
            <tr>
                <td style="margin-left: 40px">
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" DisplayMode="List" ForeColor="Red" ValidationGroup="Login" style="position: fixed;top: 495px;"/>
                    <asp:Label ID="lblPrijava" runat="server" ForeColor="Red"></asp:Label>
                </td>
            </tr>
        </table>
        </div>
    </div>
    </form>
</body>
</html>
