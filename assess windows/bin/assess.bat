@echo off

@setlocal

set JAVA_OPTS="-mx512M"

set CLASSPATH=..\lib\commons-math-1.1.jar;..\lib\gsea-lib.jar;..\lib\javax.servlet.jar;..\lib\assess.jar

if "%JAVA_HOME%"=="" goto noJavaHome
if not exist "%JAVA_HOME%"\bin\java.exe goto noJava

set JAVACMD="%JAVA_HOME%"\bin\java.exe

%JAVACMD% %JAVA_OPTS% -cp %CLASSPATH% xapps.gsea.Main 
goto end


=====================================================================
                              ERRORS
=====================================================================


:noJavaHome
echo ERROR: JAVA_HOME not set! Aborting.
goto end

:noJava
echo ERROR: The Java VM (java.exe) was not found in %JAVA_HOME%\bin! Aborting
goto end


REM ================================================================
REM                             END
REM ================================================================
:end
@endlocal


