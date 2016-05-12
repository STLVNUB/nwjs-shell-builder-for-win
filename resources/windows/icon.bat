set CUR_DIR="%CD%"
set EXE_PATH=%CUR_DIR%\mua.exe
set ICO_PATH=%CUR_DIR%\logo.ico
Resourcer -op:upd -src:%EXE_PATH% -type:14 -name:IDR_MAINFRAME -file:%ICO_PATH%
