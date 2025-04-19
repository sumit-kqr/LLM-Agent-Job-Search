# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN useradd -m appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Copy application code
COPY --chown=appuser:appuser . .

# Create .streamlit directory for config
RUN mkdir -p /app/.streamlit

# Copy .env file if it exists, otherwise use example
COPY --chown=appuser:appuser .env* ./

# Expose the port Streamlit runs on
EXPOSE 8501

# Set environment variables with defaults
ENV MODEL_ID=o3-mini

# Command to run the app
CMD ["streamlit", "run", "agents/jobs/job-search-agent.py", "--server.port=8501", "--server.address=0.0.0.0"]