from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from imapclient import IMAPClient
import pyzmail
import time
import re
import os
from datetime import datetime, timezone
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import threading

LOGIN_URL = "http://localhost:3000"
CODE_WAIT_TIMEOUT = 180  # 3 минуты
FUTURE_ALLOWANCE_SECONDS = 14400  # 4 часа

# ---------------- EMAIL ----------------
def load_email_env():
    env_path = '.env.email'
    config = {}
    if os.path.exists(env_path):
        with open(env_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#') or '=' not in line:
                    continue
                k, v = line.split('=', 1)
                config[k.strip()] = v.strip()
        print(f"[INFO] Завантажено налаштування з {env_path}")
    else:
        print(f"[INFO] Файл {env_path} не знайдено. Введіть дані вручну (Enter — стандартне для Gmail):")
        config['EMAIL'] = input('Email: ').strip()
        config['EMAIL_PASSWORD'] = input('Пароль від пошти (App Password для Gmail): ').strip()
        config['IMAP_SERVER'] = input('IMAP сервер [imap.gmail.com]: ').strip() or 'imap.gmail.com'
        port = input('IMAP порт [993]: ').strip()
        config['IMAP_PORT'] = int(port) if port else 993
        config['IMAP_FOLDER'] = input('IMAP папка [INBOX]: ').strip() or 'INBOX'
        # Зберігаємо у .env.email
        with open(env_path, 'w') as f:
            f.write(f"EMAIL={config['EMAIL']}\n")
            f.write(f"EMAIL_PASSWORD={config['EMAIL_PASSWORD']}\n")
            f.write(f"IMAP_SERVER={config['IMAP_SERVER']}\n")
            f.write(f"IMAP_PORT={config['IMAP_PORT']}\n")
            f.write(f"IMAP_FOLDER={config['IMAP_FOLDER']}\n")
        print(f"[INFO] Дані збережено у {env_path}")
    return config

def get_latest_code_from_subject():
    with IMAPClient(IMAP_SERVER, port=IMAP_PORT, ssl=True) as client:
        client.login(EMAIL, EMAIL_PASSWORD)
        client.select_folder(IMAP_FOLDER)
        messages = client.search(['ALL'])
        if not messages:
            print("[WARN] INBOX пуст!")
            return None
        latest_uid = messages[-1]
        envelope = client.fetch([latest_uid], ['ENVELOPE'])[latest_uid][b'ENVELOPE']
        subject = envelope.subject.decode() if envelope.subject else ''
        m = re.match(r'^(\d{6})', subject.strip())
        if m:
            return m.group(1)
        else:
            print(f"[WARN] Код в теме письма не найден: {subject}")
            return None

# ---------------- SELENIUM ----------------
config = load_email_env()
EMAIL = config.get('EMAIL')
EMAIL_PASSWORD = config.get('EMAIL_PASSWORD')
IMAP_SERVER = config.get('IMAP_SERVER', 'imap.gmail.com')
IMAP_PORT = int(config.get('IMAP_PORT', 993))
IMAP_FOLDER = config.get('IMAP_FOLDER', 'INBOX')

options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)
wait = WebDriverWait(driver, 30)

print("Открываем страницу...")
driver.get(LOGIN_URL)

# --- Шаг 1: кнопка Sign in ---
login_button = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//button[contains(text(),'Sign in')]"))
)
print("Кнопка Sign in найдена!")
login_button.click()

# --- Шаг 2: поле email ---
email_input = wait.until(
    EC.visibility_of_element_located((By.CSS_SELECTOR, "input[type='email'][placeholder='EMAIL@EXAMPLE.COM']"))
)
print("Поле для email найдено!")
email_input.clear()
email_input.send_keys(EMAIL)

# --- Шаг 3: кнопка Continue ---
continue_button = wait.until(
    EC.element_to_be_clickable((By.XPATH, "//button[contains(text(),'CONTINUE WITH EMAIL')]"))
)
print("Кнопка CONTINUE WITH EMAIL найдена!")
continue_button.click()

print("Ждем 30 секунд, пока придет письмо...")
time.sleep(30)

# --- Шаг 4: достаем код из почты ---
code = get_latest_code_from_subject()
if code:
    print(f"Код из письма: {code}")

    otp_input = wait.until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, "input[placeholder='••••••'][maxlength='6']"))
    )
    otp_input.clear()
    otp_input.send_keys(code)
    print("Код введен!")

    # --- Шаг 5: кнопка Verify ---
    verify_button = wait.until(
        EC.element_to_be_clickable((By.XPATH, "//button[contains(text(),'VERIFY CODE')]"))
    )
    print("Кнопка VERIFY CODE найдена!")
    verify_button.click()
    print("Код подтвержден!")
else:
    print("Не удалось достать код из письма!")

# --- Выход через 1 минуту ---
def delayed_quit(driver, delay=60):
    time.sleep(delay)
    driver.quit()

threading.Thread(target=delayed_quit, args=(driver, 60), daemon=True).start()
