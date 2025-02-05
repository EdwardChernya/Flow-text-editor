@echo on
chcp 65001 >nul
set PYTHONIOENCODING=utf-8
set url=%1
set output_file=%2
set save_dir=%3
start cmd /k python -u download.py %url% %output_file% %save_dir%
pause