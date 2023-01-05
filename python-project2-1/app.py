import ssl
import json
import pymongo
import ast
from threading import Thread
from flask import Flask, request, jsonify
from kafka import KafkaConsumer


app = Flask(__name__)

def create_kafka_connection():
  ssl_context = ssl.create_default_context(
    cafile="snakeoil-ca-1.crt",
  )
  consumer = KafkaConsumer("quotes", \
          security_protocol="SASL_SSL",\
          sasl_mechanism="SCRAM-SHA-256",\
          sasl_plain_username="kafkaclient",\
          sasl_plain_password="password",\
          ssl_context=ssl_context, \
          bootstrap_servers=["kafka-broker-1:19094","kafka-broker-2:29094","kafka-broker-3:39094"],\
          ssl_check_hostname=False, \
          group_id="quotes"
          )
  return consumer

def create_mongo_connection():
  mongo_client = pymongo.MongoClient(host=["mongo1:27017", "mongo2:27018", "mongo3:27019"], \
                                     tls=True, \
                                     tlsAllowInvalidCertificates=True, \
                                     tlsCAFile='rootCA.pem', \
                                     tlsCertificateKeyFile='mongodb.pem', \
                                     username="root", \
                                     password="pass", \
                                     authSource="admin", \
                                     authMechanism="SCRAM-SHA-256")
  return mongo_client

def persist_message(message):
  message = json.loads(message)
  message = json.loads(message)
  mongo_column.insert_one(message)

@app.route('/get_quote')
def get_quote():
  quote = mongo_column.aggregate([{ "$sample": { "size": 1 } }])
  for x in quote:
    del x["_id"]
    return jsonify(x)
  

def get_message_from_kafka():
  for message in consumer:
    persist_message(message.value)

consumer = create_kafka_connection()
mongo_client = create_mongo_connection()
mongo_database = mongo_client["quoteDB"]
mongo_column = mongo_database["quotes"]
p = Thread(target=get_message_from_kafka)
p.start()
