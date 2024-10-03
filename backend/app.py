from flask import Flask, jsonify, request
import requests
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)

# Initialize Prometheus metrics
metrics = PrometheusMetrics(app)

# OpenWeatherMap API key
API_KEY = "b7fea3cdd48393ed8f9e804810bb4c22"

# Route to get weather data
@app.route('/weather', methods=['GET'])
def get_weather():
    city = request.args.get('city')
    if not city:
        return jsonify({"error": "No city provided"}), 400
    
    # Fetch weather data from OpenWeatherMap
    url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric'
    response = requests.get(url)

    if response.status_code != 200:
        return jsonify({"error": "Failed to fetch weather data"}), response.status_code

    data = response.json()
    
    # Extract relevant data
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
