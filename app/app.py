from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics
import psycopg2
import redis

# Configura a aplicação Flask
app = Flask(__name__)

# Configura o PrometheusMetrics para expor métricas na rota /metrics
metrics = PrometheusMetrics(app, path='/metrics')

@app.route("/")
def hello_world():
    return "App is running!"

@app.route('/redis')
def get_status_redis():
    try:
        r = redis.Redis(host='redis', port=6379, db=0, decode_responses=True)
        r.ping()
        return "Conexão com o Redis estabelecida com sucesso!"
    except Exception as e:
        return f"Erro ao conectar com o Redis: {e}"

@app.route('/postgres')
def get_status_postgres():
    try:
        conn = psycopg2.connect(
            host="postgres",
            database="postgres",
            user="user",
            password="senhafacil",
            port=5432
        )
        conn.close()
        return "Conexão com o PostgreSQL estabelecida com sucesso!"
    except Exception as e:
        return f"Erro ao conectar com o PostgreSQL: {e}"
    
@app.route('/error')
def get_error():
    # simule um erro 500
    error_message = "Ocorreu um erro interno no servidor."
    return jsonify({'error': error_message}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug = True)


