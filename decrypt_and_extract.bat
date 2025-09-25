@echo off
rem Proton Pass Portable Decryptor - launcher v1.9.3
rem Default keeps only ZIP + data.txt. Add -KeepDocs to preserve README/CHANGELOG.

rem ==================== Пояснення (UA) ====================
rem Цей BAT запускає PowerShell-скрипт decrypt_and_extract.ps1 із поточної папки.
rem Усі параметри, які ти додаєш після .bat, автоматично передаються у .ps1 (через %*).
rem Вимоги: Windows 10/11, PowerShell 5+, наявний gpg.exe (Gpg4win або локальний bin\gnupg\bin\gpg.exe).
rem Права адміністратора не потрібні; політика виконання тимчасово обминається ключем -ExecutionPolicy Bypass.

rem ==================== Notes (EN) ====================
rem This BAT launches the PowerShell script decrypt_and_extract.ps1 from the current folder.
rem Any parameters you pass after the .bat are forwarded to the .ps1 (via %*).
rem Requirements: Windows 10/11, PowerShell 5+, a gpg.exe available (Gpg4win or local bin\gnupg\bin\gpg.exe).
rem Admin rights are not required; execution policy is bypassed only for this run.
rem ==================== Корисні прапорці ====================
rem -KeepDocs      — після успіху залишити README.md і CHANGELOG.md
rem                  (без цього збережуться лише data.txt + ваш архів ZIP).
rem -NoTranscript  — не створювати файл транскрипту консолі (data_run_transcript.log).
rem -InputFile     — ім’я вхідного PGP-файла (типово: data.pgp).
rem -OutputPrefix  — префікс імен вихідних файлів (типово: data).
rem -LogFile       — ім’я лог-файла (типово: data_run.log).

rem ==================== Приклади запуску ====================
rem 1) Стандартний строгий режим (залишає тільки data.txt + ZIP):
rem    "%~nx0"
rem 2) Зберегти документацію разом із результатом:
rem    "%~nx0" -KeepDocs
rem 3) Без транскрипту консолі:
rem    "%~nx0" -NoTranscript
rem 4) Користувацькі імена файлів:
rem    "%~nx0" -InputFile myvault.pgp -OutputPrefix export_2025

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0decrypt_and_extract.ps1" %*

rem (необов’язково) Проброс коду завершення PowerShell у ErrorLevel BAT:
rem if not "%ERRORLEVEL%"=="0" exit /b %ERRORLEVEL%
