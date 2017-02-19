<%@ Page Title="Seminari" Language="C#" MasterPageFile="~/korisnici/Site1.Master" AutoEventWireup="true" CodeBehind="Seminari.aspx.cs" Inherits="Aplikacija.korisnici.Seminari" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Seminari</title>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <br />
        <table style="width:100%;">
            <tr>
                <td>
                    <asp:Panel ID="Panel2" runat="server">
                        <div class="search">
                            <asp:TextBox ID="txtKljucnaRijec" runat="server" placeholder="Pretraži seminare"></asp:TextBox>
                            &nbsp;
                            <asp:Button ID="btnPrikazi" CssClass="btn" runat="server" Text="Prikaži" OnClick="btnPrikazi_Click" />
                        </div>
                        <div>
                            <asp:Button ID="noviSeminar" runat="server" ClientIDMode="Static" CssClass="btn extraButton" Text="Dodaj seminar" OnClick="noviSeminar_Click"  />
                        </div>
                        <br />
                        <br />
                        <div class="RezultatiGrid">
                            <%--DataKeyNames s imenom kao DataField kolone s Id od Seminara, a tu hidden kolonu izbrišemo--%>
                            <asp:GridView ID="gvSviSeminari" DataKeyNames="IdSeminar" runat="server" CellPadding="4" Font-Names="Calibri" ForeColor="#333333" GridLines="None" AutoGenerateColumns="False" OnSelectedIndexChanged="gvSviSeminari_SelectedIndexChanged" AllowPaging="True" OnPageIndexChanging="gvSviSeminari_PageIndexChanging" AllowSorting="True" OnSorting="gridView_Sorting" >
                                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                <Columns>
                                    <%--<asp:BoundField DataField="IdSeminar" HeaderText="IdSeminar" Visible="False" />--%>
                                    <asp:CommandField ButtonType="Button" SelectText="Izmijeni" ShowSelectButton="True" ControlStyle-CssClass="btn" />
                                    <%-- SortExpression je potrebno staviti da bi se moglo sortirati po toj koloni; SortExpression = ime kolone u Sql-u --%>
                                    <asp:BoundField DataField="Naziv" HeaderText="Naziv" ItemStyle-Font-Bold="true" SortExpression="Naziv">
                                    <ItemStyle Font-Bold="True" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Opis" HeaderText="Opis" ItemStyle-Width="40%" ItemStyle-HorizontalAlign="Justify" SortExpression="Opis">
                                    <ItemStyle Width="50%" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Predavač" HeaderText="Predavač" SortExpression="Predavač"/>
                                    <%--DataFormatString="{0:d}" prikazuje samo datum, bez vremena--%>
                                    <asp:BoundField DataField="Datum" HeaderText="Datum" DataFormatString="{0:d}" SortExpression="Datum" />
                                    <asp:BoundField DataField="Broj predbilježbi" HeaderText="Broj predbilježbi" ItemStyle-HorizontalAlign="Center" SortExpression="Broj predbilježbi" >
                                    <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:CheckBoxField DataField="Popunjen" HeaderText="Popunjen" ItemStyle-HorizontalAlign="Center" SortExpression="Popunjen">
                                    <ItemStyle HorizontalAlign="Center" />
                                    </asp:CheckBoxField>
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
                            <div id="bezSeminara" class="bezPodataka" runat="server">
                                Nema podataka za prikaz
                            </div>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </div>

<%--<asp:BoundField DataField="IdSeminar" HeaderText="IdSeminar" Visible="False" />--%>
    <div id="updateSeminar" ClientIDMode="Static" class="update" runat="server">
        <div class="banner">
            <div class="logo"></div>
            <div>
                <asp:Label ID="lblBannerSeminar" CssClass="lblBanner" runat="server" Text="Label"></asp:Label>
            </div>
            <div class="user-wrap" >
                <%--DataFormatString="{0:d}" prikazuje samo datum, bez vremena--%>
                <asp:Button ID="close" ClientIDMode="Static" CssClass="close" runat="server" Text="X" OnClick="close_Click1"/>
            </div>
        </div>
        <table class="popupTable" style="border: none;">
            <tr>
                <td>
                    <asp:HiddenField ID="hfIdSeminar" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblNaziv" runat="server" Text="Naziv"></asp:Label><br />
                    <asp:TextBox ID="txtNaziv" runat="server" ValidationGroup="UpdateSeminar" placeholder="Naziv" Width="300px" style="margin-left: 0px;" TabIndex="1"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNaziv" runat="server" ControlToValidate="txtNaziv" ForeColor="Red" ValidationGroup="UpdateSeminar">*</asp:RequiredFieldValidator>
                </td>
                <td rowspan="3">
                    <asp:Calendar ID="Calendar1" ClientIDMode="Static" CssClass="calendar" runat="server" DayStyle-Width="2" WeekendDayStyle-ForeColor="#eb592c" BackColor="White" BorderColor="#999999" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px" Width="200px" TabIndex="5">
                        <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                        <NextPrevStyle VerticalAlign="Bottom" />
                        <OtherMonthDayStyle ForeColor="#808080" />
                        <SelectedDayStyle BorderColor="Red" BorderWidth="1px" BackColor="#666666" Font-Bold="True" ForeColor="White" />
                        <SelectorStyle BackColor="#CCCCCC" />
                        <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                        <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                        <WeekendDayStyle BackColor="#FFFFCC"></WeekendDayStyle>
                    </asp:Calendar>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblOpis" ClientIDMode="Static" runat="server" Text="Opis"></asp:Label><br />
                    <%--onpaste="return false;" sprečava pasteanje u textbox--%>
                    <asp:TextBox ID="txtOpis" ClientIDMode="Static" onpaste="return false;" style="padding-left: 5px; resize:none; margin-top: 3px;" runat="server" TextMode="multiline" Rows="10" ValidationGroup="UpdateSeminar" placeholder="Opis" Width="300px" TabIndex="2" MaxLength="345"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revMaxLength" ControlToValidate="txtOpis" ErrorMessage="Opis može sadržavati maksimalno 345 znakova" ValidationExpression="^[\s\S]{0,345}$" runat="server" Display="None"  SetFocusOnError="true" ValidationGroup="UpdateSeminar" />
                    <asp:RequiredFieldValidator ID="rfvOpis" runat="server" ControlToValidate="txtOpis" ForeColor="Red" ValidationGroup="UpdateSeminar">*</asp:RequiredFieldValidator>
                </td>
                <%--<asp:BoundField DataField="IdSeminar" HeaderText="IdSeminar" Visible="False" />--%>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblPredavacDdl" runat="server" Text="Predavač"></asp:Label><br />
                    <asp:DropDownList ID="ddlPredavac" runat="server" TabIndex="3" style="margin-top: 3px;" ValidationGroup="UpdateSeminar"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvPredavac" runat="server" ControlToValidate="ddlPredavac" ForeColor="Red" ValidationGroup="UpdateSeminar">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:CheckBox ID="chkPopunjen" runat="server" Text=" Popunjen" TabIndex="4" CssClass="chkPopClass"/>
                </td>
            </tr>
             <tr>
                <td>
                    <asp:Label ID="lblBrojPrijava" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="btnUpdateSeminar" CssClass="btn" runat="server" Text="Izmijeni" OnClick="btnUpdateSeminar_Click" TabIndex="6" ValidationGroup="UpdateSeminar" />
                </td>
                <td>
                    <asp:Button ID="btnDeleteSeminar" CssClass="btn" runat="server" Text="Obriši" OnClick="btnDeleteSeminar_Click" OnClientClick="return confirm('Da li ste sigurni da želite obrisati?');" TabIndex="7" />
                </td>
            </tr>
        </table>
    </div>
    <div id="seminarDarkScreen" ClientIDMode="Static" class="popupBackground" runat="server"></div>
</asp:Content>
