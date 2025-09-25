
<#
================================================================================
 Proton Pass Portable Decryptor — v1.9.3
 UA: Портативний офлайн-інструмент для розшифрування PGP-експорту Proton Pass.
 EN: Portable offline decryptor for Proton Pass PGP export.
 
 ОСНОВНЕ / SUMMARY
 UA:
  - Жодних інсталяцій. Потрібен лише gpg.exe (системний або локальний bin\gnupg).
  - Після успіху каталог самоочищається: лишається тільки data.txt + ваш ZIP.
  - Двомовні логи UA/EN. Уся документація в README.md (UA/EN).
  - Опція -KeepDocs дозволяє зберегти README/CHANGELOG.
 EN:
  - No installation required. Needs gpg.exe (system or local bin\gnupg).
  - After success folder self-cleans: only data.txt + your ZIP remain.
  - Bilingual UA/EN logs. Documentation in README.md (UA/EN).
  - Use -KeepDocs to retain README/CHANGELOG.
 
 ВХІД / INPUT
  - data.pgp  — PGP-encrypted Proton Pass export.
 ВИХІД / OUTPUT
  - data.txt  — short human-readable list.
  - data_passwords.tsv / data_passwords.txt — detailed exports (removed by default).
 
 ПАРАМЕТРИ / PARAMETERS
  -InputFile      default: data.pgp
  -OutputPrefix   default: data
  -LogFile        default: data_run.log
  -OfflineOnly    (legacy; no downloads in v1.9.x)
  -NoTranscript   do not record console transcript
  -KeepDocs       keep README.md and CHANGELOG.md after cleanup
================================================================================
#>

[CmdletBinding()]
param(
  [string]$InputFile    = "data.pgp",
  [string]$OutputPrefix = "data",
  [string]$LogFile      = "data_run.log",
  [switch]$OfflineOnly,
  [switch]$NoTranscript,
  [switch]$KeepDocs
)

# UA: Строгий режим/помилки фатальні; ведемо лог у UTF-8.
# EN: Strict mode/fatal errors; log as UTF-8.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$script:LOG = Join-Path $PSScriptRoot $LogFile
$script:TS  = Join-Path $PSScriptRoot ($LogFile -replace '\.log$','_transcript.log')
$script:TS_ON = $false

# UA: Допоміжна функція для двомовного логування.
# EN: Helper for bilingual logging.
function LogLine {
  param([string]$Level="INFO",[string]$UA="",[string]$EN="")
  $ts=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss.fff")
  $line="[${ts}] [$Level] UA: $UA | EN: $EN"
  if($Level -eq "ERROR"){Write-Host $line -ForegroundColor Red}
  elseif($Level -eq "WARN"){Write-Host $line -ForegroundColor Yellow}
  else{Write-Host $line}
  Add-Content -Path $script:LOG -Value $line -Encoding UTF8
}

# UA: Стартова шапка і, за потреби, транскрипт консолі.
# EN: Header + optional console transcript.
function Start-Header{
  "" | Set-Content -Path $script:LOG -Encoding UTF8
  LogLine -UA "=== Старт v1.9.3 ===" -EN "=== Start v1.9.3 ==="
  LogLine -UA ("Каталог: {0}" -f $PSScriptRoot) -EN ("Folder: {0}" -f $PSScriptRoot)
  LogLine -UA ("PS: {0}" -f $PSVersionTable.PSVersion) -EN ("PS: {0}" -f $PSVersionTable.PSVersion)
  LogLine -UA ("OS: {0}" -f [System.Environment]::OSVersion.VersionString) -EN ("OS: {0}" -f [System.Environment]::OSVersion.VersionString)
  if(-not $NoTranscript){ try{ Start-Transcript -Path $script:TS -Append | Out-Null; $script:TS_ON=$true }catch{} }
}
Start-Header
function Stop-Transcript-IfAny{ if($script:TS_ON){ try{ Stop-Transcript|Out-Null }catch{}; $script:TS_ON=$false } }

# UA: Пошук gpg.exe у системі або поруч із скриптом.
# EN: Locate gpg.exe in system or adjacent to the script.
function Resolve-GpgExe {
  $p=(Get-Command gpg.exe -ErrorAction SilentlyContinue).Source
  if($p){ return $p }
  foreach($c in @(
    (Join-Path $env:ProgramFiles "GnuPG\bin\gpg.exe"),
    (Join-Path ${env:ProgramFiles(x86)} "GnuPG\bin\gpg.exe"),
    (Join-Path $PSScriptRoot "bin\gnupg\bin\gpg.exe"),
    (Join-Path $PSScriptRoot "bin\gpg.exe")
  )){ if(Test-Path $c){ return $c } }
  throw "gpgNotFound"
}

# UA: Генерація тимчасового .cmd, який видаляє все, КРІМ дозволених імен.
# EN: Generate a temporary .cmd that deletes everything EXCEPT allowed names.
function Start-CleanupKeepOnly {
  param([string[]]$KeepNames=@("data.txt"))
  $cleanup=Join-Path $PSScriptRoot ("cleanup_"+[guid]::NewGuid().ToString('N')+".cmd")
  $cond = 'if /I not "%%F"=="%~nx0"'
  foreach($n in $KeepNames){ $cond += ' if /I not "%%F"=="' + $n + '"' }
$tmpl = @"
@echo off
setlocal
ping -n 2 127.0.0.1 >nul
for /f "delims=" %%F in ('dir /a /b') do (
  {COND} (
    rmdir /s /q "%%F" 2>nul
    del   /f /q "%%F" 2>nul
  )
)
del /f /q "%~f0" 2>nul
endlocal
"@
  $content = $tmpl.Replace("{COND}", $cond)
  Set-Content -Path $cleanup -Value $content -Encoding ASCII
  Start-Process -FilePath 'cmd.exe' -ArgumentList '/c',('"' + $cleanup + '"') -WindowStyle Hidden | Out-Null
}

# === Основний сценарій / Main flow ===
if(-not(Test-Path (Join-Path $PSScriptRoot $InputFile))){
  LogLine -Level "ERROR" -UA "Не знайдено вхідний файл $InputFile" -EN "Input file not found: $InputFile"
  exit 2
}
$gpg=Resolve-GpgExe
LogLine -UA ("Знайдено gpg: {0}" -f $gpg) -EN ("Found gpg: {0}" -f $gpg)

# UA: Парольна фраза — приховано; жодних логів.
# EN: Hidden passphrase; never logged.
$secure=Read-Host "Enter Proton Pass passphrase (hidden)" -AsSecureString
$ptr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
try{ $pass=[Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) } finally{ [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }

# UA: Дешифрування → JSON.
# EN: Decrypt → JSON.
$outJson="$OutputPrefix`_decrypted.json"
& $gpg --batch --yes --passphrase $pass --output $outJson --decrypt $InputFile
if($LASTEXITCODE -ne 0){
  LogLine -Level "ERROR" -UA "Помилка gpg" -EN "gpg error"; exit 3
}
LogLine -UA "Розшифрування успішно" -EN "Decryption OK"

# UA: Парсинг JSON з урахуванням форм масив/мапа для vaults.
# EN: Parse JSON allowing array/map for vaults.
$json=Get-Content $outJson -Raw | ConvertFrom-Json
$vaults=@()
if($json.vaults){
  if($json.vaults.GetType().Name -match "Object\[\]"){
    $vaults=@($json.vaults)
  } else {
    foreach($p in $json.vaults.PSObject.Properties){ $vaults+=$p.Value }
  }
}

$rows=@()
foreach($v in $vaults){
  foreach($it in @($v.items)){
    if($null -eq $it.data){ continue }
    $d=$it.data; $m=$d.metadata; $c=$d.content
    $u=$c.itemUsername; if([string]::IsNullOrWhiteSpace($u)){ $u=$c.itemEmail }
    $urls=""; if($c.urls){ $arr=@(); foreach($u2 in $c.urls){ if($u2 -is [string]){$arr+=$u2}else{$arr+=($u2.url -or $u2.href -or $u2.value -or "")} }; $urls=($arr|?{$_}) -join "; " }
    $rows+=[PSCustomObject]@{
      Name=$m.name; Username=$u; Password=$c.password; URL=$urls; TOTP=$c.totpUri; Note=$m.note; Passkeys=@($c.passkeys).Count
    }
  }
}
LogLine -UA ("Витягнуто рядків: {0}" -f $rows.Count) -EN ("Extracted rows: {0}" -f $rows.Count)

# UA: Експорт TSV/TXT + короткий data.txt
# EN: Export TSV/TXT + short data.txt
$tsv="$OutputPrefix`_passwords.tsv"
$txt="$OutputPrefix`_passwords.txt"
$rows | Export-Csv -Path $tsv -NoTypeInformation -Delimiter "`t"

$sb=New-Object Text.StringBuilder
foreach($r in $rows){
  $null=$sb.AppendLine("Name: $($r.Name)")
  $null=$sb.AppendLine("Login: $($r.Username)")
  $null=$sb.AppendLine("Password: $($r.Password)")
  $null=$sb.AppendLine("URL(s): $($r.URL)")
  if($r.TOTP){ $null=$sb.AppendLine("TOTP: $($r.TOTP)") }
  if($r.Passkeys -gt 0){ $null=$sb.AppendLine("Passkeys: $($r.Passkeys)") }
  if($r.Note){ $null=$sb.AppendLine("Note: $($r.Note)") }
  $null=$sb.AppendLine("--------------------------")
}
$out=$sb.ToString()
$out | Set-Content -Path $txt -Encoding UTF8
$out | Set-Content -Path "data.txt" -Encoding UTF8
LogLine -UA "Готово: data.txt, TSV, TXT" -EN "Done: data.txt, TSV, TXT"

# UA: Завершення і прибирання.
# EN: Finish & cleanup.
Stop-Transcript-IfAny
Start-Sleep -Milliseconds 150
$keep=@("data.txt"); 
foreach($z in (Get-ChildItem -ea SilentlyContinue -File | Where-Object { $_.Name -match '^proton[-_]pass(?:[-_]windows)?[-_]portable_.*\.zip$' })){ $keep+=$z.Name }
if($KeepDocs){ $keep+=@("README.md","CHANGELOG.md") }
Start-CleanupKeepOnly -KeepNames $keep
