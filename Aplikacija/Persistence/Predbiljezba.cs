using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Aplikacija.Persistence
{
    public class Predbiljezba
    {
        public static DataTable GetTable(SqlParameter parameter)
        {
            DataTable dt = new DataTable();
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string cmdText;
                SqlDataAdapter da = new SqlDataAdapter();

                if (parameter == null)
                {
                    //uvjet za popunjene mora uključiti i nepopunjene (0) i neispunjene (NULL)
                    //prikazujem samo datum, bez time dijela pomoću CONVERT funkcije...104 je šifra za dd.mm.yyyy ispis
                    cmdText = "SELECT  s.IdSeminar, s.Naziv, s.Opis, CONVERT(VARCHAR(10), s.Datum, 104), z.Ime + ' ' + z.Prezime AS Predavač FROM  Seminar s INNER JOIN Zaposlenik z ON s.IdZaposlenik = z.IdZaposlenik WHERE (s.Popunjen = 0 OR s.Popunjen IS NULL) ORDER BY s.Datum";
                    da.SelectCommand = new SqlCommand(cmdText);
                }
                else
                {
                    cmdText = "SELECT  s.IdSeminar, s.Naziv, s.Opis, s.Datum, z.Ime + ' ' + z.Prezime AS Predavač FROM  Seminar s INNER JOIN Zaposlenik z ON s.IdZaposlenik = z.IdZaposlenik WHERE (s.Popunjen = 0 OR s.Popunjen IS NULL) AND s.Naziv LIKE '%' + @Pretraga + '%' ORDER BY s.Datum";
                    da.SelectCommand = new SqlCommand(cmdText);
                    da.SelectCommand.Parameters.Add(parameter);
                }

                da.SelectCommand.Connection = conn;
                da.Fill(dt);
            }
            
            return dt;
        }

        public static int PrijaviSeminar(string prijavaId, string ime, string prezime, string email, string tel)
        {
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                //CONVERT (date, GETDATE())  nam služi da dobijemo trenutni date, bez time dijela
                string cmdText = "INSERT INTO Predbiljezba VALUES (@IdSeminar, CONVERT (date, GETDATE()), @Ime, @Prezime, @Email, @Telefon, NULL)";
                SqlCommand cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@IdSeminar", Convert.ToInt32(prijavaId));
                cmd.Parameters.AddWithValue("@Ime", ime);
                cmd.Parameters.AddWithValue("@Prezime", prezime);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Telefon", tel);

                cmd.Connection.Open();
                return cmd.ExecuteNonQuery();
            }
        }
    }
}