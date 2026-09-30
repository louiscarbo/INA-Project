import bott
from telegram import *
from mqtt import *
import time
from paho.mqtt.client import MQTTMessage
import json

lastKnownTemp = None
lastKnownHum = None
lastUpdate = None

alarmTemp = {}
alarmEnabled = {}

def tempUpdate(temp):
    global lastKnownTemp
    lastKnownTemp = temp
    lastUpdate = time.time()

def humUpdate(hum):
    global lastKnownHum
    lastKnownHum = hum
    lastUpdate = time.time()

def checkalarm():
    if alarmEnabled and alarmTemp is not None and lastKnownTemp is not None:
        for chat_id, enabled in alarmEnabled.items():
            if enabled and chat_id in alarmTemp:
                if lastKnownTemp >= alarmTemp[chat_id]:
                    print(f"ALARM! Temperature {lastKnownTemp} °C exceeds threshold of {alarmTemp[chat_id]} °C for chat {chat_id}")
                    # client.publish(BOT_TOPIC, f"ALARM! Temperature {lastKnownTemp} °C exceeds threshold of {alarmTemp[chat_id]} °C", retain=True)
                    bott.sendMsg(chat_id=chat_id, text=f"ALARM! Temperature {lastKnownTemp} °C exceeds threshold of {alarmTemp[chat_id]} °C")
                    alarmEnabled[chat_id] = False  # Disable the alarm after triggering


def on_message(client, userdata, msg: MQTTMessage):
    payload = json.loads(msg.payload.decode("utf-8"))
    print(f"Received: {msg.topic} -> {payload}")
    if msg.topic == TEMP_TOPIC:
        tempUpdate(float(payload["tC"]))
    elif msg.topic == HUM_TOPIC:
        humUpdate(float(payload["rh"]))
    else:
        print(f"Unknown topic: {msg.topic}")
    checkalarm()

def main():
    start_mqtt(on_message)

    handler = [("get_temp", get_temp),
                ("get_hum", get_hum),
                ("get", get),
                ("set_alarm", set_alarm),
                ("get_alarm", get_alarm),
                ("enable_alarm", enable_alarm),
                ("disable_alarm", disable_alarm),
                ("status", status)]
    bott.main(handler)

    try:
        while True:
            time.sleep(1)
            # client.publish(BOT_TOPIC, message + " " + str(time.time()))
    except KeyboardInterrupt:
        print("Interrupted by user")
    finally: 
        print("Stopping...")
        shutdown_mqtt()

def queryTemp():
    return lastKnownTemp

def queryHum():
    return lastKnownHum

async def get_temp(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        str(queryTemp()) + " °C"
    )
async def get_hum(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        str(queryHum()) + " %"
    )
async def get(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        str(queryTemp()) + " °C, " + str(queryHum()) + " %"
    )
async def set_alarm(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if not context.args or len(context.args) != 1:
        await update.message.reply_text(
            "Usage: /set_alarm <temperature>\nExample: /set_alarm 30.5"
        )
        return

    try:
        temp = float(context.args[0])
    except ValueError:
        await update.message.reply_text(
            "Invalid temperature value. Please provide a valid number."
        )
        return

    global alarmTemp
    alarmTemp[update.effective_chat.id] = temp
    await update.message.set_reaction(#thumbsup
        reaction=[ReactionTypeEmoji(emoji="👍")]
    )

async def get_alarm(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if alarmTemp.get(update.effective_chat.id) is not None:
        await update.message.reply_text(
            "Alarm temperature: " + str(alarmTemp[update.effective_chat.id]) + " °C\n" +
            "Alarm enabled: " + str(alarmEnabled.get(update.effective_chat.id, False))
        )
    else:
        await update.message.reply_text(
            "Alarm temperature is not set."
        )
    
async def enable_alarm(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if alarmTemp[update.effective_chat.id] is None:
        await update.message.reply_text(
            "Alarm temperature is not set. Please set it first using /set_alarm."
        )
        return
    global alarmEnabled
    alarmEnabled[update.effective_chat.id] = True
    await update.message.set_reaction(
        reaction=[ReactionTypeEmoji(emoji="👍")]
    )

async def disable_alarm(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if alarmTemp[update.effective_chat.id] is None:
            await update.message.reply_text(
                "Alarm temperature is not set. No action taken."
            )
            return
    global alarmEnabled
    alarmEnabled[update.effective_chat.id] = False
    await update.message.set_reaction(
        reaction=[ReactionTypeEmoji(emoji="👍")]
    )

async def status(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "Last known temperature: " + str(queryTemp()) + " °C\n" +
        "Last known humidity: " + str(queryHum()) + " %\n" +
        "Alarm temperature: " + str(alarmTemp.get(update.effective_chat.id, "Not set")) + " °C\n" +
        "Alarm enabled: " + str(alarmEnabled.get(update.effective_chat.id, False)) + "\n" +
        "Last update: " + str(lastUpdate) + "\n"
    )


if __name__ == "__main__":
    main()
