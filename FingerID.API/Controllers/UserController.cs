using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
                userId = user.UserId,
                name = user.Name,
                email = user.Email
            });
        }

        // =========================
        // GET USER BY ID
        // =========================
        [HttpGet("{id}")]
        public async Task<IActionResult> GetUserById(Guid id)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.UserId == id);

            if (user == null)
                return NotFound(new { message = "User not found" });

            return Ok(new
            {
                userId = user.UserId,
                name = user.Name,
                email = user.Email,
                createdAt = user.CreatedAt
            });
        }
    }
}