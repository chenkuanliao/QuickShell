FROM python:3.9-slim

WORKDIR /app

# Copy the entire project
COPY . .

# Expose port 8000
EXPOSE 8000

# Run the server
CMD ["python", "server.py"]
