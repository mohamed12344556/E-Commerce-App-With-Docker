# Stage 1: Build the Flutter web app
FROM ubuntu:20.04 AS build

# Install tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    openjdk-8-jdk

# Set variables
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Copy Flutter project
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build the project for web
RUN flutter build web --release

# Stage 2: Create a lightweight web server to serve the app
FROM nginx:alpine

# Copy the build output from previous stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy Nginx configuration (if custom config is needed)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]