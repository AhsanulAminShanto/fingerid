using System;

namespace FingerID.API.Models.DTOs
{
    public class FingerprintVerifyDto
    {
        public Guid UserId { get; set; }
        public string DeviceId { get; set; } = string.Empty;
    }
}