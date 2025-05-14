// using loginPage.Data.Categories;
// using loginPage.Model;
// using Microsoft.AspNetCore.Authorization;
// using Microsoft.AspNetCore.Http;
// using Microsoft.AspNetCore.Identity;
// using Microsoft.AspNetCore.Mvc;
// using Microsoft.IdentityModel.Tokens;
// using System.IdentityModel.Tokens.Jwt;
// using System.Security.Claims;
// using System.Security.Cryptography;
// using System.Text;

// namespace loginPage.Controller
// {
//     [Route("api/[controller]")]
//     [ApiController]
//     public class Account : ControllerBase
//     {
//         private readonly UserManager<User> _userManager;
//         private readonly IConfiguration _configuration;

//         public Account(UserManager<User> userManager ,IConfiguration configuration)
//         {
//             _userManager = userManager;
//             _configuration = configuration;
//         }


//         [HttpPost("Register")]
//         public async Task<IActionResult> AddNewUser(dboAppUser user)
//         {
//             if (ModelState.IsValid)
//             {
//                 User appUser = new()
//                 {
//                     UserName = user.Email,
//                     NameUsr = user.UserName,
//                     Email = user.Email,
//                     PhoneNumber = user.PhoneNumber
//                 };
//                 IdentityResult result = await _userManager.CreateAsync(appUser, user.Password);
//                 if (result.Succeeded)
//                 {
//                     return Ok("Success");
//                 }
//                 else
//                 {
//                     foreach (var item in result.Errors)
//                     { 
//                         ModelState.AddModelError("", item.Description);
//                     }
//                 }

//             }
            
//             return BadRequest(ModelState);
//         }

//         [HttpPost("Login")]
//         public async Task<IActionResult> login(dtoLogin login)
//         {
//             if (ModelState.IsValid)
//             {
//                 User user = await _userManager.FindByEmailAsync(login.Email);
//                 if (user != null)
//                 {
//                     if (await _userManager.CheckPasswordAsync(user, login.Password))
//                     {
//                         // JWT payloud
//                         var claims = new List<Claim>();
//                         claims.Add(new Claim(ClaimTypes.Name, user.NameUsr));
//                         claims.Add(new Claim(ClaimTypes.NameIdentifier, user.Id));
//                         claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
//                         var roles = await _userManager.GetRolesAsync(user);
//                         foreach (var role in roles)
//                         {
//                             claims.Add(new Claim(ClaimTypes.Role, role.ToString()));
//                         }
//                         //signingCredentials generate

//                         var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWt:SecretKey"]));
//                         var sc = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

//                         var token = new JwtSecurityToken
//                             (
//                                 claims: claims,
//                                 issuer: _configuration["JWt:Issuer"],
//                                 audience: _configuration["JWt:Audience"],
//                                 expires: DateTime.Now.AddHours(2),
//                                 signingCredentials: sc
//                             );
//                         var _token = new
//                         {
//                             token = new JwtSecurityTokenHandler().WriteToken(token),
//                             expiration = token.ValidTo,

//                         };
//                         return Ok( _token );



//                     }
//                     else
//                     {
//                         return Unauthorized();
//                     }
//                 }
//                 else
//                 {
//                     ModelState.AddModelError("", "Your name is invalide");
//                 }


//             }

//             return BadRequest(ModelState);
//         }



//         [HttpPut("UpdateUser")]
//         [Authorize]
//         public async Task<IActionResult> UpdateUserData(string name , string PhoneNum)
//         {
//             if (ModelState.IsValid)
//             {
//                 var curruntId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
               
//                 var appUser = await _userManager.FindByIdAsync(curruntId);
//                 if (appUser == null)
//                 {
//                     return NotFound("User not found");
//                 }
//                 appUser.NameUsr = name;
//                 appUser.PhoneNumber = PhoneNum;


//                 var updateResult = await _userManager.UpdateAsync(appUser);
//                 if (updateResult.Succeeded)
//                 {
//                     return Ok("User data updated successfully");
//                 }
//                 else
//                 {
//                     foreach (var error in updateResult.Errors)
//                     {
//                         ModelState.AddModelError("", error.Description);
//                     }
//                 }
//             }

//             return BadRequest(ModelState);
//         }

//     }
// }


using loginPage.Data.Categories;
using loginPage.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace loginPage.Controller
{
    [Route("api/[controller]")]
    [ApiController]
    public class Account : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly IConfiguration _configuration;

        public Account(UserManager<User> userManager, IConfiguration configuration)
        {
            _userManager = userManager;
            _configuration = configuration;
        }


        [HttpPost("Register")]
        public async Task<IActionResult> AddNewUser(dboAppUser user)
        {
            if (ModelState.IsValid)
            {
                User appUser = new()
                {
                    UserName = user.Email,
                    NameUsr = user.UserName,
                    Email = user.Email,
                    PhoneNumber = user.PhoneNumber
                };
                IdentityResult result = await _userManager.CreateAsync(appUser, user.Password);
                if (result.Succeeded)
                {
                    return Ok("Success");
                }
                else
                {
                    foreach (var item in result.Errors)
                    {
                        ModelState.AddModelError("", item.Description);
                    }
                }

            }

            return BadRequest(ModelState);
        }

        [HttpPost("Login")]
        public async Task<IActionResult> login(dtoLogin login)
        {
            if (ModelState.IsValid)
            {
                User user = await _userManager.FindByEmailAsync(login.Email);
                if (user != null)
                {
                    if (await _userManager.CheckPasswordAsync(user, login.Password))
                    {
                        // JWT payloud
                        var claims = new List<Claim>();
                        claims.Add(new Claim(ClaimTypes.Name, user.NameUsr));
                        claims.Add(new Claim(ClaimTypes.NameIdentifier, user.Id));
                        claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
                        var roles = await _userManager.GetRolesAsync(user);
                        foreach (var role in roles)
                        {
                            claims.Add(new Claim(ClaimTypes.Role, role.ToString()));
                        }
                        //signingCredentials generate

                        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWt:SecretKey"]));
                        var sc = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

                        var token = new JwtSecurityToken
                            (
                                claims: claims,
                                issuer: _configuration["JWt:Issuer"],
                                audience: _configuration["JWt:Audience"],
                                expires: DateTime.Now.AddHours(2),
                                signingCredentials: sc
                            );
                        var _token = new
                        {
                            token = new JwtSecurityTokenHandler().WriteToken(token),
                            expiration = token.ValidTo,

                        };
                        return Ok(_token);



                    }
                    else
                    {
                        return Unauthorized();
                    }
                }
                else
                {
                    ModelState.AddModelError("", "Your name is invalide");
                }


            }

            return BadRequest(ModelState);
        }
        [HttpPut("UpdateUser/{userId}")]

        public async Task<IActionResult> UpdateUserData(string userId, string name, string PhoneNum)
        {
            if (ModelState.IsValid)
            {


                var appUser = await _userManager.FindByIdAsync(userId);
                if (appUser == null)
                {
                    return NotFound("User not found");
                }
                appUser.NameUsr = name;
                appUser.PhoneNumber = PhoneNum;


                var updateResult = await _userManager.UpdateAsync(appUser);

                if (updateResult.Succeeded)
                {

                    return Ok("User data updated successfully");
                }
                else
                {
                    foreach (var error in updateResult.Errors)
                    {
                        ModelState.AddModelError("", error.Description);
                    }
                }
            }

            return BadRequest(ModelState);
        }


        [HttpGet("GetUserDataById")]
        public async Task<IActionResult> GetUserDataById(string userId)
        {
            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("User ID is required.");
            }

            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
            {
                return NotFound("User not found.");
            }

            var userData = new
            {
                user.Id,
                user.Email,
                user.PhoneNumber,
                Name = user.NameUsr
                
            };

            return Ok(userData);
        }
        [HttpGet("GetAllUsers")]
        public IActionResult GetAllUsersData()
        {
            var users = _userManager.Users.Select(user => new
            {
                user.Id,
                user.Email,
                user.PhoneNumber,
                Name = user.NameUsr
               
            }).ToList();

            return Ok(users);
        }

    }
}