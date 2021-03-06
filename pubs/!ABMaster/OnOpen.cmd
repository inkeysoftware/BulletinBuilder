@echo off
if exist "%~2" goto Continue
echo usage: %~nX0 issue MasterFilename
echo        e.g.   %~nX0 2020-07 "G:\My Drive\Asia Bulletin\AB Workspace\2020-07\!ABMaster 2020-07.txt"
goto Done

:Continue
set thispub=%~dp0
set build=%thispub%..\..
set issue=%~1
set masterFileFolder=%~dp2
set masterFile=%~2
set issueFolder=%thispub%issues\%issue%

if not exist "%masterFileFolder%images" mkdir "%masterFileFolder%images"
if %ERRORLEVEL% NEQ 0 Goto Failed

if not exist "%masterFileFolder%images\email" mkdir "%masterFileFolder%images\email"
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
