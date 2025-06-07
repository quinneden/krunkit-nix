# This script is not meant to be run directly!
# Use `nix run .#update -- <pkgName>` instead.

# shellcheck disable=SC2154

set -xeu

repoRoot=$(git rev-parse --show-toplevel)
sourceRepo="${pkgName/-efi}"
currentVersion=$(nix eval --raw "$repoRoot#packages.aarch64-darwin.$pkgName.version")
latestTag=$(curl -s "https://api.github.com/repos/containers/$sourceRepo/tags" | jq -r '.[0].name')

if [[ $latestTag == "v$currentVersion" ]]; then
  echo "Nothing to do, $currentVersion is the latest version."
  exit 0
fi

latestVersion="${latestTag#v}"
echo "Updating $pkgName derivation to $latestVersion..."

sed -i "s|version = \"$currentVersion\"|version = \"$latestVersion\"|" "$repoRoot/pkgs/$pkgName/package.nix"

oldSrcHash=$(grep -o 'hash = ".*";' package.nix | head -n 1)
newSrcHash=$(nix-prefetch-github --rev "refs/tags/$latestTag" containers libkrun | jq -r '.hash')
sed -i "s|$oldSrcHash|hash = \"$newSrcHash\";|" "$repoRoot/pkgs/$pkgName/package.nix"

oldCargoDepsHash=$(grep -o 'hash = ".*";' package.nix | tail -n 1)
newCargoDepsHash=$(nix build "$repoRoot#$pkgName.cargoDeps" 2>&1 | grep -o "got:.*sha256-.*$" | awk -F' ' '{ print $2 }')
sed -i "s|$oldCargoDepsHash|hash = \"$newCargoDepsHash\";|" "$repoRoot/pkgs/$pkgName/package.nix"
