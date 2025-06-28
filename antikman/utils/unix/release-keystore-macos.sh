export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd C:\fpcupdeluxe\projects\LAMWProjects\antikman\utils\unix\
keytool -genkey -v -keystore antikman-release.keystore -alias antikman.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /fpcupdeluxe/projects/LAMWProjects/antikman/keytool_input.txt
