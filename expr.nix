let
  inherit (import <nixpkgs> { }) lib;
  installer = builtSystem: ("eeee");
  fil = cfg-n: tar-n: lib.filterAttrs (name: value: lib.hasAttr name cfg-n) tar-n;
  pack =
    configs: wanted:
    lib.mapAttrs' (name: cfg: lib.nameValuePair "install-${name}" (installer cfg)) (fil wanted configs);
in

(pack
  {
    night = 0;
    fool = 0;
    the-star = 0;
  }
  {
    fool = 99;
    the-star = 00;
  }
)
