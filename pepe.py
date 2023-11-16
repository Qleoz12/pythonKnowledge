from transformers import T5ForConditionalGeneration, T5Tokenizer
import uvicorn
from fastapi import FastAPI

# Cargar el modelo pre-entrenado y el tokenizador
tokenizer = T5Tokenizer.from_pretrained('t5-11b')
model = T5ForConditionalGeneration.from_pretrained('t5-11b')

# Crear la aplicación FastAPI
app = FastAPI()


# Definir la ruta de la API para generar preguntas
@app.post("/generate_question")
async def generate_question():
    # Codificar el texto de entrada utilizando el tokenizador
    text="El 20 de julio es una fecha importante en la historia de Colombia"
    input_ids = tokenizer.encode(text,max_length=512, return_tensors='pt',truncation=True)

    # Generar la pregunta utilizando el modelo T5
    output = model.generate(input_ids,max_length=64)
    question = tokenizer.decode(output[0], skip_special_tokens=True)

    # Devolver la pregunta generada como respuesta a la solicitud
    return {"question": question}


# Ejecutar la aplicación
if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)
