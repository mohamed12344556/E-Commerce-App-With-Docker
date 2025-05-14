using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace loginPage.Migrations
{
    /// <inheritdoc />
    public partial class AddNameClumomToUserTableA : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "NameUsr",
                table: "AspNetUsers",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "NameUsr",
                table: "AspNetUsers");
        }
    }
}
