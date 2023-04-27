from django.urls import reverse
import pytest
from bs4 import BeautifulSoup
from lettings.models import Address, Letting


@pytest.mark.django_db
def test_lettings_main_page(client):
    response = client.get(reverse('lettings_index'))
    assert response.status_code == 200
    assert b'<h1>Lettings</h1>' in response.content


@pytest.mark.django_db
def test_lettings_detail_page(client):
    # First, fill the database
    addr = Address.objects.create(number=7217,
                                  street="Bedford Street",
                                  city="Brunswick",
                                  state="GA",
                                  zip_code=31525,
                                  country_iso_code="USA"
                                  )
    Letting.objects.create(title="Joshua Tree Green Haus /w Hot Tub",
                           address=addr
                           )

    # Lettings main page
    response = client.get(reverse('lettings_index'))
    assert response.status_code == 200

    # Get all links in the page - first one should point to our object
    data = response.content.decode()
    soup = BeautifulSoup(data, 'html.parser')
    links = soup.find_all('a')
    href = links[0].get('href')

    # Follow the link and check the title
    response = client.get(href, follow_redirects=True)
    assert response.status_code == 200
    assert b'<h1>Joshua Tree Green Haus /w Hot Tub</h1>' in response.content
