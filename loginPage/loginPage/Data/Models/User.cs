using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;

namespace loginPage.Data.Categories
{
    public class User : IdentityUser
    {
        [Required]
        [MaxLength(100)]
       public string NameUsr { get; set; }
    }
}
