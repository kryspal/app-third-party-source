# app-third-party-source

Source code, patches and build files for the third-party open-source components used by Kryspal Player on each platform (Android, Apple and Windows).

Some components in the apps are licensed under the GNU Lesser General Public License (LGPL) or similar terms that require the source code
to be available. This repository is where it is. The code is not kept in the repository itself: **each app release has a matching Release
here**, with the source archives and build files of that exact app version attached.

If you want to change one of these libraries and use your version in the app, see [REPLACING.md](REPLACING.md).

## Where to find the source for your version

1. Open the app's About screen (or its open-source licenses page) and note the app version and platform.
2. Open the [Releases](../../releases) of this repository and take the newest one for your platform whose tag version is
   not later than yours. The tag is `app-<version>-<platform>`, for example `app-1.0.0-android`; the notes say "Applies to Kryspal Player
   for Android 1.0.0 and every later version, until a newer source release for Android is published", because a new Release is made only
   when the source changes. The platform is `android`, `apple` or `windows`. If a Release was issued again, its tag
   ends in `-r2`, `-r3` and so on; the highest one is the latest.
3. Every Release has a `RELEASE-MANIFEST.txt` listing its files and a `SHA256SUMS` file. Check the files with
   `sha256sum --check SHA256SUMS`.

A Release is never changed after it is published.

## What is in a Release

| Platform | Components with source here | What the Release holds |
| --- | --- | --- |
| Android | FFmpeg (LGPL-2.1-or-later), FriBidi (LGPL-2.1-or-later, inside the libass library) | The FFmpeg release archive and its signature; the build scripts and JNI glue that link FFmpeg into the app (the app's own, small, Apache-2.0 code); the source of the libass library that contains FriBidi, with its submodules |
| Apple (iOS, tvOS, macOS) | mpv, FFmpeg, libplacebo, FriBidi, uchardet (all LGPL-2.1-or-later; uchardet also under MPL-1.1); AetherEngine (LGPL-3.0 with an App Store exception) and the FFmpeg and libzvbi builds next to it | The source trees as built, the patches applied to them, and the scripts that build the frameworks |
| Windows | libmpv with the FFmpeg and libplacebo it is built from (LGPL-2.1-or-later), and the libraries of its build; the Java runtime (Eclipse Temurin, GPLv2 with the Classpath Exception) | The source archive of that libmpv build with its build recipe and build record, the built library, and the unmodified Temurin source |

Components under permissive licenses (MIT, BSD, Apache-2.0 and the like) do not require source to be offered and are listed, with their
licenses, in the app's open-source licenses page. [THIRD-PARTY.md](THIRD-PARTY.md) lists the components with source here and where each
comes from.

## Rebuilding

Each Release contains what is needed to rebuild the LGPL components and link them into the app again. The details differ by platform; each
Release's `MANIFEST` file (inside the build archive) gives the exact versions, configure options and the order of steps.

- **Android.** Run the build script in the FFmpeg build archive with Android NDK r26b. It checks the FFmpeg archive, builds the static
  libraries for the four ABIs and links them into `libffmpegJNI.so` with CMake. The libass library, which contains FriBidi, is built from the
  libass source archive with its own CMake files and submodules.
- **Apple.** Run `build-core.sh` from the scripts directory against a checkout of the build framework named in the manifest. It applies the
  patches, builds each platform and links one dynamic `Libmpv` framework per platform. This needs macOS with Xcode and the tools listed in the manifest.
- **Windows.** Unpack the source archive; its build recipe and build record say how the library was built. It needs a Linux container with
  the toolchain named in the record, and produces `libmpv-2.dll`.

If something is missing or does not rebuild, open an issue here with the app version and platform.

## Written offer

If you received one of the apps, you may ask for the source of its LGPL components for the version you have, on any medium customary for
software exchange, for at most the cost of making the copy. Open an issue here, or write to support@kryspal.net. The Releases
are the normal way and cost nothing.

## How the Releases are made

The apps' release builds produce their source files in the same run as the app package (for Windows, on a release of the library build),
so the versions match. The `Upload sources` workflow in this repository (`.github/workflows/upload-sources.yml`) is started by hand with the
run's ID or release tag. It checks the files against their checksums,
adds the upstream archives that the app build does not produce (`upstream/pins.env`, pinned by commit), and compares the result with the
latest Release of the same platform (`scripts/same-source.sh`). If the source is the same, it stops and makes no new Release. Otherwise it creates one. It never replaces the files of a Release that exists.

## License

The text and scripts in this repository are licensed under the Apache License 2.0 (see `LICENSE`). The components in the Releases keep
their own licenses, which are in their archives.
