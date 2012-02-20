@echo off
REM ---------------- set constants ----------------
set OBJECTROOT=D:\workhome\workspace\objectjs.org\object
set JSDOCROOT=D:\workhome\jsdoc
set BrowserPath=D:\"Program Files"\chrome-win32\chrome.exe

set OUTDIR=%JSDOCROOT%\out
set Target=test
REM set Target=object 
if %Target%==test (
	set SRCCODE=%JSDOCROOT%\for_object\
) else (
	set SRCCODE=%OBJECTROOT%\src\
) 

REM ---------------- remove exist dirs and files ----------------
if exist %OUTDIR% (
	del %OUTDIR% /Q /F /S
)
if exist %OUTDIR%\styles (
	rmdir %OUTDIR%\styles
)

REM ---------------- generate jsdoc ----------------
echo [INFO] generating jsdoc for %SRCCODE%
if %Target%==test (
	java -cp %JSDOCROOT%\lib\js.jar org.mozilla.javascript.tools.shell.Main -modules node_modules -modules rhino_modules -modules plugins %JSDOCROOT%\jsdoc.js %SRCCODE% -d %OUTDIR% -p
) else (
	java -cp %JSDOCROOT%\lib\js.jar org.mozilla.javascript.tools.shell.Main -modules node_modules -modules rhino_modules -modules plugins %JSDOCROOT%\jsdoc.js %SRCCODE% -r -d %OUTDIR% -p
) 

REM ---------------- rename a.html#b to a.html ----------------
for /r "%OUTDIR%" %%a in (*.html#*) do (
	ren %%a %%~na.html
)

REM ---------------- open one jsdoc file with chrome ----------------
for /r "%OUTDIR%" %%a in (*.html) do ( 
	start %BrowserPath% %%a
	goto :finish
) 
:finish
