from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    image_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Don_state_technical_university.JPG/1920px-Don_state_technical_university.JPG"
    return f"""
    <html>
        <body>
            <h1>Testing of Flask Python App</h1>
            <img src="{image_url}" alt="Don State Technical University" width="500">
        </body>
    </html>
    """

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(debug=True, host='0.0.0.0', port=port)
