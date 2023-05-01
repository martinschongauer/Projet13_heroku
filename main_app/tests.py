from django.urls import reverse


def test_main_page(client):
    response = client.get(reverse('index'))
    assert response.status_code == 200
    assert b'<h1>Welcome to Holiday Homes</h1>' in response.content
