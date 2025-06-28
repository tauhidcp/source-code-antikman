export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd C:\fpcupdeluxe\projects\LAMWProjects\antikman\utils\unix\
jarsigner -verify -verbose -certs /fpcupdeluxe/projects/LAMWProjects/antikman/build/outputs/apk/release/antikman-release.apk
