{
  description = "Flake for building a system installer iso";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let

      lib = nixpkgs.lib;

      installer =
        target:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit target; };
          modules = [
            ./install.nix
            { nixpkgs.hostPlatform = target.pkgs.stdenv.hostPlatform.system; }
          ];
        };

      cfg-iso = target: (installer target).config.system.build.isoImage;
      filter = cfg-n: tar-n: lib.getAttrs cfg-n tar-n;
      isos =
        configs: wanted:
        lib.mapAttrs' (name: cfg: lib.nameValuePair "install-${name}" (cfg-iso cfg)) (
          filter wanted configs
        );

    in
    {

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      lib = {
        iso-installer = isos;
      };
    };
}
