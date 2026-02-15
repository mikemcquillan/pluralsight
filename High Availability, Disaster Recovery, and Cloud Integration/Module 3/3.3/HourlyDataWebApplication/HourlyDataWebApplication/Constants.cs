namespace HourlyDataWebApplication
{
    public static class Constants
    {
        public static string CONN_REPORTING = "reportConnection";

        public static string COL_REPORTDATE = "ReportDate";
        public static string COL_REPORTHOUR = "ReportHour";
        public static string COL_NUMBEROFORDERS = "NumberOfOrders";
        public static string COL_TOTALORDERAMOUNT = "TotalOrderAmount";

        public static string SQL_HOURLY_DATA = "SELECT ReportDate, ReportHour, NumberOfOrders, TotalOrderAmount FROM dbo.HourlyOrderData ORDER BY ReportDate DESC, ReportHour DESC;";
    }
}
