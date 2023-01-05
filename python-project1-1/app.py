import ssl
import json
from flask import Flask, request, jsonify
from kafka import KafkaProducer


app = Flask(__name__)

def create_kafka_connection():
  ssl_context = ssl.create_default_context(
    cafile="snakeoil-ca-1.crt",
  )
  producer = KafkaProducer(security_protocol="SASL_SSL",\
          sasl_mechanism="SCRAM-SHA-256",\
          sasl_plain_username="kafkaclient",\
          sasl_plain_password="password",\
          ssl_context=ssl_context, \
          bootstrap_servers=["kafka-broker-1:19094","kafka-broker-2:29094","kafka-broker-3:39094"],\
          ssl_check_hostname=False,
          value_serializer=lambda v: json.dumps(v).encode('utf-8'))
  return producer

@app.route('/set_quote', methods=["POST"])
def set_quote():
  input_json = request.get_json(force=True)
  quote = {'name':input_json['name'],
          'quote':input_json['quote']}
  send_message_to_kafka(quote)
  return 'we got your quote thanks'

def send_message_to_kafka(message):
  producer.send("quotes", json.dumps(message))

producer = create_kafka_connection()
