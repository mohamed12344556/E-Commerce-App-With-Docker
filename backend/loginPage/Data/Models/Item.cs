using System.ComponentModel.DataAnnotations;

namespace loginPage.Data.Models
{
    public class Item
    {

        

        

        [Key]
        public string Id { get; set; } =Guid.NewGuid().ToString(); 
        [Required]
        public string Description { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        public byte[] ImageData { get; set; }
    }
}
