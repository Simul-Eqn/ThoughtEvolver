from flask import Flask, request, jsonify
import numpy as np

from sonar_handler import generate_embedding, reconstruct_text

# call gemini to evaluate 
from google import genai
from google.genai import types

with open("apikey.txt", 'r') as f: 
    apikey = f.readline().strip()
client = genai.Client(api_key=apikey)

def evaluate_response(question, response): 
    prompt = (
            "Fail is socially awkward, pass is ok. Conversation:"
            f"\"{question}\"\n"
            f"\"{response}\"\n"
            "Reply with either \"pass\" or \"fail\"."
        )
    
    response = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=prompt,
        #config=types.GenerateContentConfig(stopSequences=['pass', 'fail'])
    )


    res = response.text.lower() 

    #print("TEXT", res)

    if ('pass' in res): 
        return "pass" 
    elif ('fail' in res):
        return "fail"

    return "ERROR evaluating response"



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


@app.route('/evaluate', methods=['POST'])
def evaluate():
    """
    API endpoint to evaluate the player's response.
    Input: JSON object with 'question' and 'response'.
    Output: JSON object with 'result' indicating 'pass' or 'fail'.
    """
    data = request.get_json()

    if not data or 'question' not in data or 'response' not in data:
        return jsonify({"result": "ERROR: Invalid input. Must include 'question' and 'response'."}), 400

    question = data['question']
    response = data['response']

    result = evaluate_response(question, response)
    return jsonify({"result": result})



if __name__ == "__main__":
    app.run(debug=False, port=7625, host='0.0.0.0')