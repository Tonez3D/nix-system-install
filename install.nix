{
  lib,
  target,
  pkgs,
  modulesPath,
  ...
}:
let
  b = target.config.system.build;
  host = target.config.networking.hostName;
  install = pkgs.writeShellApplication {
    name = "install-${host}";
    runtimeInputs = [ pkgs.nixos-install-tools ];
    text = ''
      read -r -p "Type 'Y': " resp
      [ "$resp" = yes ] || exit 1
      ${b.diskoScript}                 
      nixos-install --no-root-passwd --system ${b.toplevel}
    '';
  };
in
{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  isoImage.isoName = lib.mkForce "installer-${host}.iso";
  environment.systemPackages = [ install ]; 
}
