:: Project Juliet
 
@echo off
mode con cols=130 lines=40

:start
set Version=0.45b
title ProjectJuliet - %Version%
IF EXIST ProjectJuliet rmdir /s /q ProjectJuliet

:check
cls
set fileCheck=false
IF EXIST Tools\Git\App\Git\Bin\Git.exe echo. Directory: Git [FOUND]
IF NOT EXIST Tools\Git\App\Git\Bin\Git.exe echo. Directory: Git [NOT FOUND] && echo. Project Juliet will now install Git && ping -n 5 127.0.0.1>nul && goto gitInstall
IF EXIST Tools\CMake echo. Directory: CMAKE [FOUND]
IF NOT EXIST Tools\CMake echo. Directory: CMake [NOT FOUND] && echo. Project Juliet will now install CMake && ping -n 5 127.0.0.1>nul && goto cmakeInstall
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
cls
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
echo. Version: %Version%                                                    
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
SET /P W=Do you want a 32bit(Y) or a 64bit(N) core (press X to return to the previous screen) : 
IF /I %W%==Y SET Win=Win32
IF /I %W%==N SET Win=x64
IF /I %W%==X GOTO trinityStart
cls
echo ==========================================================
echo Enter your MySQL Information (Press ENTER for [default]).
echo ==========================================================
echo.
set /p host=MySQL Host [localhost]: 
if %host%. == . set host=localhost
set /p user=MySQL User [root]: 
if %user%. == . set user=root
set /p pass=MySQL Pass [ascent]: 
if %pass%. == . set pass=ascent
set /p port=MySQL Port [3306]: 
if %port%. == . set port=3306
cls
echo =============================================================
echo Enter Your Database Information (Press ENTER for [default]).
echo =============================================================
echo.
set /p worlddb=World DB Name [world]: 
if %worlddb%. == . set worlddb=world
set /p charsdb=Char DB Name [characters]: 
if %charsdb%. == . set charsdb=characters
set /p authdb=Auth DB Name [auth]: 
if %authdb%. == . set authdb=auth
:infoCheck
cls
echo =====================================
echo Your MySQL and Database Information
echo =====================================
echo.
echo MySQL Information :
echo.
echo MySQL Host : %host%
echo MySQL User : %user%
echo MySQL Pass : %pass%
echo MySQL Port : %port%
echo.
echo Database Information :
echo.
echo World DB : %worlddb%
echo Char DB  : %charsdb%
echo Auth DB  : %authdb%
echo.
echo Is the information correct?
echo Y - Yes, continue
echo N - No, restart
SET /P InfCheck=(Y\N) : 
IF /I %InfCheck%==Y GOTO trinityComp
IF /I %InfCheck%==N GOTO trinityStart
GOTO infoCheck

:trinityComp
cls
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
IF /i %Win%==Win32 ..\..\Tools\CMake\bin\cmake.exe cmake --build ..\TrinityCore -G "Visual Studio 12 2013"
IF /i %Win%==x64 ..\..\Tools\CMake\bin\cmake.exe cmake --build ..\TrinityCore -G "Visual Studio 12 2013 Win64"
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
for %%i in (Release\TrinityCore\sql\updates\world\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %worlddb% < %%i
for %%i in (Release\TrinityCore\sql\updates\characters\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %charsdb% < %%i
for %%i in (Release\TrinityCore\sql\updates\auth\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %authdb% < %%i
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
 
 
