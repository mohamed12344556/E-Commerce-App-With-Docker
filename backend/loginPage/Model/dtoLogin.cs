using System.ComponentModel.DataAnnotations;

namespace loginPage.Model
{
    public class dtoLogin
    {
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }
    }
}
