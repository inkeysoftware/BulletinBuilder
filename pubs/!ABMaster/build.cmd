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

echo CLOSETAB Checking.html;GatewayPages.html;FinalEmail.html

echo Generate project.xslt
java -jar "%build%\tools\saxon\saxon9he.jar" -o:"%thispub%scripts\xslt\project.xslt" "%thispub%settings\blank.xml" "%thispub%scripts\xslt\vimod-projecttasks2variable.xslt" projectpath="%issueFolder%"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
perl "%thispub%scripts\perl\splitMaster.pl" "%masterFile%" "%issueFolder%" "%issueFolder%" 1
if %ERRORLEVEL% NEQ 0 Goto Failed

xcopy "%thispub%Settings\*.jade" "%issueFolder%" /I /Y /D
if %ERRORLEVEL% NEQ 0 Goto Failed

echo Build content.xml
call "%build%\node_modules\.bin\jade" -o "%issueFolder%" -E xml -P "%issueFolder%\content.jade"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo Build content.html
java -jar "%build%\tools\saxon\saxon9he.jar" -o:"%issueFolder%\content.html" "%issueFolder%\content.xml" "%thispub%scripts\xslt\ab-outlook-fix.xslt"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo Build toc.html
java -jar "%build%\tools\saxon\saxon9he.jar" -o:"%issueFolder%\toc.html" "%issueFolder%\content.html" "%thispub%scripts\xslt\ab-toc.xslt"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo Build Step1.html
call "%build%\node_modules\.bin\jade" -o "%issueFolder%" -E html -P "%issueFolder%\ABStep1.jade"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
perl "%thispub%scripts\perl\tidy.pl" "%issueFolder%\ABStep1.html" "%issueFolder%\ABStep2.html"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
perl "%thispub%scripts\perl\Trim2Excerpts.pl" "%issueFolder%\ABStep2.html" "%issueFolder%\Checking.html"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
perl "%thispub%scripts\perl\MakeImageList.pl" "%issueFolder%\Checking.html" "%issueFolder%\ImageList-Email.txt"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
if not exist "%issueFolder%\img" mkdir %issueFolder%\img
perl "%thispub%scripts\perl\AssembleFiles.pl" "%issueFolder%\ImageList-Email.txt" "%syncFolder%resources\%issue%\email;%syncFolder%resources\%issue%;%syncFolder%resources\common" "%issueFolder%\img" 
if %ERRORLEVEL% NEQ 0 Goto Failed
echo OPENTAB Checking.html

echo.
perl "%thispub%scripts\perl\MakeGatewayPages.pl" "%issueFolder%\ABStep2.html" "%issueFolder%" "%issue%"
if %ERRORLEVEL% NEQ 0 Goto Failed
echo OPENTAB GatewayPages.html

echo.
echo Run Juice
call "%build%\node_modules\.bin\juice" "%issueFolder%\Checking.html" "%issueFolder%\juice.html"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
echo Run Inliner
call "%build%\node_modules\.bin\inliner.cmd" "%issueFolder%\juice.html" > "%issueFolder%\FinalEmail.html"
rem node  "%build%\node_modules\inliner\cli\index.js" "%issueFolder%\juice.html" > "%issueFolder%\FinalEmail.html" 
if %ERRORLEVEL% NEQ 0 Goto Failed
echo OPENTAB FinalEmail.html

REM echo.
REM if not exist "%issueFolder%\wiki-img" mkdir %issueFolder%\wiki-img
REM perl "%thispub%scripts\perl\AssembleFiles.pl" "%issueFolder%\ImageList-Wiki.txt" "%syncFolder%resources\%issue%;%syncFolder%resources\common" "%issueFolder%\wiki-img" 
REM if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
echo ***************** DONE
goto Done

:Failed
echo.
echo ***************** FAILED!  :(
exit 99

:Done
rem pause 