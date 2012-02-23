@echo off
goto :comment_end
-------------------------------------------------------------------------------
This is a shell for Windows, can be used to generate jsdoc for objectjs

NOTICE: You should modify JSDOC_ROOT and BROWSER_PATH property before run this shell.

@usage : 
  	1. runjsdoc       (will generate jsdoc)
	2. runjsdoc -o    (will generate jsdoc, and open a html file with specified browser)

@example
	project
  		|--- src
  		|--- doc
			  |--- jsdoc (auto-generated)
  	cd project dir --> runjsdoc
  	cd project dir --> runjsdoc -o

@version 0.1
@author wangjeaf

MODIFICATIONS:
	1. just remove html files in doc dir, do not remove sub directory files
	2. output html files into /doc/jsdoc dir, not /doc dir
	3. remove a.html#b if a.html exists, not rename
-------------------------------------------------------------------------------
:comment_end

REM ---------------- set constants, should be modified by user ----------------
set JSDOC_ROOT=D:\workhome\jsdoc
set BROWSER_PATH="D:\Program Files\chrome-win32\chrome.exe"

if not exist %JSDOC_ROOT%\jsdoc.js (
	echo [ERROR] Wrong jsdoc dir : %JSDOC_ROOT%
	goto :finish
)

REM ---------------- set constants ----------------
set DISK=%CD:~0,2%
set ROOT_PATH="%CD%"
set SRC_DIR="%CD%\src"
set DOC_DIR="%CD%\doc"
set OUT_DIR="%CD%\doc\jsdoc"
set RM_FILE="%CD%\doc\jsdoc\*.html"
set CSS_DIR="%CD%\doc\jsdoc\styles"
set "ARG=%1"

if not exist %SRC_DIR% (
	echo [ERROR] No src dir in "%CD%"
	goto :finish
)

if not "%ARG%" == "-o" (
	if not "%ARG%" == "" (
		echo [ERROR] Args error!
		goto :usage
	)
)

REM ---------------- remove exist files ----------------
echo [INFO] Removing exist doc files in %OUT_DIR%
if not exist %DOC_DIR% (
	mkdir %DOC_DIR%
)
if not exist %OUT_DIR% (
	mkdir %OUT_DIR%
)

if exist %RM_FILE% (
	del /f /q %RM_FILE%
)
if exist %CSS_DIR% (
	del /f /q %CSS_DIR%
	rmdir %CSS_DIR%
)

REM ---------------- generate jsdoc ----------------
%JSDOC_ROOT:~0,2%
cd %JSDOC_ROOT%
echo [INFO] Generating jsdoc for %SRC_DIR%
java -cp %JSDOC_ROOT%\lib\js.jar org.mozilla.javascript.tools.shell.Main -modules node_modules -modules rhino_modules -modules plugins %JSDOC_ROOT%\jsdoc.js %SRC_DIR% -r 10 -d %OUT_DIR% -p

REM ---------------- rename a.html#b to a.html, just in case ----------------
%DISK%
cd %OUT_DIR%
for /r %OUT_DIR% %%a in (*.html#*) do (
	if not exist "%%~na.html" (
		ren %%a %%~na.html
	) else (
		del "%%a"
	)
)
%DISK%
cd %ROOT_PATH%

REM ---------------- open one generated html file with browser specified if in open mode ----------------
if "%ARG%" == "-o" (
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
goto :exit

:usage
echo [Usage] :
echo   1. runjsdoc
echo   2. runjsdoc -o (will open html automatically)

:exit
