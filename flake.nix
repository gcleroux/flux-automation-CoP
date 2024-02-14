{
  description = "A demo on how to use flux-automation with kubernetes";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs@{ self, ... }:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let pkgs = inputs.nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ go fluxcd kind kubectl k9s ];
        };
      });
}
