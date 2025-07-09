import pytest
import json
from app import app


@pytest.fixture
def client():
    """Create a test client for the Flask application."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_home_endpoint(client):
    """Test the home endpoint."""
    response = client.get('/')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['message'] == 'Hello, DevOps!'
    assert data['status'] == 'running'


def test_health_endpoint(client):
    """Test the health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'


def test_version_endpoint(client):
    """Test the version endpoint."""
    response = client.get('/version')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['app'] == 'devops-app'
    assert data['version'] == '1.0.0'