# DTB_DeformerExport — Deformer -> Terrain Builder

Требует мод GF_Deformer. Меню в Eden: Tools > Deformer > Export to Terrain Builder.

## Сборка
Папку DTB_DeformerExport положить на P:\ и упаковать (Mikero pboProject / Addon Builder), префикс DTB_DeformerExport (файл $PBOPREFIX$ уже есть).

## Пункты меню
1. Edited terrain -> heightmap patch (.asc): ASC-патч только редактированной области (+1 ячейка запаса). Копируется в буфер частями (~1.5 МБ), части вставлять по порядку в один файл heightmap_patch.asc.
2. Converted objects -> TB import (+ delete list): объекты из слоя "Deformer converts" в формате импорта TB: "name";x;y;yaw;pitch;roll;scale;relZ; плюс список исходных объектов, которые надо удалить в TB.
3. All editor objects -> TB import: все объекты сцены (аналог E2TB).

Патч в полную карту: python tools/merge_asc.py full.asc heightmap_patch.asc out.asc

## Калибровка (проверить один раз на тестовом экспорте)
Переменные можно задать в debug-консоли Eden до экспорта:
- DTB_xOffset = 200000 (смещение X карты в TB), DTB_yOffset = 0
- DTB_yawMode = 0 или 1 (1 = 360 - heading, если объекты в TB повёрнуты зеркально)
- DTB_nameMode = "model" (имя p3d без расширения, как в библиотеке TB) или "class"



========================================================================================
🇷🇺 Русский (Russian)
📌 Описание
Данный пакет файлов автоматизирует процесс переноса изменений карты высот (heightmap) и объектов из редактора Eden в официальный редактор карт Terrain Builder.
Вместо ручного копирования десятков текстовых файлов и использования командной строки, вы можете использовать удобный батник QuickExport.bat, который берет данные прямо из буфера обмена и склеивает их с вашей исходной картой.

⚙️ Требования
Установленный Python (версия 3.8 или выше). При установке обязательно поставьте галочку "Add Python to PATH".

Установленная библиотека numpy (батник установит её автоматически, либо введите вручную: python -m pip install numpy).

Мод GF_Deformer для Arma 3.

Программа Terrain Builder.

📂 Установка
Положите файлы QuickExport.bat и merge_asc.py в папку с вашими картами высот (например: P:\ВашаКарта\heightmaps).

Убедитесь, что в этой же папке лежит ваш исходный (полный) файл heightmap.asc.

🚀 Как пользоваться
1. Экспорт ландшафта (Heightmap)
В Eden Editor отредактируйте местность.

Откройте меню: Tools -> Deformer -> Export to Terrain Builder.

Нажмите 1. Edited terrain -> heightmap patch. Скрипт скопирует данные в буфер обмена.

Запустите QuickExport.bat и выберите пункт [1].

Если Eden сообщил, что данные скопированы частями, выберите 1 (Первый кусок). Вернитесь в Eden, скопируйте следующий кусок, снова запустите батник и выберите 2 (Дописать). Повторяйте до конца.

Батник автоматически запустит Python-скрипт и создаст итоговый файл heightmap_merged.asc. Импортируйте его в Terrain Builder.

2. Экспорт объектов
В Eden Editor нажмите Tools -> Deformer -> Export to Terrain Builder -> 2. Converted objects (или пункт 3).

Запустите QuickExport.bat и выберите пункт [2].

В папке появится файл tb_objects_import.txt со списком объектов для импорта и удаления в TB.

3. Калибровка (если объекты или карта смещены)
Перед экспортом откройте дебаг-консоль в Eden Editor и введите нужные параметры:

DTB_xOffset = 200000 (смещение по X) и DTB_yOffset = 0 (смещение по Y).

DTB_yawMode = 1 (если объекты в Terrain Builder повернуты зеркально).

DTB_nameMode = "model" (использовать имя p3d) или "class" (имя класса).

🚑 Решение проблем (Troubleshooting)
Ошибка ModuleNotFoundError: No module named 'numpy': Откройте CMD и введите python -m pip install numpy.

Ошибка python не является внутренней командой: Python не добавлен в PATH. Переустановите его с галочкой "Add Python to PATH".

🇬🇧 English
📌 Description
This package automates the process of transferring heightmap changes and objects from the Eden Editor to the official Terrain Builder.
Instead of manually copying dozens of text chunks and using the command line, you can use the QuickExport.bat tool, which grabs data directly from the clipboard and merges it with your original map.

⚙️ Requirements
Python installed (version 3.8 or higher). Make sure to check "Add Python to PATH" during installation.

numpy library installed (the .bat will install it automatically, or run manually: python -m pip install numpy).

GF_Deformer mod for Arma 3.

Terrain Builder.

📂 Installation
Place QuickExport.bat and merge_asc.py into your heightmaps folder (e.g., P:\YourMap\heightmaps).

Ensure your original (full) heightmap.asc is in the same folder.

🚀 Usage
1. Terrain (Heightmap) Export
Edit the terrain in Eden Editor.

Go to: Tools -> Deformer -> Export to Terrain Builder.

Click 1. Edited terrain -> heightmap patch. The data is copied to your clipboard.

Run QuickExport.bat and select [1].

If Eden copied the data in chunks, select 1 (First chunk). Return to Eden, copy the next chunk, run the bat again, and select 2 (Append). Repeat until done.

The bat will automatically run the Python script and create the final heightmap_merged.asc. Import this file into Terrain Builder.

2. Object Export
In Eden Editor, go to Tools -> Deformer -> Export to Terrain Builder -> 2. Converted objects (or option 3).

Run QuickExport.bat and select [2].

A file named tb_objects_import.txt will be created, containing the object import list and the delete list for TB.

3. Calibration (if objects/map are offset)
Before exporting, open the Eden Editor debug console and type the required parameters:

DTB_xOffset = 200000 (X offset) and DTB_yOffset = 0 (Y offset).

DTB_yawMode = 1 (if objects are mirrored/rotated incorrectly in Terrain Builder).

DTB_nameMode = "model" (use p3d name) or "class" (use config class name).

🚑 Troubleshooting
Error ModuleNotFoundError: No module named 'numpy': Open CMD and run python -m pip install numpy.

Error python is not recognized...: Python is not in your PATH. Reinstall it and check "Add Python to PATH".