using Microsoft.AspNetCore.Mvc;
using FingerID.API.Data;
using FingerID.API.Models;
using FingerID.API.Models.DTOs;

namespace FingerID.API.Controllers
{
    [ApiController]
    [Route("api/users")]
    public class UserController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UserController(AppDbContext context)
        {
            _context = context;
        }

        // =========================
        // REGISTER USER + FINGERPRINT
        // =========================
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto dto)
        {
            if (dto == null)
                return BadRequest("Invalid request");

            var user = new User
            {
                UserId = Guid.NewGuid(),
                Name = dto.Name,
                Email = dto.Email,
                CreatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);

            var fingerprint = new Fingerprint
            {
                Id = Guid.NewGuid(),
                UserId = user.UserId,
                DeviceId = dto.DeviceId,
                FingerTemplate = dto.FingerTemplate
            };

            _context.Fingerprints.Add(fingerprint);

            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "User registered successfully",
                userId = user.UserId
            });
        }
    }
}