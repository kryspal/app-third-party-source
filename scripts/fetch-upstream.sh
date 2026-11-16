#!/usr/bin/env bash
# Usage: scripts/fetch-upstream.sh <android|windows|apple> <output-dir>
# Fetches the upstream source archives for a platform that the app build does not produce, checks each against the pinned commit
# in upstream/pins.env, and writes the archives into <output-dir>.
set -euo pipefail
platform="${1:?platform}"; out="${2:?output dir}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../upstream/pins.env
. "$here/upstream/pins.env"
mkdir -p "$out"
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT

fetch() { # name url tag commit submodules(yes|no)
  local name="$1" url="$2" tag="$3" commit="$4" subs="$5" dir="$work/$1"
  git clone -q --depth 1 --branch "$tag" "$url" "$dir"
  [ "$(git -C "$dir" rev-parse HEAD)" = "$commit" ] || { echo "error: $name $tag is not $commit" >&2; exit 1; }
  if [ "$subs" = yes ]; then git -C "$dir" submodule update --init --recursive --depth 1 -q; fi
  tar --exclude-vcs -C "$work" -czf "$out/$name-$tag.tar.gz" --transform "s#^$name#$name-$tag#" "$name"
}

case "$platform" in
  android) fetch libass-android "$LIBASS_ANDROID_URL" "$LIBASS_ANDROID_TAG" "$LIBASS_ANDROID_COMMIT" yes ;;
  windows) fetch jdk21u "$TEMURIN_URL" "$TEMURIN_TAG" "$TEMURIN_COMMIT" no ;;
  apple) ;; # the Apple build produces every archive it needs
  *) echo "error: unknown platform $platform" >&2; exit 2 ;;
esac
