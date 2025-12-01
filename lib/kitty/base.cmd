@echo off

set lib_base=call "%~dp0base.cmd"

if "%~1" == "/h" (
    %lib_base% help "%~0"
) else if "%1" neq "" (
    call :%*
)

exit /b

:help
:::===============================================================================
:::show_subs - shows all sub routines in a .bat/.cmd file with documentation
:::.
:::include:
:::.
:::       call "lib_base.cmd"
:::.
:::usage:
:::.
:::       %lib_base% show_subs "file"
:::.
:::options:
:::.
:::       file <in> full path to file containing lib_routines to display
:::.
:::-------------------------------------------------------------------------------
    for /f "tokens=* delims=:" %%a in ('type "%~1" ^| %WINDIR%\System32\findstr /i /r "^:::"') do (
        rem echo a="%%a"

        if "%%a"=="." (
            echo.
        ) else if /i "%%a" == "usage" (
            echo %%a:
        ) else if /i "%%a" == "options" (
            echo %%a:
        ) else if not "%%a" == "" (
            echo %%a
        )
    )

    pause
    exit /b

:kitty_shell
:::===============================================================================
:::show_subs - shows all sub routines in a .bat/.cmd file with documentation
:::.
:::include:
:::.
:::       call "lib_base.cmd"
:::.
:::usage:
:::.
:::       %lib_base% kitty_shell
:::.
:::options:
:::.
:::       file <in> full path to file containing lib_routines to display
:::.
:::-------------------------------------------------------------------------------
    call :detect_comspec %ComSpec%
    exit /b

:detect_comspec
    set KITTY_SHELL=%~n1
    if not defined KITTY_CLINK (
        set KITTY_CLINK=1
    )
    if not defined KITTY_ALIASES (
        set KITTY_ALIASES=1
    )
    exit /b

:update_legacy_aliases
    type "%user_aliases%" | %WINDIR%\System32\findstr /i ";= Add aliases below here" >nul
    if "%errorlevel%" == "1" (
        echo Creating initial user_aliases store in "%user_aliases%"...
        if defined KITTY_USER_CONFIG (
            copy "%user_aliases%" "%user_aliases%.old_format"
            copy "%KITTY_ROOT%\etc\default\aliases.cmd.default" "%user_aliases%"
        ) else (
            copy "%user_aliases%" "%user_aliases%.old_format"
            copy "%KITTY_ROOT%\etc\default\aliases.cmd.default" "%user_aliases%"
        )
    )
    exit /b
