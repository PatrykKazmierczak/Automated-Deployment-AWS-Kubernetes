from flask import Flask, jsonify, request
import requests
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Initialize Prometheus metrics
metrics = PrometheusMetrics(app)

# OpenWeatherMap API key
API_KEY = "b7fea3cdd48393ed8f9e804810bb4c22"

# Sample multi-day weather forecast data
forecast_data = {
    "city": {
        "id": 3163858,
        "name": "Zocca",
        "coord": {
            "lon": 10.99,
            "lat": 44.34
        },
        "country": "IT",
        "population": 4593,
        "timezone": 7200
    },
    "cod": "200",
    "message": 0.0582563,
    "cnt": 7,
    "list": [
        {
            "dt": 1661857200,
            "sunrise": 1661834187,
            "sunset": 1661882248,
            "temp": {
                "day": 299.66,
                "min": 288.93,
                "max": 299.66,
                "night": 290.31,
                "eve": 297.16,
                "morn": 288.93
            },
            "feels_like": {
                "day": 299.66,
                "night": 290.3,
                "eve": 297.1,
                "morn": 288.73
            },
            "pressure": 1017,
            "humidity": 44,
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "speed": 2.7,
            "deg": 209,
            "gust": 3.58,
            "clouds": 53,
            "pop": 0.7,
            "rain": 2.51
        },
        {
            "dt": 1661943600,
            "sunrise": 1661920656,
            "sunset": 1661968542,
            "temp": {
                "day": 295.76,
                "min": 287.73,
                "max": 295.76,
                "night": 289.37,
                "eve": 292.76,
                "morn": 287.73
            },
            "feels_like": {
                "day": 295.64,
                "night": 289.45,
                "eve": 292.97,
                "morn": 287.59
            },
            "pressure": 1014,
            "humidity": 60,
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "speed": 2.29,
            "deg": 215,
            "gust": 3.27,
            "clouds": 66,
            "pop": 0.82,
            "rain": 5.32
        },
        {
            "dt": 1662030000,
            "sunrise": 1662007126,
            "sunset": 1662054835,
            "temp": {
                "day": 293.38,
                "min": 287.06,
                "max": 293.38,
                "night": 287.06,
                "eve": 289.01,
                "morn": 287.84
            },
            "feels_like": {
                "day": 293.31,
                "night": 287.01,
                "eve": 289.05,
                "morn": 287.85
            },
            "pressure": 1014,
            "humidity": 71,
            "weather": [
                {
                    "id": 500,
                    "main": "Rain",
                    "description": "light rain",
                    "icon": "10d"
                }
            ],
            "speed": 2.67,
            "deg": 60,
            "gust": 2.66,
            "clouds": 97,
            "pop": 0.84,
            "rain": 4.49
        },
        # Additional forecast entries can be added here...
    ]
}

# Route to get weather data (both real-time and multi-day forecast)
@app.route('/weather', methods=['GET'])
def get_weather():
    city = request.args.get('city')
    if not city:
        return jsonify({"error": "No city provided"}), 400
    
    # If the requested city is "Zocca", return the predefined multi-day forecast data
    if city.lower() == forecast_data["city"]["name"].lower():
        city_forecast = {
            "city": forecast_data["city"]["name"],
            "country": forecast_data["city"]["country"],
            "coordinates": forecast_data["city"]["coord"],
            "population": forecast_data["city"]["population"],
            "timezone": forecast_data["city"]["timezone"],
            "forecasts": []
        }

        for entry in forecast_data["list"]:
            city_forecast["forecasts"].append({
                "date": entry["dt"],
                "sunrise": entry["sunrise"],
                "sunset": entry["sunset"],
                "temperature": entry["temp"],
                "feels_like": entry["feels_like"],
                "pressure": entry["pressure"],
                "humidity": entry["humidity"],
                "weather": entry["weather"][0]["description"],
                "wind_speed": entry["speed"],
                "rain": entry.get("rain", 0),  # Default rain to 0 if not available
                "cloud_coverage": entry["clouds"]
            })

        return jsonify(city_forecast)

    # Fetch real-time weather data from OpenWeatherMap API if the city is not "Zocca"
    url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric'
    response = requests.get(url)

    if response.status_code != 200:
        return jsonify({"error": "Failed to fetch weather data"}), response.status_code

    data = response.json()

    # Extract relevant real-time data
    weather_info = {
        "city": data["name"],
        "temperature": data["main"]["temp"],
        "description": data["weather"][0]["description"],
        "humidity": data["main"]["humidity"],
        "wind_speed": data["wind"]["speed"]
    }

    return jsonify(weather_info)

# Health check endpoint
@app.route('/healthz', methods=['GET'])
def health_check():
    return "OK", 200

# Prometheus metrics endpoint
@app.route('/metrics', methods=['GET'])
def metrics():
    return metrics.do_export()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
