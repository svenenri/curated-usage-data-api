FROM python:3.11-slim-bookworm

# Set working directory
WORKDIR /app

# Set environment to non-interactive for clean apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Update system packages and install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends gcc libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .

# Install updated version of setuptools and remedieate vulnerabilities
RUN pip install --upgrade setuptools==78.1.1
RUN rm -rf /usr/lib/python3.11/site-packages/setuptools*

# Install remaining Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]