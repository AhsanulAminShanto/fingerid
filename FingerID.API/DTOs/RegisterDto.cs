namespace FingerID.API.Models.DTOs
{
    public class RegisterDto
    {
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string DeviceId { get; set; } = string.Empty;
        public string FingerTemplate { get; set; } = string.Empty;
    }
}