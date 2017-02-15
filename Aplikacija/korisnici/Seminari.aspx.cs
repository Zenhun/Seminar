using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Security;

namespace Aplikacija.korisnici
{
    public partial class Seminari : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        { 
            if (!IsPostBack)
            {
                bezSeminara.Visible = false;
                FillGrid();
            }
        }
        
        private void FillGrid()
        {
            string cmdText = "SELECT  s.IdSeminar, s.Naziv, s.Opis, s.Datum, z.Ime + ' ' + z.Prezime AS Predavač, (SELECT COUNT(*) FROM Predbiljezba p WHERE p.IdSeminar = s.IdSeminar) AS 'Broj predbilježbi', s.Popunjen FROM  Seminar s INNER JOIN Zaposlenik z ON s.IdZaposlenik = z.IdZaposlenik ORDER BY s.Datum";

            DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText);
            PopulateGridView(dt);
        }

        private void PopulateGridView(DataTable dt)
        {
            gvSviSeminari.DataSource = dt;
            gvSviSeminari.DataBind();
            ViewState["grid"] = dt;

            if (gvSviSeminari.Rows.Count == 0)
                bezSeminara.Visible = true;
            else
                bezSeminara.Visible = false;
        }

        protected void btnPrikazi_Click(object sender, EventArgs e)
        {
            if (txtKljucnaRijec.Text == "")
            {
                FillGrid();
            }
            else
            {
                string cmdText = "SELECT  s.IdSeminar, s.Naziv, s.Opis, s.Datum, z.Ime + ' ' + z.Prezime AS Predavač, (SELECT COUNT(*) FROM Predbiljezba p WHERE p.IdSeminar = s.IdSeminar AND p.Status = 'prihvacena') AS 'Broj predbilježbi', s.Popunjen FROM  Seminar s INNER JOIN Zaposlenik z ON s.IdZaposlenik = z.IdZaposlenik WHERE s.Naziv LIKE '%' + @KljucnaRijec + '%' ORDER BY s.Datum";
                SqlParameter paramRijec = new SqlParameter("@KljucnaRijec", SqlDbType.NVarChar);
                paramRijec.Value = txtKljucnaRijec.Text;

                DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText, paramRijec);

                PopulateGridView(dt);
            }
        }

        protected void btnOdjava_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("~/Predbiljezba.aspx");
        }

        protected void gvSviSeminari_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvSviSeminari.SelectedIndex >= 0)
            {
                updateSeminar.Style.Add("display", "block");
                seminarDarkScreen.Style.Add("display", "block");
                btnDeleteSeminar.Visible = true;
                lblBannerSeminar.Text = "Izmijeni seminar";
                btnUpdateSeminar.Text = "Izmijeni seminar";
            }

            ddlPredavac.Items.Clear();            

            hfIdSeminar.Value = "";
            txtNaziv.Text = "";
            txtOpis.Text = "";
            Calendar1.SelectedDate = Calendar1.VisibleDate = DateTime.Now;
            lblBrojPrijava.Text = "";
            chkPopunjen.Checked = false;

            //index seminara u bazi
            int index = gvSviSeminari.SelectedIndex;
            GridViewRow selectedRow = gvSviSeminari.SelectedRow;

            //punjenje drop down liste popisom zaposlenika
            GetDropDownList(selectedRow);

            //IdSeminar vrijednost (id) određenu u gvSeminari kao DataKeyNames dohvatimo preko DataKey od selected row
            hfIdSeminar.Value = gvSviSeminari.DataKeys[index].Value.ToString();
            
            txtNaziv.Text = selectedRow.Cells[1].Text;
            txtOpis.Text = selectedRow.Cells[2].Text;
            //predavač se povuče iz drop down liste iznad
            Calendar1.SelectedDate = Calendar1.VisibleDate = Convert.ToDateTime(selectedRow.Cells[4].Text);
            lblBrojPrijava.Text = "Broj predbilježbi: " + selectedRow.Cells[5].Text;
            chkPopunjen.Checked = ((CheckBox)selectedRow.Cells[6].Controls[0]).Checked ? true : false;

            //u label ispisujemo koliko je ostalo znakova do max 345 u textboxu Opis
            lblOpis.Text = "Opis (" + (345 - txtOpis.Text.Length) + ")";
        }

        protected DropDownList GetDropDownList(GridViewRow selectedRow)
        {
            string cmdText = "SELECT IdZaposlenik, Ime + ' ' + Prezime AS 'Predavač' FROM Zaposlenik";
            DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText);

            foreach (DataRow row in dt.Rows)
            {
                ListItem li = new ListItem();
                li.Value = row[0].ToString();
                li.Text = row[1].ToString();
                ddlPredavac.Items.Add(li);
                //kod stvaranja nove tablice se koristi GetDropDownList metoda, ali nije odabran ni jedan redak pa se prosljeđuje null
                //zato radimo provjeru selectedRow != null
                if (selectedRow != null && li.Text == selectedRow.Cells[3].Text)
                {
                    ddlPredavac.SelectedValue = li.Value;
                }
            }
            return ddlPredavac;
        }

        protected void btnUpdateSeminar_Click(object sender, EventArgs e)
        {
            updateSeminar.Style.Remove("display");
            seminarDarkScreen.Style.Remove("display");

            string cmdText = "";
            if (hfIdSeminar.Value == "")
                cmdText = "INSERT INTO Seminar VALUES (@predavac, @naziv, @opis, @datum, @popunjen)";
            else
                cmdText = "UPDATE Seminar SET IdZaposlenik = @predavac, Naziv = @naziv, Opis = @opis, Datum = @datum, Popunjen = @popunjen WHERE IdSeminar = @idSeminar";

            Persistence.Seminari.InsertOrUpdateSeminar(cmdText, hfIdSeminar.Value, txtNaziv.Text, txtOpis.Text, Calendar1.SelectedDate, ddlPredavac.SelectedValue, chkPopunjen.Checked);

            FillGrid();
        }

        protected void noviSeminar_Click(object sender, EventArgs e)
        {
            updateSeminar.Style.Add("display", "block");
            seminarDarkScreen.Style.Add("display", "block");

            ddlPredavac.Items.Clear();
            lblOpis.Text = "Opis (345)";

            hfIdSeminar.Value = "";
            txtNaziv.Text = "";
            txtOpis.Text = "";
            Calendar1.SelectedDate = Calendar1.VisibleDate = DateTime.Now;
            //ddlPredavac.SelectedValue = "1";
            chkPopunjen.Checked = false;
            lblBrojPrijava.Text = "Broj predbilježbi: 0";

            //prosljeđujemo null jer nije odabran ni jedan redak, a metoda očekuje selectedRow argument
            GetDropDownList(null);

            lblBannerSeminar.Text = "Novi seminar";
            btnUpdateSeminar.Text = "Unesi seminar";
            btnDeleteSeminar.Visible = false;
        }

        protected void btnDeleteSeminar_Click(object sender, EventArgs e)
        {
            if (hfIdSeminar.Value != "")
            {
                //sql cmd koji provjerava da li je seminar koji želimo obrisati pridružen nekoj predbilježbi
                string cmdProvjeraText = "SELECT * FROM Predbiljezba WHERE IdSeminar = @IdSeminar";
                string cmdText = "DELETE FROM Seminar WHERE IdSeminar = @IdSeminar";
                SqlParameter paramIdSeminar = new SqlParameter("@IdSeminar", SqlDbType.Int);
                paramIdSeminar.Value = hfIdSeminar.Value;

                DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdProvjeraText, paramIdSeminar);

                //ako seminar nema pridruženih predbilježbi možemo ga brisati
                if (dt.Rows.Count == 0)
                {
                    Persistence.Predbiljezbe.GetSqlTable(cmdText, paramIdSeminar);
                }
                else
                {
                    //window.onload = function () {}  dio je bitan da se alert pojavi nakon što se učita stranica...inače se alert prikaže nakon postbacka, a prije učitavanja nove stranice
                    //dakle bez toga se alert javi na bijelom ekranu prije učitavanja stranice nakon postbacka
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "window.onload = function () {alert('Seminar se ne može obrisati zbog postojećih predbilježbi!')};", true);
                }

                hfIdSeminar.Value = "";

                updateSeminar.Style.Remove("display");
                seminarDarkScreen.Style.Remove("display");

            }

            FillGrid();
        }

        protected void close_Click1(object sender, EventArgs e)
        {
            updateSeminar.Style.Remove("display");
            seminarDarkScreen.Style.Remove("display");
        }

        protected void gvSviSeminari_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSviSeminari.PageIndex = e.NewPageIndex;
            FillGrid();
            gvSviSeminari.SelectedIndex = -1;
        }

        protected void gridView_Sorting(object sender, GridViewSortEventArgs e)
        {
            //gridView.DataSource sam prebacio u ViewState jer je nakon postbacka gridView.DataSource = null
            DataTable dataTable = (DataTable)ViewState["grid"];

            string sortDirection = "ASC";
            string sortExpression = "";

            if (ViewState["expression"] != null)
                sortExpression = ViewState["expression"].ToString();

            if (ViewState["direction"] != null)
            {
                sortDirection = ViewState["direction"].ToString();
            }

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

                gvSviSeminari.DataSource = dataTable;
                gvSviSeminari.DataBind();
                gvSviSeminari.SelectedIndex = -1;
                ViewState["grid"] = dataTable;
                ViewState["expression"] = e.SortExpression;
                ViewState["direction"] = sortDirection;
            }
        }
    }
}