:: Project Juliet
 
@echo off
mode con cols=130 lines=40

:start
set Version=0.4b
title ProjectJuliet - %Version%
IF EXIST ProjectJuliet rmdir /s /q ProjectJuliet

:check
cls
set fileCheck=false
IF EXIST Tools\Git\App\Git\Bin\Git.exe echo. Directory: Git [FOUND]
IF NOT EXIST Tools\Git\App\Git\Bin\Git.exe echo. Directory: Git [NOT FOUND] && echo. Project Juliet will now install Git && ping -n 5 127.0.0.1>nul && goto gitInstall
IF EXIST Tools\CMake echo. Directory: CMAKE [FOUND]
IF NOT EXIST Tools\CMake echo. Directory: CMake [NOT FOUND] && echo. Project Juliet will now install CMake && ping -n 5 127.0.0.1>nul && goto cmakeInstall
IF EXIST Tools\mysql.exe echo. File     : MySQL [FOUND]
IF NOT EXIST Tools\mysql.exe echo. File     : MySQL [NOT FOUND] && goto Update
IF EXIST Tools\UnRAR_32.exe echo. File     : WinRAR [FOUND]
IF NOT EXIST Tools\UnRAR_32.exe echo. File     : WinRAR [NOT FOUND] && goto Update
IF EXIST Install rmdir /s /q Install
SET fileCheck=true
echo.
echo. All files have been found
echo. ProjectJuliet will start in 5 seconds.
ping -n 5 127.0.0.1>nul
goto update

:gitInstall
cls
IF NOT EXIST Install mkdir Install
IF NOT EXIST Tools mkdir Tools
bitsadmin.exe /transfer "Downloading Git" "http://downloads.sourceforge.net/project/gitportable/GitPortable_1.9.4.paf.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgitportable%2F&ts=1436239333&use_mirror=netcologne" %cd%\Install\Git.exe
echo. 
echo. A Git installation window will open in 10 seconds.
echo. Please install Git in the Tools folder.
ping -n 10 127.0.0.1 >nul
cd Install
Git.exe
cd ../
cd tools
RENAME GitPortable Git
cd ../
goto check

:cmakeInstall
cls
IF NOT EXIST Install mkdir Install
IF NOT EXIST Tools mkdir Tools
bitsadmin.exe /transfer "Downloading CMake" "http://www.cmake.org/files/v3.3/cmake-3.3.0-rc3-win32-x86.exe" %cd%\Install\CMake.exe
echo. 
echo. A CMake installation window will open in 10 seconds.
echo. Please install CMake in the Tools folder.
ping -n 10 127.0.0.1 >nul
cd Install
CMake.exe
cd ../
goto check

:update
Tools\Git\App\Git\Bin\Git.exe clone git://github.com/Poxleit/ProjectJuliet
COPY ProjectJuliet\Juliet.bat ".\" /Y
COPY ProjectJuliet\Tools\UnRAR_32.exe ".\Tools" /Y
COPY ProjectJuliet\Tools\mysql.exe ".\Tools" /Y
IF NOT EXIST Release mkdir Release
rmdir /s /q ProjectJuliet
IF %fileCheck%==false goto check
IF %fileCheck%==true goto boot

:boot
cls
echo.   
Echo. Version: %Version%                                                    
echo. __________                   __               __         ____.     .__  .__        __   
echo. \______   \_______  ____    ^|__^| ____   _____/  ^|_      ^|    ^|__ __^|  ^| ^|__^| _____/  ^|_ 
echo.  ^|     ___/\_  __ \/  _ \   ^|  ^|/ __ \_/ ___\   __\     ^|    ^|  ^|  \  ^| ^|  ^|/ __ \   __\
echo.  ^|    ^|     ^|  ^| \(  ^<_^> )  ^|  \  ___/\  \___^|  ^|   /\__^|    ^|  ^|  /  ^|_^|  \  ___/^|  ^|  
echo.  ^|____^|     ^|__^|   \____/\__^|  ^|\___  ^>\___  ^>__^|   \________^|____/^|____/__^|\___  ^>__^|  
echo.                         \______^|    \/     \/                                   \/       
echo.  
echo. Welcome to ProjectJuliet, %USERNAME%
echo.
echo. What would you like to do ?
echo.
echo. T - Compile Trinity Core (3.3.5a)
echo. X - Exit
echo.
SET /P Option= Enter your choice :
IF /I %Option%==T GOTO trinityStart
IF /I %Option%==X EXIT
IF /I %Option%==* GOTO invalidChoice
 
:invalidChoice
echo.
echo. Error: You made a invalid Choice!
echo.
pause
goto boot

:trinityStart
cls
SET /P TC=Do you want to release (R) or Debug (D) the core (press X to return to start screen) :  
IF /I %TC%==R SET debug=Release
IF /I %TC%==D SET debug=debug
IF /I %TC%==X GOTO boot
cls
SET /P W=Do you want a 32bit(Y) or a 64bit(N) core :
IF /I %W%==Y SET Win=Win32
IF /I %W%==N SET Win=x64
cls
Echo ==================================
Echo Enter your MySQL Information.
Echo ==================================
echo.
set /p host=MySQL Host:
if %host%. == . set host=localhost
set /p user=MySQL User:
if %user%. == . set user=root
set /p pass=MySQL Pass:
if %pass%. == . set pass=ascent
set /p port=MySQL Port:
if %port%. == . set port=3306
cls
Echo ==================================
Echo Enter Your Database Information.
Echo ==================================
cls
echo.
set /p worlddb=World DB Name:
if %worlddb%. == . set worlddb=World
set /p charsdb=Char DB Name:
if %charsdb%. == . set charsdb=characters
set /p authdb=Realm DB Name:
if %authdb%. == . set authdb=auth
cls
 
:trinityComp
echo. Compiling will start in 5 seconds
echo. If you made a mistake restart ProjectJuliet now!
ping -n 5 127.0.0.1 > nul
cd Release
IF EXIST Solution rmdir /s /q Solution
mkdir Solution
cls
:: Needs updating
IF EXIST TrinityCore cd TrinityCore && ..\..\Tools\git\bin\git.exe pull git://github.com/TrinityCore/TrinityCore 3.3.5 && cd ../
IF NOT EXIST TrinityCore ..\Tools\Git\App\Git\Bin\Git.exe clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore
cls
cd Solution
IF /i %Win%==Win32 ..\..\Tools\Git\App\Git\Bin\Git.exe cmake --build ..\TrinityCore -G "Visual Studio 12 2013"
IF /i %Win%==x64 ..\..\Tools\Git\App\Git\Bin\Git.exe cmake --build ..\TrinityCore -G "Visual Studio 12 2013 Win64"
cls
"C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" TrinityCore.sln /t:Rebuild /p:Configuration=%debug%;Platform=%Win% /flp1:logfile=CompileErrors_%debug%_%folder_name%_%Win%.log;errorsonly /flp2:logfile=CompileWarnings_%debug%_%folder_name%_%Win%.log;warningsonly
echo.
echo. TrinityCore has been compiled.
echo. If you've experienced any errors during the compile, the core did not compile (issue with the core itself, not ProjectJuliet).
echo. Warnings are normal.
cd ../../

 
:trinityDB
cls
echo. ProjectJuliet will now update your database.
echo. Please make sure your MySQL server is online.
pause
cls
for %%i in (Release\TrinityCore\sql\updates\world\*_*_*_*_*_*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %worlddb% < %%i
for %%i in (Release\TrinityCore\sql\updates\characters\*_*_*_*_*_*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %charsdb% < %%i
for %%i in (Release\TrinityCore\sql\updates\auth\*_*_*_*_*_*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %authdb% < %%i
Echo.
Echo. 
Echo. ProjectJuliet will continue in 5 seconds
ping -n 5 127.0.0.1 > nul
cls
Echo. Database has been updated!
Echo. Compiled core is located inside Release\Bin\Release folder.
echo.
Pause
goto boot
 
 
