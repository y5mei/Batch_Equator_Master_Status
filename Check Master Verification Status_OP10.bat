@echo off

goto start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 	Renishaw Master Verification Result File Sorting Program
%
%	Author:				Yaowen Mei (Quality Specialist)
%	E-mail:				ymei@stackpole.com
%	Address:			Stackpole International PMDA
%						1325 Cormorant Road
%					Ancaster, ON, Canada, L9G 4V5
%	Date Created:				Nov, 06, 2020
%	Purpose:			Generate a status report for Master Verification Reports in CMD terminal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:start
REM THIS PROGRAM CHECKS ALL THE *.RTF FILES UNDER CURRENT DIRCTORY
REM AND IT WILL REPORT ANYTHING THAT FAILED OR NOT COMPLETED 
REM Chris Mei @ Nov 06 2020 Stackploe ymei@stackpole.com

setlocal ENABLEDELAYEDEXPANSION
rem mode con: cols=120 lines=40

rem this is the color coding setting, put your code between :start and : ColorText flags
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

REM Save all the RTF files in a text file (filelist) in time sequence order;
dir "%CD%\"*OP10*.RTF /b /o-d > fileslist.txt
set "cmd=findstr /R /N "^^" fileslist.txt | find /C ":""
REM Make a file (currentFail) to hold the failed dimensions
type nul > currentFail.txt

for /f %%a in ('!cmd!') do set number=%%a
echo %number% of files have been checked

call :ColorText F0 "======================================================="
echo.
call :ColorText F0 "====================START OF CHECK====================="
echo.
call :ColorText F0 "======================================================="
echo.

REM Setup variables:
Set val=0
Set keyword=\cf3
Set failFlg=0
Set dummy=0
Set lineCounter=0


for /f "tokens=*" %%s in (fileslist.txt) do (	
	echo ************************************************************
	REM For Each file in fileslist, get the filename and read each line of the file
	set filename=%%s
	set /a failFlg=0 
	set /a lineCounter=0
	type nul > currentFail.txt
	
	REM the date and time and calculate the shift string
	set filetime=!filename:~10,-4!
	set /a hoursDig1=!filename:~-10,-9!
	set /a hoursDig2=!filename:~-9,-8!
	set /a hrs=!hoursDig1!*10+!hoursDig2!
	set shift=NightShift_23PM-7AM
	
	
	if !hrs! GEQ 7 IF !hrs! LSS 15 SET shift=Dayshift_7AM-3PM
	if !hrs! GEQ 15 IF !hrs! LSS 23 SET Shift=AfternoonShift_3PM-23PM
	echo :           During the !shift!>>currentFail.txt
	
	
		
	for /f "tokens=*" %%f in ('type "!filename!"') do (
		set currentline=%%f
		set /a lineCounter+=1
		REM FOUND THE FAILED LINES, and set the fail flag to be true
		if "!currentline:~0,4!"=="%keyword%" (echo !currentline:~5,-4!>>currentFail.txt & set /a failFlg=1 ) else ( set dummy+=1)
	)
	
	
	REM if the failed flag is true, report the file as failed for remaster; otherwise, report the file to be pass.
	
	if !failFlg!==1 ( 
	call :ColorText C0 "======================FAILED=========================="
	echo.
	for /f "tokens=*" %%i in (currentFail.txt) do (echo %%i)
	echo "!filename!" FAILED THE REMASTER*****************
	echo ************************************************************
	)
	REM 25 lines for op20 and 45 lines for OP10
	if !lineCounter! LEQ 45 ( 
	call :ColorText E0 "====================WARNINING========================" 
	echo. 
	for /f "tokens=*" %%i in (currentFail.txt) do (echo %%i)
	echo "!filename!" DIDN'T FINISH, ONLY HAS !lineCounter! LINES IN THE FILE 
	echo ************************************************************
	set /a failFlg=1
	)
	if !failFlg!==0 ( 
	call :ColorText A0 "======================PASSED==========================" 
	echo. 
	for /f "tokens=*" %%i in (currentFail.txt) do (echo %%i)
	echo "!filename!" PASSED REMASTER 
	echo ************************************************************
	)
)

REM Delete the tem. files: filelist and currentFail

DEL /S /Q /F fileslist.txt > nul
DEL /S /Q /F currentFail.txt > nul
call :ColorText F0 "====================THis IS THE END===================="
echo.
PAUSE

goto :eof

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof
 
rem goto :STOP

rem :STOP
rem PAUSE
 
  