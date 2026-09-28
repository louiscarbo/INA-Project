import time
import paho.mqtt.client as mqtt

# BROKER = "mqtt.negraszus.eu"
# PORT = 80
# # PORT = 9001
# BROKER = "localhost"
BROKER = "test.mosquitto.org"
PORT = 1883

TEMP_TOPIC = "upvina/humtemp/status/temperature"
HUM_TOPIC = "upvina/humtemp/status/humidity"
BOT_TOPIC = "upvina/humtemp/bot/status"

USERNAME = ""
PASSWORD = ""

# USERNAME = "bot"
# PASSWORD = "bot"
# PASSWORD = "pSRq9tHGYh86m5HqxZA2"


def on_connect(client, userdata, flags, rc, properties=None):
    print("Connected to MQTT broker")
    client.subscribe(TEMP_TOPIC)
    # client.subscribe(HUM_TOPIC)


def on_message(client, userdata, msg):
    print(f"Received: {msg.topic} -> {msg.payload.decode()}")


# client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
client = mqtt.Client(
    mqtt.CallbackAPIVersion.VERSION2,
    # transport="websockets"
)

client.on_connect = on_connect
client.on_message = on_message

# Set MQTT username and password
client.username_pw_set(USERNAME, PASSWORD)

# Connect to broker
client.connect(BROKER, PORT, 60)

# Start receiving messages in the background
client.loop_start()

# Give the connection a moment to establish
time.sleep(1)

# Send a message
message = "Hello from Python!"
client.publish(BOT_TOPIC, message)
print(f"Sent: {message}")

# Keep the program alive so it can receive messages
try:
    while True:
        time.sleep(1)
        # client.publish(BOT_TOPIC, message + " " + str(time.time()))
except KeyboardInterrupt:
    print("Stopping...")

client.loop_stop()
client.disconnect()
