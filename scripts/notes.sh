#!/usr/bin/env bash
# Writes the text of a Release's notes to stdout.
#   scripts/notes.sh new <platform> <version> <run-url>
#   scripts/notes.sh add <platform> <version> <old-notes-file>   the old notes with <version> added to the first line
# The first line says which app versions the source belongs to: "Used by Kryspal Player for Android 0.1.74 and 0.1.75."
set -euo pipefail
mode="${1:?mode}"; platform="${2:?platform}"; version="${3:?version}"
case "$platform" in android) label=Android ;; apple) label="Apple platforms" ;; windows) label=Windows ;; *) echo "error: unknown platform" >&2; exit 2 ;; esac
rest='The files, with their SHA-256 sums, are listed in RELEASE-MANIFEST.txt. How to rebuild is in the README.'

sentence() { # versions as arguments
  local list="" n=$#
  case "$n" in 1) list="$1" ;; 2) list="$1 and $2" ;; *) list="$(printf '%s, ' "${@:1:n-1}" | sed 's/, $//') and ${!n}" ;; esac
  printf 'Used by Kryspal Player for %s %s.' "$label" "$list"
}

case "$mode" in
  new)
    printf '%s\n\n%s Uploaded by %s\n' "$(sentence "$version")" "$rest" "${4:?run url}" ;;
  add)
    old="${4:?old notes file}"
    first="$(head -n 1 "$old")"
    # Versions already named on the first line, then the new one; a version is never listed twice.
    mapfile -t vs < <(printf '%s\n' "$first" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+([-.][0-9A-Za-z.]+)?[0-9A-Za-z]' | sed 's/\.$//' || true)
    for v in "${vs[@]:-}"; do [ "$v" = "$version" ] && { cat "$old"; exit 0; }; done
    vs+=("$version")
    { sentence "${vs[@]}"; printf '\n'; tail -n +2 "$old"; } ;;
  *) echo "error: unknown mode" >&2; exit 2 ;;
esac
