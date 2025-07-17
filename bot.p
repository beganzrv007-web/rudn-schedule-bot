from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Updater, CommandHandler, CallbackContext, CallbackQueryHandler
from fpdf import FPDF
import os

def create_schedule_pdf():
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", "B", 14)
    pdf.cell(0, 10, "Распорядок дня первокурсника-медика РУДН", ln=True, align="C")
    pdf.set_font("Arial", "B", 12)
    pdf.cell(0, 10, "🕰️ Будни (Понедельник–Суббота)", ln=True)
    pdf.set_font("Arial", "", 11)
    weekday = """04:00 – 04:15 — Фаджр-намаз (МСК)
04:15 – 05:00 — Зикр / размышления
05:00 – 06:30 — Сон (дозарядка)
06:30 – 07:00 — Умывание
07:00 – 07:30 — Завтрак
07:30 – 08:00 — Дорога + дуа
08:30 – 13:40 — Учеба
13:40 – 14:30 — Обед
14:30 – 15:30 — Самоподготовка
15:30 – 16:30 — Отдых + дневной намаз
16:30 – 18:00 — Саморазвитие
18:00 – 18:20 — Магриб-намаз
18:20 – 19:00 — Ужин
19:00 – 20:30 — Отдых
20:30 – 21:00 — Уход + Иша-намаз
21:00 – 21:30 — Завершение дня
21:30 – 04:00 — Сон"""
    pdf.multi_cell(0, 10, weekday)
    pdf.set_font("Arial", "B", 12)
    pdf.cell(0, 10, "🕊️ Воскресенье — Восстановление", ln=True)
    pdf.set_font("Arial", "", 11)
    sunday = """04:00 – 04:15 — Фаджр-намаз
04:15 – 08:00 — Сон
08:00 – 09:00 — Завтрак
09:00 – 10:00 — Прогулка / спорт
10:00 – 12:00 — Учеба
12:00 – 13:00 — Намаз + обед
13:00 – 15:00 — Саморазвитие
15:00 – 17:00 — Отдых с семьёй
17:00 – 18:00 — Ужин + Магриб
18:00 – 21:00 — Планирование
21:00 – 21:30 — Уход + Иша
21:30 – 04:00 — Сон"""
    pdf.multi_cell(0, 10, sunday)
    filename = "schedule.pdf"
    pdf.output(filename)
    return filename

def start(update: Update, ctx: CallbackContext):
    kb = InlineKeyboardMarkup([[InlineKeyboardButton("📄 Скачать распорядок", callback_data="get_pdf")]])
    update.message.reply_text("Ассаляму алейкум, брат! Вот твой распорядок:", reply_markup=kb)

def button(update: Update, ctx: CallbackContext):
    query = update.callback_query
    if query.data == "get_pdf":
        pdf = create_schedule_pdf()
        query.message.reply_document(open(pdf, "rb"))

def main():
    token = os.getenv("BOT_TOKEN")
    updater = Updater(token, use_context=True)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(CallbackQueryHandler(button))
    updater.start_polling()
    updater.idle()

if __name__ == "__main__":
    main()
