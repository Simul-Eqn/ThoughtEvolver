from flask import Flask, request, jsonify
import numpy as np

from sonar_handler import generate_embedding, reconstruct_text

app = Flask(__name__)

@app.route("/get_embedding", methods=["POST"])
def get_embedding():
    #print("RQEUEST", request.data)
    data = request.json
    #print("RQUEST JSON", data)
    if "text" not in data:
        return jsonify({"error": "Missing 'text' in request."}), 400

    text = data["text"]
    embedding = generate_embedding(text)
    return jsonify({"embedding": embedding})

@app.route("/reconstruct_text", methods=["POST"])
def reconstruct_text_route():
    #print("RQEUEST", request.data)
    data = request.json
    #print("RECONSTRUCTR REQUEST JSON", data)
    if "embedding" not in data:
        return jsonify({"error": "Missing 'embedding' in request."}), 400

    embedding = data["embedding"]
    randomness = data['randomness'] if 'randomness' in data else 0.0
    if not isinstance(embedding, list) or not all(isinstance(i, (float, int)) for i in embedding):
        return jsonify({"error": "'embedding' must be a list of numbers."}), 400

    text = reconstruct_text(embedding, randomness)
    return jsonify({"text": text})


# TODO probably evaluate/ that probably calls gemini to see if it passes or fails 



if __name__ == "__main__":
    app.run(debug=False, port=7625, host='0.0.0.0')