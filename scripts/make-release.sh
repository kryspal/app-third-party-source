#!/usr/bin/env bash
# Usage: scripts/make-release.sh <platform> <app-version> <artifact-dir> <release-dir>
# Collects what a Release holds: the files the app build produced, checked against their own SHA256SUMS, plus the upstream archives from
# fetch-upstream.sh, a MANIFEST of the whole, and one SHA256SUMS over everything. Fails on a missing or mismatching file.
set -euo pipefail
platform="${1:?platform}"; version="${2:?app version}"; art="${3:?artifact dir}"; rel="${4:?release dir}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$rel"

# 1. Find the files the app build produced. Each platform's artifact has its own layout and carries a SHA256SUMS next to its files.
case "$platform" in
  android) root="$art" ;;
  windows) root="$art" ;;
  apple)   root="$(find "$art" -maxdepth 2 -type d -name 'kryspal-apple-source-*' | head -n 1)"; [ -n "$root" ] || { echo "error: no kryspal-apple-source-* directory" >&2; exit 1; } ;;
  *) echo "error: unknown platform $platform" >&2; exit 2 ;;
esac
[ -f "$root/SHA256SUMS" ] || { echo "error: $root/SHA256SUMS is missing" >&2; exit 1; }
(cd "$root" && sha256sum --check --strict --quiet SHA256SUMS)
# Apple's files sit in subdirectories and are published as one archive per platform release; the others are flat.
if [ "$platform" = apple ]; then
  tar -C "$(dirname "$root")" -czf "$rel/$(basename "$root").tar.gz" "$(basename "$root")"
else
  find "$root" -maxdepth 1 -type f ! -name SHA256SUMS -exec cp -f {} "$rel"/ \;
  cp -f "$root/SHA256SUMS" "$rel/SHA256SUMS.app-build"
fi

# 2. Upstream archives that the app build does not produce.
"$here/scripts/fetch-upstream.sh" "$platform" "$rel"

# 3. Manifest and sums over what is in the Release.
{
  echo "App version: $version"; echo "Platform: $platform"; echo "Built from: ${GITHUB_RUN_ID:-local}"
  echo; echo "Files:"; (cd "$rel" && ls -1 | grep -v '^SHA256SUMS$' | sed 's/^/  /')
} > "$rel/RELEASE-MANIFEST.txt"
(cd "$rel" && sha256sum $(ls -1 | grep -v '^SHA256SUMS$') > SHA256SUMS)
echo "release files:"; ls -l "$rel"
