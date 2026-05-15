using System;
using System.Collections.Generic;

namespace FingerID.API.Models
{
    public class User
    {
        public Guid UserId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public List<Fingerprint> Fingerprints { get; set; } = new();
    }
}

// This code defines a User class in the FingerID.API.Models namespace. The User class has properties for UserId, Name, Email, CreatedAt, and a list of Fingerprints. The UserId is a unique identifier for each user, while Name and Email are self-explanatory. CreatedAt records the time when the user was created. The Fingerprints property is a list that can hold multiple Fingerprint objects associated with the user.