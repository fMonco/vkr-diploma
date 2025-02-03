from flask import Flask, render_template, request

app = Flask(__name__)

# Главная страница с формой для калькулятора
@app.route("/", methods=["GET", "POST"])
def calculator():
    result = ""
    if request.method == "POST":
        try:
            # Получаем значение из формы и вычисляем результат
            expression = request.form["expression"]
            result = eval(expression)
        except Exception as e:
            result = f"Error: {str(e)}"
    
    return render_template("index.html", result=result)

if __name__ == "__main__":
    app.run(debug=True)
