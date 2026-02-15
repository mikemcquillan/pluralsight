using Microsoft.Data.SqlClient;
using System.Data;

namespace HourlyDataWebApplication.Data
{
    public class DataConnection
    {       
        private string _connectionString;
        private SqlConnection _conn;

        public DataConnection(string connectionString)
        {
            _connectionString = connectionString;
            _conn = new SqlConnection(connectionString);
        }

        public DataTable ExecuteQuery(string sql)
        {
            var table = new DataTable();

            if (_conn != null && _conn.State != ConnectionState.Open)
            {
                _conn.Open();
            }

            var cmd = new SqlCommand(sql, _conn);
            var reader = cmd.ExecuteReader();
            table = ConvertQueryDataToDataTable(reader);

            if (_conn != null)
            {
                _conn.Close();
            }

            return table;
        }

        private DataTable ConvertQueryDataToDataTable(SqlDataReader reader)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(Constants.COL_REPORTDATE, typeof(DateTime));
            dt.Columns.Add(Constants.COL_REPORTHOUR, typeof(int));
            dt.Columns.Add(Constants.COL_NUMBEROFORDERS, typeof(int));
            dt.Columns.Add(Constants.COL_TOTALORDERAMOUNT, typeof(decimal));

            while (reader.Read())
            {
                var row = dt.NewRow();

                row[Constants.COL_REPORTDATE] = reader[Constants.COL_REPORTDATE];
                row[Constants.COL_REPORTHOUR] = reader[Constants.COL_REPORTHOUR];
                row[Constants.COL_NUMBEROFORDERS] = reader[Constants.COL_NUMBEROFORDERS];
                row[Constants.COL_TOTALORDERAMOUNT] = reader[Constants.COL_TOTALORDERAMOUNT];

                dt.Rows.Add(row);
            }

            return dt;
        }
    }
}
