set Path=%PATH%;D:\Master\Android\Sdk\platform-tools;D:\Master\Android\Sdk\build-tools\30.0.3
set GRADLE_HOME=D:\Master\Android\gradle-8.5
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\fpcupdeluxe\projects\LAMWProjects\antikman\build\outputs\apk\release\antikman-universal-release-unsigned.apk C:\fpcupdeluxe\projects\LAMWProjects\antikman\build\outputs\apk\release\antikman-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\fpcupdeluxe\projects\LAMWProjects\antikman\antikman-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\fpcupdeluxe\projects\LAMWProjects\antikman\build\outputs\apk\release\antikman-release.apk C:\fpcupdeluxe\projects\LAMWProjects\antikman\build\outputs\apk\release\antikman-universal-release-unsigned-aligned.apk
