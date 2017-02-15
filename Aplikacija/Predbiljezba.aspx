<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Predbiljezba.aspx.cs" Inherits="Aplikacija.Predbiljezba" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Predbilježba</title>
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
            <a href="Prijava.aspx">
                <div id="prijava">Prijava</div>
            </a>
        </div>
    </div>
    <div class="wrapper">
        <div class="RezultatiGrid pocetna" style="padding: 40px 20px 20px 20px;">
            <div class="search">
                <asp:TextBox ID="txtPretraga" runat="server" placeholder="Pretraži seminare"></asp:TextBox>
                &nbsp;
                <asp:Button ID="btnPretrazi" CssClass="btn" runat="server" Text="Pretraži" OnClick="btnPretrazi_Click" />
            </div>
            <br />
            <br />
            <br />
            <br />
            <div class="flex-container" id="flexContainer" runat="server">
                <%--html iz code behinda--%>
            </div>
            <div id="bezPodataka" class="bezPodataka" runat="server">
                Nema podataka za prikaz
            </div>

        </div>
    </div>

<%-------- POPUP --------%>
        <div id="prijaviSeminar" ClientIDMode="Static" class="update" runat="server">
        <div class="banner" style="margin-bottom: 0;">
            <div class="logo"></div>
            <div>
                <asp:Label ID="lblBannerSeminar" CssClass="lblBanner" runat="server" Text="Prijava seminara"></asp:Label>
            </div>
            <div class="user-wrap" >
                <%--DataFormatString="{0:d}" prikazuje samo datum, bez vremena--%>
                <input id="close" type="button" value="X" class="close" />
            </div>
        </div>
        <div>
            <div class="popupDiv">
                <p>
                    <asp:HiddenField ID="hfPrijavaIdSeminar" runat="server" />
                </p>
                <p>
                    <asp:Label ID="lblDatumText" runat="server"  style="margin-left: 0px;" ><span class="underline">Datum:</span></asp:Label>&nbsp;&nbsp;
                    <asp:Label ID="lblPrijavaDatum" runat="server"  style="margin-left: 0px;" ></asp:Label>
                </p>
                <p>
                    <asp:Label ID="lblPrijavaNazivText" runat="server"><span class="underline">Naziv:</span></asp:Label><br />
                    <asp:Label ID="lblPrijavaNaziv" runat="server" ValidationGroup="UpdateSeminar" placeholder="Naziv" style="margin-left: 0px;"></asp:Label>
                </p>
                <p>
                    <asp:Label ID="lblPrijavaOpisText" ClientIDMode="Static" runat="server"><span class="underline">Opis:</span></asp:Label><br />
                    <%--onpaste="return false;" sprečava pasteanje u textbox--%>
                    <asp:Label ID="lblPrijavaOpis" ClientIDMode="Static" runat="server"></asp:Label>
                </p>
                <p>
                    <asp:Label ID="lblPrijavaPredavacText" runat="server" ValidationGroup="UpdateSeminar"><span class="underline">Predavač:</span></asp:Label>&nbsp;&nbsp;
                    <asp:Label ID="lblPrijavaPredavac" runat="server" ValidationGroup="UpdateSeminar"></asp:Label>
                </p>
            </div>
        </div>
        <div id="unosPrijava">
            <div>
                <asp:TextBox ID="txtUnosIme" ClientIDMode="Static" placeholder="Ime" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Potrebno je unijeti ime!" ControlToValidate="txtUnosIme" Text="*" ValidationGroup="prijavaSeminara" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>
            <div>
                <asp:TextBox ID="txtUnosPrezime" ClientIDMode="Static" placeholder="Prezime" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Potrebno je unijeti prezime!" ControlToValidate="txtUnosPrezime" Text="*" ValidationGroup="prijavaSeminara" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>
            <div>
                <asp:TextBox ID="txtUnosEmail" ClientIDMode="Static" placeholder="Email" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Potrebno je unijeti email!" ControlToValidate="txtUnosEmail" Text="*" ValidationGroup="prijavaSeminara" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Neispravan email!" ControlToValidate="txtUnosEmail" Text="*" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ValidationGroup="prijavaSeminara" ForeColor="Red"></asp:RegularExpressionValidator>
            </div>
            <div>
                <asp:TextBox ID="txtUnosTel" ClientIDMode="Static" placeholder="Telefon" runat="server" MaxLength="12" ValidationGroup="prijavaSeminara"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Potrebno je unijeti telefon!" ControlToValidate="txtUnosTel" Text="*" ValidationGroup="prijavaSeminara" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Neispravan broj telefona!" ControlToValidate="txtUnosTel" ValidationExpression="(\d*[- \/]?\d*[- \/]?\d*){1,12}" ValidationGroup="prijavaSeminara" Text="*" ForeColor="Red"></asp:RegularExpressionValidator>
            </div>
            <div>
                <asp:Button ID="btnPrijavi" CssClass="btnPrijavi" runat="server" Text="Prijavi seminar" ValidationGroup="prijavaSeminara" OnClick="btnPrijavi_Click" />
            </div>
            <div>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="prijavaSeminara" DisplayMode="List" ForeColor="Red" />
            </div>
        </div>
        </div>
        <div id="predbiljezbaDarkScreen" ClientIDMode="Static" class="popupBackground" runat="server"></div>
    </form>
</body>
</html>
