# FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
# WORKDIR /app
# EXPOSE 80
# EXPOSE 443

# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /src
# COPY ["loginPage.csproj", "./"]
# RUN dotnet restore "loginPage.csproj"
# COPY . .
# WORKDIR "/src/."
# RUN dotnet build "loginPage.csproj" -c Release -o /app/build

# FROM build AS publish
# RUN dotnet publish "loginPage.csproj" -c Release -o /app/publish /p:UseAppHost=false

# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "loginPage.dll"]



FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["loginPage.csproj", "./"]
RUN dotnet restore "loginPage.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "loginPage.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "loginPage.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# إضافة سكريبت لتنفيذ الهجرات
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]