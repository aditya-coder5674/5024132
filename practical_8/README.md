# Practical 8: Device Storage

This Material 3 Flutter app demonstrates asynchronous text-file storage.

## Install and run

From the repository root:

```sh
cd practical_8
flutter pub get
flutter run
```

This checkout includes a Windows desktop target, which exercises native
filesystem access when run on Windows:

```sh
flutter run -d windows
```

For Android, this checkout does not yet include Android platform scaffolding.
Generate it once from `practical_8`, then choose an Android emulator or
connected device:

```sh
flutter create --platforms=android .
flutter run
```

On Android, the app creates `practical_8_sample.txt` in the directory returned by
`getApplicationDocumentsDirectory()`, writes the sample sentence, then reads
the file back. The UI displays the returned directory path, actual file
contents, successful read count, and time of the latest successful read.
Tap **Write and read again** to repeat the operation.

## Web preview

Run `flutter run -d chrome` to preview the interface in a browser. Flutter Web
does not use `path_provider` and `dart:io` to access a device documents
directory. The web build uses `shared_preferences` browser local storage as a
separate web-compatible demonstration, clearly labeled in the app. It does
not create a native text file or claim native filesystem access.

## Verify

```sh
flutter analyze
flutter test
```
