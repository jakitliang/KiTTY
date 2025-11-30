@echo off

set KITTY_INIT_START=%time%

:: Init Script for cmd.exe shell
:: Created as part of kitty project

:: !!! THIS FILE IS OVERWRITTEN WHEN KITTY IS UPDATED
:: !!! Use "%KITTY_ROOT%\config\user_profile.cmd" to add your own startup commands

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
    for /f "delims=" %%i in ("%~dp0") do (
        set "KITTY_ROOT=%%~fi"
    )
)

:: Remove trailing '\' from %KITTY_ROOT%
if "%KITTY_ROOT:~-1%" == "\" SET "KITTY_ROOT=%KITTY_ROOT:~0,-1%"

:: Include libraries
call "%kitty_root%\bin\cexec.cmd" /setpath
call "%kitty_root%\lib\lib_console"
call "%kitty_root%\lib\lib_base"
call "%kitty_root%\lib\lib_path"
call "%kitty_root%\lib\lib_git"
call "%kitty_root%\lib\lib_profile"

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
            if not exist "%~2\config\profile.d" mkdir "%~2\config\profile.d"
            set "kitty_user_config=%~2\config"
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
:: Enable console related methods if verbose/debug is turned on
if %debug_output% gtr 0 (set print_debug=%lib_console% debug_output)
if %verbose_output% gtr 0 (
    set print_verbose=%lib_console% verbose_output
    set print_warning=%lib_console% show_warning
)

:: Sets KITTY_SHELL, KITTY_CLINK, KITTY_ALIASES variables
%lib_base% kitty_shell
%print_debug% init.bat "Env Var - KITTY_ROOT=%KITTY_ROOT%"
%print_debug% init.bat "Env Var - debug_output=%debug_output%"

:: Set the Kitty directory paths
set KITTY_CONFIG_DIR=%KITTY_ROOT%\config

:: Check if we're using Kitty individual user profile
if defined KITTY_USER_CONFIG (
    %print_debug% init.bat "KITTY IS ALSO USING INDIVIDUAL USER CONFIG FROM '%KITTY_USER_CONFIG%'!"

    if not exist "%KITTY_USER_CONFIG%\..\opt" md "%KITTY_USER_CONFIG%\..\opt"
    set KITTY_CONFIG_DIR=%KITTY_USER_CONFIG%
)

if not "%KITTY_SHELL%" == "cmd" (
    %print_warning% "Incompatible 'ComSpec/Shell' Detected: %KITTY_SHELL%"
    set KITTY_CLINK=0
    set KITTY_ALIASES=0
)

:: Pick the right version of Clink
:: TODO: Support for ARM
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set clink_architecture=x86
    set architecture_bits=32
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set clink_architecture=x64
    set architecture_bits=64
) else (
    %print_warning% "Incompatible Processor Detected: %PROCESSOR_ARCHITECTURE%"
    set KITTY_CLINK=0
)

if "%KITTY_CLINK%" == "1" (
    REM TODO: Detect if clink is already injected, if so goto :CLINK_FINISH
    goto :INJECT_CLINK
)

goto :SKIP_CLINK

:INJECT_CLINK
    %print_verbose% "Injecting Clink!"

    :: Check if Clink is not present
    if not exist "%KITTY_ROOT%\opt\clink\clink_%clink_architecture%.exe" (
        %print_error% "Clink executable is not present in \opt\clink\clink_%clink_architecture%.exe'"
        goto :SKIP_CLINK
    )

    :: Run Clink
    if not exist "%KITTY_CONFIG_DIR%\settings" if not exist "%KITTY_CONFIG_DIR%\clink_settings" (
        echo Generating Clink initial settings in "%KITTY_CONFIG_DIR%\clink_settings"
        copy "%KITTY_ROOT%\etc\clink_settings.default" "%KITTY_CONFIG_DIR%\clink_settings"
        echo Additional *.lua files in "%KITTY_CONFIG_DIR%" are loaded on startup.
    )

    if not exist "%KITTY_CONFIG_DIR%\kitty_prompt_config.lua" (
        echo Creating Kitty prompt config file: "%KITTY_CONFIG_DIR%\kitty_prompt_config.lua"
        copy "%KITTY_ROOT%\etc\kitty_prompt_config.lua.default" "%KITTY_CONFIG_DIR%\kitty_prompt_config.lua"
    )

    :: Cleanup legacy Clink Settings file
    if exist "%KITTY_CONFIG_DIR%\settings" if exist "%KITTY_CONFIG_DIR%\clink_settings" (
        del "%KITTY_CONFIG_DIR%\settings"
    )

    :: Cleanup legacy Clink history file
    if exist "%KITTY_CONFIG_DIR%\.history" if exist "%KITTY_CONFIG_DIR%\clink_history" (
        del "%KITTY_CONFIG_DIR%\.history"
    )

    "%KITTY_ROOT%\opt\clink\clink_%clink_architecture%.exe" inject --quiet --profile "%KITTY_CONFIG_DIR%" --scripts "%KITTY_ROOT%\lib"

    :: Check if a fatal error occurred when trying to inject Clink
    if errorlevel 2 (
        %print_error% "Clink injection has failed with error code: %errorlevel%"
        goto :SKIP_CLINK
    )

    goto :CLINK_FINISH

:SKIP_CLINK
    %print_warning% "Skipping Clink Injection!"

    for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
    chcp 65001>nul

    :: Revert back to plain cmd.exe prompt without clink
    prompt $E[1;32;49m$P$S$_$E[1;30;49m>$S$E[0m

    chcp %cp%>nul

:CLINK_FINISH

if "%KITTY_CONFIGURED%" GTR "1" (
    %print_verbose% "Kitty is already configured, skipping Kitty Init!"

    goto :USER_ALIASES
) else if "%KITTY_CONFIGURED%" == "1" (
    %print_verbose% "Kitty is already configured, skipping to Kitty User Init!"

    goto :USER_CONFIG_START
)

:PATH_ENHANCE
%lib_path% enhance_path "%KITTY_ROOT%\bin"

:USER_CONFIG_START
%lib_path% enhance_path_recursive "%KITTY_ROOT%\bin" 0 %max_depth%
if defined KITTY_USER_BIN (
    %lib_path% enhance_path_recursive "%KITTY_USER_BIN%" 0 %max_depth%
)

:: Drop *.bat and *.cmd files into "%KITTY_ROOT%\config\profile.d"
:: to run them at startup.
%lib_profile% run_profile_d "%KITTY_ROOT%\config\profile.d"
if defined KITTY_USER_CONFIG (
    %lib_profile% run_profile_d "%KITTY_USER_CONFIG%\profile.d"
)

:USER_ALIASES
:: Allows user to override default aliases store using profile.d
:: scripts run above by setting the 'aliases' env variable.
::
:: Note: If overriding default aliases store file the aliases
:: must also be self executing, see '.\user_aliases.cmd.default',
:: and be in profile.d folder.
if not defined user_aliases (
    set "user_aliases=%KITTY_CONFIG_DIR%\user_aliases.cmd"
)

if "%KITTY_ALIASES%" == "1" (
    REM The aliases environment variable is used by alias.bat to id
    REM the default file to store new aliases in.
    if not defined aliases (
        set "aliases=%user_aliases%"
    )

    REM Make sure we have a self-extracting user_aliases.cmd file
    if not exist "%user_aliases%" (
        echo Creating initial user_aliases store in "%user_aliases%"...
        copy "%KITTY_ROOT%\etc\user_aliases.cmd.default" "%user_aliases%"
    ) else (
        %lib_base% update_legacy_aliases
    )

    :: Update old 'user_aliases' to new self executing 'user_aliases.cmd'
    if exist "%KITTY_ROOT%\config\aliases" (
        echo Updating old "%KITTY_ROOT%\config\aliases" to new format...
        type "%KITTY_ROOT%\config\aliases" >> "%user_aliases%"
        del "%KITTY_ROOT%\config\aliases"
    ) else if exist "%user_aliases%.old_format" (
        echo Updating old "%user_aliases%" to new format...
        type "%user_aliases%.old_format" >> "%user_aliases%"
        del "%user_aliases%.old_format"
    )
)

:: Add aliases to the environment
type "%user_aliases%" | findstr /b /l /i "history=cat " >nul
if "%ERRORLEVEL%" == "0" (
    echo Migrating alias 'history' to new Clink 1.x.x...
    call "%KITTY_ROOT%\bin\alias.cmd" /d history
    echo Restart the session to activate changes!
)

call "%user_aliases%"

if "%KITTY_CONFIGURED%" gtr "1" goto :KITTY_CONFIGURED

:: Set home path
if not defined HOME set "HOME=%USERPROFILE%"
%print_debug% init.bat "Env Var - HOME=%HOME%"

set "initialConfig=%KITTY_ROOT%\config\user_profile.cmd"
if exist "%KITTY_ROOT%\config\user_profile.cmd" (
    REM Create this file and place your own command in there
    %print_debug% init.bat "Calling - %KITTY_ROOT%\config\user_profile.cmd"
    call "%KITTY_ROOT%\config\user_profile.cmd"
)

if defined KITTY_USER_CONFIG (
    set "initialConfig=%KITTY_USER_CONFIG%\user_profile.cmd"
    if exist "%KITTY_USER_CONFIG%\user_profile.cmd" (
        REM Create this file and place your own command in there
        %print_debug% init.bat "Calling - %KITTY_USER_CONFIG%\user_profile.cmd"
        call "%KITTY_USER_CONFIG%\user_profile.cmd"
    )
)

if not exist "%initialConfig%" (
    echo Creating user startup file: "%initialConfig%"
    copy "%KITTY_ROOT%\etc\user_profile.cmd.default" "%initialConfig%"
)

if "%KITTY_ALIASES%" == "1" if exist "%KITTY_ROOT%\bin\alias.bat" if exist "%KITTY_ROOT%\bin\alias.cmd" (
    echo Kitty's 'alias' command has been moved into "%KITTY_ROOT%\bin\alias.cmd"
    echo to get rid of this message either:
    echo.
    echo Delete the file "%KITTY_ROOT%\bin\alias.bat"
    echo.
    echo or
    echo.
    echo If you have customized it and want to continue using it instead of the included version
    echo   * Rename "%KITTY_ROOT%\bin\alias.bat" to "%KITTY_ROOT%\bin\alias.cmd".
    echo   * Search for 'user-aliases' and replace it with 'user_aliases'.
)

set initialConfig=

:KITTY_CONFIGURED
if not defined KITTY_CONFIGURED set KITTY_CONFIGURED=1

set KITTY_INIT_END=%time%

if %time_init% gtr 0 (
    "%kitty_root%\bin\timer.cmd" "%KITTY_INIT_START%" "%KITTY_INIT_END%"
)
exit /b
