@echo off

if exist "%~2" goto Continue
echo usage: %~nX0 issue MasterFilename
echo        e.g.   %~nX0 2020-07 "G:\My Drive\Rho-PD\Sync\2020-09\!PDMaster #2020-09.txt"
rem                              "G:\My Drive\Asia Bulletin\AB Workspace\Sync\!ABMaster#2020-07.txt"
goto Done

:Continue
set thispub=%~dp0
set build=%thispub%..\..
set issue=%~1
set masterFolder=%~dp2
set syncFolder=%~dp2..\
set masterFile=%~2
set issueFolder=%thispub%issues\%issue%

echo CLOSETAB BasicEmail.html;Juice.html;FinalEmail.html

if not exist "%issueFolder%" mkdir %issueFolder%
if %ERRORLEVEL% NEQ 0 Goto Failed

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
java -jar "%build%\tools\saxon\saxon9he.jar" -o:"%issueFolder%\content.html" "%issueFolder%\content.xml" "%thispub%scripts\xslt\bb-outlook-fix.xslt"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo Build BulletinTemplate.html
call "%build%\node_modules\.bin\jade" -o "%issueFolder%" -E html -P "%issueFolder%\BulletinTemplate.jade"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
perl "%thispub%scripts\perl\tidy.pl" "%issueFolder%\BulletinTemplate.html" "%issueFolder%\BasicEmail.html"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
perl "%thispub%scripts\perl\MakeImageList.pl" "%issueFolder%\BasicEmail.html" "%issueFolder%\Email-ImageList.txt"
if %ERRORLEVEL% NEQ 0 Goto Failed

echo.
if not exist "%issueFolder%\img" mkdir %issueFolder%\img
perl "%thispub%scripts\perl\AssembleFiles.pl" "%issueFolder%\Email-ImageList.txt" "%masterFolder%images\email;%masterFolder%images;%syncFolder%\common" "%issueFolder%\img" 
if %ERRORLEVEL% NEQ 0 Goto Failed
echo OPENTAB BasicEmail.html

echo.
echo Run Juice
call "%build%\node_modules\.bin\juice" "%issueFolder%\BasicEmail.html" "%issueFolder%\juice.html"
if %ERRORLEVEL% NEQ 0 Goto Failed
echo OPENTAB Juice.html

echo.
echo Run Inliner
call "%build%\node_modules\.bin\inliner.cmd" "%issueFolder%\juice.html" > "%issueFolder%\FinalEmail.html"
rem node  "%build%\node_modules\inliner\cli\index.js" "%issueFolder%\juice.html" > "%issueFolder%\FinalEmail.html" 
if %ERRORLEVEL% NEQ 0 Goto Failed
echo OPENTAB FinalEmail.html


echo.
echo ***************** DONE
goto Done

:Failed
echo.
echo ***************** FAILED!  :(
exit 99

:Done
rem pause 