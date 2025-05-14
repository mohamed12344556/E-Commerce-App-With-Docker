using System.ComponentModel.DataAnnotations;

namespace loginPage.Model
{
    public class dboAppUser
    {
        [Required]
        public string UserName { get; set; }
        
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { set; get; }

        public string? PhoneNumber { get; set; }
    }
}
