# Stage 1: Builder
FROM python:3-alpine AS builder

WORKDIR /app

# Create and activate a virtual environment
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Stage 2: Runner
FROM python:3-alpine AS runner

WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /app/venv venv

# Copy the main application file (main.py)
COPY main.py main.py

# Set up the environment for Flask
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV FLASK_APP=main.py
EXPOSE 8080

# Start the app with Gunicorn, pointing to "main:app"
CMD ["gunicorn", "--bind", ":8080", "--workers", "2", "main:app"]
