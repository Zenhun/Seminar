using System;
using System.Web.Security;

namespace Aplikacija
{
    public partial class Prijava : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            txtKorisnickoIme.Focus();
        }

        protected void btnPrijavi_Click(object sender, EventArgs e)
        {
            if (Persistence.Prijava.ProvjeraKorisnika(txtKorisnickoIme.Text, txtLozinka.Text))
            {
                FormsAuthentication.RedirectFromLoginPage(txtKorisnickoIme.Text, false);
                Session["korisnik"] = Persistence.Prijava.GetUser(txtKorisnickoIme.Text);
            }
            else
            {
                lblPrijava.Text = "Krivo korisničko ime i/ili lozinka!";
            }
        }
    }
}