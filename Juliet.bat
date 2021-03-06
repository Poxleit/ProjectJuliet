:: Project Juliet
 
@echo off
mode con cols=130 lines=40

:start
set Version=0.45b
title ProjectJuliet - %Version%
IF EXIST ProjectJuliet rmdir /s /q ProjectJuliet

:check
cls
IF EXIST Tools\Git\App\Git\Bin\Git.exe echo. Directory: Git [FOUND]
IF NOT EXIST Tools\Git\App\Git\Bin\Git.exe echo. Directory: Git [NOT FOUND] && echo. Project Juliet will now install Git && ping -n 5 127.0.0.1>nul && goto gitInstall
IF EXIST Tools\CMake echo. Directory: CMAKE [FOUND]
IF NOT EXIST Tools\CMake echo. Directory: CMake [NOT FOUND] && echo. Project Juliet will now install CMake && ping -n 5 127.0.0.1>nul && goto cmakeInstall
IF EXIST Install rmdir /s /q Install
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
IF NOT EXIST Cores mkdir Cores
rmdir /s /q ProjectJuliet

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
echo. M - Compile CMaNGOS Core (2.4.3)
echo. X - Exit
echo.
SET /P Option= Enter your choice :
IF /I %Option%==T GOTO infoFill
IF /I %Option%==M GOTO infoFill
IF /I %Option%==X EXIT
IF /I %Option%==* GOTO invalidChoice
 
:invalidChoice
echo.
echo. Error: You have entered an invalid Choice!
echo.
pause
goto boot

:infoFill
cls
SET /P TC=Do you want to release (R) or Debug (D) the core (press X to return to start screen) : 
IF /I %TC%==R SET debug=Release
IF /I %TC%==D SET debug=debug
IF /I %TC%==X GOTO boot
cls
SET /P W=Do you want a 32bit(Y) or a 64bit(N) core (press X to return to the previous screen) : 
IF /I %W%==Y SET Win=Win32
IF /I %W%==N SET Win=x64
IF /I %W%==X GOTO infoFill
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
set /p worlddb=World/Mangos DB Name [world]: 
if %worlddb%. == . set worlddb=world
set /p charsdb=Char DB Name [characters]: 
if %charsdb%. == . set charsdb=characters
set /p authdb=Auth/Realmd DB Name [auth]: 
if %authdb%. == . set authdb=auth
:infoCheck
cls
echo =====================================
echo Your MySQL and Database Information
echo =====================================
echo.
echo MySQL Information :
echo.
echo MySQL Host     : %host%
echo MySQL User     : %user%
echo MySQL Pass     : %pass%
echo MySQL Port     : %port%
echo.
echo Database Information :
echo.
echo World/Mangos DB : %worlddb%
echo Char DB         : %charsdb%
echo Auth/Realmd DB  : %authdb%
echo.
echo Is the information correct?
echo Y - Yes, continue
echo N - No, restart
SET /P InfCheck=(Y\N) : 
IF /I %InfCheck%==Y GOTO coreCheck
IF /I %InfCheck%==N GOTO infoFill
GOTO infoCheck

:coreCheck
IF /I %Option%==T GOTO trinityComp
IF /I %Option%==M goto mangosComp

:trinityComp
cls
echo. Compiling will start in 5 seconds
echo. If you made a mistake restart ProjectJuliet now!
ping -n 5 127.0.0.1 > nul
cd Cores
IF NOT EXIST Trinity mkdir Trinity
cd Trinity
IF EXIST Build rmdir /s /q Build
mkdir Build
cls
:: Needs updating
:: IF EXIST TrinityCore cd TrinityCore && ..\..\..\Tools\Git\App\Git\Bin\Git.exe pull git://github.com/TrinityCore/TrinityCore 3.3.5 && cd ../
:: Git fails to recognize the pull command
:: Temporary workaround by removing TrinityCore folder and forcing a redownload
rmdir TrinityCore
IF NOT EXIST TrinityCore ..\..\Tools\Git\App\Git\Bin\Git.exe clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore
cls
cd Build
IF /i %Win%==Win32 ..\..\..\Tools\CMake\bin\cmake.exe cmake --build ..\TrinityCore -G "Visual Studio 12 2013"
IF /i %Win%==x64 ..\..\..\Tools\CMake\bin\cmake.exe cmake --build ..\TrinityCore -G "Visual Studio 12 2013 Win64"
cls
"C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" TrinityCore.sln /t:Rebuild /p:Configuration=%debug%;Platform=%Win% /flp1:logfile=CompileErrors_%debug%_%folder_name%_%Win%.log;errorsonly /flp2:logfile=CompileWarnings_%debug%_%folder_name%_%Win%.log;warningsonly
echo.
echo. TrinityCore has been compiled.
echo. If you've experienced any errors during the compile, the core did not compile (issue with the core itself, not ProjectJuliet).
echo. Warnings are normal.
cd ../../../
pause
goto trinityDB

 
:trinityDB
echo.
echo. ProjectJuliet will now update your database.
echo. Please make sure your MySQL server is online.
pause
cls
for %%i in (Cores\Trinity\TrinityCore\sql\updates\world\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %worlddb% < %%i
for %%i in (Cores\Trinity\TrinityCore\sql\updates\characters\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %charsdb% < %%i
for %%i in (Cores\Trinity\TrinityCore\sql\updates\auth\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %authdb% < %%i
Echo.
Echo. 
Echo. ProjectJuliet will continue in 5 seconds
ping -n 5 127.0.0.1 > nul
cls
Echo. Database has been updated!
Echo. Compiled core is located inside Cores\Trinity\Build\Bin\Release folder.
echo.
Pause
goto boot

:mangosComp
cls
echo. Compiling will start in 5 seconds
echo. If you made a mistake restart ProjectJuliet now!
ping -n 5 127.0.0.1 > nul
cd Cores
IF NOT EXIST MaNGOS mkdir MaNGOS
cd MaNGOS
cls
IF EXIST mangostbc cd mangostbc &&  ..\..\..\Tools\git\App\Git\bin\git.exe pull git://github.com/Poxleit/s-core.git && cd ../
IF NOT EXIST mangostbc ..\..\Tools\Git\App\Git\Bin\Git.exe clone git://github.com/Poxleit/s-core.git mangostbc
IF EXIST mangostbc\src\bindings\ScriptDev2 cd mangostbc\src\bindings\ScriptDev2 && ..\..\..\..\..\..\Tools\git\App\Git\bin\git.exe pull git://github.com/Poxleit/s-scripts.git && cd ../../../../
IF NOT EXIST mangostbc\src\bindings\ScriptDev2 ..\..\Tools\Git\App\Git\Bin\Git.exe clone git://github.com/Poxleit/s-scripts.git mangostbc\src\bindings\ScriptDev2
cls
IF EXIST "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" mangostbc\win\mangosdVC120.sln /t:Rebuild /p:Configuration=%debug%;Platform=%Win% /flp1:logfile=CompileErrors_%debug%_%folder_name%_%Win%.log;errorsonly /flp2:logfile=CompileWarnings_%debug%_%folder_name%_%Win%.log;warningsonly
IF EXIST "C:\Program Files\MSBuild\12.0\Bin\MSBuild.exe" "C:\Program Files\MSBuild\12.0\Bin\MSBuild.exe"  mangostbc\win\mangosdVC120.sln /t:Rebuild /p:Configuration=%debug%;Platform=%Win% /flp1:logfile=CompileErrors_%debug%_%folder_name%_%Win%.log;errorsonly /flp2:logfile=CompileWarnings_%debug%_%folder_name%_%Win%.log;warningsonly
ping -n 10 127.0.0.1 > nul
cls
IF EXIST "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe" mangostbc\src\bindings\ScriptDev2\scriptVC120.sln /t:Rebuild /p:Configuration=%debug%;Platform=%Win% /flp1:logfile=CompileErrors_%debug%_%folder_name%_%Win%.log;errorsonly /flp2:logfile=CompileWarnings_%debug%_%folder_name%_%Win%.log;warningsonly
IF EXIST "C:\Program Files\MSBuild\12.0\Bin\MSBuild.exe" "C:\Program Files\MSBuild\12.0\Bin\MSBuild.exe" mangostbc\src\bindings\ScriptDev2\scriptVC120.sln /t:Rebuild /p:Configuration=%debug%;Platform=%Win% /flp1:logfile=CompileErrors_%debug%_%folder_name%_%Win%.log;errorsonly /flp2:logfile=CompileWarnings_%debug%_%folder_name%_%Win%.log;warningsonly
::Needs to also copy and rename .conf files
echo.
echo. MaNGOS has been compiled and is now located at Cores\MaNGOS\mangostbc\bin\%Win%_Release
echo. If you've experienced any errors during the compile, the core did not compile (issue with the core itself, not ProjectJuliet).
echo. Error Log files are located at Cores\MaNGOS.
echo. Warnings are normal.
cd ../../
goto mangosDB
 
:mangosDB
::Needs updates and sd2 update functionality 
echo.
echo. ProjectJuliet will now update your database.
echo. Please make sure your MySQL server is online.
pause
cls
for %%i in (Cores\MaNGOS\mangostbc\sql\updates\mangos\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %worlddb% < %%i
for %%i in (Cores\MaNGOS\mangostbc\sql\updates\realmd\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %charsdb% < %%i
for %%i in (Cores\MaNGOS\mangostbc\sql\updates\auth\*.sql) do echo Importing: %%i & Tools\mysql.exe -q -s -h %host% --user=%user% --password=%pass% --port=%port% --line_numbers %authdb% < %%i
echo.
echo. 
echo. ProjectJuliet will continue in 5 seconds
ping -n 5 127.0.0.1 > nul
cls
echo. Database has been updated!
echo.
Pause
goto boot
