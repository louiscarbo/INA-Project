import time
import paho.mqtt.client as mqtt

# BROKER = "mqtt.negraszus.eu"
# PORT = 80
# # PORT = 9001
# BROKER = "localhost"
BROKER = "test.mosquitto.org"
PORT = 1883

TEMP_TOPIC = "upvina/humtemp/status/temperature:0"
HUM_TOPIC = "upvina/humtemp/status/humidity:0"
BOT_TOPIC = "upvina/humtemp/bot/status"

USERNAME = ""
PASSWORD = ""

# USERNAME = "bot"
# PASSWORD = "bot"
# PASSWORD = "pSRq9tHGYh86m5HqxZA2"

client = None

def on_connect(client, userdata, flags, rc, properties=None):
    print("Connected to MQTT broker")
    client.subscribe(TEMP_TOPIC)
    client.subscribe(HUM_TOPIC)

def start_mqtt(callback):
    global client
    client = mqtt.Client(
        mqtt.CallbackAPIVersion.VERSION2,
        # transport="websockets"
    )

    client.on_connect = on_connect
    client.on_message = callback

    # Set MQTT username and password
    client.username_pw_set(USERNAME, PASSWORD)

    # Connect to broker
    client.connect(BROKER, PORT, 60)

    # Start receiving messages in the background
    client.loop_start()

    msg = client.publish(BOT_TOPIC, "Bot is starting up...")
    msg.wait_for_publish(5)

def shutdown_mqtt():
    global client
    msg = client.publish(BOT_TOPIC, "Bot is shutting down...", retain=True)
    msg.wait_for_publish(5)

    client.loop_stop()
    client.disconnect()


def default_on_message(client, userdata, msg):
    payload = msg.payload.decode()
    print(f"Received: {msg.topic} -> {payload}")

if __name__ == "__main__":
    start_mqtt(default_on_message)
    try:
        while True:
            time.sleep(1)
            # client.publish(BOT_TOPIC, message + " " + str(time.time()))
    except KeyboardInterrupt:
        print("Interrupted by user")
    finally: 
        print("Stopping...")
        shutdown_mqtt()