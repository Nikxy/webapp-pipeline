"""
Geo Coding class
Author: Diana Melnychuk
"""
import requests


class NotFoundException(Exception):
    """ GeoCoding Not Found Exception """
    pass


class GeoCoding:
    """Contains geocoding data and find method"""
    def __init__(self, name, country, latitude, longitude):
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude

    @staticmethod
    def find(query: str):
        """Uses geocoding api to get coordinates from city/country name"""
        response = requests.get(f'https://geocoding-api.open-meteo.com/v1/search?name={query}'
                                '&count=1&language=en&format=json')
        response_obj = response.json()
        if 'results' not in response_obj.keys():
            raise NotFoundException()
        geo = response_obj['results'][0]
        country = "N/A"
        if 'country' in geo:
            country = geo['country']
        elif 'country_code' in geo:
            country = geo['country_code']
        return GeoCoding(geo['name'], country, geo['latitude'], geo['longitude'])
