namespace HourlyDataWebApplication.Models
{
    public class HourlyDataModel
    {
        public DateTime ReportDate { get; set; }
        public int ReportHour { get; set; }
        public int NumberOfOrders { get; set; }
        public decimal TotalOrderAmount { get; set; }
    }
}
