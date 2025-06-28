export PATH=/Master/Android/Sdk/platform-tools:$PATH
export GRADLE_HOME=/Master/Android/gradle-8.5
export PATH=$PATH:$GRADLE_HOME/bin
. ~/.bashrc
gradlew build
