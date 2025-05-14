using System.ComponentModel.DataAnnotations;

namespace loginPage.Model
{
    public class DtoItem
    {
        [Required]
        public string Description { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        public IFormFile ImageData { get; set; }
    }
}

