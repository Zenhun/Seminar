using System;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace Aplikacija
{
    public partial class Predbiljezba : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                bezPodataka.Visible = false;
                PopulateGrid(null);
            }
        }

        protected void btnPretrazi_Click(object sender, EventArgs e)
        {
            if (txtPretraga.Text == "")
            {
                PopulateGrid(null);
            }
            else
            {
                SqlParameter paramPretraga = new SqlParameter("@Pretraga", SqlDbType.NVarChar);
                paramPretraga.Value = txtPretraga.Text;
                PopulateGrid(paramPretraga);
            }
        }

        private void PopulateGrid(SqlParameter parameter)
        {
            DataTable dt = new DataTable();
            dt = Persistence.Predbiljezba.GetTable(parameter);

            BuildFlexGrid(dt);
            ifEmpty(dt);
        }

        private void BuildFlexGrid(DataTable dt)
        { 
            StringBuilder stringBuilder = new StringBuilder();

            foreach (DataRow row in dt.Rows)
            {
                //unutar svakog flex-itema u hidden fieldu je pospremljen ID Predbilježbe na koji se odnosi
                //nije mi radilo s asp:hiddenfield, a input type='hidden' je ok
                stringBuilder.AppendFormat("<div class='flex-item'><input type='hidden' class='hidSeminar' name='hidSeminar' Value='{0}' /><div class='naslov'>{1}<h2>Prijavi seminar</h2><div class='overlayWrap'></div></div><div id='datum'><b>{2}</b></div><div class='opis'>{3}</div><div id='predavac'>{4}</div></div>", row[0].ToString(), row[1].ToString(), row[3].ToString(), row[2].ToString(), row[4].ToString());
            }

            flexContainer.InnerHtml = stringBuilder.ToString();
        }

        public void ifEmpty(DataTable dt)
        {
            if (dt.Rows.Count == 0)
                bezPodataka.Visible = true;
            else
                bezPodataka.Visible = false;
        }

        protected void btnPrijavi_Click(object sender, EventArgs e)
        {
            string poruka;
            int brojRedova = Persistence.Predbiljezba.PrijaviSeminar(hfPrijavaIdSeminar.Value, txtUnosIme.Text, txtUnosPrezime.Text, txtUnosEmail.Text, txtUnosTel.Text);

            if (brojRedova == 1)
                poruka = "Uspješno ste prijavili seminar!";
            else
                poruka = "Došlo je do greške!";

            //window.onload = function () {}  dio je bitan da se alert pojavi nakon što se učita stranica...inače se alert prikaže nakon postbacka, a prije učitavanja nove stranice
            //dakle bez toga se alert javi na bijelom ekranu prije učitavanja stranice nakon postbacka
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "window.onload = function () {alert('" + poruka + "')};", true);
        }
    }
}