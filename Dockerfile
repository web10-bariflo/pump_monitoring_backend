## Use an official Python runtime as a parent image
#FROM python:3.10-slim
 
## Set the working directory in the container
#WORKDIR /app
 
## Install system dependencies including PostgreSQL client and dev libraries
#RUN apt-get update && apt-get install -y \
#    gcc \
#    python3-dev \
#    libpq-dev \
#    && rm -rf /var/lib/apt/lists/*
 
## Copy project files
#COPY . /app/
 
## Install dependencies
#RUN pip install --no-cache-dir --upgrade pip && \
#    pip install --no-cache-dir -r requirement.txt
 
## Expose port 8000 for Django
#EXPOSE 8000
 
## Set default command to run Django server
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
 
FROM python:3.10-slim
 
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/opt/venv/bin:$PATH"
 
# Set the working directory
WORKDIR /app
 
# Install only essential packages
RUN apt-get update && \
    apt-get install -y \
    python3-venv \
    procps \
    supervisor && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    rm -rf /var/lib/apt/lists/*
 
# Create a virtual environment
RUN python3 -m venv /opt/venv
 
# Copy requirements and install dependencies
COPY requirement.txt /app/
RUN pip install --no-cache-dir -r requirement.txt
 
# Copy application code
COPY . /app/
 
# Make the startup script executable
COPY all_commands.sh /app/all_commands.sh
RUN chmod +x /app/all_commands.sh
 
# Expose Django port
EXPOSE 8000
 
# Run the startup script
CMD ["/app/all_commands.sh"]
