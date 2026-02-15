using HourlyDataWebApplication.Data;
using HourlyDataWebApplication.Models;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Diagnostics;

namespace HourlyDataWebApplication.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private IConfiguration _config;

        public HomeController(ILogger<HomeController> logger, IConfiguration config)
        {
            _logger = logger;
            _config = config;
        }

        public IActionResult Index()
        {
            var connString = _config.GetConnectionString(Constants.CONN_REPORTING);
            var output = new OutputModel();

            try
            {
                DataConnection conn = new DataConnection(connString);
                var table = conn.ExecuteQuery(Constants.SQL_HOURLY_DATA);

                output.ConnectionString = connString;
                output.HourlyData = convertTableToModelList(table);
            }
            catch (Exception ex)
            {
                output.ConnectionString = connString;
                output.ErrorMessage = ex.Message;
            }

            return View(output);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        private List<HourlyDataModel> convertTableToModelList(DataTable table)
        {
            List<HourlyDataModel> hourlyDataSet = new List<HourlyDataModel>();

            for (int i = 0; i < table.Rows.Count; i++)
            {
                var hd = new HourlyDataModel()
                {
                    ReportDate = (DateTime)table.Rows[i][Constants.COL_REPORTDATE],
                    ReportHour = (int)table.Rows[i][Constants.COL_REPORTHOUR],
                    NumberOfOrders = (int)table.Rows[i][Constants.COL_NUMBEROFORDERS],
                    TotalOrderAmount = (decimal)(table.Rows[i][Constants.COL_TOTALORDERAMOUNT] == null ? table.Rows[i][Constants.COL_TOTALORDERAMOUNT] : (decimal)0)
                };

                hourlyDataSet.Add(hd);
            }

            return hourlyDataSet;
        }
    }
}
