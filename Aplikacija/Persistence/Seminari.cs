using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Aplikacija.Persistence
{
    public class Seminari
    {
        public static int InsertOrUpdateSeminar(string cmdText, string IdSeminar, string naziv, string opis, DateTime datum, string predavac, bool popunjen)
        {
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {

                SqlCommand cmd = new SqlCommand(cmdText, conn);

                cmd.Parameters.AddWithValue("@idSeminar", IdSeminar);
                cmd.Parameters.AddWithValue("@naziv", naziv);
                cmd.Parameters.AddWithValue("@opis", opis);
                cmd.Parameters.AddWithValue("@datum", datum);
                //ddlPredavac.SelectedValue = IdZaposlenik
                cmd.Parameters.AddWithValue("@predavac", predavac);
                cmd.Parameters.AddWithValue("@popunjen", popunjen);

                cmd.Connection.Open();
                return cmd.ExecuteNonQuery();
            }
        }
    }
}