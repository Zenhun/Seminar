using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace Aplikacija.korisnici
{
    public partial class Predbiljezbe : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                bezPredbiljezbi.Visible = false;
                FillGrid();
            }

            predbiljezba.Style.Remove("display");
            predbiljezbeDarkScreen.Style.Remove("display");
        }

        private void FillGrid()
        {
            //pogledaj u html-u kako sam bindao drop down list kontrolu sa Status poljem iz tablice
            string cmdText = GetCmdText();
            DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText);
            PopulateGridView(dt);
        }

        private void PopulateGridView(DataTable dt)
        {
            gvPredbiljezbe.DataSource = dt;
            gvPredbiljezbe.DataBind();

            if (gvPredbiljezbe.Rows.Count == 0)
                bezPredbiljezbi.Visible = true;
            else
                bezPredbiljezbi.Visible = false;

            ViewState["grid"] = dt;
        }

        protected string GetCmdText()
        {
            //"(SELECT CAST(COUNT(*) AS NVARCHAR)" - morao sam Int dobiven s Count pretvoriti u string jer bez toga je javljao grešku kad hoću dodati zagradu na kraju
            //"(Naziv + '(' + (SELECT CAST(COUNT(*) AS NVARCHAR) FROM Predbiljezba p WHERE p.IdSeminar = s.IdSeminar AND p.Status = 'prihvacena') + ')')"  - upit koji pored naziva doda u zagradama i broj prijava na taj seminar
            string cmdText = "SELECT IdPredbiljezba, Ime, Prezime, Email, Telefon, p.Datum AS 'Datum predbilježbe', (Naziv + ' (' + (SELECT CAST(COUNT(*) AS NVARCHAR) FROM Predbiljezba p WHERE p.IdSeminar = s.IdSeminar AND p.Status = 'prihvacena') + ')') AS 'Seminar', Status FROM Predbiljezba p JOIN Seminar s ON p.IdSeminar = s.IdSeminar";
            if (rbNeobradene.Checked)
                cmdText += " WHERE Status IS NULL";
            else if (rbPrivhacene.Checked)
                cmdText += " WHERE Status = 'Prihvacena'";
            else if (rbNeprihvacene.Checked)
                cmdText += " WHERE Status = 'Odbijena'";

            return cmdText;
        }

        protected void btnPrikazi_Click(object sender, EventArgs e)
        {
            if (txtKljucnaRijec.Text == "")
            {
                FillGrid();
            }
            else
            {
                string cmdText = "";
                if (rbSvi.Checked)
                {
                    //koristi se parametar @KljucnaRijec u upitu umjesto txtKljucnaRijec.Text da se spriječi SQL injection
                    //obrati pažnju kako se ključna riječ, odn. parametar ubacuje između wild cardova -- '%' + @KljucnaRijec + '%'
                    cmdText = "SELECT IdPredbiljezba, Ime, Prezime, Email, Telefon, p.Datum AS 'Datum predbilježbe', Naziv AS 'Seminar', Status FROM Predbiljezba p JOIN Seminar s ON p.IdSeminar = s.IdSeminar WHERE Naziv LIKE '%' + @KljucnaRijec + '%'";
                }
                else
                {
                    cmdText = GetCmdText() + " AND Naziv LIKE '%' + @KljucnaRijec + '%'";
                }

                SqlParameter paramKljucnaRijec = new SqlParameter("@KljucnaRijec", SqlDbType.NVarChar);
                paramKljucnaRijec.Value = txtKljucnaRijec.Text;
                DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText, paramKljucnaRijec);
                PopulateGridView(dt);
            }
        }

        protected void rbSvi_CheckedChanged(object sender, EventArgs e)
        {
            btnPrikazi_Click(sender, new EventArgs());
            gvPredbiljezbe.SelectedIndex = -1;
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            //you always get the control that raised an event by the SENDER argument, you only have to cast it accordingly
            DropDownList list = (DropDownList)sender;

            //If you also need to get a reference to the GridViewRow of the DropDownList(or any other control in a TemplateField of a GridView), you can use the NamingContainer property.
            GridViewRow row = (GridViewRow)list.NamingContainer;

            //nađemo Data Key za odabrani red prema indexu tog reda (za gvPredbiljezbe smo odredili DataKeyNames="IdPredbiljezba")
            //dakle index odabranog reda nije isto što i idPredbiljezba u tom redu
            int selectedValue = Convert.ToInt32(gvPredbiljezbe.DataKeys[row.RowIndex].Values[0]);

            string cmdText = "UPDATE Predbiljezba SET Status = @Status WHERE IdPredbiljezba = @IdPredbiljezba";
            SqlParameter paramStatus = new SqlParameter("@Status", SqlDbType.NVarChar);
            paramStatus.Value = list.SelectedValue;
            SqlParameter paramIdPredbiljezba = new SqlParameter("@IdPredbiljezba", SqlDbType.Int);
            paramIdPredbiljezba.Value = selectedValue;
            Persistence.Predbiljezbe.GetSqlTable(cmdText, paramStatus, paramIdPredbiljezba);

            //da sam stavio samo FillGrid() onda bi u slučaju da smo filtrirali po "Pretraži" i imali samo par predbilježbi u gridu, kada bi promijenili status predbilježbi bi prikazao
            //sve predbilježbe, a ne samo one koje odgovoraju filteru "Pretraži"
            //FillGrid();

            //ovako kada mijenjamo status ostanu prikazane predbilježbe s obzirom na filter "Pretraži"
            btnPrikazi_Click(sender, new EventArgs());
        }

        protected void gvPredbiljezbe_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvPredbiljezbe.SelectedIndex >= 0)
            {
                predbiljezba.Style.Add("display", "block");
                predbiljezbeDarkScreen.Style.Add("display", "block");
            }

            int index = gvPredbiljezbe.SelectedIndex;
            GridViewRow row = gvPredbiljezbe.SelectedRow;

            //IdPredbiljezba je Data Key u gvPredbiljezbe na poziciji Selected Index
            hfIdPredbiljezba.Value = gvPredbiljezbe.DataKeys[index].Value.ToString();
            DataTable dt = new DataTable();

            string cmdText = "SELECT IdPredbiljezba, Ime, Prezime, Email, Telefon, p.Datum AS 'Datum predbilježbe', Naziv AS 'Seminar', Status, p.IdSeminar, (SELECT COUNT(*) FROM Predbiljezba p WHERE p.IdSeminar = s.IdSeminar AND p.Status = 'prihvacena') AS 'Broj predbilježbi', s.Datum FROM Predbiljezba p JOIN Seminar s ON p.IdSeminar = s.IdSeminar WHERE IdPredbiljezba = @IdPredbiljezba";

            SqlParameter paramIdPredbiljezba = new SqlParameter("@IdPredbiljezba", SqlDbType.Int);
            paramIdPredbiljezba.Value = hfIdPredbiljezba.Value;
            dt = Persistence.Predbiljezbe.GetSqlTable(cmdText, paramIdPredbiljezba);

            string prijava = (Convert.ToInt32(dt.Rows[0][9].ToString()) > 1 && Convert.ToInt32(dt.Rows[0][9].ToString()) < 5) ? " prijave)" : " prijava)";
            lblNaziv.Text = dt.Rows[0][6].ToString() + " &nbsp;&nbsp;(" + dt.Rows[0][9].ToString() + prijava;
            lblDatumSem.Text = Convert.ToDateTime(dt.Rows[0][10]).ToShortDateString();
            lblPrijavitelj.Text = dt.Rows[0][1].ToString() + " " + dt.Rows[0][2].ToString();
            lblEmail.Text = dt.Rows[0][3].ToString();
            lblTelefon.Text = dt.Rows[0][4].ToString();
            lblDatum.Text = Convert.ToDateTime(dt.Rows[0][5]).ToShortDateString();
            lblStatus.Text = dt.Rows[0][7].ToString();

        }

        protected void btnObrisiSeminar_Click(object sender, EventArgs e)
        {
            string poruka = Persistence.Predbiljezbe.ObrisiSeminar(hfIdPredbiljezba.Value);
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "window.onload = function () {alert('" + poruka + "')};", true);

            FillGrid();
            gvPredbiljezbe.SelectedIndex = -1;
        }

        protected void gvPredbiljezbe_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPredbiljezbe.PageIndex = e.NewPageIndex;
            gvPredbiljezbe.PagerSettings.Mode = PagerButtons.NumericFirstLast;
            FillGrid();
            gvPredbiljezbe.SelectedIndex = -1;
        }

        protected void gvPredbiljezbe_Sorting(object sender, GridViewSortEventArgs e)
        {
            //gridView.DataSource sam prebacio u ViewState jer je nakon postbacka gridView.DataSource = null
            DataTable dataTable = (DataTable)ViewState["grid"];

            string sortDirection = "ASC";
            string sortExpression = "";

            if (ViewState["expression"] != null)
                sortExpression = ViewState["expression"].ToString();

            if (ViewState["direction"] != null)
                sortDirection = ViewState["direction"].ToString();

            //ako sortiramo kolonu koju smo upravo sortirali, samo obrnemo poredak
            if (sortExpression == e.SortExpression && sortDirection == "ASC")
                sortDirection = "DESC";
            else if (sortExpression == e.SortExpression && sortDirection == "DESC")
                sortDirection = "ASC";
            //ako je kolona koju nismo upravo sortirali onda sortirati ascending
            else
                sortDirection = "ASC";

            if (dataTable != null)
            {
                //probao sam prebaciti dataTable u DataView pa onda sortirati, ali mi je bacalo grešku da DataView is not marked as serializable
                //DataTable je serializable tako da je dataTable.DefaultView.Sort riješio problem  (dataTable.DefaultView je po svom tipu isto DataView)
                dataTable.DefaultView.Sort = e.SortExpression + " " + sortDirection;

                gvPredbiljezbe.DataSource = dataTable;
                gvPredbiljezbe.DataBind();
                gvPredbiljezbe.SelectedIndex = -1;
                ViewState["grid"] = dataTable;
                ViewState["expression"] = e.SortExpression;
                ViewState["direction"] = sortDirection;
            }
        }
    }
}