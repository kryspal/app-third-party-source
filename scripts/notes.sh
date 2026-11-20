#!/usr/bin/env bash
# Writes the notes of a new Release to stdout.
#   scripts/notes.sh <platform> <first-version> <run-url>
# The first line says which app versions the source applies to: the first one and every later one, until a newer source Release exists.
set -euo pipefail
platform="${1:?platform}"; version="${2:?first app version}"; url="${3:?run url}"
case "$platform" in android) label=Android ;; apple) label="Apple platforms" ;; windows) label=Windows ;; *) echo "error: unknown platform" >&2; exit 2 ;; esac
printf 'Applies to Kryspal Player for %s %s and every later version, until a newer source release for %s is published.\n\n' "$label" "$version" "$label"
printf 'The files, with their SHA-256 sums, are listed in RELEASE-MANIFEST.txt. How to rebuild is in the README. Uploaded by %s\n' "$url"
