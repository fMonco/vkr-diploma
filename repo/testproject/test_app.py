import pytest
from app import app  # Предполагаем, что ваше приложение называется 'app.py'

# Простая проверка статуса главной страницы
def test_homepage():
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b'Hello, World!' in response.data

# Простой тест для другой страницы (если у вас есть другая страница)
def test_another_page():
    with app.test_client() as client:
        response = client.get('/another')
        assert response.status_code == 200
        assert b'Another Page' in response.data

# Тест проверки ошибки на несуществующую страницу
def test_not_found():
    with app.test_client() as client:
        response = client.get('/nonexistent')
        assert response.status_code == 404
