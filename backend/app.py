from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the backend API!"})

@app.route('/api/data')
def get_data():
    return jsonify({"data": "This is some data from the backend"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
