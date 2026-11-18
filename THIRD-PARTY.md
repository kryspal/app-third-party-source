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
| libplacebo | 7.360.1 | LGPL-2.1-or-later | https://github.com/haasn/libplacebo (tag v7.360.1, cee9b076f2c63104ccfd497fa79c39a867293ec4) | In the `Libmpv` framework; prebuilt static library, no patches (see below) |
| FriBidi | 1.0.16 | LGPL-2.1-or-later | https://github.com/fribidi/fribidi (tag v1.0.16, 68162babff4f39c4e2dc164a5e825af93bda9983) | In the `Libmpv` framework; prebuilt static library, no patches (see below) |
| uchardet | 0.0.8 | MPL-1.1, GPL-2.0-or-later or LGPL-2.1-or-later (offered here under LGPL-2.1-or-later or MPL-1.1) | https://gitlab.freedesktop.org/uchardet/uchardet (tag v0.0.8, ae6302a016088ad07177f86d417b20010053632b) | In the `Libmpv` framework; prebuilt static library, no patches (see below) |
| AetherEngine | 7.44.0 | LGPL-3.0 with an App Store exception | https://github.com/superuser404notfound/AetherEngine | Statically in the app's own player framework; not modified |
| FFmpeg (second build) | 8.1.3 | LGPL-2.1-or-later | https://github.com/superuser404notfound/FFmpegBuild (pinned commit 3b398c8f) | Dynamic frameworks next to the player framework. The Release holds the upstream FFmpeg source plus the build repository with its ten patches, pinned by commit, without binaries |
| libzvbi | 0.2.45 | LGPL-2.1-or-later | https://github.com/zapping-vbi/zvbi | Dynamic framework next to the player framework |

**Where the prebuilt Apple libraries come from.** FFmpeg and mpv in the `Libmpv` framework are built from source by the MPVKit project
(with the two patches of this app, `mpvkit-formats.patch` and `mpvkit-no-tls.patch`). libplacebo, FriBidi and uchardet are downloaded by
MPVKit as prebuilt static libraries from its build projects (mpvkit/libplacebo-build 7.360.1, mpvkit/libass-build 0.17.5,
mpvkit/libuchardet-build 0.0.8). The Release holds the upstream source of each at the tag above and the build project that made it.
The shared build package those projects use (mpvkit/BuildShared) is pinned in the Release manifest by the last commit before the build
started; that commit is inferred, because the build logs are past GitHub's retention. These builds are not patched: the build projects
have no patch directory at the pinned commit. The libraries of permissive licenses that come the same way (libass, HarfBuzz, FreeType,
libunibreak, dav1d, Little CMS, libdovi, shaderc, glslang, MoltenVK, LuaJIT) are listed on the app's open-source licenses page.

The Release also holds the build repositories of the dual-layer Dolby Vision engine's libraries, pinned by commit and without binaries: FFmpegBuild (3b398c8f), LibDovi (0d7cce1d) and LibTrueHD (aebd5ffe). Their licenses are in those repositories and in the Release manifest.

## Windows

| Component | Version | License | Upstream | How it is in the app |
| --- | --- | --- | --- | --- |
| mpv (libmpv) | see the Release manifest | LGPL-2.1-or-later | https://github.com/mpv-player/mpv | `libmpv-2.dll`, built with the GPL parts off |
| FFmpeg | see the Release manifest | LGPL-2.1-or-later | https://github.com/FFmpeg/FFmpeg | Built into the same library |
| libplacebo | see the Release manifest | LGPL-2.1-or-later | https://code.videolan.org/videolan/libplacebo | Built into the same library |
| Other libraries of that build | see the Release manifest | various; each package's source archive is in the Release | | |
| Eclipse Temurin (OpenJDK) | 21.0.12.1+1 | GPL-2.0 with the Classpath Exception | https://github.com/adoptium/jdk21u | The Java runtime in the app, not modified; the source for the tag is in the Release |
