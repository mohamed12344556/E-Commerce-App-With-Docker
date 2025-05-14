using loginPage.Data.Categories;
using loginPage.Data.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace loginPage.Data
{
    public class AppDbContext : IdentityDbContext<User>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options):base(options) 
        {

            
        }
        public DbSet<User> users { get; set; }
        public DbSet<Item> items { get; set; }


       
    }
}
