goto :comment
This is a shell can be used to generate jsdoc for objectjs

NOTICE: You should modify JSDOC_ROOT and BROWSER_PATH property before run this shell.

@usage : 
  	1. runjsdoc	   		(will generate jsdoc)
	2. runjsdoc open	(will generate jsdoc, and open a html file with specified browser)

@example
	project
  		|--- src
  		|--- doc(auto-generated)
  	cd project dir --> runjsdoc open

@version 0.1
@author zhifu.wang
:comment

@echo off
REM ---------------- set constants, should be modified by user ----------------
set JSDOC_ROOT=D:\workhome\jsdoc
set BROWSER_PATH="D:\Program Files\chrome-win32\chrome.exe"

if not exist %JSDOC_ROOT%\jsdoc.js (
	echo [ERROR] Wrong jsdoc dir : %JSDOC_ROOT%
	goto :finish
)

REM ---------------- set dirs ----------------
set DISK=%CD:~0,2%
set CURRENT_PATH="%CD%"
set SRC_DIR="%CD%\src"
set OUT_DIR="%CD%\doc"
set "ARG=%1"

if not exist %SRC_DIR% (
	echo [ERROR] no src dir in "%CD%"
	goto :finish
)
REM ARG0 should be '' or 'open'
if not "%ARG%" == "open" (
	if not "%ARG%" == "" (
		echo [ERROR] args error!
		goto :usage
	)
)

REM ---------------- remove exist files ----------------
if exist "%CD%\doc" (
	del /f /s /q "%CD%\doc\"
)
if exist "%CD%\doc\styles" (
	rmdir "%CD%\doc\styles"
)

REM ---------------- generate jsdoc ----------------
%JSDOC_ROOT:~0,2%
cd %JSDOC_ROOT%
echo [INFO] generating jsdoc for %SRC_DIR%
java -cp %JSDOC_ROOT%\lib\js.jar org.mozilla.javascript.tools.shell.Main -modules node_modules -modules rhino_modules -modules plugins %JSDOC_ROOT%\jsdoc.js %SRC_DIR% -r 10 -d %OUT_DIR% -p

REM ---------------- rename a.html#b to a.html, just in case ----------------
for /r %OUT_DIR% %%a in (*.html#*) do (
	ren %%a %%~na.html
)

REM ---------------- open one generated html file with browser specified if in open mode----------------
if "%ARG%" == "open" (
	if not exist %BROWSER_PATH% (
		echo [ERROR] Wrong browser file path : %BROWSER_PATH%
		goto :finish
	)
	for /r %OUT_DIR% %%a in (*.html) do ( 
		start "" %BROWSER_PATH% "%%a"
		goto :finish
	) 
)

:finish
%DISK%
cd %CURRENT_PATH%
goto :exit

:usage
echo [Usage] 
echo   1. runjsdoc
echo   2. runjsdoc open(will open jsdoc file)
:exit
