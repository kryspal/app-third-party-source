# Components with source in the Releases

The versions are those in the most recent app builds when this file was written; each Release's manifest has the exact ones for its build.

## Android

| Component | Version | License | Upstream | How it is in the app |
| --- | --- | --- | --- | --- |
| FFmpeg | 9.0.2 | LGPL-2.1-or-later | https://ffmpeg.org/releases/ | libavcodec, libavutil, libswresample, libswscale and libavfilter are linked statically into the app's `libffmpegJNI.so`, which the app loads through JNI. Built without GPL, version3 or nonfree options; no patches |
| FriBidi | 1.0.16 | LGPL-2.1-or-later | https://github.com/fribidi/fribidi | Linked statically into `libass.so` from the libass-android 0.5.1 library (https://github.com/peerless2012/libass-android, commit `504f64a`), which is used as built; no patches |

## Apple (iOS, tvOS, macOS)

| Component | Version | License | Upstream | How it is in the app |
| --- | --- | --- | --- | --- |
| mpv | 0.41.0 | LGPL-2.1-or-later | https://github.com/mpv-player/mpv | One dynamic `Libmpv` framework per platform, with the libraries below linked into it |
| FFmpeg | 9.0.2 | LGPL-2.1-or-later | https://github.com/FFmpeg/FFmpeg | In the `Libmpv` framework; built without GPL or version3; the build patches are in the Release |
| libplacebo | 7.360.1 | LGPL-2.1-or-later | https://code.videolan.org/videolan/libplacebo | In the `Libmpv` framework |
| FriBidi | 1.0.16 | LGPL-2.1-or-later | https://github.com/fribidi/fribidi | In the `Libmpv` framework |
| AetherEngine | 7.44.0 | LGPL-3.0 with an App Store exception | https://github.com/superuser404notfound/AetherEngine | Statically in the app's own player framework; not modified |
| FFmpeg (second build) | 8.1.3 | LGPL-2.1-or-later | https://github.com/superuser404notfound/FFmpegBuild | Dynamic frameworks next to the player framework |
| libzvbi | 0.2.45 | LGPL-2.1-or-later | https://github.com/zapping-vbi/zvbi | Dynamic framework next to the player framework |

## Windows

| Component | Version | License | Upstream | How it is in the app |
| --- | --- | --- | --- | --- |
| mpv (libmpv) | see the Release manifest | LGPL-2.1-or-later | https://github.com/mpv-player/mpv | `libmpv-2.dll`, built with the GPL parts off |
| FFmpeg | see the Release manifest | LGPL-2.1-or-later | https://github.com/FFmpeg/FFmpeg | Built into the same library |
| libplacebo | see the Release manifest | LGPL-2.1-or-later | https://code.videolan.org/videolan/libplacebo | Built into the same library |
| Other libraries of that build | see the Release manifest | various; each package's source archive is in the Release | | |
| Eclipse Temurin (OpenJDK) | 21.0.12.1+1 | GPL-2.0 with the Classpath Exception | https://github.com/adoptium/jdk21u | The Java runtime in the app, not modified; the source for the tag is in the Release |
