# Release notes — v1.9.3

## UA
**Proton Pass — Windows Portable Console Toolkit** для швидкого офлайн‑розшифрування експорту Proton Pass (PGP)
та автоматичного експорту важливих даних (TSV/TXT). Створено для користувачів, що роблять резервні копії
і у форс‑мажорі мають швидко відновити доступ без ручної рутини у стресі.

### Нове/важливе
- Двомовний **README** (UA/EN): *Швидкий старт*, **таблиця параметрів**, **приклади**, **FAQ**, **ліцензія**.
- **CHANGELOG** з історією 1.6.x → v1.9.3.
- **BAT**-лаунчер: виправлені коментарі, додано EN-примітки, усі рядки коректно коментовані `rem`.
- Типове **self‑cleanup**: лишається тільки `data.txt` + ZIP. Ключ `-KeepDocs` зберігає документацію.
- Опція `-OfflineOnly` блокує будь-які мережеві звернення.
- Ліцензія **MIT**.

### Параметри (нагадування)
`-InputFile`, `-OutputPrefix`, `-LogFile`, `-OfflineOnly`, `-NoTranscript`, `-KeepDocs`.

---

## EN
**Proton Pass — Windows Portable Console Toolkit** for fast offline decryption of Proton Pass (PGP) exports
and automated export of critical data (TSV/TXT). Designed for users who keep backups and need to recover
access under pressure without manual, error‑prone steps.

### Highlights
- Bilingual **README** (UA/EN): *Quick start*, **parameter table**, **examples**, **FAQ**, **license**.
- **CHANGELOG** capturing 1.6.x → v1.9.3.
- **BAT** launcher: comment fixes, EN notes added; all non‑commands properly `rem`‑commented.
- Default **self‑cleanup** leaves only `data.txt` + ZIP. Use `-KeepDocs` to retain docs.
- `-OfflineOnly` switch forbids any network activity.
- **MIT** license.

### Parameters (recap)
`-InputFile`, `-OutputPrefix`, `-LogFile`, `-OfflineOnly`, `-NoTranscript`, `-KeepDocs`.
