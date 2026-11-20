#!/usr/bin/env bash
# Usage: scripts/same-source.sh <release-dir-a> <release-dir-b>
# Exit 0 if the two Release directories hold the same source, 1 if they differ.
#
# "The same" means the content of the components, not the labels of one build. Per file:
#   - plain files (upstream archives, signatures) are compared by SHA-256;
#   - tar archives are compared by the SHA-256 of every file inside, so a different commit in the archive's name, a different top-level
#     directory name or different archive timestamps do not count as a difference;
#   - a commit id of 8 hex digits at the end of an archive's name is ignored when pairing files;
#   - the manifests and the sums files (MANIFEST*, RELEASE-MANIFEST.txt, SHA256SUMS*) describe one build and are left out.
# When in doubt it reports "different", which only means that a new Release is made.
set -euo pipefail
a="${1:?release dir a}"; b="${2:?release dir b}"

work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT

describe() { # <dir> <out-file>
  local dir="$1" out="$2" f name n tree top
  : > "$out"
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    case "$name" in MANIFEST*|RELEASE-MANIFEST.txt|SHA256SUMS*) continue ;; esac
    n="$(printf '%s' "$name" | sed -E 's/-[0-9a-f]{8}(\.(tar\.(gz|xz|bz2)|tgz))$/\1/')"
    case "$name" in
      *.tar.gz|*.tgz|*.tar.xz|*.tar.bz2)
        tree="$(mktemp -d -p "$work")"
        tar -xf "$f" -C "$tree"
        # A single top-level directory is only a wrapper whose name may carry the version; look inside it.
        top="$tree"
        if [ "$(find "$tree" -mindepth 1 -maxdepth 1 | wc -l)" -eq 1 ] && [ -d "$(find "$tree" -mindepth 1 -maxdepth 1)" ]; then
          top="$(find "$tree" -mindepth 1 -maxdepth 1)"
        fi
        # Nested archives are compared by their bytes; gzip timestamps can make equal content look different, which errs on "different".
        printf '%s\t%s\n' "$n" "$(cd "$top" && find . -type f ! -name 'MANIFEST*' ! -name 'SHA256SUMS*' -print0 | sort -z | xargs -0 -r sha256sum | sha256sum | cut -d' ' -f1)" >> "$out" ;;
      *)
        printf '%s\t%s\n' "$n" "$(sha256sum "$f" | cut -d' ' -f1)" >> "$out" ;;
    esac
  done
  LC_ALL=C sort -o "$out" "$out"
}

describe "$a" "$work/a.txt"
describe "$b" "$work/b.txt"
if [ ! -s "$work/a.txt" ] || [ ! -s "$work/b.txt" ]; then echo "error: a release directory has no files to compare" >&2; exit 2; fi
if diff -u "$work/a.txt" "$work/b.txt" >"$work/diff.txt"; then echo "same source"; exit 0; fi
echo "different source:"; cat "$work/diff.txt"; exit 1
