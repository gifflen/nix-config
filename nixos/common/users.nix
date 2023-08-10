{ ... }:
let
  authKeys = import ./authKeys.nix;
in
{
  users.users = {
    root = {
      openssh.authorizedKeys.keys = authKeys.keys;
    };
    gifflen = {
      openssh.authorizedKeys.keys = authKeys.keys;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      isNormalUser = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;


  nix.settings.trusted-users = [
    "root"
    "gifflen"
    "@wheel"
  ];
}
