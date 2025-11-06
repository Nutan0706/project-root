# backend/Dockerfile
FROM python:3.11-slim

WORKDIR /app

# install build deps for bcrypt
RUN apt-get update && apt-get install -y build-essential libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*

COPY app/ ./app/
WORKDIR /app/app

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 8000

CMD ["python", "main.py"]
