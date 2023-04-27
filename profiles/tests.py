from django.urls import reverse
import pytest
from bs4 import BeautifulSoup
from profiles.models import Profile
from django.contrib.auth.models import User


@pytest.mark.django_db
def test_profiles_main_page(client):
    response = client.get(reverse('profiles_index'))
    assert response.status_code == 200
    assert b'<h1>Profiles</h1>' in response.content


@pytest.mark.django_db
def test_profiles_detail_page(client):
    # Populate the database
    user1 = User.objects.create_user(username='Test_user',
                                     first_name='Test', last_name='User',
                                     email='Test_user@oc.com', password='password')
    Profile.objects.create(user=user1,
                           favorite_city="Miami"
                           )

    # Profiles main page
    response = client.get(reverse('profiles_index'))
    assert response.status_code == 200

    # Get all links in the page - first one should point to the user profile
    data = response.content.decode()
    soup = BeautifulSoup(data, 'html.parser')
    links = soup.find_all('a')
    href = links[0].get('href')

    # Follow the link and check the title
    response = client.get(href, follow_redirects=True)
    assert response.status_code == 200
    assert b'<h1>Test_user</h1>' in response.content
