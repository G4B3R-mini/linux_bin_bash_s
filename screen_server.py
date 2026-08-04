from flask import Flask, Response, request
import mss
import cv2
import numpy as np
import time

app = Flask(__name__)

sct = mss.mss()

# Monitor principal
monitor = sct.monitors[1]

def gerar_video(qualidade=70, fps=5):
    # Calcula o tempo de espera entre os quadros baseado no FPS desejado
    tempo_espera = 1.0 / fps if fps > 0 else 0
    
    while True:
        inicio_processamento = time.time()
        
        img = np.array(sct.grab(monitor))
        img = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)

        # Aplica a qualidade selecionada
        _, jpeg = cv2.imencode(
            ".jpg",
            img,
            [int(cv2.IMWRITE_JPEG_QUALITY), qualidade]
        )

        frame = jpeg.tobytes()

        yield (
            b'--frame\r\n'
            b'Content-Type: image/jpeg\r\n\r\n' +
            frame +
            b'\r\n'
        )
        
        # Calcula quanto tempo o processamento levou e dorme o restante necessário
        tempo_processamento = time.time() - inicio_processamento
        tempo_restante = tempo_espera - tempo_processamento
        if tempo_restante > 0:
            time.sleep(tempo_restante)

@app.route("/video")
def video():
    # Pega os valores da URL (ex: /video?qualidade=30&fps=2)
    # Se não forem passados, usa os valores padrão: qualidade=70, fps=5
    qualidade = request.args.get('qualidade', default=70, type=int)
    fps = request.args.get('fps', default=5, type=int)
    
    return Response(
        gerar_video(qualidade, fps),
        mimetype="multipart/x-mixed-replace; boundary=frame"
    )

@app.route("/")
def index():
    return """<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Transmissão de Tela</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        #video-stream {
            width: 100%;
            max-width: 1280px; /* Limita o tamanho máximo para não ficar gigante em monitores grandes */
            border: 2px solid #333;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h2>Transmissão de Tela</h2>
    
    <button onclick="abrirTelaCheia()">Entrar em Tela Cheia</button>
    
    <br>
    
    <img id="video-stream" src="./video?qualidade=50&fps=5">

    <script>
        // Pega o elemento da imagem
        var videoElem = document.getElementById("video-stream");

        // Função para ativar a tela cheia
        function abrirTelaCheia() {
            if (videoElem.requestFullscreen) {
                videoElem.requestFullscreen();
            } else if (videoElem.mozRequestFullScreen) { /* Firefox */
                videoElem.mozRequestFullScreen();
            } else if (videoElem.webkitRequestFullscreen) { /* Chrome, Safari & Opera */
                videoElem.webkitRequestFullscreen();
            } else if (videoElem.msRequestFullscreen) { /* IE/Edge */
                videoElem.msRequestFullscreen();
            }
        }
    </script>
</body>
</html>"""

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050, threaded=True)