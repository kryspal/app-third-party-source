# Replacing an LGPL library in the app

The LGPL gives you the right to modify the libraries listed in [THIRD-PARTY.md](THIRD-PARTY.md) and to use your modified version in place
of the one the app ships. This page says what that means on each platform. The source and build files for your app version are in the
Release tagged `app-<version>-<platform>` (see the [README](README.md)).

The libraries are linked in a way that lets you rebuild and swap them. The app's own code is not part of this offer, and the app's
license terms and the stores' rules still apply to the app itself.

## Android

FFmpeg is linked into one shared library, `libffmpegJNI.so`, inside the app package. The libass library (which contains FriBidi) is a
separate shared library in the same package.

1. Build the library from the Release files as described in the README, with the same NDK and the options in the manifest.
2. Replace the library under `lib/<abi>/` in the app package (an `.apk` is a zip file).
3. Sign the package with your own key and install it. A package signed with a different key cannot update the store version; uninstall that
   first.

## Apple (iOS, tvOS, macOS)

The libraries are built into one dynamic `Libmpv` framework per platform. Rebuild the framework with `build-core.sh` from the Release
(it applies the patches shown in the Release), then replace the framework inside the app bundle and sign the bundle with your own
developer identity. Running a modified app on a device needs your own signing certificate and provisioning profile.

## Windows

`libmpv-2.dll` sits next to the app's executable. Rebuild it from the source archive and build recipe in the Release, then copy your
`libmpv-2.dll` over the shipped one. No signing step is needed for a local copy.

## Help

If a step does not work with the files in a Release, open an issue here with the app version and platform, or write to
support@kryspal.net.
