final: prev:
prev.lib.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ../pkgs;
}
// (import ./overrides.nix final prev)
