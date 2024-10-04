import pytest

from app import app  

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_homepage(client):
    response = client.get('/')
    assert response.data == b'Welcome!'
    assert response.status_code == 200

def test_how_are_you(client):
    response = client.get('/how are you')
    assert response.data == b'I am good, how about you?'
    assert response.status_code == 200
