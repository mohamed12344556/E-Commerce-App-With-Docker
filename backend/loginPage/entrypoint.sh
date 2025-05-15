#!/bin/bash

# انتظار حتى يكون SQL Server جاهزاً
echo "Waiting for SQL Server to be ready..."
sleep 10

# محاولة تنفيذ الهجرات
echo "Attempting to run migrations..."
for i in {1..50}; do
    dotnet loginPage.dll --migrate && break
    echo "SQL Server not ready yet (attempt $i/50)..."
    sleep 5
done

# تشغيل التطبيق
echo "Starting the application..."
exec dotnet loginPage.dll