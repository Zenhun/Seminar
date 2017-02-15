<%@ Page Title="Predbilježbe" Language="C#" MasterPageFile="~/korisnici/Site1.Master" AutoEventWireup="true" CodeBehind="Predbiljezbe.aspx.cs" Inherits="Aplikacija.korisnici.Predbiljezbe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <title>Predbilježbe</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <br />
        <table style="width:100%;">
            <tr>
                <td>
                    <asp:Panel ID="Panel2" runat="server">
                        <br />
                        <div class="search" style="margin-top: -3px;">
                            <asp:TextBox ID="txtKljucnaRijec" runat="server" placeholder="Pretraži predbilježbe"></asp:TextBox>
                            &nbsp;
                            <asp:Button ID="btnPrikazi" CssClass="btn" runat="server" Text="Prikaži" OnClick="btnPrikazi_Click" />
                        </div>
                        <div id="radioButtons">
                            <asp:RadioButton ID="rbSvi" runat="server" AutoPostBack="True" GroupName="Predbiljezbe" OnCheckedChanged="rbSvi_CheckedChanged" Text=" Sve predbilježbe" />
                            <asp:RadioButton ID="rbNeobradene" runat="server" AutoPostBack="True" GroupName="Predbiljezbe" OnCheckedChanged="rbSvi_CheckedChanged" Text=" Neobrađene" />
                            <asp:RadioButton ID="rbPrivhacene" runat="server" AutoPostBack="True" GroupName="Predbiljezbe" OnCheckedChanged="rbSvi_CheckedChanged" Text=" Prihvaćene" />
                            <asp:RadioButton ID="rbNeprihvacene" runat="server" AutoPostBack="True" GroupName="Predbiljezbe" OnCheckedChanged="rbSvi_CheckedChanged" Text=" Odbijene" />
                        </div>
                        <br />
                        <br />
                        <div class="RezultatiGrid">
                            <%-- PageSize određuje koliko redova se prikazuje na stranici prije uvođenja pageinga; bez toga default je 10 --%>
                            <asp:GridView ID="gvPredbiljezbe"  runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnSelectedIndexChanged="gvPredbiljezbe_SelectedIndexChanged" DataKeyNames="IdPredbiljezba" AllowPaging="True" PageSize="12" OnPageIndexChanging="gvPredbiljezbe_PageIndexChanging" AllowSorting="True" OnSorting="gvPredbiljezbe_Sorting">
                                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                <Columns>
                                    <%--DataFormatString="{0:d}" prikazuje samo datum, bez vremena--%>
                                    <asp:CommandField ButtonType="Button" SelectText="Odaberi" ShowSelectButton="True">
                                        <ControlStyle CssClass="btn" />
                                    </asp:CommandField>
                                    <asp:BoundField DataField="IdPredbiljezba" HeaderText="IdPredbiljezba" Visible="False" />
                                    <asp:BoundField DataField="Seminar" HeaderText="Seminar" ItemStyle-HorizontalAlign="Center" SortExpression="Seminar">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Ime" HeaderText="Ime" ItemStyle-Font-Bold="true" SortExpression="Ime">
                                        <ItemStyle Font-Bold="True" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Prezime" HeaderText="Prezime" ItemStyle-Font-Bold="true" SortExpression="Prezime">
                                        <ItemStyle Font-Bold="True" />
                                    </asp:BoundField>
                                    <%--Email i Telefon kolone sam sakrio u gridview, ali će se prikazivati u Details view--%>
                                    <asp:BoundField DataField="Email" HeaderText="Email"  HeaderStyle-CssClass="hidden" ItemStyle-CssClass="hidden"/>
                                    <asp:BoundField DataField="Telefon" HeaderText="Telefon" ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="hidden" ItemStyle-CssClass="hidden">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Datum predbilježbe" HeaderText="Datum predbilježbe" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:d}" SortExpression="Datum predbilježbe">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Status" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <%--Dodao sam nevidljivu kolonu Status (iz tablice Predbiljezba), 
                                                dropdown kontrolu sam narihtao da joj Values odgovaraju podacima u Status koloni.
                                                Bindam direktno drop down kontrolu sa Status kolonom iz tablice!!!!  --%>
                                            <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" DataTextField="Status" DataValueField="IdPredbiljezba" SelectedValue='<%# Bind("Status") %>' OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                                                <%--"prazan" item u dropdownu je vidljiv, ali se ne može selektirati (disabled="disabled")--%>
                                                <asp:ListItem Value="" Text="" disabled="disabled"></asp:ListItem>
                                                <asp:ListItem Value="odbijena" Text="odbijena"></asp:ListItem>
                                                <asp:ListItem Value="prihvacena" Text="prihvaćena"></asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Status" HeaderText="Status" Visible="False" />
                                </Columns>
                                <EditRowStyle BackColor="#999999" />
                                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                <HeaderStyle BackColor="#eb592c" Font-Bold="True" ForeColor="White" />
                                <PagerStyle CssClass="pager"/>
                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                <SortedAscendingCellStyle BackColor="#E9E7E2" />
                                <SortedAscendingHeaderStyle BackColor="#506C8C" />
                                <SortedDescendingCellStyle BackColor="#FFFDF8" />
                                <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                            </asp:GridView>
                            <div id="bezPredbiljezbi" class="bezPodataka" runat="server">
                                Nema podataka za prikaz
                            </div>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </div>

    <%------- POPUP -------%>
    <div id="predbiljezba" ClientIDMode="Static" class="update" runat="server">
        <div class="banner" style="margin-bottom: 0;">
            <div class="logo"></div>
            <div>
                <asp:Label ID="lblBannerPredbiljezba" CssClass="lblBanner" runat="server" Text="Predbilježba"></asp:Label>
            </div>
            <div class="user-wrap" >
                <%--DataFormatString="{0:d}" prikazuje samo datum, bez vremena--%>
                <%--<asp:Button ID="close" ClientIDMode="Static" CssClass="close" runat="server" Text="X"/>--%>
                <input id="close" type="button" value="X" class="close" />
            </div>
        </div>
        <div class="popupDiv" style="margin-top: 50px;">
                <p>
                    <asp:HiddenField ID="hfIdPredbiljezba" runat="server" />
                </p>
                <table id="predbiljezbaInfo">
                    <tr>
                        <td class="title"><asp:Label ID="lblNazivText" runat="server"  style="margin-left: 0px;" ><span class="underline">Naziv seminara:</span></asp:Label></td>
                        <td class="data"><asp:Label ID="lblNaziv" runat="server"  style="margin-left: 0px;" ></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="title"><asp:Label ID="lblDatumSemText" runat="server"  style="margin-left: 0px;" ><span class="underline">Datum seminara:</span></asp:Label></td>
                        <td class="data"> <asp:Label ID="lblDatumSem" runat="server"  style="margin-left: 0px;" ></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="title"><asp:Label ID="lblPrijaviteljText" runat="server"><span class="underline">Prijavitelj:</span></asp:Label></td>
                        <td class="data"><asp:Label ID="lblPrijavitelj" runat="server" ValidationGroup="UpdateSeminar" placeholder="Naziv" style="margin-left: 0px;"></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="title"><asp:Label ID="lblEmailText" ClientIDMode="Static" runat="server"><span class="underline">Email:</span></asp:Label></td>
                        <td class="data"><asp:Label ID="lblEmail" ClientIDMode="Static" runat="server"></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="title"><asp:Label ID="lblTelefonText" runat="server" ValidationGroup="UpdateSeminar"><span class="underline">Telefon:</span></asp:Label></td>
                        <td class="data"><asp:Label ID="lblTelefon" runat="server" ValidationGroup="UpdateSeminar"></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="title"><asp:Label ID="lblDatumText" runat="server" ValidationGroup="UpdateSeminar"><span class="underline">Datum predbilježbe:</span></asp:Label></td>
                        <td class="data"><asp:Label ID="lblDatum" runat="server" ValidationGroup="UpdateSeminar"></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="title"><asp:Label ID="lblStatusText" runat="server" ValidationGroup="UpdateSeminar"><span class="underline">Status:</span></asp:Label></td>
                        <td class="data"><asp:Label ID="lblStatus" runat="server" ValidationGroup="UpdateSeminar"></asp:Label></td>
                    </tr>
                </table>
            </div>
            <div id="ObrisiSeminar">
                <asp:Button ID="btnObrisiSeminar" CssClass="btnPrijavi" runat="server" Text="Obriši predbilježbu" ValidationGroup="UpdateSeminar" OnClientClick="return confirm('Jeste li sigurni da želite obrisati predbilježbu?');" OnClick="btnObrisiSeminar_Click" />
            </div>
    </div>
    <div id="predbiljezbeDarkScreen" ClientIDMode="Static" class="popupBackground" runat="server"></div>
</asp:Content>
