export JAVA_HOME=/Program Files/Zulu/zulu-21
cd /fpcupdeluxe/projects/LAMWProjects/antikman
LC_ALL=C keytool -genkey -v -keystore antikman-release.keystore -alias antikman.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /fpcupdeluxe/projects/LAMWProjects/antikman/keytool_input.txt
