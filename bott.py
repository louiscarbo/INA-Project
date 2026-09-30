import asyncio

from telegram import Update
from telegram.ext import Application, CommandHandler, ContextTypes, MessageHandler, filters

BOT_TOKEN = "8607131324:AAEMcUfPyZIeVXYh6dB-17R6TlsBab_8ync"

async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        f"Echo: {update.message.text}"
    )

app = None

def main(handler=None):
    global app
    app = Application.builder().token(BOT_TOKEN).build()

    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, echo))
    for h in handler:
        app.add_handler(CommandHandler(h[0], h[1]))

    print("Bot is running...")
    app.run_polling()

def sendMsg(chat_id, text):
    global app
    if app is not None:
        asyncio.run(app.bot.send_message(chat_id=chat_id, text=text))

if __name__ == "__main__":
    main([])
