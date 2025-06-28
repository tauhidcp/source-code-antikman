set JAVA_HOME=C:\Program Files\Zulu\zulu-21
path %JAVA_HOME%\bin;%path%
cd C:\fpcupdeluxe\projects\LAMWProjects\antikman\utils\windows\
jarsigner -verify -verbose -certs C:\fpcupdeluxe\projects\LAMWProjects\antikman\bin\antikman-release.apk
