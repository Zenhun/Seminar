using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Aplikacija.Persistence
{
    public class Prijava
    {
        public static bool ProvjeraKorisnika(string korisnickoIme, string lozinka)
        {
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                //SqlCommand objekt koji poziva stored procedure pod imenom spPrijava
                SqlCommand cmd = new SqlCommand("spPrijava", conn);
                //cmd objekt poziva stored procedure
                cmd.CommandType = CommandType.StoredProcedure;

                //stored procedure spPrijava prihvaća 2 parametra, dodajemo ih cmd objektu
                cmd.Parameters.AddWithValue("@KorisnickoIme", korisnickoIme);
                cmd.Parameters.AddWithValue("@Lozinka", lozinka);

                cmd.Connection.Open();

                //pozivamo stored procedure gdje se vrši provjera korisničkih podataka
                int ReturnCode = (int)cmd.ExecuteScalar();

                //uspoređujemo ReturnCode s 1 i tako vraćamo bool vrijednost
                return ReturnCode == 1;
            }
        }

        public static string GetUser(string userName)
        {
            //izvučemo ime korisnika koji se logira i pospremimo u session da ga kasnije upotrijebimo da ispišemo ime logiranog korisnika, a ne user name
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string cmdText = "SELECT Ime + ' ' + Prezime FROM Zaposlenik WHERE KorisnickoIme = @KorisnickoIme";
                SqlCommand cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@KorisnickoIme", userName);

                cmd.Connection.Open();
                return cmd.ExecuteScalar().ToString();
            }
        }
    }
}