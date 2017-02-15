using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Security;

namespace Aplikacija.korisnici
{
    public partial class Predavaci : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfIdPredavac.Value = "";
                FillGrid();
            }
        }

        private void FillGrid()
        {
            string cmdText = "SELECT IdZaposlenik, Ime, Prezime, KorisnickoIme AS 'Korisničko ime', Lozinka FROM Zaposlenik ";

            DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText);

            PopulateGridView(dt);
        }

        //public DataTable GetSqlTable(string cmdText, params SqlParameter[] parameters)
        //{
        //    string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
        //    using (SqlConnection conn = new SqlConnection(connString))
        //    {
        //        SqlDataAdapter da = new SqlDataAdapter(cmdText, conn);
        //        //moram isprazniti parametre, jer ovdje se dodaje parametar s generičkim imenom pa svaki puta kada se pozove metoda javlja grešku da već ima parametar s tim imenom pridružen drugoj kolekciji
        //        da.SelectCommand.Parameters.Clear();
        //        if (parameters.Length != 0)
        //        {
        //            foreach (SqlParameter parameter in parameters)
        //            {
        //                da.SelectCommand.Parameters.Add(parameter);
        //            }
        //        }
                
        //        DataTable dt = new DataTable();
        //        da.Fill(dt);
                
        //        return dt;
        //    }
        //}

        private void PopulateGridView(DataTable dt)
        {
            gvPredavaci.DataSource = dt;
            gvPredavaci.DataBind();

            if (gvPredavaci.Rows.Count == 0)
                bezPredavaca.Visible = true;
            else
                bezPredavaca.Visible = false;
        }

        private void EmptyFormFields()
        {
            hfIdPredavac.Value = "";
            txtIme.Text = "";
            txtPrezime.Text = "";
            txtKorisnickoIme.Text = "";
            txtLozinka.Text = "";
        }

        protected void gvPredavaci_SelectedIndexChanged(object sender, EventArgs e)
        {
            updatePredavac.Style.Add("display", "block");
            predavacDarkScreen.Style.Add("display", "block");
            lblBannerPredavac.Text = "Izmijeni korisnika";
            btnUpdatePredavac.Text = "Izmijeni korisnika";
            btnDeletePredavac.Visible = true;
            popisSeminara.Visible = true;

            //indeks odabranog reda u tablici
            int index = gvPredavaci.SelectedIndex;
            GridViewRow row = gvPredavaci.SelectedRow;

            //u hidden field pospremimo vrijednost ćelije DataKey ("DataField="IdZaposlenik"") iz odabranog reda tablice
            hfIdPredavac.Value = gvPredavaci.DataKeys[index].Value.ToString();

            txtIme.Text = row.Cells[1].Text;
            txtPrezime.Text = row.Cells[2].Text;
            txtKorisnickoIme.Text  = row.Cells[3].Text;
            txtLozinka.Text = row.Cells[4].Text;

            //nađemo sve seminare kojima je pridružen ovaj predavač
            string cmdText = "SELECT IdSeminar, Naziv FROM Seminar WHERE IdZaposlenik = " + hfIdPredavac.Value;
            DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText);

            lbPopisSeminara.DataSource = dt;
            lbPopisSeminara.DataValueField = "IdSeminar";
            lbPopisSeminara.DataTextField = "Naziv";
            lbPopisSeminara.DataBind();

        }

        protected void btnUpdatePredavac_Click(object sender, EventArgs e)
        {
            string cmdText = "";

            SqlParameter paramIme = new SqlParameter("@Ime", SqlDbType.NVarChar);
            paramIme.Value = txtIme.Text;
            SqlParameter paramPrezime = new SqlParameter("@Prezime", SqlDbType.NVarChar);
            paramPrezime.Value = txtPrezime.Text;
            SqlParameter paramKorisnickoIme = new SqlParameter("@KorisnickoIme", SqlDbType.NVarChar);
            paramKorisnickoIme.Value = txtKorisnickoIme.Text;
            SqlParameter paramLozinka = new SqlParameter("@Lozinka", SqlDbType.NVarChar);
            paramLozinka.Value = txtLozinka.Text;

            if (hfIdPredavac.Value == "")
            {
                cmdText = "INSERT INTO Zaposlenik VALUES (@Ime, @Prezime, @KorisnickoIme, @Lozinka)";
                Persistence.Predbiljezbe.GetSqlTable(cmdText, paramIme, paramPrezime, paramKorisnickoIme, paramLozinka);
            }
            else
            {
                cmdText = "UPDATE Zaposlenik SET Ime = @Ime, Prezime = @Prezime, KorisnickoIme = @KorisnickoIme, Lozinka = @Lozinka WHERE IdZaposlenik = @IdZaposlenik";
                SqlParameter paramIdZaposlenik = new SqlParameter("@IdZaposlenik", SqlDbType.Int);
                paramIdZaposlenik.Value = hfIdPredavac.Value;
                Persistence.Predbiljezbe.GetSqlTable(cmdText, paramIdZaposlenik, paramIme, paramPrezime, paramKorisnickoIme, paramLozinka);
            }

            EmptyFormFields();
            lbPopisSeminara.Items.Clear();

            updatePredavac.Style.Remove("display");
            predavacDarkScreen.Style.Remove("display");

            //postavimo da ni jedan red nije selektiran u gridu
            gvPredavaci.SelectedIndex = -1;

            FillGrid();
        }

        protected void noviKorisnik_Click(object sender, EventArgs e)
        {
            updatePredavac.Style.Add("display", "block");
            predavacDarkScreen.Style.Add("display", "block");
            popisSeminara.Visible = false;

            EmptyFormFields();

            lblBannerPredavac.Text = "Novi korisnik";
            btnUpdatePredavac.Text = "Unesi korisnika";
            btnDeletePredavac.Visible = false;
        }
        
        protected void btnDeletePredavac_Click(object sender, EventArgs e)
        {
            if (hfIdPredavac.Value != "")
            {
                string cmdProvjeraText = "SELECT * FROM Seminar WHERE IdZaposlenik = @IdZaposlenik";
                SqlParameter paramIdZaposlenik = new SqlParameter("@IdZaposlenik", SqlDbType.Int);
                paramIdZaposlenik.Value = hfIdPredavac.Value;
                DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdProvjeraText, paramIdZaposlenik);

                if (dt.Rows.Count == 0)
                {
                    string cmdText = "DELETE FROM Zaposlenik WHERE IdZaposlenik = @IdZaposlenik";
                    SqlParameter paramIdZaposlenik2 = new SqlParameter("@IdZaposlenik", SqlDbType.Int);
                    //moram kreirati novi parametar (new SqlParameter), ne mogu napisati samo SqlParameter paramIdZaposlenik2 = paramIdZaposlenik
                    //jer će mi onda u metodi GetSqlTable kada se parametar dodaje data adapteru javljati grešku 
                    //"The SqlParameter is already contained by another SqlParameterCollection"
                    paramIdZaposlenik2.Value = hfIdPredavac.Value;
                    Persistence.Predbiljezbe.GetSqlTable(cmdText, paramIdZaposlenik2);
                }
                else
                {
                    //window.onload = function () {}  dio je bitan da se alert pojavi nakon što se učita stranica...inače se alert prikaže nakon postbacka, a prije učitavanja nove stranice
                    //dakle bez toga se alert javi na bijelom ekranu prije učitavanja stranice nakon postbacka
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "window.onload = function () {alert('Zaposlenik se ne može obrisati jer je pridružen jednom ili više seminara!')};", true);
                }

                updatePredavac.Style.Remove("display");
                predavacDarkScreen.Style.Remove("display");

                hfIdPredavac.Value = "";
            }

            FillGrid();
        }

        protected void closePredavac_Click(object sender, EventArgs e)
        {
            updatePredavac.Style.Remove("display");
            predavacDarkScreen.Style.Remove("display");

            hfIdPredavac.Value = "";
            gvPredavaci.SelectedIndex = -1;
        }

        protected void btnPretraziKorisnike_Click(object sender, EventArgs e)
        {
            if (txtKljucnaRijec.Text == "")
            {
                FillGrid();
            }
            else
            {
                string cmdText = "SELECT IdZaposlenik, Ime, Prezime, KorisnickoIme AS 'Korisničko ime', Lozinka FROM Zaposlenik WHERE Ime LIKE ('%' + @Ime + '%')";
                SqlParameter paramRijec = new SqlParameter("@Ime", SqlDbType.NVarChar);
                paramRijec.Value = txtKljucnaRijec.Text;

                DataTable dt = Persistence.Predbiljezbe.GetSqlTable(cmdText, paramRijec);
                PopulateGridView(dt);
            }
        }
    }
}