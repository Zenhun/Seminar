using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Aplikacija.Persistence
{
    public class Predbiljezbe
    {
        //zadnji parametar može biti array, u mom slučaju niz Sql parametara, koje mogu, ali ne moram upotrijebiti
        public static DataTable GetSqlTable(string cmdText, params SqlParameter[] parameters)
        {
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter(cmdText, conn);
                //moram isprazniti parametre, jer ovdje se dodaje parametar s generičkim imenom pa svaki puta kada se pozove metoda javlja grešku da već ima parametar s tim imenom pridružen drugoj kolekciji
                da.SelectCommand.Parameters.Clear();
                if (parameters.Length != 0)
                {
                    foreach (SqlParameter parameter in parameters)
                    {
                        da.SelectCommand.Parameters.Add(parameter);
                    }
                }

                DataTable dt = new DataTable();
                da.Fill(dt);
                da.SelectCommand.Parameters.Clear();
                return dt;
            }
        }

        public static string ObrisiSeminar(string IdPredbiljezba)
        {
            string connString = ConfigurationManager.ConnectionStrings["csSeminarskaBaza"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string cmdText = "DELETE FROM Predbiljezba WHERE IdPredbiljezba = @IdPredbiljezba";
                SqlCommand cmd = new SqlCommand(cmdText, conn);
                cmd.Parameters.AddWithValue("@IdPredbiljezba", Convert.ToInt32(IdPredbiljezba));
                cmd.Connection.Open();
                int brojRedova = cmd.ExecuteNonQuery();

                string poruka;
                if (brojRedova == 1)
                {
                    //brisanje uspjelo
                    poruka = "Uspješno ste obrisali predbilježbu.";
                }
                else
                {
                    //brisanje neuspješno
                    poruka = "Došlo je do greške!";
                }

                return poruka;
            }
        }
    }
}