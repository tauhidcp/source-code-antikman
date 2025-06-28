set JAVA_HOME=C:\Program Files\Zulu\zulu-21
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\fpcupdeluxe\projects\LAMWProjects\antikman
keytool -genkey -v -keystore antikman-release.keystore -alias antikman.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\fpcupdeluxe\projects\LAMWProjects\antikman\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
