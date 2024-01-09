from flask import Flask, request, jsonify
from roboflow import Roboflow
from const import API_KEY

app = Flask(__name__)
rf = Roboflow(api_key=API_KEY)
project = rf.workspace().project("nutritrack")
model = project.version(2).model

@app.route("/", methods=["POST"])
def foodDetectionAPI():
  # Get the image from the request
  image_url = request.json.get("image_url")

  # Make sure an image URL is provided
  if not image_url:
      return {"error": "Image URL is required"}, 400
 
  # infer on an image hosted elsewhere
  prediction = model.predict(image_url, hosted=True, confidence=40, overlap=30).json()
  
  result = []
  if len(prediction["predictions"]) != 0:
    for pred in prediction["predictions"]:
      if result.__contains__(pred["class"]) == False:
        result.append(pred["class"])
  
  resultString = ""
  if len(result) != 0:
    for index, r in enumerate(result):
      resultString += r + ("," if index != len(result) - 1 else "")
  print(resultString)
  return resultString

if __name__ == "__main__":
    app.run()