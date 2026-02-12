# flutter_practice

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Scripts

```text
cd android

# gradle 8.7
# jdk 17

# local.properties
sdk.dir=YOUR_ANDROID_HOME(...Sdk)
flutter.sdk=YOUR_FLUTTER_HOME(...flutter)
flutter.buildMode=debug
flutter.versionName=1.0.0
flutter.versionCode=1

# gradle.properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true
org.gradle.java.home=YOUR_JDK17_HOME(...jdk17.0.18_9)

gradlew.bat clean
cd ..
flutter clean
flutter pub get
flutter build apk --debug
```
