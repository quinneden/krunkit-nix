{
  description = "Libkrun-efi and Krunkit for aarch64-darwin.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, self }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          self.overlays.virglrenderer
        ];
      };
    in
    {
      packages.${system} = {
        inherit (pkgs) krunkit libkrun-efi virglrenderer;
      };

      overlays = {
        default =
          final: prev:
          prev.lib.packagesFromDirectoryRecursive {
            inherit (final) callPackage;
            directory = ./pkgs;
          };

        virglrenderer = import ./overlays/virglrenderer.nix;
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = [ pkgs.krunkit ];
        };
      };
    };
}
