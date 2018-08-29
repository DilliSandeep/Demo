using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
u

namespace CrudOperations
{
    public partial class DOM : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                this.BindDummyRow();
            }
        }
        private void BindDummyRow()
        {
            DataTable dummy = new DataTable();
            dummy.Columns.Add("CustomerID");
            dummy.Columns.Add("Name");
            dummy.Columns.Add("Country");
            dummy.Rows.Add();
            gvCustomers.DataSource = dummy;
            gvCustomers.DataBind();        
        }
        [WebMethod]
        public static string GetCustomers()
        {
            string query = "select CustomerID,Name,Country from tblCustomer";
            SqlCommand cmd = new SqlCommand(query);
            string constr = ConfigurationManager.AppSettings["DbString"].ToString();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    using (DataSet ds = new DataSet())
                    {
                        sda.Fill(ds);
                        return ds.GetXml();
                    }
                }
            }

        }
       [WebMethod]
        public static int InsertCustomer(string name, string country)
        {
            string constr = ConfigurationManager.AppSettings["DbString"].ToString();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand("insert into tblCustomer(Name,Country)values('@name','@country') SELECT SCOPE_IDENTITY()"))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Country", country);
                    cmd.Connection = con;
                    con.Open();
                    int customerId = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                    return customerId;
                }
            }
        }
       [WebMethod]
       public static void UpdateCustomer(int customerId, string name, string country)
       {
           string constr = ConfigurationManager.AppSettings["DbString"].ToString();
           using (SqlConnection con = new SqlConnection(constr))
           {
               using (SqlCommand cmd = new SqlCommand("UPDATE tblCustomer SET Name = @Name, Country = @Country WHERE CustomerID = @CustomerID"))
               {
                   cmd.Parameters.AddWithValue("@CustomerID", customerId);
                   cmd.Parameters.AddWithValue("@Name", name);
                   cmd.Parameters.AddWithValue("@Country", country);
                   cmd.Connection = con;
                   con.Open();
                   cmd.ExecuteNonQuery();
                   con.Close();
               }
           }
       }
       [WebMethod]
       public static void DeleteCustomer(int customerId)
       {
           string constr = ConfigurationManager.AppSettings["DbString"].ToString();
           using (SqlConnection con = new SqlConnection(constr))
           {
               using (SqlCommand cmd = new SqlCommand("DELETE FROM Customers WHERE CustomerID = @CustomerID"))
               {
                   cmd.Parameters.AddWithValue("@CustomerID", customerId);
                   cmd.Connection = con;
                   con.Open();
                   cmd.ExecuteNonQuery();
                   con.Close();
               }
           }
       }
        
    }
}