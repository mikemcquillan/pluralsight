namespace HourlyDataWebApplication.Models
{
    public class OutputModel
    {
        public string ConnectionString { get; set; }
        public List<HourlyDataModel> HourlyData { get; set; }
        public string ErrorMessage { get; set; }
    }
}
