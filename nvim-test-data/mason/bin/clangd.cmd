@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0

endLocal & goto #_undefined_# 2>NUL || title %COMSPEC% & "D:\Dan\Dev\nvim\nvim-test-data\mason\packages\clangd\clangd_20.1.0/bin/clangd.exe" %*