## Screenshots

| Feature | Screenshot | Description |
|---------|------------|-------------|
| **Backend API (Swagger UI)** | ![Backend API](https://your-image-hosting.com/backend-swagger.png) | Swagger UI showing all available API endpoints |
| **Login Screen** | ![Login Screen](https://your-image-hosting.com/login-screen.png) | User authentication interface with form validation |
| **Products List** | ![Products List](https://your-image-hosting.com/products-list.png) | Grid display of products with images and details |
| **Add Product** | ![Add Product](https://your-image-hosting.com/add-product.png) | Form for adding new products with image upload |
| **User Profile** | ![User Profile](https://your-image-hosting.com/user-profile.png) | User profile management interface |
| **Docker Containers** | ![Docker Running](https://your-image-hosting.com/docker-running.png) | Docker Desktop showing the running containers |

> Note: Replace the placeholder URLs with actual screenshots of your application.# E-commerce Platform with .NET and Flutter

This is a containerized e-commerce application built with ASP.NET Core backend and Flutter frontend, orchestrated using Docker Compose.

## Project Overview

This e-commerce platform enables users to register, login, manage products, and update their profiles. It follows a clean architecture approach with separate layers for presentation, business logic, and data access.

### Key Features

- **User Authentication**: Register, login, and manage user profiles
- **Product Management**: Add, update, view, and delete products
- **Image Handling**: Upload and store product images
- **Responsive UI**: Works across web and mobile platforms

## Tech Stack

### Backend
- ASP.NET Core 8.0
- Entity Framework Core
- SQL Server
- JWT Authentication

### Frontend
- Flutter (Web/Mobile)
- BLoC Pattern for state management
- Dio for HTTP requests

### DevOps
- Docker & Docker Compose
- Git for version control

## Architecture

The application follows Clean Architecture principles:

### Backend (.NET)
- **Controller Layer**: API endpoints for authentication and product management
- **Data Layer**: Entity Framework Core and SQL Server for data persistence
- **Model Layer**: Domain entities and DTOs

### Frontend (Flutter)
- **Presentation Layer**: UI components and screens
- **Business Logic Layer**: BLoC for state management
- **Data Layer**: API clients and repositories

## Getting Started

### Prerequisites
- Docker and Docker Compose installed
- Git (for cloning the repository)

### Running with Docker Compose

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ecommerce-project.git
   cd ecommerce-project
   ```

2. Create Dockerfile for backend in the backend/loginPage directory:
   ```dockerfile
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
   ENTRYPOINT ["dotnet", "loginPage.dll"]
   ```

3. Create docker-compose.yml in the root directory:
   ```yaml
   services:
     sql-server:
       image: mcr.microsoft.com/mssql/server:2019-latest
       environment:
         - ACCEPT_EULA=Y
         - SA_PASSWORD=YourStrongPassword123!
       ports:
         - "1433:1433"
       volumes:
         - sql-data:/var/opt/mssql
       networks:
         - ecommerce-network

     backend:
       build:
         context: ./backend/loginPage
         dockerfile: Dockerfile
       ports:
         - "5163:80"
       depends_on:
         - sql-server
       environment:
         - ASPNETCORE_ENVIRONMENT=Development
         - ConnectionStrings__conStr=Server=sql-server;Database=DotNetCore-ECommerce.Identity;User Id=sa;Password=YourStrongPassword123!;TrustServerCertificate=true;
       networks:
         - ecommerce-network

   networks:
     ecommerce-network:
       driver: bridge

   volumes:
     sql-data:
   ```

4. Start the application using Docker Compose:
   ```bash
   docker-compose up --build
   ```

5. Access the application:
   - Backend API: http://localhost:5163
   
6. Push images to Docker Hub:
   ```bash
   # Login to Docker Hub
   docker login
   
   # Tag images
   docker tag ecommerce-project_backend yourusername/ecommerce-backend:latest
   
   # Push images
   docker push yourusername/ecommerce-backend:latest
   ```

### Docker Images

- Backend: [DockerHub Link](https://hub.docker.com/yourusername/ecommerce-backend)
- Frontend: [DockerHub Link](https://hub.docker.com/yourusername/ecommerce-frontend)

## Development Setup

### Backend (.NET)
1. Navigate to the backend directory:
   ```bash
   cd backend/loginPage
   ```

2. Install dependencies and run:
   ```bash
   dotnet restore
   dotnet run
   ```

### Frontend (Flutter)
1. Navigate to the frontend directory:
   ```bash
   cd ecommerce_app
   ```

2. Install dependencies and run:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

## API Endpoints

### Authentication
- `POST /api/Account/Register` - Register a new user
- `POST /api/Account/Login` - User login
- `PUT /api/Account/UpdateUser/{userId}` - Update user profile
- `GET /api/Account/GetUserDataById` - Get user data
- `GET /api/Account/GetAllUsers` - Get all users

### Products
- `GET /api/Item/GetItems` - Get all products
- `POST /api/Item/AddItem` - Add a new product
- `PUT /api/Item/UpdateItem/{id}` - Update product
- `DELETE /api/Item/DeleteItem/{id}` - Delete product

## Docker Configuration

### Backend Dockerfile
```dockerfile
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
ENTRYPOINT ["dotnet", "loginPage.dll"]
```

### docker-compose.yml
```yaml
services:
  sql-server:
    image: mcr.microsoft.com/mssql/server:2019-latest
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=YourStrongPassword123!
    ports:
      - "1433:1433"
    volumes:
      - sql-data:/var/opt/mssql
    networks:
      - ecommerce-network

  backend:
    build:
      context: ./backend/loginPage
      dockerfile: Dockerfile
    ports:
      - "5163:80"
    depends_on:
      - sql-server
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ConnectionStrings__conStr=Server=sql-server;Database=DotNetCore-ECommerce.Identity;User Id=sa;Password=YourStrongPassword123!;TrustServerCertificate=true;
    networks:
      - ecommerce-network

networks:
  ecommerce-network:
    driver: bridge

volumes:
  sql-data:
```

## Contributors
- Your Name

## License
This project is licensed under the MIT License - see the LICENSE file for details.
