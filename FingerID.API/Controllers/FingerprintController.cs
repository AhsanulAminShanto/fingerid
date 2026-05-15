using Microsoft.AspNetCore.Mvc;
using FingerID.API.Data;
using FingerID.API.Models.DTOs;
using System.Linq;

namespace FingerID.API.Controllers
{
    [ApiController]
    [Route("api/fingerprint")]
    public class FingerprintController : ControllerBase
    {
        private readonly AppDbContext _context;

        public FingerprintController(AppDbContext context)
        {
            _context = context;
        }

        // =========================
        // VERIFY LOGIN (FIXED)
        // =========================
        [HttpPost("verify")]
        public IActionResult Verify([FromBody] FingerprintVerifyDto dto)
        {
            if (dto == null)
                return BadRequest("Invalid request");

            // ✅ ONLY CHECK DEVICE + USER
            var fingerprint = _context.Fingerprints
                .FirstOrDefault(x =>
                    x.UserId == dto.UserId &&
                    x.DeviceId == dto.DeviceId);

            if (fingerprint == null)
                return Unauthorized("Device not registered");

            var user = _context.Users
                .FirstOrDefault(u => u.UserId == dto.UserId);

            if (user == null)
                return Unauthorized("User not found");

            return Ok(new
            {
                message = $"Welcome {user.Name}",
                userId = user.UserId
            });
        }
    }
}