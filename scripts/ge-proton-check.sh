#!/usr/bin/env bash
# Report GE-Proton releases newer than anything in home.nix's geProtons list,
# and print the entry to add for each. Prefetching downloads the tarball
# (~500 MB) into the store, so the subsequent rebuild doesn't fetch it again.
#
# Usage: scripts/ge-proton-check.sh [--all]
#   --all  print entries for every newer release, not just the latest
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/.." && pwd)
releases_url="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases?per_page=20"

# geProtons entries are the only `version = "N-N"` lines in home.nix.
newest_local=$(grep -oP 'version = "\K[0-9]+-[0-9]+(?=")' "$repo_root/home.nix" | sort -V | tail -1)

# Tags look like GE-Proton11-9; skip prereleases and drafts.
mapfile -t newer < <(
  curl -fsSL "$releases_url" |
    jq -r '.[] | select(.prerelease | not) | select(.draft | not) | .tag_name' |
    sed -n 's/^GE-Proton\([0-9]\+-[0-9]\+\)$/\1/p' |
    sort -V |
    awk -v cur="$newest_local" '
      function newer(a, b,   x, y) {
        split(a, x, "-"); split(b, y, "-")
        return x[1] > y[1] || (x[1] == y[1] && x[2] > y[2])
      }
      newer($0, cur)'
)

if [ ${#newer[@]} -eq 0 ]; then
  echo "Up to date: newest GE-Proton in home.nix is $newest_local."
  exit 0
fi

if [ "${1:-}" != "--all" ]; then
  newer=("${newer[-1]}")
fi

echo "Newest in home.nix: $newest_local. Add to geProtons in home.nix:"
echo
for version in "${newer[@]}"; do
  url="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton$version/GE-Proton$version-x86_64.tar.gz"
  echo "Prefetching GE-Proton$version..." >&2
  sha256=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null)
  cat <<EOF
    {
      version = "$version";
      sha256 = "$sha256";
    }
EOF
done
