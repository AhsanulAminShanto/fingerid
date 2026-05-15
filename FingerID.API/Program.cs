using Microsoft.EntityFrameworkCore;
using FingerID.API.Data;

var builder = WebApplication.CreateBuilder(args);

// Controllers
builder.Services.AddControllers();

// PostgreSQL
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// IMPORTANT: allow external access (mobile/phone)
builder.WebHost.UseUrls("http://0.0.0.0:5176");

var app = builder.Build();

// ❌ REMOVE HTTPS REDIRECTION (VERY IMPORTANT FOR MOBILE TESTING)
// app.UseHttpsRedirection();

// Swagger (optional)
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

// Routes
app.MapControllers();

// Test endpoint
app.MapGet("/api/test", () => "FingerID API is working!");

app.Run();