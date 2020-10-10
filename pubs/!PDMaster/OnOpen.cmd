@echo off
if exist "%~2" goto Continue
echo usage: %~nX0 issue MasterFilename
echo        e.g.   %~nX0 2020-07 "G:\My Drive\Asia Bulletin\AB Workspace\Sync\!ABMaster 2020-07.txt"
goto Done

:Continue
set thispub=%~dp0
set build=%thispub%..\..
set issue=%~1
set syncFolder=%~dp2
set masterFile=%~2
set issueFolder=%thispub%issues\%issue%

if not exist "%syncFolder%resources" mkdir "%syncFolder%resources"
if %ERRORLEVEL% NEQ 0 Goto Failed

if not exist "%syncFolder%resources\%issue%" mkdir "%syncFolder%resources\%issue%"
if %ERRORLEVEL% NEQ 0 Goto Failed

if not exist "%syncFolder%resources\%issue%\email" mkdir "%syncFolder%resources\%issue%\email"
if %ERRORLEVEL% NEQ 0 Goto Failed

if exist "%issueFolder%\BasicEmail.html" echo OPENTAB BasicEmail.html
if exist "%issueFolder%\WikiPages.html" echo OPENTAB WikiPages.html
if exist "%issueFolder%\FinalEmail.html" echo OPENTAB FinalEmail.html

echo Loaded %masterFile%
goto Done

:Failed
echo.
echo ***************** FAILED!  :(
exit 99

:Done
