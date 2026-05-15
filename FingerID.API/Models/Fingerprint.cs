using System;

namespace FingerID.API.Models
{
    public class Fingerprint
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string DeviceId { get; set; } = string.Empty;

        // ⚠️ stored only for record, NOT for matching
        public string FingerTemplate { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}