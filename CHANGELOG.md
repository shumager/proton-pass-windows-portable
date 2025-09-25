# CHANGELOG (UA/EN)

## v1.9.3 — Full docs (UA/EN), complete changelog
- **UA:** Розширено README (Threat Model, Backup/Recovery, JSON, мапінг, приклади), доповнено повний CHANGELOG.
- **EN:** README expanded (Threat Model, Backup/Recovery, JSON, mapping, examples); complete CHANGELOG added.
- **Engine:** без змін відносно v1.9.1/1.9.2 (той самий пайплайн і очищення).

## v1.9.2 — Docs++ (Threat Model, Backup/Recovery, JSON Structure)
- **UA:** Додано Threat Model, Backup & Recovery, приклад структури JSON Proton Pass та мапінг полів.
- **EN:** Added Threat Model, Backup & Recovery, Proton Pass JSON structure and field mapping.
- **Engine:** same as v1.9.1.

## v1.9.1 — Expanded docs (UA/EN), same engine as v1.9.0
- **UA:** Переписано README/CHANGELOG двома мовами; механіка без змін.
- **EN:** Reworked README/CHANGELOG in UA/EN; no engine changes.

## v1.9.0 — Stable cleanup & strict retention
- **UA:** Фікс лапок у генерації cleanup: here‑string з токеном `{COND}`; типово лишаємо ZIP + `data.txt`; додано `-KeepDocs`.
- **EN:** Fixed quoting in cleanup generation using a here‑string with `{COND}`; default keep ZIP + `data.txt`; added `-KeepDocs`.

## v1.8.9 — Packaging sanity
- **UA:** Гарантоване включення README/CHANGELOG у ZIP; спрощено пошук GPG; у деяких збірках — ризик помилки лапок.
- **EN:** Ensured README/CHANGELOG present; simplified GPG discovery; some builds had quoting edge‑cases.

## v1.8.8 — Keep docs by default
- **UA:** За замовчуванням лишали README/CHANGELOG; введено опцію вимикання; батник переведено в ASCII.
- **EN:** Kept docs by default; option to switch to strict mode; batch switched to ASCII.

## v1.8.7 — Reliable cleanup
- **UA:** Очищення без `goto`: один IF‑NOT ланцюг; пропуск `%~nx0`; самознищення скрипта‑очищувача.
- **EN:** Cleanup via a single IF‑NOT chain; skip `%~nx0`; self‑delete cleaner.

## v1.8.6 — Path & comments polish
- **UA:** Виправлення `.TrimEnd`/`rstrip` у батнику (блокування/шляхи); розширені двомовні коментарі; кращий лог.
- **EN:** Fixed `.TrimEnd`/`rstrip` path handling (locks/paths); more bilingual comments; improved logging.

## v1.8.5 — Minimal footprint
- **UA:** Після успіху — залишати тільки ZIP + `data.txt`.
- **EN:** After success — keep only ZIP + `data.txt`.

## v1.8.4 — More fields
- **UA:** Додано витяг Note/Description, TOTP; підрахунок Passkeys; зведений TXT; TSV‑експорт.
- **EN:** Added Note/Description, TOTP; passkeys count; human‑readable TXT; TSV export.

## v1.8.3 — JSON normalization improvements
- **UA:** Краще нормалізуємо `vaults` (масив/мапа); стабілізовано парсинг окремих елементів.
- **EN:** Better `vaults` normalization (array/map); stabilized item parsing.

## v1.8.2 — Logging & transcript
- **UA:** Стандартизовано формат рядків логів UA/EN; покращено транскрипт.
- **EN:** Standardized UA/EN log line format; improved transcript handling.

## v1.8.1 — Solid pipeline
- **UA:** Стабілізовано послідовність кроків: пошук GPG → decrypt → parse → export → cleanup.
- **EN:** Solidified the sequence: find GPG → decrypt → parse → export → cleanup.

## v1.6.3 — Network fallbacks hardened
- **UA:** Спроби IWR/certutil/curl для завантаження portable GnuPG; обхід 404, TLS, прав доступу (історично).
- **EN:** Attempts IWR/certutil/curl to fetch portable GnuPG; handled 404/TLS/permissions (historical).

## v1.6.2 — Bilingual logs introduced
- **UA:** Почали вести логи UA/EN; додали транскрипт консолі.
- **EN:** Introduced UA/EN logs; added console transcript.

## v1.6.1 — First prototype
- **UA:** Базове розшифрування з gpg; ранні заготовки cleanup; сирі коментарі.
- **EN:** Basic gpg decrypt; early cleanup stubs; rough comments.
