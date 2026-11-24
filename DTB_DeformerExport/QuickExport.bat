@echo off
chcp 65001 >nul
title Быстрый экспорт DTB / Quick Export DTB
setlocal EnableDelayedExpansion

:: ===================================================
:: АВТОМАТИЧЕСКИЙ ПОИСК ПУТЕЙ / AUTO PATH DETECTION
:: %~dp0 означает "папка, в которой лежит этот батник" / means "folder where this bat is located"
:: ===================================================
set "MAP_DIR=%~dp0"

set "FULL_ASC=%MAP_DIR%heightmap.asc"
set "PATCH_ASC=%MAP_DIR%heightmap_patch.asc"
set "OUT_ASC=%MAP_DIR%heightmap_merged.asc"
set "OBJECTS_TXT=%MAP_DIR%tb_objects_import.txt"

:: Ищем скрипт merge_asc.py рядом с батником / Looking for merge_asc.py next to the bat
if exist "%MAP_DIR%merge_asc.py" (
    set "PY_SCRIPT=%MAP_DIR%merge_asc.py"
) else (
    set "PY_SCRIPT=D:\DTB_DeformerExport\tools\merge_asc.py"
)

:menu
cls
echo ===================================================
echo    ИНСТРУМЕНТ БЫСТРОГО ЭКСПОРТА (DTB)
echo    QUICK EXPORT TOOL (DTB)
echo ===================================================
echo Рабочая папка / Working dir: %MAP_DIR%
echo.
echo ВАЖНО: Сначала сделайте экспорт в Eden Editor!
echo IMPORTANT: Export from Eden Editor first!
echo (Tools ^> Deformer ^> Export to Terrain Builder)
echo.
echo [1] Экспорт Heightmap (из буфера) / Export Heightmap (from clipboard)
echo [2] Экспорт объектов (из буфера) / Export objects (from clipboard)
echo [3] Объединить готовый патч / Merge existing patch
echo [0] Выход / Exit
echo ===================================================
set /p choice="Выберите действие (0-3) / Select action (0-3): "

if "%choice%"=="1" goto export_heightmap
if "%choice%"=="2" goto export_objects
if "%choice%"=="3" goto just_merge
if "%choice%"=="0" exit
goto menu

:export_heightmap
echo.
echo Получение данных из буфера обмена...
echo Getting data from clipboard...
set /p append_choice="Вы скопировали ПЕРВЫЙ кусок (1) или СЛЕДУЮЩИЙ (2)? / FIRST chunk (1) or NEXT chunk (2)?: "
if "%append_choice%"=="1" (
    powershell -NoProfile -Command "Get-Clipboard | Out-File -Encoding utf8 '%PATCH_ASC%'"
) else (
    powershell -NoProfile -Command "Get-Clipboard | Out-File -Encoding utf8 -Append '%PATCH_ASC%'"
)
echo Данные сохранены в heightmap_patch.asc / Data saved to heightmap_patch.asc
goto just_merge

:export_objects
echo.
echo Сохранение объектов из буфера обмена...
echo Saving objects from clipboard...
powershell -NoProfile -Command "Get-Clipboard | Out-File -Encoding utf8 '%OBJECTS_TXT%'"
echo [УСПЕХ] Объекты сохранены в: / [SUCCESS] Objects saved to: %OBJECTS_TXT%
pause
goto menu

:just_merge
echo.
echo Запуск слияния карт (Python)...
echo Running map merge (Python)...
python "%PY_SCRIPT%" "%FULL_ASC%" "%PATCH_ASC%" "%OUT_ASC%"
if %errorlevel% equ 0 (
    echo.
    echo ===================================================
    echo [УСПЕХ] Карта объединена! / [SUCCESS] Map merged!
    echo Новый файл / New file: %OUT_ASC%
    echo ===================================================
) else (
    echo.
    echo [ОШИБКА] Слияние не удалось. / [ERROR] Merge failed.
    echo Проверьте консоль. / Check the console output.
)
pause
goto menu