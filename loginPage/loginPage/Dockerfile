FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# نسخ ملف المشروع وترميم التبعيات
COPY ["loginPage.csproj", "."]
RUN dotnet restore

# نسخ باقي الملفات وبناء المشروع
COPY . .
RUN dotnet build "loginPage.csproj" -c Release -o /app/build

# نشر المشروع
FROM build AS publish
RUN dotnet publish "loginPage.csproj" -c Release -o /app/publish /p:UseAppHost=false

# الصورة النهائية
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# إضافة دعم CORS
RUN echo '{ "AllowedHosts": "*", "ConnectionStrings": { "DefaultConnection": "Data Source=loginPage.db" }, "Cors": { "AllowedOrigins": ["http://localhost:8080", "http://localhost", "http://frontend"] } }' > appsettings.Docker.json

# تعيين منفذ الاستماع
ENV ASPNETCORE_URLS=http://+:5163
EXPOSE 5163

ENTRYPOINT ["dotnet", "loginPage.dll"]