# Dockerfile لتطبيق Flutter Web
FROM ubuntu:20.04 as builder

# تعيين منطقة زمنية لتجنب موجه التفاعل
ENV TZ=Africa/Cairo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# تثبيت الاعتماديات اللازمة
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# تثبيت Flutter
ENV FLUTTER_ROOT=/flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_ROOT
ENV PATH="$FLUTTER_ROOT/bin:$PATH"

# تهيئة Flutter وتمكين الويب
RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web

# نسخ تطبيق Flutter وتثبيت التبعيات
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

# تحديث ملف api_constants.dart ليشير إلى خدمة الباكند
RUN sed -i 's|http://localhost:5163|http://backend:5163|g' lib/core/constants/api_constants.dart

# بناء تطبيق الويب
RUN flutter build web --release

# استخدام Nginx لخدمة الملفات الثابتة
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html

# تكوين Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]