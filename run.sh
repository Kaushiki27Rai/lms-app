#!/bin/bash

echo "=================================================="
echo "🚀 Starting LMS Web Application..."
echo "=================================================="

# Check for Maven
if command -v mvn &> /dev/null; then
    MVN_CMD="mvn"
elif [ -f "/opt/homebrew/bin/mvn" ]; then
    MVN_CMD="/opt/homebrew/bin/mvn"
else
    echo "❌ Error: Maven is not installed or not in PATH."
    exit 1
fi

echo "📦 Compiling and starting embedded web server on http://localhost:8080..."
echo "🔗 Open http://localhost:8080/auth in your browser when ready!"
echo "=================================================="

$MVN_CMD jetty:run
