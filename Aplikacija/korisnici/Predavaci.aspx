<%@ Page Title="Predavači" Language="C#" MasterPageFile="~/korisnici/Site1.Master" AutoEventWireup="true" CodeBehind="Predavaci.aspx.cs" Inherits="Aplikacija.korisnici.Predavaci" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <br />
        <table style="width:100%;">
            <tr>
                <td>
                    <asp:Panel ID="Panel3" runat="server">
                        <div class="search">
                            <asp:TextBox ID="txtKljucnaRijec" runat="server" placeholder="Pretraži korisnike"></asp:TextBox>
                            &nbsp;
                            <asp:Button ID="btnPretraziKorisnike" CssClass="btn" runat="server" Text="Prikaži" OnClick="btnPretraziKorisnike_Click"/>
                        </div>
                        <asp:Button ID="noviKorisnik" class="btn extraButton" runat="server" Text="Dodaj korisnika" OnClick="noviKorisnik_Click" />
                        <br />
                        <br />
                        <br />
                        <div class="RezultatiGrid" style="width: 60%;">
                            <%--DataKeyNames s imenom kao DataField kolone s Id od Seminara, a tu hidden kolonu izbrišemo--%>
                            <asp:GridView ID="gvPredavaci" DataKeyNames="IdZaposlenik" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="gvPredavaci_SelectedIndexChanged" AlternatingRowStyle-Wrap="False">
                                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                <Columns>
                                    <%--<asp:BoundField DataField="IdZaposlenik" HeaderText="IdZaposlenik" Visible="False" />--%>
                                    <asp:CommandField ButtonType="Button" SelectText="Izmijeni" ShowSelectButton="True" ControlStyle-CssClass="btn" >
                                    <ControlStyle CssClass="btn" />
                                    </asp:CommandField>
                                    <asp:BoundField DataField="Ime" HeaderText="Ime" />
                                    <asp:BoundField DataField="Prezime" HeaderText="Prezime" />
                                    <asp:BoundField DataField="Korisničko ime" HeaderText="Korisničko ime" />
                                    <asp:BoundField DataField="Lozinka" HeaderText="Lozinka" />
                                </Columns>
                                <EditRowStyle BackColor="#999999" />
                                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                <HeaderStyle BackColor="#eb592c" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                <SortedAscendingCellStyle BackColor="#E9E7E2" />
                                <SortedAscendingHeaderStyle BackColor="#506C8C" />
                                <SortedDescendingCellStyle BackColor="#FFFDF8" />
                                <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                            </asp:GridView>
                            <div id="bezPredavaca" class="bezPodataka" runat="server">
                                Nema podataka za prikaz
                            </div>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
        
    </div>
    <%----- POPUP -----%>
    <div id="updatePredavac" ClientIDMode="Static" class="update" runat="server">
        <div class="banner">
            <div class="logo"></div>
            <div >
                <asp:Label ID="lblBannerPredavac" CssClass="lblBanner" ClientIDMode="Static" runat="server" Text="Label" style="display: inline-block;"></asp:Label>
            </div>
            <div class="user-wrap" >
                <%--ClientIDMode="Static" spriječi da se id pretvori u "ContentPlaceHolder1_close"--%>
                <asp:Button ID="closePredavac" ClientIDMode="Static" CssClass="close" runat="server" Text="X" OnClick="closePredavac_Click" />
            </div>
        </div>
        <table class="popupTable" style="margin-left: -270px; ">
            <tr>
                <td>
                    <asp:HiddenField ID="hfIdPredavac" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="title">
                    <asp:Label ID="lblIme" runat="server"><span class="underline">Ime:</span></asp:Label>
                </td>
                <td class="data">
                    <asp:TextBox ID="txtIme" runat="server" ValidationGroup="UpdateSeminar" placeholder="Ime" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvIme" runat="server" ControlToValidate="txtIme" ForeColor="Red" ValidationGroup="Predavac">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="title">
                    <asp:Label ID="lblPrezime" runat="server"><span class="underline">Prezime:</span></asp:Label>
                </td>
                <td class="data">
                    <asp:TextBox ID="txtPrezime" runat="server" ValidationGroup="UpdateSeminar" placeholder="Prezime" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPrezime" runat="server" ControlToValidate="txtPrezime" ForeColor="Red" ValidationGroup="Predavac">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="title">
                    <asp:Label ID="lblKorisnickoIme" runat="server"><span class="underline">Korisničko ime:</span></asp:Label>
                </td>
                <td class="data">
                    <asp:TextBox ID="txtKorisnickoIme" runat="server" ValidationGroup="UpdateSeminar" placeholder="Korisničko ime" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfKorisnickoIme" runat="server" ControlToValidate="txtKorisnickoIme" ForeColor="Red" ValidationGroup="Predavac">*</asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td class="title">
                    <asp:Label ID="lblLozinka" runat="server"><span class="underline">Lozinka:</span></asp:Label>
                </td>
                <td class="data">
                    <asp:TextBox ID="txtLozinka" runat="server" ValidationGroup="UpdateSeminar" placeholder="Lozinka" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfLozinka" runat="server" ControlToValidate="txtLozinka" ForeColor="Red" ValidationGroup="Predavac">*</asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
        <table style="margin: -10px 0 25px 50px;">
            <tr>
                <td>
                    <asp:Button ID="btnUpdatePredavac" CssClass="btn" runat="server" Text="Izmijeni" OnClick="btnUpdatePredavac_Click" ValidationGroup="Predavac" />
                </td>
                <td>
                    <%--obrati pažnju na OnClientClick event --> [OK, Cancel} dialog popup --%>
                    <asp:Button ID="btnDeletePredavac" CssClass="btn" runat="server" Text="Obriši" OnClick="btnDeletePredavac_Click" OnClientClick="return confirm('Da li ste sigurni da želite obrisati?');" />
                </td>
            </tr>
        </table>
        <div id="popisSeminara" runat="server" ClientIDMode="Static">
            <p>Popis seminara pridruženih korisniku</p>
            <asp:ListBox ID="lbPopisSeminara" runat="server" Width="80%" Height="100px"></asp:ListBox>
        </div>
    </div>
    <div id="predavacDarkScreen" ClientIDMode="Static" class="popupBackground" runat="server"></div>
</asp:Content>
