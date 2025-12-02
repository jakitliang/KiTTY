@echo off

set KITTY_INIT_START=%time%

:: Init Script for cmd.exe shell
:: Created as part of kitty project

:: !!! THIS FILE IS OVERWRITTEN WHEN KITTY IS UPDATED
:: !!! Use "%KITTY_ROOT%\etc\profile.cmd" to add your own startup commands

:: Use /v command line arg or set to > 0 for verbose output to aid in debugging.
if not defined verbose_output set verbose_output=0

:: Use /d command line arg or set to 1 for debug output to aid in debugging.
if not defined debug_output set debug_output=0

:: Use /t command line arg or set to 1 to display init time.
if not defined time_init set time_init=0

:: Use /f command line arg to speed up init at the expense of some functionality.
if not defined fast_init set fast_init=0

:: Use /max_depth 1-5 to set max recurse depth for calls to `enhance_path_recursive`
if not defined max_depth set max_depth=1

:: Add *nix tools to end of path. 0 turns off *nix tools, 2 adds *nix tools to the front of the path.
if not defined nix_tools set nix_tools=1

set "KITTY_USER_FLAGS= "

:: Find root dir
if not defined KITTY_ROOT (
    for /f "delims=" %%i in ("%~dp0\..\..") do (
        set "KITTY_ROOT=%%~fi"
    )
)

:: Remove trailing '\' from %KITTY_ROOT%
if "%KITTY_ROOT:~-1%" == "\" SET "KITTY_ROOT=%KITTY_ROOT:~0,-1%"

:: Include libraries
call "%kitty_root%\bin\cexec.cmd" /setpath
call "%kitty_root%\lib\kitty\console"
call "%kitty_root%\lib\kitty\base"
call "%kitty_root%\lib\kitty\path"
call "%kitty_root%\lib\kitty\git"
call "%kitty_root%\lib\kitty\profile"

:var_loop
    if "%~1" == "" (
        goto :start
    ) else if /i "%1" == "/f" (
        set fast_init=1
    ) else if /i "%1" == "/t" (
        set time_init=1
    ) else if /i "%1" == "/v" (
        set verbose_output=1
    ) else if /i "%1" == "/d" (
        set debug_output=1
    ) else if /i "%1" == "/unicode" (
        chcp 65001 >nul
    ) else if /i "%1" == "/max_depth" (
        if "%~2" geq "1" if "%~2" leq "5" (
            set "max_depth=%~2"
            shift
        ) else (
            %print_error% "'/max_depth' requires a number between 1 and 5!"
            exit /b
        )
    ) else if /i "%1" == "/c" (
        if exist "%~2" (
            if not exist "%~2\bin" mkdir "%~2\bin"
            set "kitty_user_bin=%~2\bin"
            if not exist "%~2\etc\profile.d" mkdir "%~2\etc\profile.d"
            set "kitty_user_config=%~2\etc"
            shift
        )
    ) else if /i "%1" == "/user_aliases" (
        if exist "%~2" (
            set "user_aliases=%~2"
            shift
        )
    ) else if /i "%1" == "/home" (
        if exist "%~2" (
            set "HOME=%~2"
            shift
        ) else (
            %print_error% The home folder "%2" that you specified does not exist!
            exit /b
        )
    ) else if /i "%1" == "/svn_ssh" (
        set SVN_SSH=%2
        shift
    ) else (
        set "KITTY_USER_FLAGS=%1 %KITTY_USER_FLAGS%"
    )
    shift
goto :var_loop

:start

:PATH_ENHANCE
%lib_path% enhance_path "%KITTY_ROOT%\bin"

busybox bash --login
