export PATH=/Master/Android/Sdk/platform-tools:$PATH
export PATH=/Master/Android/Sdk/build-tools/30.0.3:$PATH
export GRADLE_HOME=/Master/Android/gradle-8.5
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /fpcupdeluxe/projects/LAMWProjects/antikman/build/outputs/apk/release/antikman-arm64-v8a-release-unsigned.apk /fpcupdeluxe/projects/LAMWProjects/antikman/build/outputs/apk/release/antikman-arm64-v8a-release-unsigned-aligned.apk
apksigner sign --ks /fpcupdeluxe/projects/LAMWProjects/antikman/antikman-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /fpcupdeluxe/projects/LAMWProjects/antikman/build/outputs/apk/release/antikman-release.apk /fpcupdeluxe/projects/LAMWProjects/antikman/build/outputs/apk/release/antikman-arm64-v8a-release-unsigned-aligned.apk
