# backend/app/main.py
from flask import Flask, request, jsonify, send_from_directory
import boto3
import os
import json
from datetime import datetime
import bcrypt
import logging

app = Flask(__name__, static_folder='../../frontend', static_url_path='')

# Environment variables
S3_BUCKET = os.environ.get("S3_BUCKET", "REPLACE_ME_BUCKET")
S3_PREFIX = os.environ.get("S3_PREFIX", "logins/")

# boto3 client will pick up instance role credentials automatically on EC2
s3 = boto3.client('s3')

@app.route('/')
def index():
    # serve static html from frontend folder
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json(force=True)
    username = (data.get('username') or '').strip()
    password = data.get('password') or ''
    if not username or not password:
        return jsonify({"error": "username and password required"}), 400

    # hash password with bcrypt
    salt = bcrypt.gensalt()
    hashed_pw = bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

    record = {
        "username": username,
        "password_hash": hashed_pw,
        "timestamp": datetime.utcnow().isoformat() + 'Z'
    }

    key = f"{S3_PREFIX}{username}-{int(datetime.utcnow().timestamp())}.json"
    try:
        s3.put_object(
            Bucket=S3_BUCKET,
            Key=key,
            Body=json.dumps(record).encode('utf-8'),
            ContentType='application/json',
            ServerSideEncryption='AES256'
        )
    except Exception as e:
        logging.exception("Failed to write to S3")
        return jsonify({"error": "failed to write to S3"}), 500

    return jsonify({"message": "login saved"}), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)
