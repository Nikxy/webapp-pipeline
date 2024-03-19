"""
Forecast class
Author: Diana Melnychuk
"""
import requests
from dateutil import parser, tz
from geocoding import GeoCoding


class DayForecast:
    """ Contains day forecast data """

    def __init__(self, date, min_temp, max_temp, average_humidity, weather_code):
        self.date = date
        self.min_temp = min_temp
        self.max_temp = max_temp
        self.average_humidity = average_humidity
        self.weather_code = weather_code


class CurrentWeather:
    """ Contains current weather data """

    def __init__(self, temp, humidity, weather_code):
        self.temp = temp
        self.humidity = humidity
        self.weather_code = weather_code


class Forecast:
    """ Contains forecast data and get method"""

    def __init__(self):
        self.days = []
        self.current = None
        self.geocoding = None

    def getWeatherEmoji(self, weather_code):
        if weather_code == 1:
            return "🌤️"
        elif weather_code == 2:
            return "⛅"
        elif weather_code == 3:
            return "☁️"
        elif weather_code == 45:
            return "🌫️"
        elif 51 <= weather_code <= 67:
            return "🌧️"
        elif 80 <= weather_code <= 82:
            return "🌧️"
        elif 71 <= weather_code <= 77 or 85 <= weather_code <= 86:
            return "🌨️"
        elif 95 <= weather_code <= 99:
            return "⛈️"
        else:
            return "☀️"

    @staticmethod
    def get(geocoding: GeoCoding, forecast_days):
        """ Get weather forecast for specified location """
        params = {
            'latitude': geocoding.latitude,
            'longitude': geocoding.longitude,
            'current': 'temperature_2m,relative_humidity_2m,weather_code',
            'daily': 'weather_code,temperature_2m_max,temperature_2m_min,relative_humidity_2m_mean',
            'forecast_days': forecast_days,
            'timezone': 'auto'
        }
        response = requests.get('https://api.open-meteo.com/v1/forecast', params=params)
        response_obj = response.json()
        forecast = Forecast()
        # Read time zone for datetime
        timezone = response_obj['timezone']
        forecast.current = CurrentWeather(
            response_obj['current']['temperature_2m'],
            response_obj['current']['relative_humidity_2m'],
            response_obj['current']['weather_code'])

        for i in range(0, forecast_days):
            # Read date of day
            date = response_obj['daily']['time'][i]
            # Parse date string to datetime with timezone
            date = parser.parse(date).astimezone(tz.gettz(timezone))
            # Create day forecast
            day_forecast = DayForecast(date,
                                       response_obj['daily']['temperature_2m_min'][i],
                                       response_obj['daily']['temperature_2m_max'][i],
                                       response_obj['daily']['relative_humidity_2m_mean'][i],
                                       response_obj['daily']['weather_code'][i])
            # Add forecast to days list
            forecast.days.append(day_forecast)

        forecast.geocoding = geocoding
        return forecast
