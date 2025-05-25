{
  description = "Libkrun-efi and Krunkit derivations for Darwin.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, self }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          }
        );
    in
    {
      packages = perSystem (
        { pkgs }:
        {
          inherit (pkgs) krunkit libkrun-efi;
        }
      );

      overlays.default = import ./overlay;
    };
}
