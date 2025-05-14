using loginPage.Data;
using loginPage.Data.Models;
using loginPage.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace loginPage.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItemController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;
        
        public ItemController(AppDbContext appDbContext)
        {
            _appDbContext = appDbContext;
        }

        [HttpPost("AddItem")]
        public async Task<IActionResult> AddItem([FromForm] DtoItem dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            byte[] imageBytes;
            using (var ms = new MemoryStream())
            {
                await dto.ImageData.CopyToAsync(ms);
                imageBytes = ms.ToArray();
            }

            var newItem = new Item
            {
                
                Title = dto.Title,
                Description = dto.Description,
                ImageData = imageBytes
            };

            await _appDbContext.AddAsync(newItem);
            _appDbContext.SaveChanges();
            return Ok(newItem);
        }

        [HttpGet("GetItems")]
        public async Task<IActionResult> GetItems()
        {
            var items = await _appDbContext.items.ToListAsync();
            return Ok(items);
        }






        [HttpPut("UpdateItem/{id}")]
        public async Task<IActionResult> UpdateItem(string id, [FromForm] DtoItem dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var item = await _appDbContext.items.FirstOrDefaultAsync(i => i.Id == id);
            if (item == null)
                return NotFound("Item not found");

            byte[] imageBytes;
            using (var ms = new MemoryStream())
            {
                await dto.ImageData.CopyToAsync(ms);
                imageBytes = ms.ToArray();
            }

            item.Title = dto.Title;
            item.Description = dto.Description;
            item.ImageData = imageBytes;
            _appDbContext.Update(item);
            _appDbContext.SaveChanges();
            return Ok(item);
        }




        [HttpDelete("DeleteItem/{id}")]
        public async Task<IActionResult> DeleteItem(string id)
        {
            var item = _appDbContext.items.FirstOrDefault(i => i.Id == id);
            if (item == null)
                return NotFound("Item not found");

            _appDbContext.items.Remove(item);
            _appDbContext.SaveChanges();
            return Ok("Item deleted successfully");
        }
    }
}
