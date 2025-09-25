# Proton Pass — Windows Portable Console Toolkit (v1.9.3)

[![GitHub release](https://img.shields.io/github/v/release/0scorp919/proton-pass-windows-portable?label=Release)](https://github.com/0scorp919/proton-pass-windows-portable/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Downloads](https://img.shields.io/github/downloads/0scorp919/proton-pass-windows-portable/total?label=Downloads)](https://github.com/0scorp919/proton-pass-windows-portable/releases)

UA: Портативний офлайн-інструмент для розшифрування експорту Proton Pass (PGP) на Windows  
EN: Portable offline toolkit for decrypting Proton Pass PGP exports on Windows

## UA • Ключова ідея

### Для кого цей інструмент
Цей проєкт для користувачів Proton Pass, які роблять локальні резервні копії на випадок аварії. Коли у форс-мажорі треба терміново відновити доступ із зашифрованого експорту, інструмент автоматизує розшифрування, парсинг і експорт мінімальною кількістю кроків.
Портативний офлайн‑інструмент для розшифрування PGP‑експорту Proton Pass на Windows 10/11 **без інсталяції**.
Після успіху каталог **самоочищається**: типово лишаються тільки `data.txt` і цей `ZIP архів`.
Додайте `-KeepDocs`, щоб також зберегти `README.md` та `CHANGELOG.md`.

### Технології
- **PowerShell** — керування процесом, логування UA/EN, StrictMode, UTF‑8.
- **GnuPG** (`gpg.exe`) — розшифрування `data.pgp`; шукаємо в PATH, `Program Files\GnuPG\bin`, `bin\gnupg`.
- **JSON** — `ConvertFrom-Json` із підтримкою `vaults` як масиву або мапи.
- **Вивід** — `TSV` для таблиць, повний `data_passwords.txt` і короткий `data.txt` для швидкого перегляду.
- **Очищення** — тимчасовий `cleanup_*.cmd` із ланцюжком `IF NOT`, що видаляє все, крім дозволених імен.

### Pipeline (UA)
1. **Пошук GPG** → 2. **Прихований ввід парольної фрази** → 3. **`gpg --decrypt`** → 4. **Парсинг JSON**  
→ 5. **Експорт TSV/TXT + `data.txt`** → 6. **Очищення**.

### Поля, що витягуються
- `Name` ← `data.metadata.name`
- `Username/Email` ← `data.content.itemUsername` → fallback → `itemEmail`
- `Password` ← `data.content.password`
- `URL(s)` ← список з `data.content.urls` (рядки та/або об’єкти `url|href|value`), `'; '`‑з’єднання
- `TOTP` ← `data.content.totpUri` (якщо є)
- `Note/Description` ← `data.metadata.note`
- `Passkeys` ← `count(data.content.passkeys)`

### Threat Model (UA)
- **Активи:** парольна фраза; `data_decrypted.json`; `data.txt`/TSV; логи.
- **Ризики:** локальний зловмисник, незашифровані бекапи, редактори з автозбереженням у публічні папки.
- **Захист/контрзаходи:** прихований ввід; відсутність секретів у логах; суворе прибирання; UTF‑8 у виводі.
- **Рекомендації:**
  - Працюйте у тимчасовій локальній папці (без хмарної синхронізації).
  - `data.txt` — зберігайте недовго або **зашифруйте** (7‑Zip AES‑256 / `gpg -c`).
  - Якщо транскрипт не потрібен — `-NoTranscript`.
  - Використовуйте редактори без автокопій у «Документах/AutoRecover».

### Backup & Recovery (UA)
- **Бекап:** зашифрований архів, що містить **лише** `data.txt`. JSON не зберігати.
- **Відновлення:** розшифрувати архів → відкрити `data.txt` (UTF‑8). Для аналізу — імпортувати `TSV` у таблиці.
- **Життєвий цикл:** перенести секрети у менеджер паролів → видалити проміжні файли → залишити тільки зашифрований бекап.

### Структура Proton Pass JSON (UA)
- Корінь має `vaults` — **масив** або **мапа**:
```json
{
  "vaults": [
    {
      "name": "Default",
      "items": [
        {
          "type": "login",
          "data": {
            "metadata": { "name": "GitHub", "note": "recovery codes inside" },
            "content": {
              "itemUsername": "user@example.com",
              "itemEmail": "user@example.com",
              "password": "********",
              "urls": [
                {"url": "https://github.com"},
                "https://status.github.com"
              ],
              "totpUri": "otpauth://totp/...",
              "passkeys": [{"rpId":"github.com","credId":"..."}]
            }
          }
        }
      ]
    }
  ]
}
```

### Параметри / Використання (UA)
```bat
decrypt_and_extract.bat                :: строгий режим (залишає лише ZIP + data.txt)
decrypt_and_extract.bat -KeepDocs      :: залишити README/CHANGELOG
decrypt_and_extract.bat -NoTranscript  :: не писати транскрипт консолі
```
> Вхідний файл — `data.pgp` поруч із .bat/.ps1.

### Сумісність і кодування (UA)
- Windows 10/11, PowerShell 5+.
- Тексти — UTF‑8; `.bat` — ASCII для CMD.
- GnuPG — системний або локальний портативний.

---

## EN • Key idea

### Who this tool is for
This tool is for Proton Pass users who keep local backups for emergencies. When you must quickly recover access from an encrypted export under pressure, it automates decryption, parsing, and export with minimal steps.
Portable offline decryptor for Proton Pass PGP export on Windows 10/11 **with no installation**.
After success the folder **self‑cleans**: by default only `data.txt` and your `ваш ZIP архів` remain.
Use `-KeepDocs` to keep `README.md` and `CHANGELOG.md` as well.

### Technologies
- **PowerShell** for orchestration, UA/EN logging, StrictMode, UTF‑8.
- **GnuPG** (`gpg.exe`) for decrypting `data.pgp`; looked up in PATH, `Program Files\GnuPG\bin`, or local `bin\gnupg`.
- **JSON** via `ConvertFrom-Json` supporting `vaults` as array or property map.
- **Outputs**: spreadsheet‑friendly TSV, verbose `data_passwords.txt`, and short `data.txt`.
- **Cleanup**: temporary `cleanup_*.cmd` with an IF‑NOT chain removing everything except allowed names.

### Pipeline (EN)
1. Locate GPG → 2. Hidden passphrase → 3. `gpg --decrypt` → 4. Parse JSON → 5. Export TSV/TXT + `data.txt` → 6. Cleanup.

### Field mapping
- `Name` ← `data.metadata.name`
- `Username/Email` ← `data.content.itemUsername` (fallback to `itemEmail`)
- `Password` ← `data.content.password`
- `URL(s)` ← normalized `data.content.urls` (strings/objects `url|href|value`) joined by `; `
- `TOTP` ← `data.content.totpUri`
- `Note/Description` ← `data.metadata.note`
- `Passkeys` ← `len(data.content.passkeys)`

### Threat Model (EN)
- **Assets:** passphrase; `data_decrypted.json`; `data.txt`/TSV; logs.
- **Risks:** local attacker, unencrypted backups, editors writing autosave copies.
- **Controls:** hidden input; no secrets in logs; strict cleanup; UTF‑8 outputs.
- **Recommendations:** run in a temp folder; encrypt `data.txt` if kept longer; avoid auto‑sync; consider `-NoTranscript`.

### Backup & Recovery (EN)
- **Backup:** encrypted archive containing **only** `data.txt`. Do not keep the JSON.
- **Restore:** decrypt → open `data.txt` (UTF‑8); optionally import TSV into a spreadsheet.
- **Lifecycle:** migrate to a password manager → delete intermediates → keep only the encrypted backup.

### Proton Pass JSON structure (EN)
Same as UA section (array/map). Example mirrors the sample above.

### CLI / Usage (EN)
```bat
decrypt_and_extract.bat                :: strict cleanup (ZIP + data.txt only)
decrypt_and_extract.bat -KeepDocs      :: keep README/CHANGELOG as well
decrypt_and_extract.bat -NoTranscript  :: no console transcript
```

### Compatibility & encoding (EN)
Windows 10/11; PowerShell 5+; text UTF‑8; batch ASCII; GnuPG either system or local portable.
