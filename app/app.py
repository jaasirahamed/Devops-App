from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    """Simple home endpoint"""
    return jsonify({
        "message": "Hello, DevOps!",
        "status": "running"
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy"})

@app.route('/version')
def version():
    """Version endpoint"""
    return jsonify({
        "app": "devops-app",
        "version": "1.0.0",
        "environment": os.getenv('ENV', 'development')
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port)