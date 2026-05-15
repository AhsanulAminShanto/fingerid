using Microsoft.EntityFrameworkCore;
using FingerID.API.Models;

namespace FingerID.API.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Fingerprint> Fingerprints { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Fingerprint>()
                .HasKey(f => f.Id);
        }
    }
}