@echo off
if exist "%~2" goto Continue
echo usage: %~nX0 issue MasterFilename
echo        e.g.   %~nX0 2020-07 "G:\My Drive\Asia Bulletin\AB Workspace\2020-07\!ABMaster#2020-07.txt"
goto Done

:Continue
set thispub=%~dp0
set build=%thispub%..\..
set issue=%~1
set masterFileFolder=%~dp2
set masterFile=%~2
set issueFolder=%thispub%issues\%issue%

echo.
if not exist "%issueFolder%\wiki-img" mkdir %issueFolder%\wiki-files
perl "%thispub%scripts\perl\AssembleFiles.pl" "%issueFolder%\WikiPages-ImageList.txt" "%masterFileFolder%images;%masterFileFolder%..\common;%issueFolder%" "%issueFolder%\wiki-files" 
if %ERRORLEVEL% NEQ 0 Goto Failed

@echo explorer "%issueFolder%\wiki-files" 
explorer "%issueFolder%\wiki-files" 

echo.
echo ***************** DONE
goto Done

:Failed
echo.
echo ***************** FAILED!  :(
explorer "%masterFileFolder%" 
exit 99

:Done
rem pause 